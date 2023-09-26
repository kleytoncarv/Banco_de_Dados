CREATE DATABASE LojaDoKleyton;
use LojaDoKleyton;


CREATE TABLE Cliente (
    IDCliente INT PRIMARY KEY,
    Nome VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE Produto (
    IDProduto INT PRIMARY KEY,
    Nome VARCHAR(50),
    Preco DECIMAL(10, 2)
);

CREATE TABLE Pedido (
    IDPedido INT PRIMARY KEY,
    DataPedido DATE,
    IDCliente INT,
    FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente)
);

CREATE TABLE ItemPedido (
    IDItemPedido INT PRIMARY KEY,
    IDPedido INT,
    IDProduto INT,
    Quantidade INT,
    FOREIGN KEY (IDPedido) REFERENCES Pedido(IDPedido),
    FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto)
);

CREATE TABLE Estoque (
    IDEstoque INT PRIMARY KEY,
    IDProduto INT,
    Quantidade INT,
    FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto)
);

CREATE TABLE Fornecedor (
    IDFornecedor INT PRIMARY KEY,
    Nome VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE Compra (
    IDCompra INT PRIMARY KEY,
    DataCompra DATE,
    IDFornecedor INT,
    FOREIGN KEY (IDFornecedor) REFERENCES Fornecedor(IDFornecedor)
);

CREATE TABLE ItemCompra (
    IDItemCompra INT PRIMARY KEY,
    IDCompra INT,
    IDProduto INT,
    Quantidade INT,
    FOREIGN KEY (IDCompra) REFERENCES Compra(IDCompra),
    FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto)
);

CREATE TABLE Funcionario (
    IDFuncionario INT PRIMARY KEY,
    Nome VARCHAR(50),
    Cargo VARCHAR(50)
);

CREATE TABLE RegistroAlteracaoPreco (
    IDRegistro INT PRIMARY KEY AUTO_INCREMENT,
    IDProduto INT,
    NovoPreco DECIMAL(10, 2),
    DataAlteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto)
);


CREATE TABLE Devolucao (
    IDDevolucao INT PRIMARY KEY,
    DataDevolucao DATE,
    IDProduto INT,
    Quantidade INT,
    Motivo VARCHAR(255),
    FOREIGN KEY (IDProduto) REFERENCES Produto(IDProduto)
);

-- parte das views
CREATE VIEW ViewPedidosMaisRecentes AS
SELECT IDPedido, DataPedido
FROM Pedido
ORDER BY DataPedido DESC
LIMIT 5;

CREATE VIEW ViewProdutosMaisVendidos AS
SELECT p.Nome, SUM(ip.Quantidade) AS TotalVendido
FROM Produto p
JOIN ItemPedido ip ON p.IDProduto = ip.IDProduto
GROUP BY p.Nome
ORDER BY TotalVendido DESC
LIMIT 5;

CREATE VIEW ViewEstoqueBaixo AS
SELECT e.IDEstoque, p.Nome AS NomeProduto, e.Quantidade
FROM Estoque e
JOIN Produto p ON e.IDProduto = p.IDProduto
WHERE e.Quantidade < 10;

CREATE VIEW ViewComprasFornecedor AS
SELECT c.IDCompra, c.DataCompra, f.Nome AS NomeFornecedor
FROM Compra c
JOIN Fornecedor f ON c.IDFornecedor = f.IDFornecedor
ORDER BY c.DataCompra DESC
LIMIT 5;

-- parte dos Trigger
DELIMITER //
CREATE TRIGGER TriggerAtualizarEstoqueAposPedido
AFTER INSERT ON ItemPedido
FOR EACH ROW
BEGIN
    UPDATE Estoque
    SET Quantidade = Quantidade - NEW.Quantidade
    WHERE IDEstoque = NEW.IDProduto;
END;
//

DELIMITER ;

-- Trigger para atualizar o preço médio do produto após a inserção de uma nova compra
DELIMITER //
CREATE TRIGGER TriggerAtualizarPrecoMedio
AFTER INSERT ON ItemCompra
FOR EACH ROW
BEGIN
    DECLARE total_quantidade INT;
    DECLARE total_valor DECIMAL(10, 2);
    DECLARE preco_medio DECIMAL(10, 2);

    -- Calcula o total de quantidade e valor para o produto afetado pela compra
    SELECT SUM(Quantidade), SUM(Quantidade * (SELECT Preco FROM Produto WHERE IDProduto = NEW.IDProduto))
    INTO total_quantidade, total_valor
    FROM ItemCompra
    WHERE IDProduto = NEW.IDProduto;

    -- Calcula o novo preço médio
    SET preco_medio = total_valor / total_quantidade;

    -- Atualiza o preço médio do produto na tabela Produto
    UPDATE Produto
    SET Preco = preco_medio
    WHERE IDProduto = NEW.IDProduto;
END;
//

-- Trigger para registrar alterações de preço de produtos
DELIMITER //
CREATE TRIGGER TriggerRegistroAlteracaoPreco
AFTER UPDATE ON Produto
FOR EACH ROW
BEGIN
    INSERT INTO RegistroAlteracaoPreco (IDProduto, NovoPreco, DataAlteracao)
    VALUES (OLD.IDProduto, NEW.Preco, NOW());
END;
//

-- Trigger para atualizar a quantidade de produtos em estoque após uma devolução
DELIMITER //
CREATE TRIGGER TriggerAtualizarEstoqueAposDevolucao
AFTER INSERT ON Devolucao
FOR EACH ROW
BEGIN
    UPDATE Estoque
    SET Quantidade = Quantidade + NEW.Quantidade
    WHERE IDEstoque = NEW.IDProduto;
END;
//

DELIMITER ;

-- essa parte é as informações inseridas nas tabelas
--
-- Tabela Cliente
INSERT INTO Cliente (IDCliente, Nome, Email)
VALUES
    (1, 'João Silva', 'joao@example.com'),
    (2, 'Maria Santos', 'maria@example.com'),
    (3, 'Carlos Ferreira', 'carlos@example.com');

-- Tabela Produto
INSERT INTO Produto (IDProduto, Nome, Preco)
VALUES
    (1, 'Camiseta', 19.99),
    (2, 'Calça Jeans', 39.99),
    (3, 'Tênis', 59.99);

-- Tabela Pedido
INSERT INTO Pedido (IDPedido, DataPedido, IDCliente)
VALUES
    (1, '2023-09-01', 1),
    (2, '2023-09-05', 2),
    (3, '2023-09-10', 1);

-- Tabela ItemPedido
INSERT INTO ItemPedido (IDItemPedido, IDPedido, IDProduto, Quantidade)
VALUES
    (1, 1, 1, 3),
    (2, 1, 2, 2),
    (3, 2, 3, 1);

-- Tabela Estoque
INSERT INTO Estoque (IDEstoque, IDProduto, Quantidade)
VALUES
    (1, 1, 50),
    (2, 2, 30),
    (3, 3, 40);

-- Tabela Fornecedor
INSERT INTO Fornecedor (IDFornecedor, Nome, Email)
VALUES
    (1, 'Fornecedor A', 'fornecedorA@example.com'),
    (2, 'Fornecedor B', 'fornecedorB@example.com');

-- Tabela Compra
INSERT INTO Compra (IDCompra, DataCompra, IDFornecedor)
VALUES
    (1, '2023-09-02', 1),
    (2, '2023-09-06', 2),
    (3, '2023-09-12', 1);

-- Tabela ItemCompra
INSERT INTO ItemCompra (IDItemCompra, IDCompra, IDProduto, Quantidade)
VALUES
    (1, 1, 1, 100),
    (2, 1, 2, 50),
    (3, 2, 3, 80);

-- Tabela Funcionario
INSERT INTO Funcionario (IDFuncionario, Nome, Cargo)
VALUES
    (1, 'Ana Pereira', 'Vendedor'),
    (2, 'Pedro Santos', 'Gerente');

-- Tabela Devolucao
INSERT INTO Devolucao (IDDevolucao, DataDevolucao, IDProduto, Quantidade, Motivo)
VALUES
    (1, '2023-09-07', 1, 5, 'Produto com defeito'),
    (2, '2023-09-08', 2, 2, 'Tamanho errado'),
    (3, '2023-09-15', 3, 3, 'Não era o produto desejado');
    
