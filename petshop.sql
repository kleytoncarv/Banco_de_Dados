create database petshop;
use petshop;

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
  data_aplicacao DATE,
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
  
SELECT * FROM petshop.clientes;
SELECT * FROM petshop.animais;


SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1; #modo seguro

UPDATE Funcionarios AS F
JOIN (
    SELECT OS.funcionario_id, SUM(PS.preco * IOS.quantidade) AS faturamento
    FROM OrdemServico AS OS
    JOIN ItensOrdemServico AS IOS ON OS.id = IOS.ordem_servico_id
    JOIN ProdutoServico AS PS ON IOS.produto_servico_id = PS.id
    WHERE OS.data_servico BETWEEN '2023-01-01' AND '2023-12-31' 
    GROUP BY OS.funcionario_id
) AS FaturamentoPorFuncionario ON F.id = FaturamentoPorFuncionario.funcionario_id
SET F.comissao = FaturamentoPorFuncionario.faturamento * 0.03;

ALTER TABLE VacinasAplicadas
ADD data_aplicacao DATE;

#eu descobri que pra ativar essas func precisa usar o set em 0 mas dps precisa voltar pro modo seguro
UPDATE VacinasAplicadas AS VA
JOIN (
    SELECT vacina_id, MAX(data_aplicacao) AS ultima_data_aplicacao
    FROM VacinasAplicadas
    GROUP BY vacina_id
) AS UltimaDataPorVacina ON VA.vacina_id = UltimaDataPorVacina.vacina_id
SET VA.data_proxima_dose = DATE_ADD(UltimaDataPorVacina.ultima_data_aplicacao, INTERVAL 1 YEAR);


ALTER TABLE OrdemServico
ADD valor_total float;
ALTER TABLE Clientes
ADD total_comprado DECIMAL(10, 2) DEFAULT 0;

UPDATE Clientes AS C
JOIN (
    SELECT A.cliente_id, SUM(OS.valor_total) AS total_comprado
    FROM Animais AS A
    JOIN OrdemServico AS OS ON A.id = OS.animal_id
    GROUP BY A.cliente_id
) AS TotalCompradoPorCliente ON C.id = TotalCompradoPorCliente.cliente_id
SET C.total_comprado = TotalCompradoPorCliente.total_comprado;

#tenha piedade da gente na próxima vez professora 
