create database proceduree;
use proceduree;


create table cliente(
cliID int auto_increment primary key,
nome varchar (120),
endere varchar (120),
cpf int
);

create table ordem_servico(
ord_cli_id INT AUTO_INCREMENT PRIMARY KEY,
o_data_do_servico DATE,
o_valor_total DECIMAL(10, 2)
);	

DELIMITER //

CREATE PROCEDURE GetrOrdem_servico_cli(IN cliID INT)
BEGIN
	SELECT * FROM ordem_servico WHERE ord_cli_id = cliID;
END //

DELIMITER ;

CALL GetrOrdem_servico_cli(12)
