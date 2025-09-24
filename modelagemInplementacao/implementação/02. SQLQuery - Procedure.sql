USE OlistStore;

-- ============================================================================

-- 1. Listar todos os produtos
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

-- 2. Buscar produtos por categoria
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

-- 3. Contar produtos por categoria (com parâmetro de saída)
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

-- 4. Top categorias com mais produtos
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

-- ============================================================================
