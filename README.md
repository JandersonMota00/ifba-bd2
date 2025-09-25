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

## Tabela inicial do dataset Olist
<img width="1526" height="797" alt="Tabelas do banco inicial" src="https://github.com/user-attachments/assets/4c182f1b-1bfb-4118-924c-15f4c8780e22" />


## Ferramentas
- SQL Server
- SQL Server Management Studio ^19

## Baixar Banco de Dados
- Modelagem:

  🔗 Link: https://drive.google.com/file/d/1RY4DBAFp7MTFFtB8spdXCPxbo46iinaU/view?usp=sharing

- Modelagem e Implementação:

  🔗 Link: https://drive.google.com/file/d/1iywdigBeTrRxSMBdAVWPx1Kcl_TRuelf/view?usp=sharing

- Modelagem e Implementação + Data Warehouse e OLAP

  🔗 Link: https://drive.google.com/file/d/1Jts56bWFwubuSllEhbz6hZVWV8IW5Aq3/view?usp=sharing

## Estrutura do Repositorio

| Diretório | Descricao |
| ---------- | ---------|
|`./datasheets` | **Diretorio que contem os datasheets base** |
|`./modelagemInplementacao/modelagem` | **Diretorio que contem os scripts de modelagem do banco e inserção via BurkInsert** |
|`./auditoriaSeguranca`| **Diretorio que contem os pacotes com as configurações de usuários,tabela de logs e triggers das tabelas principais do fluxo operacional do Olist**|
|`./dataWarehouseAndOlap`| **Diretorio que contem os pacotes com as configurações de Data Warehouse e OLAP**|

---

## Itens

### 1. Modelagem e Implementação

#### 1.1. Modelagem 
- Mediante downloads dos datasheets necessarios para realizar a tarefa de modelar e implementar, é necessario inicialmente criar um banco de dados e subir os todas

```Criacao

CREATE DATABASE OlistStore

```



Em seguida "setar" o banco de dados 


```Criacao
USE OlistStore

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

#### 1.1.1. Normalização 

<img width="720" height="662" alt="image" src="https://github.com/user-attachments/assets/9a04c850-63a1-4588-a363-a89d4794cd26" />

A imagem anterior descreve a modelagem do banco de e suas possivels relações. Entretanto, observando os dados, nos tempos possiveis inconsistências no que tange a duplicidade dos dados. Nesse sentido, tendo em vista que a natureza destes dados não afetam consideravelmente o datasheet, é realizada a exclusão destes dados.

#### 1.2. Implementação
Implementação de **_procedure_** usando a `tabela olist_products_dataset`.

1. Listar todos os produtos
    ```
    CREATE PROCEDURE ListarProdutos
    AS
    BEGIN
        SET NOCOUNT ON;

        SELECT TOP 50 *
        FROM olist_products_dataset
        ORDER BY product_id;
    END;

    -- Executar
    EXEC ListarProdutos;
    ```

2. Buscar produtos por categoria
    ```
    CREATE PROCEDURE BuscarProdutosPorCategoria
        @Categoria NVARCHAR(100)
    AS
    BEGIN
        SET NOCOUNT ON;

        SELECT product_id, product_category_name, product_weight_g, product_length_cm, product_height_cm, product_width_cm
        FROM olist_products_dataset
        WHERE product_category_name = @Categoria;
    END;

    -- Executar
    EXEC BuscarProdutosPorCategoria @Categoria = 'perfumaria';
    ```

3. Contar produtos por categoria (com parâmetro de saída)
    ```
    CREATE PROCEDURE ContarProdutosPorCategoria
        @Categoria NVARCHAR(100),
        @Qtd INT OUTPUT
    AS
    BEGIN
        SET NOCOUNT ON;

        SELECT @Qtd = COUNT(*)
        FROM olist_products_dataset
        WHERE product_category_name = @Categoria;
    END;

    -- Executar
    DECLARE @Total INT;
    EXEC ContarProdutosPorCategoria @Categoria = 'perfumaria', @Qtd = @Total OUTPUT;
    PRINT 'Total de produtos: ' + CAST(@Total AS VARCHAR);
    ```

4. Top categorias com mais produtos
    ```
    CREATE PROCEDURE TopCategoriasProdutos
        @TopN INT = 10
    AS
    BEGIN
        SET NOCOUNT ON;

        SELECT TOP (@TopN) product_category_name, COUNT(*) AS qtd_produtos
        FROM olist_products_dataset
        GROUP BY product_category_name
        ORDER BY qtd_produtos DESC;
    END;

    -- Executar
    EXEC TopCategoriasProdutos @TopN = 5;
    ```

Implementação de **_triggers_** usando a tabela `olist_orders_dataset`.

Devido não possuir uma tabela de Log, será necesário criar.

1. Trigger para Log de Novos Pedidos
    ```
    -- Criação da tabela de log para registrar cada pedido novo.
    CREATE TABLE Log_NovosPedidos (
        log_id INT IDENTITY PRIMARY KEY,
        order_id NVARCHAR(50),
        customer_id NVARCHAR(50),
        data_insercao DATETIME DEFAULT GETDATE()
    );

    -- Trigger
    INSERT INTO olist_orders_dataset (order_id, customer_id, order_status, order_purchase_timestamp, order_estimated_delivery_date)
    VALUES ('PEDIDO_TESTE_1', '000379cdec625522490c315e70c7a9fb', 'created', GETDATE(), DATEADD(DAY, 10, GETDATE()));

    SELECT * FROM Log_NovosPedidos;
    ```

2. Trigger para Bloquear Exclusão de Pedidos
    ```
    -- Nenhum pedido poderá ser deletado diretamente.
    CREATE TRIGGER trg_BloquearDeletePedido
    ON olist_orders_dataset
    INSTEAD OF DELETE
    AS
    BEGIN
        RAISERROR ('Exclusão de pedidos não é permitida!', 16, 1);
    END;

    -- Trigger
    DELETE FROM olist_orders_dataset WHERE order_id = 'PEDIDO_TESTE_1';
    -- Vai gerar erro e impedir exclusão
    ```
    <img width="720" height="131" alt="image" src="https://github.com/user-attachments/assets/6ad0157b-c871-4b0d-b61b-4f91be20b486" />


3. Trigger para Log de Mudança no Status do Pedido
    ```
    -- Criaremos uma tabela de log:
    CREATE TABLE Log_StatusPedido (
        log_id INT IDENTITY PRIMARY KEY,
        order_id NVARCHAR(50),
        status_antigo NVARCHAR(50),
        status_novo NVARCHAR(50),
        data_alteracao DATETIME DEFAULT GETDATE()
    );

    -- Trigger
    CREATE TRIGGER trg_LogAlteracaoStatus
    ON olist_orders_dataset
    AFTER UPDATE
    AS
    BEGIN
        INSERT INTO Log_StatusPedido (order_id, status_antigo, status_novo)
        SELECT d.order_id, d.order_status, i.order_status
        FROM DELETED d
        JOIN INSERTED i ON d.order_id = i.order_id
        WHERE d.order_status <> i.order_status;
    END;

    -- Teste
    UPDATE olist_orders_dataset
    SET order_status = 'shipped'
    WHERE order_id = 'PEDIDO_TESTE_1';

    SELECT * FROM Log_StatusPedido;
    ```

4. Trigger para Garantir que a Data de Entrega Não Seja Antes da Data de Compra
    ```
    CREATE TRIGGER trg_ValidarDataEntrega
    ON olist_orders_dataset
    AFTER INSERT, UPDATE
    AS
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM INSERTED
            WHERE order_delivered_customer_date < order_purchase_timestamp
        )
        BEGIN
            RAISERROR ('A data de entrega não pode ser antes da data de compra!', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END;
    ```

Implementação de **_functions_**.

Função que retorna todos os pedidos de um cliente.
```
CREATE FUNCTION fn_PedidosPorCliente (@customer_id VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT order_id, order_status, order_purchase_timestamp
    FROM olist_orders_dataset
    WHERE customer_id = @customer_id
);
GO

SELECT * FROM dbo.fn_PedidosPorCliente('000379cdec625522490c315e70c7a9fb');
```

Implementação de **_transaction_**.

Inserir pedido e pagamento juntos. Se o pedido falhar, o pagamento também não entra.
```
BEGIN TRANSACTION;

BEGIN TRY
    -- Inserindo pedido
    INSERT INTO olist_orders_dataset (
        order_id, customer_id, order_status,
        order_purchase_timestamp, order_estimated_delivery_date
    )
    VALUES (
        'PEDIDO_TX1', '000379cdec625522490c315e70c7a9fb',
        'created', GETDATE(), DATEADD(DAY, 10, GETDATE())
    );

    -- Inserindo pagamento (incluindo installments)
    INSERT INTO olist_order_payments_dataset (
        order_id, payment_sequential, payment_type, payment_installments, payment_value
    )
    VALUES (
        'PEDIDO_TX1', 1, 'credit_card', 1, 250.00
    );

    -- Confirma as duas operações
    COMMIT TRANSACTION;
    PRINT 'Transação concluída com sucesso!';
END TRY
BEGIN CATCH
    -- Se der erro em qualquer uma, desfaz tudo
    ROLLBACK TRANSACTION;
    PRINT 'Erro: ' + ERROR_MESSAGE();
END CATCH;
```

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
Papel: Verificar a integridade do sistema e detectar inconsistências ou acessos indevidos por meio da análise de registros de atividade e cruzamento com os dados originais. - Permissões:
- SELECT na tabela de logs audit.ChangeLog
- SELECT em todas as tabelas operacionais (pedidos, pagamentos, produtos, avaliações, etc.)
- DENY em INSERT, UPDATE e DELETE para garantir que o auditor não possa modificar os dados
  
Monitora quem, quando e como os dados foram alterados nos módulos de pedidos, pagamentos, produtos e avaliações, sustentando práticas de governança, conformidade e rastreabilidade.
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

Nesta etapa do projeto, o objetivo foi implementar um Data Warehouse para a Olist, utilizando um esquema dimensional em estrela (Star Schema). Esse modelo foi escolhido por ser amplamente utilizado em Business Intelligence, pois organiza os dados em tabelas dimensão e em uma tabela fato, o que facilita a execução de consultas rápidas e análises estratégicas.

#### 3.1 Criação do Esquema Dimensional (Star Schema)
- Foram criadas cinco dimensões: Tempo, Cliente, Produto, Vendedor e Pagamento.
- No centro está a Tabela FatoVendas, que centraliza os dados de vendas e se conecta a todas as dimensões por meio de chaves estrangeiras.
- Essa estrutura permite realizar análises a partir de diferentes perspectivas, como tempo, produto, região e cliente.

#### 3.2 Processo de ETL (Extração, Transformação e Carga)

- As dimensões foram populadas a partir das tabelas operacionais.
- Na Dimensão Tempo, foram extraídos ano, mês e dia da data de compra.
- Na Dimensão Produto, foram carregados atributos relevantes como categoria e preço.
- A Tabela FatoVendas recebeu os dados integrados: cliente, produto, vendedor, forma de pagamento, quantidade e valor total.
- O uso de comandos JOIN garantiu a ligação correta entre fatos e dimensões.

#### 3.3 Consultas Analíticas (OLAP)
- 1 – Faturamento Mensal por Categoria de Produto
Consulta responsável por identificar o faturamento mensal de cada categoria de produto.
Objetivo: analisar sazonalidade de vendas e apoiar o planejamento de estoque e marketing.

- 2 – Tempo Médio de Entrega por Estado
Consulta que calcula a média de dias entre a compra e a entrega por estado.
Objetivo: identificar gargalos logísticos e otimizar processos de entrega.

- 3 – Top 5 Vendedores por Faturamento Anual
Consulta que retorna os cinco vendedores com maior faturamento anual.
Objetivo: destacar os melhores desempenhos e estabelecer referências para comparação.

Essas consultas foram selecionadas por sua relevância em resumir grandes volumes de dados de forma ágil e estratégica.

#### 3.4 Benefícios para a Olist

- Visão histórica consolidada: permite comparações entre diferentes períodos e identificação de tendências.
- Consultas otimizadas: o modelo dimensional melhora o desempenho em consultas analíticas.
- Suporte à decisão: os gestores têm acesso a relatórios estratégicos sobre vendas, logística e clientes.
