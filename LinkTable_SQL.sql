-- SQL

-- 1. Criação das Tabelas de Dimensões

-- Criação da tabela de dimensão Data
CREATE TABLE DimData AS
SELECT DISTINCT DataID, Data
FROM (
  SELECT DataID, Data FROM Vendas
  UNION
  SELECT DataID, Data FROM Despesas
);

-- Criação da tabela de dimensão Produto
CREATE TABLE DimProduto AS
SELECT DISTINCT ProdutoID, Produto
FROM (
  SELECT ProdutoID, Produto FROM Vendas
  UNION
  SELECT ProdutoID, Produto FROM Despesas
);
-- 2. Criação da Link Table
-- Criação da Link Table
CREATE TABLE LinkTable AS
SELECT DISTINCT
  DataID,
  ProdutoID,
  CONCAT(DataID, '-', ProdutoID) AS LinkKey
FROM (
  SELECT DataID, ProdutoID FROM Vendas
  UNION
  SELECT DataID, ProdutoID FROM Despesas
);
-- 3. Modificação das Tabelas de Fatos
-- Criação da tabela de fatos Vendas sem as colunas de dimensão e com a chave composta
CREATE TABLE FatosVendas AS
SELECT
  VendasID,
  Quantidade,
  Valor AS ValorVendas,
  CONCAT(DataID, '-', ProdutoID) AS LinkKey
FROM Vendas;

-- Criação da tabela de fatos Despesas sem as colunas de dimensão e com a chave composta
CREATE TABLE FatosDespesas AS
SELECT
  DespesaID,
  Custo AS CustoDespesas,
  CONCAT(DataID, '-', ProdutoID) AS LinkKey
FROM Despesas;

/*
// Carregar dados de Dimensões
DimData:
LOAD
  DataID,
  Data
SQL SELECT DataID, Data FROM DimData;

DimProduto:
LOAD
  ProdutoID,
  Produto
SQL SELECT ProdutoID, Produto FROM DimProduto;

// Carregar dados da Link Table
LinkTable:
LOAD
  DataID,
  ProdutoID,
  LinkKey
SQL SELECT DataID, ProdutoID, LinkKey FROM LinkTable;

// Carregar dados de Fatos Vendas
FatosVendas:
LOAD
  VendasID,
  Quantidade,
  ValorVendas,
  LinkKey
SQL SELECT VendasID, Quantidade, ValorVendas, LinkKey FROM FatosVendas;

// Carregar dados de Fatos Despesas
FatosDespesas:
LOAD
  DespesaID,
  CustoDespesas,
  LinkKey
SQL SELECT DespesaID, CustoDespesas, LinkKey FROM FatosDespesas;

*/
