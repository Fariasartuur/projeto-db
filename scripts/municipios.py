import requests
import pyodbc

# --- 1. CONFIGURAÇÕES DO BANCO DE DADOS ---
#    (Altere para as suas credenciais)
DB_SERVER = 'localhost'  # ou o IP do seu servidor Docker
DB_NAME = 'mortalidade'
DB_USER = 'sa'
DB_PASSWORD = 'Cc202505!'
DB_DRIVER = '{ODBC Driver 17 for SQL Server}'  # Mantenha este, é o driver padrão

# --- 2. CONFIGURAÇÕES DA API ---
API_URL = "https://servicodados.ibge.gov.br/api/v1/localidades/municipios"


def get_uf_from_municipio(municipio_json):
    """
    Função auxiliar para navegar com segurança na estrutura JSON aninhada da API
    e extrair a sigla da UF.
    """
    try:
        # Tenta o caminho padrão
        return municipio_json['microrregiao']['mesorregiao']['UF']['sigla']
    except (TypeError, KeyError):
        # Se falhar (para casos como Brasília, que não tem microrregião)
        if municipio_json.get('nome') == 'Brasília':
            return 'DF'
        # Retorna None para qualquer outra anomalia
        return None


def buscar_municipios_da_api():
    """Busca a lista completa de municípios na API do IBGE."""
    print("Buscando dados da API do IBGE...")
    try:
        response = requests.get(API_URL)
        response.raise_for_status()
        municipios = response.json()
        print(f"{len(municipios)} municípios encontrados.")
        return municipios
    except requests.exceptions.RequestException as e:
        print(f"ERRO ao buscar dados da API: {e}")
        return None


def sincronizar_com_banco(municipios):
    """Conecta ao SQL Server e sincroniza os dados usando a lógica de MERGE."""
    if not municipios:
        print("Nenhum município para sincronizar.")
        return

    conn_str = f'DRIVER={DB_DRIVER};SERVER={DB_SERVER};DATABASE={DB_NAME};UID={DB_USER};PWD={DB_PASSWORD}'

    try:
        print("Conectando ao banco de dados SQL Server...")
        with pyodbc.connect(conn_str) as conn:
            cursor = conn.cursor()
            print("Conexão bem-sucedida.")

            print("Criando tabela temporária...")
            cursor.execute("""
                IF OBJECT_ID('tempdb..#municipios_api') IS NOT NULL DROP TABLE #municipios_api;
                CREATE TABLE #municipios_api (
                    cod_municipio CHAR(7) PRIMARY KEY,
                    nome_municipio VARCHAR(100),
                    uf CHAR(2)
                );
            """)

            # Prepara os dados usando a nova função de segurança
            dados_para_inserir = [
                (str(m['id']), m['nome'], get_uf_from_municipio(m))
                for m in municipios
            ]

            # Filtra registros que possam ter retornado UF nula (caso a tabela final não permita nulos)
            dados_validos = [d for d in dados_para_inserir if d[2] is not None]

            print(f"Inserindo {len(dados_validos)} registros válidos na tabela temporária...")
            cursor.executemany(
                "INSERT INTO #municipios_api (cod_municipio, nome_municipio, uf) VALUES (?, ?, ?)",
                dados_validos
            )
            print("Inserção em massa na tabela temporária concluída.")

            print("Executando o MERGE para sincronizar a tabela 'municipio'...")
            merge_sql = """
                MERGE INTO municipio AS Target
                USING #municipios_api AS Source
                ON (Target.cod_municipio = Source.cod_municipio)
                WHEN MATCHED AND (Target.nome_municipio <> Source.nome_municipio OR Target.uf <> Source.uf) THEN
                    UPDATE SET
                        Target.nome_municipio = Source.nome_municipio,
                        Target.uf = Source.uf
                WHEN NOT MATCHED BY TARGET THEN
                    INSERT (cod_municipio, nome_municipio, uf)
                    VALUES (Source.cod_municipio, Source.nome_municipio, Source.uf);
            """
            cursor.execute(merge_sql)
            print(f"MERGE concluído. {cursor.rowcount} registros foram afetados (inseridos/atualizados).")

            conn.commit()

    except pyodbc.Error as ex:
        sqlstate = ex.args[0]
        print(f"ERRO de banco de dados: {sqlstate}")
        print(ex)
    except Exception as e:
        print(f"Um erro inesperado ocorreu: {e}")


if __name__ == "__main__":
    lista_municipios = buscar_municipios_da_api()
    sincronizar_com_banco(lista_municipios)
    print("Processo finalizado.")
