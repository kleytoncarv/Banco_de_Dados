create database orbitaKleyton;
use orbitaKleyton;

CREATE TABLE Clientes (
    ID_cliente INT AUTO_INCREMENT PRIMARY KEY,
    NomeCompleto VARCHAR(255) NOT NULL,
    NomeQueGostariaDeSerChamado VARCHAR(255),
    CPF CHAR(11) NOT NULL UNIQUE,
    DataNascimento DATE,
    Telefone VARCHAR(20),
    Email VARCHAR(255),
    Bairro VARCHAR(255),
    Cidade VARCHAR(255),
    Estado VARCHAR(255)
);

CREATE TABLE Pasteis (
    ID_pastel INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Preco DECIMAL(10, 2) NOT NULL,
    Recheio VARCHAR(255) NOT NULL,
    Tamanho VARCHAR(255) NOT NULL,
    Categoria VARCHAR(255) NOT NULL
);


CREATE TABLE Pedidos (
    ID_pedido INT AUTO_INCREMENT PRIMARY KEY,
    DataPedido DATE NOT NULL,
    FormaPagamento VARCHAR(255) NOT NULL,
    ClienteID INT,
    FOREIGN KEY (ClienteID) REFERENCES Clientes (ID_cliente)
);

CREATE TABLE ItensPedido (
    ID_item INT AUTO_INCREMENT PRIMARY KEY,
    PedidoID INT,
    ProdutoID INT,
    Quantidade INT,
    FOREIGN KEY (PedidoID) REFERENCES Pedidos (ID_pedido),
    FOREIGN KEY (ProdutoID) REFERENCES Pasteis (ID_pastel)
);

CREATE TABLE Bebidas (
    ID_bebida INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Preco DECIMAL(10, 2) NOT NULL
);


#------------------------- essa parte são os inserts -------------------------------------

INSERT INTO Clientes (NomeCompleto, NomeQueGostariaDeSerChamado, CPF, DataNascimento, Telefone, Email, Bairro, Cidade, Estado)
VALUES
('João Silva', 'João', '12345678901', '1990-05-15', '+55123456789', 'joao@email.com', 'Bairro A', 'Cidade X', 'Estado Y'),
('Maria Souza', 'Maria', '98765432101', '1985-09-20', '+55198765432', 'maria@email.com', 'Bairro B', 'Cidade Z', 'Estado W'),
('Guilherme', 'Gui', '1122335544', '1999-05-15', '+55752255445', 'gui@gmail.com', 'Bairro C', 'Feira', 'BA');

INSERT INTO Pasteis (Nome, Preco, Recheio, Tamanho, Categoria)
VALUES
('Pastel de Queijo', 5.99, 'Queijo', 'Médio', 'Normal'),
('Pastel de Frango', 6.99, 'Frango', 'Grande', 'Normal'),
('Pastel Vegano de Legumes', 7.99, 'Legumes', 'Médio', 'Vegano'),
('Pastel de Bacon e Queijo', 8.99, 'Bacon e Queijo', 'Médio', 'Normal');

INSERT INTO Pedidos (DataPedido, FormaPagamento, ClienteID)
VALUES
('2023-10-01', 'Cartão de Crédito', 1),
('2023-10-02', 'Dinheiro', 2);

INSERT INTO ItensPedido (PedidoID, ProdutoID, Quantidade)
VALUES
(1, 1, 2), -- 2 unidades do Pastel de Queijo no primeiro pedido
(1, 3, 1), -- 1 unidade do Pastel Vegano de Legumes no primeiro pedido
(2, 2, 3); -- 3 unidades do Pastel de Frango no segundo pedido

INSERT INTO Bebidas (Nome, Preco)
VALUES
('Refrigerante de Cola', 4.49);


-- aqui lista os pedidos de pastel vegano de pessoas acima de 18 anos
SELECT DISTINCT p.Nome
FROM Pasteis p
INNER JOIN ItensPedido ip ON p.ID_pastel = ip.ProdutoID
INNER JOIN Pedidos pe ON ip.PedidoID = pe.ID_pedido
INNER JOIN Clientes c ON pe.ClienteID = c.ID_cliente
WHERE p.Categoria = 'Vegano' AND (YEAR(CURRENT_DATE) - YEAR(c.DataNascimento)) > 18;

-- cliente com maiores numero de pedido realizados em 1 ano agrupado por mes
SELECT MONTH(pe.DataPedido) AS Mês, COUNT(pe.ID_pedido) AS NúmeroDePedidos, c.NomeCompleto AS Cliente
FROM Pedidos pe
INNER JOIN Clientes c ON pe.ClienteID = c.ID_cliente
WHERE YEAR(pe.DataPedido) = YEAR(CURRENT_DATE)
GROUP BY Mês, Cliente
ORDER BY Mês, NúmeroDePedidos DESC;


-- lista pastel com bacon e queijo
SELECT Nome
FROM Pasteis
WHERE Recheio LIKE '%bacon%' AND Recheio LIKE '%queijo%';

-- valor total de todos pasteis à venda
SELECT SUM(Preco) AS ValorTotalDeVenda
FROM Pasteis;

-- Lista de todos os pedidos onde há pelo menos um pastel e uma bebida
SELECT pe.ID_pedido AS NúmeroDoPedido
FROM Pedidos pe
INNER JOIN ItensPedido ip ON pe.ID_pedido = ip.PedidoID
INNER JOIN Pasteis p ON ip.ProdutoID = p.ID_pastel
WHERE EXISTS (SELECT 1 FROM ItensPedido WHERE PedidoID = pe.ID_pedido AND ProdutoID IN (SELECT ID_pastel FROM Pasteis))
AND EXISTS (SELECT 1 FROM ItensPedido WHERE PedidoID = pe.ID_pedido AND ProdutoID IN (SELECT ID_bebida FROM Bebidas))
LIMIT 0, 1000;

-- em ordem crescente, vai listar os pasteis mais vendidos
SELECT p.Nome, COUNT(ip.ProdutoID) AS QuantidadeDeVendas
FROM Pasteis p
LEFT JOIN ItensPedido ip ON p.ID_pastel = ip.ProdutoID
GROUP BY p.Nome
ORDER BY QuantidadeDeVendas ASC;





