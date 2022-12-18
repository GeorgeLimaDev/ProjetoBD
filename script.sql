#Parte 1: Criação do banco
CREATE DATABASE galeria;

USE galeria;

CREATE TABLE artista (
cpf char(11) primary key check (length(cpf) = 11),
nomeReal varchar(45) not null,
nomeArtistico varchar(45)
);
#DROP TABLE artista; #Caso precise alterar algo na tabela remova o # no começo da linha.

CREATE TABLE cliente (
cpf char(11) primary key check (length(cpf) = 11),
nome varchar(45) not null,
rua varchar(45) not null,
numero varchar(10) not null,
bairro varchar(45) not null,
cidade varchar(45) not null,
estado char(2) not null check (length(estado) = 2),
cep varchar(8) not null check (length(cep) = 8),
idade varchar(3),
sexo varchar(45) check (sexo = 'M' or sexo = 'F' or sexo = null),
numeroFone varchar(45) not null check (length(numeroFone) >= 8),
dddFone char(3) not null check (length(dddFone) = 2),
numDeCupons varchar(45) default(0),
FK_funcionario char(11) not null,
FK_cliente char(11), #Chave do auto-relacionamento opcional de indicação entre clientes
constraint FK_funcionarioEmCliente foreign key (FK_funcionario) references funcionario(cpf)
);
#DROP TABLE cliente; #Caso precise alterar algo na tabela remova o # no começo da linha.

#alterando a tabela cliente para adicionar a chave opcional do auto-relacionamento
ALTER TABLE cliente
modify FK_cliente char(11),
add constraint FK_clienteEmCliente foreign key (FK_cliente) references cliente(cpf);

CREATE TABLE funcionario (
cpf char(11) primary key check (length(cpf) = 11),
nome varchar(45) not null,
rua varchar(45) not null,
numeroResidencia varchar(45) not null,
bairro varchar(45) not null,
cidade varchar(45) not null,
estado char(2) not null check (length(estado) = 2),
cep varchar(8) not null check (length(cep) = 8),
salario decimal (10,2) not null check (salario > 0), #testar
etnia varchar(45),
dataNasc date not null, check (dataNasc < sysdate()),
pis char(11) not null unique check (length(pis) = 11), #chave candidata
numeroCarteira char(7) not null check (length(numeroCarteira) = 7),
uf char(2) not null check (length(uf) = 2),
serie char(4) not null check (length(serie) = 4),
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
cnpj char(14) primary key check (length(cnpj) = 14),
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

#Entidade que contém a especialização
CREATE TABLE peca (
codigoPeca int primary key,
titulo varchar(45) not null
);
#DROP TABLE peca; #Caso precise alterar algo na tabela remova o # no começo da linha.

#Especialização de peça
CREATE TABLE fisica (
FK_CodigoPeca int, #Chave herdada da entidade generalista peca
peso decimal(4,2) not null,
comprimento decimal(3,2) not null,
largura decimal(3,2) not null,
altura decimal(3,2) not null,
constraint FK_CodigoPecaEmFisica foreign key (FK_CodigoPeca) references peca(codigoPeca)
);
#DROP TABLE fisica; #Caso precise alterar algo na tabela remova o # no começo da linha.

#Especialização de peça
CREATE TABLE digital (
FK_CodigoPeca int, #Chave herdada da entidade generalista peca
token varchar(45) not null unique, #Chave candidata
constraint FK_CodigoPecaEmDigital foreign key (FK_CodigoPeca) references peca(codigoPeca)
);
#DROP TABLE digital; #Caso precise alterar algo na tabela remova o # no começo da linha.

#Tabela de cardinalidade N:N
CREATE TABLE exibidaEm (
FK_CodigoPeca int,
FK_exposicao int,
constraint PK_ExibidaEm primary key (FK_CodigoPeca, FK_exposicao),
constraint FK_CodigoPecaExibida foreign key (FK_CodigoPeca) references peca(codigoPeca),
constraint FK_ExibidaEmExposicao foreign key (FK_exposicao) references exposicao(numero)
);
#DROP TABLE exibidaEm; #Caso precise alterar algo na tabela remova o # no começo da linha.

#Agregação
CREATE TABLE pedido (
codPedido int primary key,
FK_cliente char(11) not null,
FK_CodigoPeca int not null unique,
dataPedido date not null check (dataPedido < sysdate()),
notaFiscal varchar(45) not null,
tipoEntrega varchar(45) not null check (tipoEntrega = 'Retirada na loja' or tipoEntrega = 'Entrega em domicílio'),
constraint AK_pedido unique (FK_cliente, FK_codigoPeca),
constraint FK_clienteEmPedido foreign key (FK_cliente) references cliente(cpf),
constraint FK_CodigoPecaEmPedido foreign key (FK_CodigoPeca) references peca(codigoPeca)
);
#DROP TABLE pedido; #Caso precise alterar algo na tabela remova o # no começo da linha.

#Tabela de cardinalidade N:N
CREATE TABLE produz (
FK_artista char(11) not null,
FK_CodigoPeca int not null,
constraint PK_produz primary key (FK_artista, FK_CodigoPeca),
constraint FK_artistaEmProduz foreign key (FK_artista) references artista(cpf),
constraint FK_CodigoPecaEmProduz foreign key (FK_CodigoPeca) references peca(codigoPeca)
);
#DROP TABLE produz; #Caso precise alterar algo na tabela remova o # no começo da linha.

#show tables;

#Parte 2: Alimentando o banco:
INSERT funcionario values (
'12345678900',
'João José da Silva',
'Rua dos prazeres',
'100',
'Mangabeira',
'João Pessoa',
'PB',
'58309000',
2500.00,
null,
01/05/1995,
'12345678910',
'1234567',
'PB',
'1010',
'recepcionista'
);
UPDATE funcionario set dataNasc = '1995-5-1' where cpf = '12345678900'; #Atualizando sem precisar excluir pois já está referenciado em um cliente.

INSERT funcionario values (
'98765432100',
'Maria do Rosário Cavalcante da Silva',
'Avenida Brasil',
'45',
'Jardim Aeroporto',
'Bayeux',
'PB',
'58309090',
5000.00,
'Parda',
'1989-7-7',
'98765432101',
'7654321',
'PB',
'0945',
'contadora'
);

INSERT funcionario values (
'98745612000',
'Maria Barbosa Calixto',
'Rua dos Alfineiros',
'4',
'Jaguaribe',
'João Pessoa',
'PB',
'58309384',
5000.00,
'Branca',
'1981-10-21',
'98765432100',
'7654323',
'PB',
'7394',
'curadora'
);

INSERT funcionario values (
'13846294649',
'Amanda Cruz de Araújo',
'Rua da vitória',
'100',
'Jaguaribe',
'João Pessoa',
'PB',
'58307391',
10000.00,
'Branca',
'1995-6-15',
'99374501200',
'1284562',
'PB',
'8423',
'Diretora geral'
);

INSERT funcionario values (
'86346811627',
'Amauri Gomes Olimpio Flor',
'Rua Orlando da Cunha',
'137',
'Mutirão',
'Bayeux',
'PB',
'58112576',
1500.00,
null,
'1990-10-18',
'93826485710',
'3767456',
'PB',
'2895',
'Estagiário'
);

INSERT cliente values (
'87865694982',
'Washington Luís Pedreiro da Rocha',
'Avenida Beira Mar',
'15',
'Manaíra',
'João Pessoa',
'PB',
'58309384',
null,
'M',
'99999-0909',
'83',
default,
'12345678900',
null
);

INSERT cliente values (
'94385923712',
'Gabrielly dos Santos',
'Rua Vitória da Conquista',
'13',
'Tibiri',
'Santa Rita',
'PB',
'58309421',
'27',
'F',
'987642365',
'83',
default,
'12345678900',
'87865694982'
);

INSERT cliente values (
'18452055686',
'Pedro Henricky Diniz',
'Rua Vitória da Conquista',
'13',
'Tibiri',
'Santa Rita',
'PB',
'58309421',
'27',
'M',
'987642365',
'83',
default,
'12345678900',
'94385923712'
);

UPDATE cliente set numDeCupons = 1 where cpf = '94385923712'; #Adicionando um cupom para Gabrielly por ter indicado Pedro

INSERT cliente values (
'46194571525',
'Felipe Cartaxo de Freitas',
'Avenida dos Navegantes',
'171',
'Cruz das Armas',
'João Pessoa',
'PB',
'58309823',
null,
null,
'991638462',
'83',
default,
'12345678900',
null
);

INSERT cliente values (
'83496628464',
'Diego Augusto Barbosa Calixto',
'Travessa Bombeiro Martins',
'5',
'Conjunto União',
'Santa Rita',
'PB',
'58309914',
38,
'M',
'932320268',
'83',
default,
'12345678900',
null
);

INSERT interesse values (
'arte moderna',
'87865694982'
), (
'NFTs',
'87865694982'
);

INSERT interesse values (
'Estética asiática',
'94385923712'
);

INSERT interesse values (
'nacionalismo',
'83496628464'
);

INSERT interesse values (
'NFTs',
'46194571525'
);

INSERT artista values (
'13142453587',
'Ricardo Brenant III',
'Richie the 3rd'
);

INSERT artista values (
'84802748671',
'Edicarlos Araújo',
'Ed'
);

INSERT artista values (
'08503999471',
'George Barbosa de Lima',
null
);

INSERT artista values (
'84958621837',
'Luiz Carlos de Pontes Filho',
null
);

INSERT artista values (
'84015456788',
'Ellen Bianca Brito da Fonseca',
'Francesa'
);

INSERT especialidade values (
'Arte digital',
'13142453587'
), (
'Surrealismo',
'13142453587'
);

INSERT especialidade values (
'Pintura',
'84802748671'
), (
'Esculturas',
'84802748671'
);

INSERT especialidade values (
'Fotografia',
'84958621837'
);

INSERT peca values (
101,
'Travelling through space'
);

INSERT peca values (
204,
'Estátua bacana'
);

INSERT peca values (
551,
'Paisagem na moldura'
);

INSERT peca values (
812,
'Jarro esculpido'
);

INSERT peca values (
306,
'Fotografia conceitual'
);

INSERT peca values (
609,
'Óleo sobre tela'
);

INSERT fisica values (
551,
1.5,
0.50,
0.50,
0.50
);

INSERT fisica values (
812,
10.0,
1,
1,
1
);

INSERT fisica values (
306,
0.10,
0.80,
0.80,
0.45
);

INSERT fisica values (
609,
3,
0.20,
0.60,
0.50
);

INSERT peca values (
353,
'Monkeypox'
);

INSERT peca values (
702,
'Brazilian Aesthetics'
);

INSERT peca values (
482,
'Pegasus Fantasy'
);

INSERT peca values (
555,
'worthless NFT'
);

INSERT digital values (
101,
'#%jsahdiahsnD81278643'
);

INSERT digital values (
353,
'dauhsmnbee124435457m__daeds7864'
);

INSERT digital values (
702,
'iahsnD812786124435457m__daeds7864'
);

INSERT digital values (
482,
'lnJBDIGWYIUG9634879u¨*&IBKJBD*&vfada'
);

INSERT digital values (
555,
'DOHNAODH67987bvu1IG*¨&%¨&V'
);

INSERT produz values (
'13142453587',
'101'
);

INSERT estudio values (
'94985873762192',
'Coletivo de arte Paraibano',
'Rua das Trincheiras 145 Centro João Pessoa PB'
);

INSERT estudio values (
'93649164956960',
'Associação de escultores de João Pessoa',
'Rua Primavera 25 Tambaú João Pessoa PB'
);

INSERT estudio values (
'98164527257412',
'Estúdio Flor do Campo',
'Rua dos Operários 80 Sesi Bayeux PB'
);

INSERT estudio values (
'90168464826278',
'International Crafts',
'Av. Ruy Carneiro 1000 Manaíra João Pessoa PB'
);

INSERT estudio values (
'51253891247443',
'União da Feira de Tambaú',
'Av. Epitácio Pessoa 15 Miramar João Pessoa PB'
);

INSERT estudio values (
'27465924384678',
'União dos artistas de Bayeux',
'Av. Liberdade 3 Centro Bayeux PB'
);

INSERT exposicao values (
default, #Recebe o valor auto-incrementado
'Fulano, Cicrano, Beltrano...',
'2022-12-17',
'94985873762192'
);

INSERT exposicao values (
default,
'Fulano, Cicrano, Beltrano...',
'2022-12-17',
'94985873762192'
);

INSERT exposicao values (
default,
'Fulano, Cicrano, Beltrano...',
'2022-11-15',
'90168464826278'
);

INSERT exposicao values (
default,
'Fulano, Cicrano, Beltrano...',
'2021-11-21',
'98164527257412'
);

INSERT exposicao values (
default,
'Fulano, Cicrano, Beltrano...',
'2022-5-1',
'51253891247443'
);

INSERT fisica values (
204,
05.50,
1.05,
1.00,
1.00
);

INSERT pedido values (
1,
'87865694982',
101,
'2022-12-16',
'123456789',
'Entrega em domicílio'
);

INSERT pedido values (
2,
'87865694982',
353,
'2022-12-17',
'987654321',
'Entrega em domicílio'
);

INSERT pedido values (
3,
'46194571525',
812,
'2022-11-18',
'283947561',
'Retirada na loja'
);

INSERT pedido values (
4,
'94385923712',
306,
'2021-5-12',
'984727401',
'Retirada na loja'
);

INSERT pedido values (
5,
'94385923712',
551,
'2022-2-4',
'376885671',
'Retirada na loja'
);

INSERT exibidaEm values (
101,
3
);

INSERT exibidaEm values (
353,
3
);

INSERT exibidaEm values (
353,
4
);

INSERT exibidaEm values (
609,
4
),(
555,
4
);

INSERT produz values (
'84802748671',
812
);

INSERT produz values (
'84958621837',
812
);

INSERT produz values (
'08503999471',
353
),(
'08503999471',
555
);

#Agrupando a visualização das inserções aqui:
#SELECT * FROM artista;
#SELECT * FROM cliente;
#SELECT * FROM digital;
#SELECT * FROM especialidade;
#SELECT * FROM estudio;
#SELECT * FROM exibidaEm;
#SELECT * FROM exposicao;
#SELECT * FROM fisica;
#SELECT * FROM funcionario;
#SELECT * FROM interesse;
#SELECT * FROM peca;
#SELECT * FROM pedido;
#SELECT * FROM produz; #Algumas peças ficaram sem autor. Isso deveria ser possível?
#SELECT * from produz right JOIN peca on codigoPeca = FK_codigoPeca; #Possível problema no relacionamento N:N

#Parte 3: Consultas no banco: (remover comentários dos SELECTs para executar a consulta)

#Consulta da tabela cliente retornando apenas os clientes que informaram seus sexos.
#SELECT nome, sexo from cliente WHERE sexo in ('M', 'F');

#Consulta da tabela funcionario retornando apenas os funcionários nascidos na década de 90
#SELECT cpf, nome, dataNasc from funcionario WHERE year(dataNasc) between 1990 AND 1995;

#Consulta da tabela artista retornando apenas os artistas que tenham nomes artisticos
#SELECT * from artista WHERE nomeArtistico is not null;

#Consulta da tabela estudio retornando apenas os estúdios na cidade de Bayeux
#SELECT * from estudio WHERE endereco like '%Bayeux%';

#Consulta da tabela pedido retornando os pedidos ordenados por data (mais recentes primeiro)
#SELECT * from pedido ORDER BY dataPedido desc;

#Consulta da tabela fisica (peca) retornando o peso médio das peças cadastradas
#SELECT AVG (peso) as pesoMedio from fisica;

#Consulta da tabela funcionario retornando o maior e o menor salário
#SELECT max(salario) as maiorSalario, min(salario) as menorSalario from funcionario;

#Consulta da tabela cliente agrupando o número de clientes pro bairro
#SELECT count(bairro), bairro from cliente GROUP BY bairro;

#Consulta da tabela pedido retornando apenas o tipo de entrega em domicílio
#SELECT * from pedido HAVING tipoEntrega = 'Entrega em domicílio';

#Consulta conjunta das tabelas artista e especialidade
#SELECT * from artista JOIN especialidade on cpf = FK_artista;
