
use escola2;

create table alunos(
alu_id int primary key auto_increment,
alu_nome varchar (100) not null,
alu_curso varchar (80),
alu_nota float
);

insert into alunos(alu_nome, alu_curso, alu_nota) value ('Kleyton', 'Desenvolvimento', '10.0');
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Klara', 'Desenvolvimento', '10.0');
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Muriel', 'Desenvolvimento', '8.0');
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Rom', 'Desenvolvimento', '6.0');
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Baki', 'Desenvolvimento', '1.0');
insert into alunos(alu_nome, alu_curso, alu_nota) value ('Pickle', 'Desenvolvimento', '5.0');

select alu_curso, avg(alu_nota) as alu_media
from alunos
where alu_curso = 'Desenvolvimento'
group by alu_curso;

select count(alu_nome)
from alunos
where alu_curso = 'Desenvolvimento'
group by alu_curso;

select max(alu_nota)
from alunos
where alu_curso = 'Desenvolvimento'
group by alu_curso;

select min(alu_nota)
from alunos
where alu_curso = 'Desenvolvimento'
group by alu_curso;

create table notas(
id_nota int primary key auto_increment,
cod_aluno int,
notas float,
foreign key (cod_aluno) references alunos(alu_id)
);

insert into notas(id_nota, notas) value ('1', 10);

SELECT notas, alu_nome, id_nota
FROM alunos
left JOIN notas ON alunos.alu_id = notas.cod_aluno;

create table materias(
mat_id int primary key auto_increment,
mat_nome varchar(100)
);

create table Aluno_materia(
amat_id int primary key auto_increment,
amat_fk_materia int not null,
amat_fk_aluno int not null,
FOREIGN KEY (amat_fk_materia) REFERENCES materias(mat_id),
FOREIGN KEY (amat_fk_aluno) REFERENCES alunos(alu_id)
);


delete from alunos;
set sql_safe_updates = 0;




