-- Dimensão Tempo
CREATE TABLE dbo.DimTempo (
    IdTempo INT IDENTITY(1,1) PRIMARY KEY,
    Data DATE,
    Ano INT,
    Mes INT,
    Dia INT
);

-- Dimensão Cliente
CREATE TABLE dbo.DimCliente (
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    CustomerUniqueId NVARCHAR(50),
    Estado NVARCHAR(2),
    Cidade NVARCHAR(100)
);

-- Dimensão Produto
CREATE TABLE dbo.DimProduto (
    IdProduto INT IDENTITY(1,1) PRIMARY KEY,
    ProductID NVARCHAR(50),
    Categoria NVARCHAR(100),
    Preco DECIMAL(10,2)
);

-- Dimensão Vendedor
CREATE TABLE dbo.DimVendedor (
    IdVendedor INT IDENTITY(1,1) PRIMARY KEY,
    SellerID NVARCHAR(50),
    Estado NVARCHAR(2),
    Cidade NVARCHAR(100)
);

-- Dimensão Pagamento
CREATE TABLE dbo.DimPagamento (
    IdPagamento INT IDENTITY(1,1) PRIMARY KEY,
    TipoPagamento NVARCHAR(50),
    Parcelas INT
);
-- Tabela Fato Vendas
CREATE TABLE dbo.FatoVendas (
    IdFato INT IDENTITY(1,1) PRIMARY KEY,
    IdTempo INT NOT NULL,
    IdCliente INT NOT NULL,
    IdProduto INT NOT NULL,
    IdVendedor INT NOT NULL,
    IdPagamento INT NOT NULL,
    Quantidade INT,
    ValorTotal DECIMAL(10,2),
    FOREIGN KEY (IdTempo) REFERENCES DimTempo(IdTempo),
    FOREIGN KEY (IdCliente) REFERENCES DimCliente(IdCliente),
    FOREIGN KEY (IdProduto) REFERENCES DimProduto(IdProduto),
    FOREIGN KEY (IdVendedor) REFERENCES DimVendedor(IdVendedor),
    FOREIGN KEY (IdPagamento) REFERENCES DimPagamento(IdPagamento)
);
