CREATE DATABASE galeria;

USE galeria;

CREATE TABLE artista (
cpf char(11) primary key,
nomeReal varchar(45) not null,
nomeArtistico varchar(45)
);

CREATE TABLE cliente (
cpf char(11) primary key,
nome varchar(45) not null,
rua varchar(45) not null,
numero varchar(10) not null,
bairro varchar(45) not null,
cidade varchar(45) not null,
estado char(2) not null,
cep varchar(8) not null,
idade varchar(3),
sexo varchar(45) check ('M' or 'F' or null),
numeroFone varchar(45) not null,
dddFone char(3) not null,
numDeCupons varchar(45),
FK_funcionario char(11) not null,
FK_cliente char(11), #Chave do auto-relacionamento de indicação entre clientes
constraint FK_funcionarioEmCliente foreign key (FK_funcionario) references funcionario(cpf)
#constraint FK_clienteEmCliente foreign key (FK_cliente) references cliente(cpf)
);

#alterando a tabela cliente para adicionar a chave opcional do auto-relacionamento
ALTER TABLE cliente
modify FK_cliente char(11),
add constraint FK_clienteEmCliente foreign key (FK_cliente) references cliente(cpf)
;

CREATE TABLE funcionario (
cpf char(11) primary key,
nome varchar(45) not null,
rua varchar(45) not null,
numeroResidencia varchar(45) not null,
bairro varchar(45) not null,
cidade varchar(45) not null,
estado char(2) not null,
cep varchar(8) not null,
salario decimal (10,2) not null check (salario > 0),
etnia varchar(45),
dataNasc date not null, #check menor ou igual a atual
pis char(11) not null unique, #chave candidata
numeroCarteira char(7) not null,
uf char(2) not null,
serie char(4) not null,
funcao varchar(45) not null
);

CREATE TABLE especialidade (
IDespecialidade varchar(45) primary key,
FK_artista char(11) not null,
constraint FK_artistaEmEspecialidade foreign key (FK_artista) references artista(cpf)
);

CREATE TABLE estudio (
cnpj char(14) primary key,
nome varchar(45) not null,
endereco varchar(45) not null
);

#Entidade fraca
CREATE TABLE exposicao (
numero int auto_increment,
convidados varchar(45) not null,
data date not null, #check menor ou igual a atual
FK_estudio char(14) not null,
constraint PK_exposicao primary key (numero, FK_estudio),
constraint FK_estudioEmExposicao foreign key (FK_estudio) references estudio(cnpj)
);

CREATE TABLE interesse (
IDinteresse varchar(45),
FK_cliente char(11),
constraint PK_interesse primary key (IDinteresse, FK_cliente),
constraint FK_clienteEmInteresse foreign key (FK_cliente) references cliente(cpf)
);

CREATE TABLE peca (
codigoPeca int primary key,
titulo varchar(45) not null
);

#Especialização de peça
CREATE TABLE fisica (
FK_CodigoPeca int primary key,
peso decimal(4,2) not null,
comprimento decimal(3,2) not null,
largura decimal(3,2) not null,
altura decimal(3,2) not null,
constraint FK_CodigoPecaEmFisica foreign key (FK_CodigoPeca) references peca(codigoPeca)
);

#Especialização de peça
CREATE TABLE digital (
FK_CodigoPeca int primary key,
token varchar(45) not null,
constraint FK_CodigoPecaEmDigital foreign key (FK_CodigoPeca) references peca(codigoPeca)
);

#Tabela de cardinalidade N:N
CREATE TABLE exibidaEm (
FK_CodigoPeca int,
FK_exposicao int,
constraint PK_Exibicao primary key (FK_CodigoPeca, FK_exposicao),
constraint FK_CodigoPecaExibida foreign key (FK_CodigoPeca) references peca(codigoPeca),
constraint FK_ExibidaEmExposicao foreign key (FK_exposicao) references exposicao(numero)
);

#Agregação de pedido
CREATE TABLE pedido (
codPedido int primary key,
FK_cliente char(11) not null,
FK_CodigoPeca varchar(45) not null,
data date not null,
notaFiscal varchar(45) not null,
tipoEntrega varchar(45) not null
);

CREATE TABLE produz (
FK_artista char(11) not null,
FK_CodigoPeca int not null,
constraint PK_produz primary key (FK_artista, FK_CodigoPeca)
);

show tables;