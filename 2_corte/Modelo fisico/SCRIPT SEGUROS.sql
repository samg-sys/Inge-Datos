create database companiasseguros;
use companiasseguros;
create table compania(
idcompania varchar(50) primary key, 
nit varchar(20) unique not null,
nombrecompania varchar (50) not null,
fechaFundacion date null,
representantelegal varchar(50)not null);

create table seguros(
idseguro varchar (50) primary key,
estado varchar(20) not null,
costo double not null,
fechadeinicio date not null,
fechavencimiento date not null,
valorasegurado double not null,
idcompaniaFK varchar (50) not null,
idautomovilFK varchar (50) not null
);

create table automovil (
idauto varchar (50) primary key,
marca varchar (50) not null,
modelo varchar (50) not null,
tipo varchar (50) not null,
anofabricacion int not null,
chasisserial varchar (50) not null,
cilindraje double not null,
pasajeros int not null
);

create table accidente(
idaccidente int primary key,
accidentefecha date not null,
lugar varchar (50) not null,
heridos int null,
fatalidades int null,
automotores int not null);

create table detalleaccidente(
iddetalle int primary key,
idaccidenteFK varchar (50) not null,
idautoFK varchar (50) not null
);