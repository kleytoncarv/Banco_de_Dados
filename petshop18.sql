create database PetShopBraba;
use PetShopBraba;

CREATE TABLE Racas (
    r_id INT AUTO_INCREMENT PRIMARY KEY,
    r_nome VARCHAR(100)
);

CREATE TABLE Clientes(
	c_id int primary key auto_increment,
	c_nome varchar(100),
	c_fd int,
	c_total_comprado FLOAT,
	CONSTRAINT fk_c_fd FOREIGN KEY (c_fd) REFERENCES Forma_de_Pagamento(fd_forma_id)
);

CREATE TABLE Animais (
    a_animal_id INT AUTO_INCREMENT PRIMARY KEY,
    a_nome VARCHAR(255),
    a_cliente_id INT,
    a_rid  INT,
    q_quantidade_de_banhos INT,
    CONSTRAINT fk_cliente_id FOREIGN KEY (a_cliente_id) REFERENCES Clientes(c_id),
    CONSTRAINT fk_raça_id FOREIGN KEY (a_rid) REFERENCES Racas(r_id)
);

CREATE TABLE Vacinas (
    v_vacina_id INT AUTO_INCREMENT PRIMARY KEY,
    v_nome VARCHAR(100),
    v_descricao TEXT,
    v_validade DATE,
    v_preço int
);

CREATE TABLE Funcionarios (
    f_funcionario_id INT AUTO_INCREMENT PRIMARY KEY,
    f_nome VARCHAR(255),
    f_cargo VARCHAR(100),
    f_salario DECIMAL(10, 2),
    f_comissao float
);

CREATE TABLE Ordem_de_servico (
    o_ordem_id INT AUTO_INCREMENT PRIMARY KEY,
    o_animal_id INT,
    o_funcionario_id INT,
    o_data_do_servico DATE,
    o_valor_total DECIMAL(10, 2),
    CONSTRAINT fk_animal_id FOREIGN KEY (o_animal_id) REFERENCES Animais(a_animal_id),
    CONSTRAINT fk_funcionario_id FOREIGN KEY (o_funcionario_id) REFERENCES Funcionarios(f_funcionario_id)
);

CREATE TABLE Produto_Servico (
    ps_produto_servico_id INT AUTO_INCREMENT PRIMARY KEY,
    ps_nome VARCHAR(255),
    ps_descricao TEXT,
    ps_preco DECIMAL(10, 2),
    ps_serv_estoque FLOAT
);

CREATE TABLE Itens_da_ordem_de_servico (
    ido_item_id INT AUTO_INCREMENT PRIMARY KEY,
    ido_ordem_id INT,
    ido_produto_servico_id INT,
    ido_quantidade INT,
    ido_valor_unitario DECIMAL(10, 2),
    CONSTRAINT fk_ordem_id FOREIGN KEY (ido_ordem_id) REFERENCES Ordem_de_servico(o_ordem_id),
    CONSTRAINT fk_produto_servico_id FOREIGN KEY (ido_produto_servico_id) REFERENCES Produto_Servico(ps_produto_servico_id)
);

CREATE TABLE Vacinas_aplicadas (
    va_aplicacao_id INT AUTO_INCREMENT PRIMARY KEY,
    va_animal_id INT,
    va_vacina_id INT,
    va_data_aplicacao DATE,
    va_proxima_dose DATE,
    CONSTRAINT va_fk_animal_id FOREIGN KEY (va_animal_id) REFERENCES Animais(a_animal_id),
    CONSTRAINT fk_vacina_id FOREIGN KEY (va_vacina_id) REFERENCES Vacinas(v_vacina_id)
);

CREATE TABLE Forma_de_pagamento (
    fd_forma_id INT AUTO_INCREMENT PRIMARY KEY,
    fd_nome VARCHAR(50)
);

CREATE TABLE Recebimento (
    re_recebimento_id INT AUTO_INCREMENT PRIMARY KEY,
    re_ordem_id INT,
    re_forma_id INT,
    re_valor DECIMAL(10, 2),
    re_data_recebimento DATE,
    CONSTRAINT fk_r_ordem_id FOREIGN KEY (re_ordem_id) REFERENCES Ordem_de_servico(o_ordem_id),
    CONSTRAINT fk_forma_id FOREIGN KEY (re_forma_id) REFERENCES Forma_de_pagamento(fd_forma_id)
);

create table Estoque(
	e_id int Primary key auto_increment,
	e_produto_serviço_id int,
	e_estoque float,
	CONSTRAINT e_fk_produto_serviço_id FOREIGN KEY (e_produto_serviço_id) REFERENCES Produto_Servico(ps_produto_servico_id)
);

create table Lucro(
	l_id int Primary key auto_increment,
	l_produto_serviço_id int,
	l_lucro float,
	CONSTRAINT l_fk_produto_serviço_id  FOREIGN KEY (l_produto_serviço_id) REFERENCES Produto_Servico(ps_produto_servico_id)
);

CREATE VIEW Cliente_Raca_Animais_v2 AS
SELECT c.c_id, c.c_nome, r.r_id, r.r_nome, a.a_animal_id, a.a_nome, a.q_quantidade_de_banhos
FROM Clientes c
INNER JOIN Animais a ON c.c_id = a.a_cliente_id
INNER JOIN Racas r ON a.a_rid = r.r_id;
SELECT * FROM Cliente_Raca_Animais_v2;

------------------------------------

CREATE TRIGGER Tgr_Estoque_Insert_BaixaDoLucro AFTER INSERT
ON itens_da_ordem_de_servico
FOR EACH ROW
UPDATE lucro SET l_lucro = produto_servico.ps_valor - produto_servico.ps_custo
WHERE l_produto_serviço_id = NEW.ido_produto_servico_id;

---------------------------------------------------

CREATE TRIGGER Tgr_Estoque_Insert_BaixaDoLucro AFTER INSERT
ON itens_da_ordem_de_servico
FOR EACH ROW
UPDATE lucro
SET l_lucro = (SELECT ps_preco - ps_custo FROM produto_servico WHERE ps_produto_servico_id = NEW.ido_produto_servico_id)
WHERE l_produto_serviço_id = NEW.ido_produto_servico_id;

------------------------

CREATE TRIGGER Tgr_Estoque_Insert_VoltaDoLucro AFTER DELETE
ON itens_da_ordem_de_servico
FOR EACH ROW
UPDATE lucro
SET l_lucro = l_lucro - (SELECT ps_preco - ps_custo FROM produto_servico WHERE ps_produto_servico_id = OLD.ido_produto_servico_id)
WHERE l_produto_serviço_id = OLD.ido_produto_servico_id;

----------

CREATE TRIGGER Tgr_Estoque_Insert_BaixaDoEstoque AFTER INSERT
ON itens_da_ordem_de_servico
FOR EACH ROW
UPDATE estoque SET e_estoque = e_estoque - NEW.ido_quantidade
WHERE e_produto_serviço_id = NEW.ido_produto_servico_id;

CREATE TRIGGER Tgr_Estoque_Delete_Volta_estoque AFTER DELETE
ON itens_da_ordem_de_servico
FOR EACH ROW
UPDATE estoque SET e_estoque = e_estoque + OLD.ido_quantidade
WHERE e_produto_serviço_id = OLD.ido_produto_servico_id;

------------

CREATE TABLE Agendamento (
    ag_id INT AUTO_INCREMENT PRIMARY KEY,
    ag_animal_id INT,
    ag_data DATE,
    ag_horario TIME,
    ag_servico VARCHAR(100),
    ag_observacoes TEXT,
    CONSTRAINT fk_ag_animal_id FOREIGN KEY (ag_animal_id) REFERENCES Animais(a_animal_id)
);

CREATE TABLE Ranking (
    r_id INT AUTO_INCREMENT PRIMARY KEY,
    r_animal_id INT,
    r_total INT,
    CONSTRAINT fk_r_animal_id FOREIGN KEY (r_animal_id) REFERENCES Animais (a_animal_id)
);

CREATE TABLE Animal_Historico (
    ah_id INT AUTO_INCREMENT PRIMARY KEY,
    ah_animal_id INT,
    ah_data DATE,
    ah_evento VARCHAR(100),
    ah_observacoes TEXT,
    CONSTRAINT fk_ah_animal_id FOREIGN KEY (ah_animal_id) REFERENCES Animais(a_animal_id)
);