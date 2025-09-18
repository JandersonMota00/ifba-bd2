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
.
.
.
#### 2.2. Configuração de Usuário Auditor

Foi criado o login aud123 com senha segura, vinculado ao usuário AuditorUser no banco TrabalhoBD2. Esse usuário foi adicionado à role db_auditor, com as seguintes permissões:

✅ Permissão de leitura na tabela audit.ChangeLog

❌ Negado acesso (SELECT, INSERT, UPDATE, DELETE) às tabelas operacionais:

-- 2.2.1 Criar login do auditor:
```
CREATE LOGIN aud123
  WITH PASSWORD = 'Aud!t0r#2025';
GO
```

-- 2.2.2 Criar Usuário do banco de dados
```
USE [TrabalhoBD2];
GO
```
-- 2.2.3 Cria o usuário de banco para o login aud123
```
IF NOT EXISTS (
  SELECT 1
  FROM sys.database_principals
  WHERE name = 'AuditorUser'
)
  CREATE USER AuditorUser
    FOR LOGIN aud123;
GO
```
-- 2.2.4 Cria a role de auditor (se ainda não existir)
```
IF NOT EXISTS (
  SELECT 1
  FROM sys.database_principals
  WHERE name = 'db_auditor' AND type = 'R'
)
  CREATE ROLE db_auditor;
GO
```
-- 2.2.5 Adiciona o usuário à role
```
ALTER ROLE db_auditor
  ADD MEMBER AuditorUser;
GO

-- 3 Permissões do usuário 
-- 3.1Permitir apenas leitura na tabela de logs
GRANT SELECT
  ON audit.ChangeLog
  TO db_auditor;
GO
```
-- 2.2.6 Negar acesso às tabelas operacionais
```
DENY SELECT, INSERT, UPDATE, DELETE
  ON dbo.olist_customers_dataset       TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE
  ON dbo.olist_orders_dataset          TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE
  ON dbo.olist_geolocation_dataset          TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE
  ON dbo.olist_order_payments_dataset          TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE
  ON dbo.olist_order_reviews_dataset          TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE
  ON dbo.olist_products_dataset          TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE
  ON dbo.olist_sellers_dataset          TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE
  ON dbo.product_category_name_translation        TO db_auditor;
DENY SELECT, INSERT, UPDATE, DELETE
  ON dbo.olist_order_items_dataset          TO db_auditor;
GO
```
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
