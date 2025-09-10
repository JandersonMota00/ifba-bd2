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

  1. Subir Automaticamente as tabelas **via flat file, e dentre outras formas de importação** a denpender da natureza dos datasheets. 
  
  2. Vale a pena ressaltar que, a  anterior é eficiente na maioria dos casos as excessões são para casos em que as tabelas não são facilmente identificadas. Nesse sentido, é aplicavel o metodo de **Burk Insert**, que em sintese se resume a criar a tabela no banco pegando as colunas e suas tipagems de cada datasheet e criar o comando **BULK INSERT**, passando a referencia da tabela criada `FROM './datasheet/product_category_name_translation.csv'`, caminho do CSV `FROM './datasheet/product_category_name_translation.csv'` e as configurações de inserção necessarias para reconhecer o datasheet e subir os dados.

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


---

### 2. Auditoria e Segurança

### 3. Data Warehouse e OLAP
