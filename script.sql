CREATE DATABASE galeria;

USE galeria;

CREATE TABLE artista (
cpf char(11) primary key,
nomeReal varchar(45) not null,
nomeArtistico varchar(45)
);
#DROP TABLE artista; #Caso precise alterar algo na tabela remova o # no começo da linha.

CREATE TABLE cliente (
cpf char(11) primary key,
nome varchar(45) not null,
rua varchar(45) not null,
numero varchar(10) not null,
bairro varchar(45) not null,
cidade varchar(45) not null,
estado char(2) not null,
cep varchar(8) not null,
idade varchar(3), #Testar se aqui passa texto por conta do tipo
sexo varchar(45) check (sexo = 'M' or 'F' or null),
numeroFone varchar(45) not null,
dddFone char(3) not null,
numDeCupons varchar(45),
FK_funcionario char(11) not null,
FK_cliente char(11), #Chave do auto-relacionamento de indicação entre clientes
constraint FK_funcionarioEmCliente foreign key (FK_funcionario) references funcionario(cpf)
);
#DROP TABLE cliente; #Caso precise alterar algo na tabela remova o # no começo da linha.

#alterando a tabela cliente para adicionar a chave opcional do auto-relacionamento
ALTER TABLE cliente
modify FK_cliente char(11),
add constraint FK_clienteEmCliente foreign key (FK_cliente) references cliente(cpf);

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
dataNasc date not null check (dataNasc < sysdate()), #Garantindo que não seja uma data futura.
pis char(11) not null unique, #chave candidata
numeroCarteira char(7) not null,
uf char(2) not null,
serie char(4) not null,
funcao varchar(45) not null
);
#DROP TABLE funcionario; #Caso precise alterar algo na tabela remova o # no começo da linha.

CREATE TABLE especialidade (
IDespecialidade varchar(45),
FK_artista char(11) not null,
constraint FK_artistaEmEspecialidade foreign key (FK_artista) references artista(cpf),
constraint PK_especialidade primary key (IDespecialidade, FK_artista)
);
#DROP TABLE especialidade; #Caso precise alterar algo na tabela remova o # no começo da linha.

CREATE TABLE estudio (
cnpj char(14) primary key,
nome varchar(45) not null,
endereco varchar(45) not null
);
#DROP TABLE estudio; #Caso precise alterar algo na tabela remova o # no começo da linha.

#Entidade fraca
CREATE TABLE exposicao (
numero int auto_increment,
convidados varchar(45) not null,
dataRealizacao date not null check (dataRealizacao < sysdate()), 
FK_estudio char(14) not null,
constraint PK_exposicao primary key (numero, FK_estudio),
constraint FK_estudioEmExposicao foreign key (FK_estudio) references estudio(cnpj)
);
#DROP TABLE exposicao; #Caso precise alterar algo na tabela remova o # no começo da linha.

CREATE TABLE interesse (
IDinteresse varchar(45),
FK_cliente char(11),
constraint PK_interesse primary key (IDinteresse, FK_cliente),
constraint FK_clienteEmInteresse foreign key (FK_cliente) references cliente(cpf)
);
#DROP TABLE interesse; #Caso precise alterar algo na tabela remova o # no começo da linha.

#Entidade que contém especialização
CREATE TABLE peca (
codigoPeca int primary key,
titulo varchar(45) not null
);
#DROP TABLE peca; #Caso precise alterar algo na tabela remova o # no começo da linha.

#Especialização de peça
CREATE TABLE fisica (
FK_CodigoPeca int primary key,
peso decimal(4,2) not null,
comprimento decimal(3,2) not null,
largura decimal(3,2) not null,
altura decimal(3,2) not null,
constraint FK_CodigoPecaEmFisica foreign key (FK_CodigoPeca) references peca(codigoPeca)
);
#DROP TABLE fisica; #Caso precise alterar algo na tabela remova o # no começo da linha.

#Especialização de peça
CREATE TABLE digital (
FK_CodigoPeca int primary key,
token varchar(45) not null,
constraint FK_CodigoPecaEmDigital foreign key (FK_CodigoPeca) references peca(codigoPeca)
);
#DROP TABLE digital; #Caso precise alterar algo na tabela remova o # no começo da linha.

#Tabela de cardinalidade N:N
CREATE TABLE exibidaEm (
FK_CodigoPeca int,
FK_exposicao int,
constraint PK_Exibicao primary key (FK_CodigoPeca, FK_exposicao),
constraint FK_CodigoPecaExibida foreign key (FK_CodigoPeca) references peca(codigoPeca),
constraint FK_ExibidaEmExposicao foreign key (FK_exposicao) references exposicao(numero)
);
#DROP TABLE exibidaEm; #Caso precise alterar algo na tabela remova o # no começo da linha.

#Agregação de pedido
CREATE TABLE pedido (
codPedido int primary key,
FK_cliente char(11) not null, #Isso deve ser unique?
FK_CodigoPeca varchar(45) not null unique,
dataPedido date not null check (dataPedido < sysdate()),
notaFiscal varchar(45) not null,
tipoEntrega varchar(45) not null check (tipoEntrega = 'Retirada na loja' or 'Entrega em domicílio'),
constraint AK_pedido unique (FK_cliente, FK_codigoPeca)
);
#DROP TABLE pedido; #Caso precise alterar algo na tabela remova o # no começo da linha.

CREATE TABLE produz (
FK_artista char(11) not null,
FK_CodigoPeca int not null,
constraint PK_produz primary key (FK_artista, FK_CodigoPeca),
constraint FK_artistaEmProduz foreign key (FK_artista) references artista(cpf),
constraint FK_CodigoPecaEmProduz foreign key (FK_CodigoPeca) references peca(codigoPeca)
);
#DROP TABLE produz; #Caso precise alterar algo na tabela remova o # no começo da linha.

#show tables;