# Trabalho: Dados Publicos de Comércio Eletrônico Brasileiro - Loja Olist

- **Instituição:** Instituto Federal da Bahia (IFBA)
- **Curso:** Análise e Desenvolvimento de Sistemas (ADS)
- **Disciplina:** Banco de Dados II
- **Projeto:** Tema de livre escolha da equipe
- **Professor:** Caio Valverde
- **Semestre:** 5
- **Ano:** 2025.1

---

## Integrantes do Projeto

<table>
  <tr>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/u/118413268?v=4" width="100px;" alt="Foto do Integrante Jabes"/><br />
      <sub><b><a href="https://github.com/MrJabes762">Jabes Cajazeira</a></b></sub>
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/u/80362674?v=4" width="100px;" alt="Foto do Integrante Janderson"/><br />
      <sub><b><a href="https://github.com/JandersonMota">Janderson Mota</a></b></sub>
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/u/129338943?v=4" width="100px;" alt="Foto da Integrante Ronaldo"/><br />
      <sub><b><a href="https://github.com/Ronaldo-Correia">Ronaldo Correia</a></b></sub>
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/u/114778311?v=4" width="100px;" alt="Foto d0 Integrante Salvador"/><br />
      <sub><b><a href="https://github.com/SalvadorCerqueiraJr">Salvador Cerqueira</a></b></sub>
    </td>
    <td align="center">
      <img src="https://avatars.githubusercontent.com/u/102630544?v=4" width="100px;" alt="Foto do Integrante Tiago"/><br />
      <sub><b><a href="https://github.com/tiagopassos9">Tiago Passos</a></b></sub>
    </td>
  </tr>
</table>

---

## Lista

[Trabalho BD2.pdf](https://github.com/user-attachments/files/21988418/Trabalho.BD2.pdf)

## Sobre o projeto

Este trabalho se apoia no Brazilian E-Commerce Public Dataset, publicado pela Olist, contendo mais de 100 mil pedidos realizados entre 2016 e 2018 nos marketplaces brasileiros. A profundidade do dataset — com atributos como status do pedido, preço, pagamento, desempenho do frete, localização do cliente, atributos do produto e avaliações, revela um ecossistema rico e minuncioso o qual fundamenta o estudo.

Nesse sentido, é possivel analisar padrões temporais como fluxo e volume de pedidos, identificar sazonalidades e alimentar previsões robustas sobre demandas futuras.

🔗 Link do dataset: [Brazilian E-Commerce Olist - Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?select=olist_customers_dataset.csv)

---

## Ferramentas
- SQL Server
- SQL Server Management Studio ^19

---

## Estrutura do Repositorio

| Diretório | Descricao |
| ---------- | ---------|
|`./datasheets` | **Diretorio que contem os datasheets base** |
|`./modelagemInplementacao/modelagem` | **Diretorio que contem os scripts de modelagem do banco e inserção via BurkInsert** |
|`./auditoriaSeguranca`| **Diretorio que contem os pacotes com as configurações de usuários,tabela de logs e triggers das tabelas principais do fluxo operacional do Olist**|


---

## Itens

### 1. Modelagem e Implementação

#### 1.1. Modelagem 

- Mediante downloads dos datasheets necessarios para realizar a tarefa de modelar e implementar, é necessario inicialmente criar um banco de dados e subir os todas

```Criacao

CREATE DATABASE TrabalhoBD2

```



Em seguida "setar" o banco de dados 


```Criacao
USE [TrabalhoBD2]

```

Feito a primeira etapa, para subir as tabelas para o banco existem diversas estratégias. Isso inclui: 

  1. **Flat File, Import Data...** - Subir Automaticamente as tabelas **via flat file, e dentre outras formas de importação** a depender da natureza dos datasheets. 
  
  2. **Burk Insert** -  Vale a pena ressaltar que a estratégia anterior é eficiente na maioria dos casos, as excessões são para casos em que as tabelas não são facilmente identificadas. Nesse sentido, é aplicavel o metodo de **Burk Insert**, que em sintese se resume a criar a tabela no banco pegando as colunas e suas tipagems de cada datasheet e criar o comando **BULK INSERT**, passando a referencia da tabela criada `FROM './datasheet/product_category_name_translation.csv'`, caminho do CSV `FROM './datasheet/product_category_name_translation.csv'` e as configurações de inserção necessarias para reconhecer o datasheet e subir os dados.

  ```Burk Insert exemplo
BULK INSERT dbo.product_category_name_translation
FROM './datasheet/product_category_name_translation.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    DATAFILETYPE = 'char',
    CODEPAGE = '65001',
    MAXERRORS = 1,
    BATCHSIZE = 1000
);
GO

```

#### 1.2. Normalização 

![Modelagem Relacional Banco De Dados](../ifba-bd2/modelagemInplementacao/diagramaRelacionalBancoDeDados/Diagrama%20Relacional%20do%20Banco%20de%20Dados.png)

A imagem anterior descreve a modelagem do banco de e suas possivels relações. Entretanto, observando os dados, nos tempos possiveis inconsistências no que tange a duplicidade dos dados. Nesse sentido, tendo em vista que a natureza destes dados não afetam consideravelmente o datasheet, é realizada a exclusão destes dados.

---

### 2. Auditoria e Segurança

#### 2.1. Mecanismos de Auditoria

Para registrar de forma automática todas as operações de inserção, atualização e exclusão, criamos uma tabela de auditoria chamada audit.ChangeLog e um conjunto de triggers DML em cada tabela alvo. Sempre que alguém faz um INSERT, UPDATE ou DELETE, o respectivo trigger dispara e insere um registro na ChangeLog sem alterar a tabela operacional.

#### Estrutura da tabela audit.ChangeLog
A tabela de logs contém colunas que capturam:

- TableName: nome da tabela onde a alteração ocorreu
- Operation: tipo de operação (I, U ou D)
- PrimaryKeyValue: valor da chave primária do registro afetado
- ColumnName: coluna alterada (ou ALL para operações em lote)
- OldValue: valor antes da mudança (null em INSERT)
- NewValue: valor depois da mudança (null em DELETE)
- ChangedBy: login do usuário que executou a operação
- ChangedAt: data e hora em que o trigger foi acionado

#### Funcionamento dos triggers
- Após a operação DML, o SQL Server invoca o trigger AFTER INSERT/UPDATE/DELETE.
- O trigger lê as pseudo-tabelas inserted e deleted para capturar os valores antigos e novos.
- Em seguida, escreve um registro na audit.ChangeLog com todas as informações necessárias.
- A operação original prossegue normalmente, sem impacto no fluxo dos dados.
  
Exemplo de consulta de auditoria
Para verificar todas as alterações na tabela de pedidos nos últimos 7 dias:

```sql
SELECT *
FROM audit.ChangeLog
WHERE TableName = 'ordens'
  AND ChangedAt >= DATEADD(DAY, -7, SYSUTCDATETIME())
ORDER BY ChangedAt DESC;
```

#### Aplicação no Olist

1) Monitoramento de pedidos
No contexto do Olist, cada alteração no ciclo de pedidos (criação, alteração de status, cancelamento) é capturada pelos triggers. Isso permite rastrear exatamente quem e quando modificou o status de entrega, datas de despacho ou até mesmo reprogramações, garantindo visibilidade total sobre o fluxo de venda e expedição.

2) Rastreio de pagamentos
As transações de pagamento são vitais para o marketplace. Com a auditoria aplicada à tabela de ordensDePagamento, qualquer mudança em parcelas, tipo de pagamento ou valor fica registrada, auxiliando no diagnóstico de disputas, estornos e conciliando relatórios financeiros com maior precisão.

3) Evolução de produtos e avaliações
No Olist, o catálogo de produtos e as avaliações dos clientes mudam com frequência. Os triggers em produtos e olist_order_reviews_dataset armazenam histórico de categorias, dimensões e notas de avaliação, suportando análises de performance de produto e identificação de tendências de mercado.

4) Conformidade e governança
Ao centralizar todo o histórico em audit.ChangeLog, o Olist atende a requisitos de compliance e auditoria externa. A separação entre dados operacionais e logs de auditoria reforça a segurança, prevenindo alterações indevidas e facilitando auditorias periódicas.

5) Suporte a análises avançadas
Com o histórico completo de mudanças, é possível alimentar modelos de previsão de demanda, detectar anomalias (ex.: aumento repentino de estornos) e gerar relatórios de governança que agregam valor estratégico ao negócio.

#### 2.2. Configuração de Usuário 

Para garantir segurança, organização e eficiência no uso do banco de dados do marketplace Olist, definimos três tipos de usuários com permissões específicas: Auditor, Analista de Vendas e Operador de Logística. Essa divisão segue o princípio do menor privilégio, onde cada perfil acessa apenas as informações e funcionalidades necessárias para suas atividades. No contexto do Olist que lida com pedidos, pagamentos, entregas e avaliações de clientes essa separação é essencial para:

- Proteger dados sensíveis e evitar alterações indevidas
- Facilitar auditorias e rastrear mudanças
- Garantir que cada área de negócio trabalhe de forma independente, sem impactar a operação das demais
  
#### Perfis de usuário

1. Sales Analyst
Papel: gerar relatórios de desempenho comercial, métricas de faturamento e tendências. – Permissões:
- SELECT em tabelas operacionais (pedidos, pagamentos, avaliações, produtos).
- DENY em INSERT/UPDATE/DELETE para impedir qualquer modificação. – Relacionamento com o Olist: usa dados históricos e transacionais para embasar decisões de marketing, precificação e planejamento de vendas.

2. Logistics Operator
Papel: acompanhar o ciclo de entrega, marcar despachos e confirmar entregas. – Permissões:
- SELECT em pedidos e itens.
- UPDATE em colunas de status e datas de entrega na tabela de pedidos.
- DENY em tabelas de pagamento e reviews, preservando a privacidade financeira. – Relacionamento com o Olist: integra as rotinas de expedição ao fluxo de vendas, garantindo que o estoque e o cliente sejam atualizados no momento certo.

3. Auditor
Papel: verificar a integridade do sistema e detectar inconsistências ou acessos indevidos. – Permissões:
- SELECT exclusivo na tabela de logs (audit.ChangeLog).
- DENY total nas tabelas operacionais, prevenindo até mesmo leituras diretas de dados transacionais. – Relacionamento com o Olist: monitora quem, quando e como os dados foram alterados, sustentando as práticas de governança e conformidade.


#### 2.3 Estratégia de Backup e Replicação

#### Estratégia de Backup
Nossa estratégia de backup foi projetada para garantir que nenhum dado sensível — como pedidos, pagamentos, informações de frete ou avaliações de clientes — seja perdido em caso de falha. Para um marketplace como a Olist, que processa milhares de transações diariamente, perder dados de um único dia pode significar um grave prejuízo financeiro e uma quebra irreparável de confiança com vendedores e clientes.

* **Backup Completo:** Uma cópia completa de todos os dados do banco será realizada semanalmente. Este backup serve como a base mais segura para restaurações de grande escala.
* **Backup Diferencial:** Para capturar as alterações diárias, serão realizados backups diferenciais todos os dias, durante a madrugada. Isso garante que, em caso de falha, possamos restaurar os dados com pouca ou nenhuma perda, utilizando o último backup completo mais o backup diferencial mais recente.

#### Estratégia de Replicação Master-Slave
A replicação é crucial para a alta disponibilidade e para a distribuição de carga de trabalho do banco de dados da Olist.

* **Servidor Master:** Este servidor será o único responsável por todas as operações de escrita, como o processamento de novos pedidos. Isso assegura que a performance do sistema de checkout e registro de transações não seja impactada por outras atividades.
* **Servidores Slaves:** As réplicas do banco de dados (slaves) terão a função de lidar com toda a carga de leitura. Isso é vital para a Olist, pois permite que consultas analíticas (como relatórios de vendas, desempenho de frete e análises de sazonalidade) sejam executadas sem sobrecarregar o servidor principal. Assim, a equipe de análise de dados pode trabalhar sem afetar a experiência do cliente que está comprando.

#### Benefícios da Estratégia para o Marketplace Olist
* **Alta Disponibilidade e Continuidade do Negócio:** Para um marketplace nacional que conecta múltiplos vendedores e clientes, o tempo de inatividade significa vendas perdidas e insatisfação para toda a cadeia. A replicação garante que, se o servidor principal (master) cair, o site continue processando pedidos e exibindo o status de entrega, mantendo o negócio em funcionamento.
* **Integridade e Disponibilidade dos Dados:** Graças a esta estratégia de backup e replicação, os dados do dataset Olist — incluindo pedidos, pagamentos e avaliações — permanecem íntegros e sempre disponíveis para serem usados em diferentes partes do seu trabalho, como:
* **Auditoria:** Os logs de alterações podem ser consultados sem impactar a operação principal.
* **Análises OLAP:** As consultas complexas para o seu Data Warehouse podem ser executadas nos servidores slaves, garantindo que a análise não interfira no processamento de novos pedidos.
* **Estudos de Comportamento do Consumidor:** Os dados históricos estarão sempre disponíveis para alimentar estudos sobre padrões de compra e previsões de demanda.
.
### 3. Data Warehouse e OLAP
