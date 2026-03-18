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

## Describir estructura de las tablas

describe compania;
## PAra relacionar hay 2 opciones, crear la tabla dentro de la misma para que estén relacionadas

#Crear una base de datos llamada tienda online y seleccionarla para usarla 
create database tiendaonline;
use tiendaonline;
##reto 2

create table productos(
idprod int unique auto_increment,
nombre varchar(20) NOT NULL,
precio,
stock,
fecha
);

##Reto 3

create table cliente(
idcliente int primary key ,
nombcliente varchar(20),
emailcliente varchar(20),
telefonocliente int not null
);

create table Pedidos(
idpedi int primary key,
idclienteFK int
fechapedido date time,
totalpedido int not null
);

/*Reto 4 Realiza los siguientes cambuos en las tablas ya creadas
agrega una columba categoria varchar 50 en productos 
cambia el tipo de dato de telefono en clientes a varchar 15
renombra la columna total de pedidos a monto_Total
Eliminal la columna fecha creacion de productos
*/

alter table pedidos add column categoria varchar (50);
alter table cliente change column telefonocliente varchar (15);
rename table pedidos to monto_total;
drop column fechacreacion producto; 























