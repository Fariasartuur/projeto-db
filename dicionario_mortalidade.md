# Dicionário de Dados - Projeto Mortalidade

Este documento detalha a estrutura do banco de dados `mortalidade`, incluindo tabelas, colunas e seus respectivos significados.

---

### Tabela: `acidtrab`
**Descrição:** Dimensão que descreve se o óbito foi relacionado a um acidente de trabalho.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_acidtrab** | `TINYINT` | Não | PK | Identificador único para o tipo de acidente de trabalho. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Sim, Não, Ignorado). |

---

### Tabela: `altcausa`
**Descrição:** Dimensão que informa se houve alteração da causa do óbito após investigação.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_altcausa** | `TINYINT` | Não | PK | Identificador único para a opção de alteração de causa. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Sim, Não). |

---

### Tabela: `assistmed`
**Descrição:** Dimensão que informa se o falecido recebeu assistência médica.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_assistmed** | `TINYINT` | Não | PK | Identificador único para a opção de assistência médica. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Sim, Não, Ignorado). |

---

### Tabela: `atestado`
**Descrição:** Armazena informações relacionadas ao atestado de óbito.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_obito** | `INT` | Não | PK, FK | Chave primária e estrangeira, ligando ao registro na tabela `obito`. |
| **id_necropsia** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `necropsia`. |
| **id_exame** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `exame`. |
| **id_cirurgia** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `cirurgia`. |
| **id_atestante** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `atestante`. |
| **id_assistmed** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `assistmed`. |
| **dtatestado** | `DATE` | Sim | | Data de assinatura do atestado. |
| **atestado** | `VARCHAR(70)` | Sim | | CIDs informados no atestado. |
| **comunsvoim** | `CHAR(7)` | Sim | | Código do município do SVO ou IML. |

---

### Tabela: `atestante`
**Descrição:** Dimensão que descreve a condição do médico que atestou o óbito.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_atestante** | `TINYINT` | Não | PK | Identificador único para o tipo de atestante. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Assistente, Substituto, IML, SVO, Outro). |

---

### Tabela: `auditoria_obito`
**Descrição:** Tabela para registrar o histórico de modificações na tabela `obito`.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_auditoria** | `INT` | Não | PK | Identificador único do registro de auditoria. |
| **id_obito** | `INT` | Sim | | ID do óbito que foi modificado. |
| **operacao** | `VARCHAR(10)` | Sim | | Tipo de operação (INSERT, UPDATE, DELETE). |
| **usuario_bd** | `SYSNAME` | Sim | | Usuário do banco de dados que realizou a operação. |
| **data_hora** | `DATETIME` | Sim | | Data e hora da operação. |
| **valores_antigos** | `NVARCHAR(MAX)` | Sim | | Dados da linha antes da modificação (em formato JSON). |
| **valores_novos** | `NVARCHAR(MAX)` | Sim | | Dados da linha após a modificação (em formato JSON). |

---

### Tabela: `cbo2002`
**Descrição:** Dimensão com o catálogo da Classificação Brasileira de Ocupações (2002).

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **codigo** | `CHAR(6)` | Não | PK | Código da ocupação. |
| **titulo** | `VARCHAR(256)` | Sim | | Título ou descrição da ocupação. |

---

### Tabela: `cid10_subcategorias`
**Descrição:** Dimensão com o catálogo de subcategorias da Classificação Internacional de Doenças (CID-10).

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **subcat** | `CHAR(4)` | Não | PK | Código da subcategoria da doença. |
| **descricao** | `VARCHAR(256)` | Sim | | Descrição da doença. |

---

### Tabela: `cid_causa`
**Descrição:** Armazena os diferentes CIDs associados a cada óbito.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_causa** | `INT` | Não | PK | Identificador único para o registro de causa. |
| **id_obito** | `INT` | Não | FK | Chave estrangeira para a tabela `obito`. |
| **id_tipo_linha** | `TINYINT` | Não | FK | Chave estrangeira para `tipo_linha` (Linha A, B, C, D ou II). |
| **cid_cod** | `VARCHAR(45)` | Sim | | Código CID informado na linha correspondente. |
| **causabas** | `CHAR(4)` | Sim | FK | Causa básica da morte. |
| **causabas_original** | `CHAR(4)` | Sim | FK | Causa básica original, antes de investigações. |
| **cb_alt** | `VARCHAR(10)` | Sim | | Variável de sistema relacionada à causa básica. |

---

### Tabela: `circobito`
**Descrição:** Dimensão que descreve a circunstância da morte.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_circobito** | `TINYINT` | Não | PK | Identificador único da circunstância. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Acidente, Suicídio, Homicídio, etc.). |

---

### Tabela: `cirurgia`
**Descrição:** Dimensão que informa se foi realizada cirurgia.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_cirurgia** | `TINYINT` | Não | PK | Identificador único da opção de cirurgia. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Sim, Não, Ignorado). |

---

### Tabela: `circunstancia_obito`
**Descrição:** Tabela associativa que detalha as circunstâncias de um óbito.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_obito** | `INT` | Não | PK, FK | Chave primária e estrangeira, ligando ao `obito`. |
| **id_circobito** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `circobito`. |
| **id_acidtrab** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `acidtrab`. |
| **id_fonte** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `fonte`. |
| **id_tpobitocor** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `tpobitocor`. |

---

### Tabela: `esc`
**Descrição:** Dimensão para a escolaridade do falecido em anos de estudo.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_esc** | `TINYINT` | Não | PK | Identificador único para a faixa de anos de estudo. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição da faixa de anos. |

---

### Tabela: `esc2010`
**Descrição:** Dimensão para a escolaridade do falecido (nível) a partir de 2010.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_esc2010** | `TINYINT` | Não | PK | Identificador único para o nível de escolaridade. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição do nível de escolaridade. |

---

### Tabela: `escfalagr1`
**Descrição:** Dimensão para a escolaridade agregada do falecido.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_escfalagr1** | `TINYINT` | Não | PK | Identificador único para a escolaridade agregada. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição da escolaridade agregada. |

---

### Tabela: `escolaridade_falecido`
**Descrição:** Consolida as diferentes formas de registro de escolaridade para o falecido.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_escol** | `INT` | Não | PK | Identificador único para o registro de escolaridade. |
| **id_esc2010** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `esc2010`. |
| **id_esc** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `esc`. |
| **id_escfalagr1** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `escfalagr1`. |
| **seriescfal** | `TINYINT` | Sim | | Última série concluída pelo falecido. |

---

### Tabela: `escmae`
**Descrição:** Dimensão para a escolaridade da mãe em anos de estudo.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_escmae** | `TINYINT` | Não | PK | Identificador único para a faixa de anos de estudo da mãe. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição da faixa de anos. |

---

### Tabela: `escmae2010`
**Descrição:** Dimensão para a escolaridade da mãe (nível) a partir de 2010.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_escmae2010** | `TINYINT` | Não | PK | Identificador único para o nível de escolaridade da mãe. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição do nível de escolaridade. |

---

### Tabela: `escmaeagr1`
**Descrição:** Dimensão para a escolaridade agregada da mãe.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_escmaeagr1** | `TINYINT` | Não | PK | Identificador único para a escolaridade agregada da mãe. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição da escolaridade agregada. |

---

### Tabela: `escolaridade_mae`
**Descrição:** Consolida as diferentes formas de registro de escolaridade para a mãe.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_escol_mae** | `INT` | Não | PK | Identificador único para o registro de escolaridade da mãe. |
| **id_escmae2010** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `escmae2010`. |
| **id_escmae** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `escmae`. |
| **id_escmaeagr1** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `escmaeagr1`. |
| **seriescmae** | `TINYINT` | Sim | | Última série concluída pela mãe. |

---

### Tabela: `estado_civil`
**Descrição:** Dimensão para o estado civil do falecido.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_estciv** | `TINYINT` | Não | PK | Identificador único para o estado civil. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição do estado civil. |

---

### Tabela: `exame`
**Descrição:** Dimensão que informa se foi realizado exame.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_exame** | `TINYINT` | Não | PK | Identificador único para a opção de exame. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Sim, Não, Ignorado). |

---

### Tabela: `fonte`
**Descrição:** Dimensão para a fonte de informação do óbito.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_fonte** | `TINYINT` | Não | PK | Identificador único para a fonte. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Ocorrência Policial, Hospital, etc.). |

---

### Tabela: `fonteinv`
**Descrição:** Dimensão para a fonte de investigação do óbito.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_fonteinv** | `TINYINT` | Não | PK | Identificador único para a fonte de investigação. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Comitê, Visita domiciliar, etc.). |

---

### Tabela: `gestacao`
**Descrição:** Dimensão para as semanas de gestação (formulário antigo).

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_gestacao** | `TINYINT` | Não | PK | Identificador único para a faixa de semanas de gestação. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição da faixa de semanas. |

---

### Tabela: `gravidez`
**Descrição:** Dimensão para o tipo de gravidez.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_gravidez** | `TINYINT` | Não | PK | Identificador único para o tipo de gravidez. |
| **tipo** | `VARCHAR(50)` | Sim | | Descrição (Única, Dupla, Tripla e mais, Ignorada). |

---

### Tabela: `idade`
**Descrição:** Armazena a idade do falecido de forma decomposta.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_idade** | `INT` | Não | PK | Identificador único do registro de idade. |
| **id_idade_unidade** | `TINYINT` | Sim | FK | Chave estrangeira para a tabela `idade_unidade`. |
| **quantidade** | `INT` | Sim | | Valor numérico da idade na unidade especificada. |

---

### Tabela: `idade_unidade`
**Descrição:** Dimensão para a unidade de medida da idade (minutos, horas, dias, anos).

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_idade_unidade** | `TINYINT` | Não | PK | Identificador único para a unidade de idade. |
| **descricao** | `VARCHAR(20)` | Sim | | Descrição da unidade. |

---

### Tabela: `info_sistema`
**Descrição:** Tabela com informações de controle, investigação e do sistema de informação.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_obito** | `INT` | Não | PK, FK | Chave primária e estrangeira, ligando ao `obito`. |
| **id_fonteinv** | `TINYINT` | Sim | FK | FK para `fonteinv`. |
| **id_tpresginfo** | `TINYINT` | Sim | FK | FK para `tpresginfo`. |
| **id_tpnivelinv** | `CHAR(1)` | Sim | FK | FK para `tpnivelinv`. |
| **id_altcausa** | `TINYINT` | Sim | FK | FK para `altcausa`. |
| **id_stdoepidem** | `TINYINT` | Sim | FK | FK para `stdoepidem`. |
| **id_stdonova** | `TINYINT` | Sim | FK | FK para `stdonova`. |
| **id_tppos** | `CHAR(1)` | Sim | FK | FK para `tppos`. |
| **id_origem** | `TINYINT` | Sim | FK | FK para `origem`. |
| **id_tp_altera** | `TINYINT` | Sim | FK | FK para `tp_altera`. |
| ... | ... | ... | | (demais colunas de sistema) |

---

### Tabela: `local_ocorrencia`
**Descrição:** Armazena os dados do local onde o óbito ocorreu.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_obito** | `INT` | Não | PK, FK | Chave primária e estrangeira, ligando ao `obito`. |
| **id_lococor** | `TINYINT` | Não | FK | Chave estrangeira para a tabela `lococor`. |
| **codestab** | `CHAR(8)` | Sim | | Código CNES do estabelecimento de saúde. |
| **codmunocor** | `CHAR(7)` | Não | FK | Código do município de ocorrência. |

---

### Tabela: `lococor`
**Descrição:** Dimensão para o tipo de local de ocorrência do óbito.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_lococor** | `TINYINT` | Não | PK | Identificador único para o local de ocorrência. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Hospital, Domicílio, Via Pública, etc.). |

---

### Tabela: `mae`
**Descrição:** Armazena informações sobre a mãe, relevantes para óbitos fetais e infantis.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_obito** | `INT` | Não | PK, FK | Chave primária e estrangeira, ligando ao `obito`. |
| **id_gestacao** | `TINYINT` | Sim | FK | FK para `gestacao`. |
| **id_gravidez** | `TINYINT` | Sim | FK | FK para `gravidez`. |
| **id_parto** | `TINYINT` | Sim | FK | FK para `parto`. |
| **id_obitoparto** | `TINYINT` | Sim | FK | FK para `obitoparto`. |
| **id_tpmorteoco** | `TINYINT` | Sim | FK | FK para `tpmorteoco`. |
| **id_obitograv** | `TINYINT` | Sim | FK | FK para `obitograv`. |
| **id_obitopuerp** | `TINYINT` | Sim | FK | FK para `obitopuerp`. |
| **id_morteparto** | `TINYINT` | Sim | FK | FK para `morteparto`. |
| **id_escol_mae** | `INT` | Sim | FK | FK para `escolaridade_mae`. |
| ... | ... | ... | | (demais colunas sobre a mãe) |

---

### Tabela: `morteparto`
**Descrição:** Dimensão para o momento do óbito em relação ao parto (após investigação).

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_morteparto** | `TINYINT` | Não | PK | Identificador único para o momento do óbito. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Antes, Durante, Após, Ignorado). |

---

### Tabela: `municipio`
**Descrição:** Tabela de dimensão com o catálogo de todos os municípios brasileiros.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **cod_municipio** | `CHAR(7)` | Não | PK | Código IBGE de 7 dígitos do município. |
| **nome_municipio** | `VARCHAR(60)` | Sim | | Nome oficial do município. |
| **uf** | `CHAR(2)` | Sim | | Sigla da Unidade da Federação. |

---

### Tabela: `necropsia`
**Descrição:** Dimensão que informa se foi realizada necropsia.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_necropsia** | `TINYINT` | Não | PK | Identificador único para a opção de necropsia. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Sim, Não, Ignorado). |

---

### Tabela: `obito`
**Descrição:** Tabela fato principal que armazena a informação central de cada registro de óbito.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_obito** | `INT` | Não | PK | Identificador único para cada óbito. |
| **id_tipobito** | `TINYINT` | Não | FK | Chave estrangeira para a tabela `tipobito`. |
| **dtobito** | `DATE` | Não | | Data em que o óbito ocorreu. |
| **horaobito** | `TIME` | Sim | | Horário em que o óbito ocorreu. |

---

### Tabela: `obitograv`
**Descrição:** Dimensão que informa se o óbito ocorreu na gravidez.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_obitograv** | `TINYINT` | Não | PK | Identificador único para a opção. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Sim, Não, Ignorado). |

---

### Tabela: `obitoparto`
**Descrição:** Dimensão para o momento do óbito em relação ao parto.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_obitoparto** | `TINYINT` | Não | PK | Identificador único para o momento do óbito. |
| **momento** | `VARCHAR(50)` | Sim | | Descrição (Antes, Durante, Depois, Ignorado). |

---

### Tabela: `obitopuerp`
**Descrição:** Dimensão que informa se o óbito ocorreu no puerpério.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_obitopuerp** | `TINYINT` | Não | PK | Identificador único para a opção. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Sim até 42 dias, Sim de 43 dias a 1 ano, etc.). |

---

### Tabela: `origem`
**Descrição:** Dimensão para a origem dos dados.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_origem** | `TINYINT` | Não | PK | Identificador único para a origem. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Oracle, Banco estadual, etc.). |

---

### Tabela: `parto`
**Descrição:** Dimensão para o tipo de parto.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_parto** | `TINYINT` | Não | PK | Identificador único para o tipo de parto. |
| **tipo** | `VARCHAR(50)` | Sim | | Descrição (Vaginal, Cesáreo, Ignorado). |

---

### Tabela: `pessoa_falecida`
**Descrição:** Armazena os dados demográficos e sociais da pessoa que faleceu.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_obito** | `INT` | Não | PK, FK | Chave primária e estrangeira, ligando ao `obito`. |
| **codmunnatu** | `CHAR(7)` | Sim | FK | Código do município de naturalidade. |
| **codmunres** | `CHAR(7)` | Sim | FK | Código do município de residência. |
| **id_escol** | `INT` | Sim | FK | FK para `escolaridade_falecido`. |
| **id_racacor** | `TINYINT` | Sim | FK | FK para `raca_cor`. |
| **id_estciv** | `TINYINT` | Sim | FK | FK para `estado_civil`. |
| **id_sexo** | `TINYINT` | Não | FK | FK para `sexo`. |
| **id_idade** | `INT` | Sim | FK | FK para `idade`. |
| **dtnasc** | `DATE` | Sim | | Data de nascimento. |
| **ocup** | `CHAR(6)` | Sim | FK | Código CBO da ocupação. |
| **natural** | `VARCHAR(4)` | Sim | | Naturalidade. |

---

### Tabela: `raca_cor`
**Descrição:** Dimensão para a raça/cor autodeclarada.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_racacor** | `TINYINT` | Não | PK | Identificador único para a raça/cor. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Branca, Preta, Amarela, Parda, Indígena). |

---

### Tabela: `sexo`
**Descrição:** Dimensão para o sexo do falecido.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_sexo** | `TINYINT` | Não | PK | Identificador único para o sexo. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Masculino, Feminino, Ignorado). |

---

### Tabela: `stdoepidem`
**Descrição:** Dimensão que informa o status de DO Epidemiológica.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_stdoepidem** | `TINYINT` | Não | PK | Identificador único para o status. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Sim, Não). |

---

### Tabela: `stdonova`
**Descrição:** Dimensão que informa o status de DO Nova.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_stdonova** | `TINYINT` | Não | PK | Identificador único para o status. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Sim, Não). |

---

### Tabela: `tipo_linha`
**Descrição:** Dimensão para as linhas de causa de morte no atestado.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_tipo_linha** | `TINYINT` | Não | PK | Identificador único para o tipo de linha. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (LINHAA, LINHAB, etc.). |

---

### Tabela: `tipobito`
**Descrição:** Dimensão para o tipo de óbito.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_tipobito** | `TINYINT` | Não | PK | Identificador único para o tipo de óbito. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Fetal, Não Fetal). |

---

### Tabela: `tp_altera`
**Descrição:** Dimensão para o tipo de alteração de causa básica.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_tp_altera** | `TINYINT` | Não | PK | Identificador único para o tipo de alteração. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição da alteração. |

---

### Tabela: `tpmorteoco`
**Descrição:** Dimensão para o momento em que o óbito ocorreu em relação à gestação/parto.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_tpmorteoco** | `TINYINT` | Não | PK | Identificador único para a situação. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição da situação gestacional. |

---

### Tabela: `tpnivelinv`
**Descrição:** Dimensão para o nível do investigador (Estadual, Regional, Municipal).

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_tpnivelinv** | `CHAR(1)` | Não | PK | Identificador único para o nível. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição do nível. |

---

### Tabela: `tpobitocor`
**Descrição:** Dimensão para o tipo de local de ocorrência de acidente/violência.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_tpobitocor** | `TINYINT` | Não | PK | Identificador único para o tipo de local. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição do local. |

---

### Tabela: `tppos`
**Descrição:** Dimensão que informa se o óbito foi investigado.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_tppos** | `CHAR(1)` | Não | PK | Identificador único. |
| **descricao** | `VARCHAR(50)` | Sim | | Descrição (Sim, Não). |

---

### Tabela: `tpresginfo`
**Descrição:** Dimensão que informa se a investigação permitiu resgate ou correção de informações.

| Coluna | Tipo de Dado | Aceita Nulos? | Chave | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **id_tpresginfo** | `TINYINT` | Não | PK | Identificador único. |
| **descricao** | `VARCHAR(75)` | Sim | | Descrição do resultado da investigação. |
