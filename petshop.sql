create database petshop2;
use petshop2;

CREATE TABLE Clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) not null,
  endereco VARCHAR(100),
  telefone VARCHAR(20)
);

CREATE TABLE Animais (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  cliente_id INT,
  raca_id INT,
  FOREIGN KEY (cliente_id) REFERENCES Clientes(id),
  FOREIGN KEY (raca_id) REFERENCES Racas(id)
);

CREATE TABLE Vacinas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  data_aplicacao DATE,
  animal_id INT,
  FOREIGN KEY (animal_id) REFERENCES Animais(id)
);

CREATE TABLE OrdemServico (
  id INT AUTO_INCREMENT PRIMARY KEY,
  data_servico DATE,
  animal_id INT,
  funcionario_id INT,
  forma_pagamento_id INT,
  FOREIGN KEY (animal_id) REFERENCES Animais(id),
  FOREIGN KEY (funcionario_id) REFERENCES Funcionarios(id),
  FOREIGN KEY (forma_pagamento_id) REFERENCES FormaPagamento(id)
);

CREATE TABLE ItensOrdemServico (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ordem_servico_id INT,
  produto_servico_id INT,
  quantidade INT,
  FOREIGN KEY (ordem_servico_id) REFERENCES OrdemServico(id),
  FOREIGN KEY (produto_servico_id) REFERENCES ProdutoServico(id)
);

CREATE TABLE ProdutoServico (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  tipo ENUM('Produto', 'Servico'),
  preco DECIMAL(10, 2)
);

CREATE TABLE VacinasAplicadas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  vacina_id INT,
  animal_id INT,
  data_proxima_dose DATE,
  FOREIGN KEY (vacina_id) REFERENCES Vacinas(id),
  FOREIGN KEY (animal_id) REFERENCES Animais(id)
);

CREATE TABLE FormaPagamento (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100)
);

CREATE TABLE Funcionarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  comissao DECIMAL(10, 2)
);

CREATE TABLE Recebimento (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ordem_servico_id INT,
  valor DECIMAL(10, 2),
  FOREIGN KEY (ordem_servico_id) REFERENCES OrdemServico(id)
);

CREATE TABLE Racas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100)
);

INSERT INTO Clientes (nome, endereco, telefone) VALUES('João Silva', 'Rua A, 123', '1234567890'), ('Maria Santos', 'Avenida B, 456', '9876543210');
INSERT INTO Racas (nome) VALUES ('Golden'), ('ViraLata');
INSERT INTO Animais (nome, cliente_id, raca_id) VALUES('Rex', 1, 1), ('Mel', 1, 2);
  
SELECT * FROM petshop2.clientes;
SELECT * FROM petshop2.animais;
