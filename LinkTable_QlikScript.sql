-- Qlik Srcipt

// Carregar dados de Vendas
Vendas:
LOAD
    VendasID,
    DataID,
    ProdutoID,
    Quantidade,
    Valor AS ValorVendas
FROM [Vendas.qvd] (qvd);

// Carregar dados de Despesas
Despesas:
LOAD
    DespesaID,
    DataID,
    ProdutoID,
    Custo AS CustoDespesas
FROM [Despesas.qvd] (qvd);

// Carregar dados de Dimensões
DimData:
LOAD
    DataID,
    Data
FROM [DimData.qvd] (qvd);

DimProduto:
LOAD
    ProdutoID,
    Produto
FROM [DimProduto.qvd] (qvd);

// Criação da Link Table
LinkTable:
LOAD DISTINCT
    DataID,
    ProdutoID,
    DataID & '-' & ProdutoID AS %LinkKey
RESIDENT Vendas;

CONCATENATE (LinkTable)
LOAD DISTINCT
    DataID,
    ProdutoID,
    DataID & '-' & ProdutoID AS %LinkKey
RESIDENT Despesas;

// Eliminar campos de dimensão das tabelas de fatos
DROP FIELDS DataID, ProdutoID FROM Vendas;
DROP FIELDS DataID, ProdutoID FROM Despesas;

// Adicionar chave composta (%LinkKey) nas tabelas de fatos
LEFT JOIN (Vendas)
LOAD
    DataID,
    ProdutoID,
    DataID & '-' & ProdutoID AS %LinkKey
RESIDENT LinkTable;

LEFT JOIN (Despesas)
LOAD
    DataID,
    ProdutoID,
    DataID & '-' & ProdutoID AS %LinkKey
RESIDENT LinkTable;
