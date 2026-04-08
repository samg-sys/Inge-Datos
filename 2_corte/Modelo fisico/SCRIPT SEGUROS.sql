CREATE DATABASE companiaseguros;
USE companiaseguros;

CREATE TABLE compania(
    idCompania VARCHAR(50) PRIMARY KEY,
    nit VARCHAR(20) UNIQUE NOT NULL,
    nombreCompania VARCHAR(50) NOT NULL,
    fechaFundacion DATE NULL,
    representantelegar VARCHAR(50) NOT NULL
);

CREATE TABLE automovil (
    idauto VARCHAR(50) PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    anofabricacion INT NOT NULL,
    chasisserial VARCHAR(50) NOT NULL,
    cilindraje DOUBLE NOT NULL,
    pasajeros INT NOT NULL,
    anio INT NOT NULL
);

CREATE TABLE seguros(
    idSeguro VARCHAR(50) PRIMARY KEY,
    estado VARCHAR(20) NOT NULL,
    costo DOUBLE NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaExperiacion DATE NOT NULL,
    valorAsegurado DOUBLE NOT NULL,
    idCompaniaFK VARCHAR(50) NOT NULL,
    idAutomovilFK VARCHAR(50) NOT NULL
);

ALTER TABLE seguros ADD CONSTRAINT FKCompaniaSeguros FOREIGN KEY(idCompaniaFK) REFERENCES compania(idCompania);
ALTER TABLE seguros ADD CONSTRAINT FKSegurosAutomovil FOREIGN KEY(idAutomovilFK) REFERENCES automovil(idauto);

ALTER TABLE compania ADD direccionCompania VARCHAR(50) NOT NULL;
ALTER TABLE compania MODIFY nit INT;
ALTER TABLE compania CHANGE nit nitCompania VARCHAR(11);

CREATE DATABASE tiendaonline;
USE tiendaonline;

CREATE TABLE productos (
    idproducto INT PRIMARY KEY AUTO_INCREMENT,
    nombreproducto VARCHAR(50) NOT NULL,
    precioproducto INT NOT NULL,
    stockproducto INT DEFAULT 0,
    fechacreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE clientes (
    idcliente INT PRIMARY KEY AUTO_INCREMENT,
    nombrecliente VARCHAR(50) NOT NULL,
    emailcliente VARCHAR(50) UNIQUE NOT NULL,
    telefonocliente VARCHAR(20)
);

CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente_fk INT,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    monto_total INT,
    CONSTRAINT FK_cliente_pedido FOREIGN KEY (id_cliente_fk) REFERENCES clientes(idcliente)
);

ALTER TABLE clientes ADD ciudad VARCHAR(50);
ALTER TABLE productos ADD categoria VARCHAR(50);
ALTER TABLE clientes MODIFY telefonocliente VARCHAR(15);
ALTER TABLE productos DROP COLUMN fechacreacion;

INSERT INTO clientes (nombrecliente, emailcliente, telefonocliente, ciudad)
VALUES ('Juanita', 'juanita@gmaill.com', '3182930912', 'Tunja'),
       ('Jero', 'jeroa@gmaill.com', '3134942093', 'Pereira'),
       ('Silvana', 'vannis@gmaill.com', '3129349292', 'Bogota');

INSERT INTO productos (nombreproducto, precioproducto, stockproducto, categoria)
VALUES ('SpeedMax', 2500, 12, 'Bebidas Energeticas'),
       ('Arroz', 10000, 10, 'granos');

INSERT INTO pedidos (id_cliente_FK, fecha_pedido, monto_total)
VALUES (1, '2026-03-23', 12500);

UPDATE clientes SET ciudad = 'Bogota' WHERE idcliente = 2;
UPDATE productos SET stockproducto = stockproducto + 5 WHERE idproducto = 1;
UPDATE productos SET precioproducto = precioproducto * 0.90 WHERE idproducto = 2;

Set SQL_SAFE_UPDATES =0;

DELETE FROM pedidos WHERE id_pedido = 1;
DELETE FROM pedidos WHERE id_cliente_fk = 2;
DELETE FROM clientes WHERE idcliente = 2;
DELETE FROM productos WHERE stockproducto < 3;

SEt SQL_SAFE_UPDATES = 1;

#consultas

describe productos;
ALTER TABLE productos change stockproducto stoProdT int(11);


select nombreproducto, stoProdT from productos ;

select nombreproducto, stoProdT from productos where idProducto=1;
select nombreproducto as Nombre_producto, stoProT as Stock from productos where stoProT >= 15 and idProducto=1;

select nombreproducto as Nombre_producto, stoProT as Stock from productos
order by nombreproducto DESC; #Descendente

select nombreproducto as Nombre_producto, stoProT as Stock from productos
order by nombreproducto ASC; #Ascendente

select nombreproducto as Nombre_producto, stoProT as Stock from productos where stoProT >= 15 or idProducto=1;

select nombreproducto as Nombre_producto, stoProT as Stock from productos
order by nombreproducto DESC; #Descendente

select nombreproducto as Nombre_producto, stoProT as Stock from productos
order by nombreproducto ASC; #Ascendente

# Between va para mostrar rangos de (tin, tan)
# select (nombre del campo o *) from (nombre de la tabla) between tin and tan

#like que inicien o que teminen con cierto caracteres, dependiendo de la ubicación del % será (Incio = 'loquesea%')(Contenencia = '%loquesea%')(Termina = '%loquesea')
select * from productos where nombreproducto like '%max'

#Reto Hacer 2 consltas especificas con minimo 2 metodos  numericos y de caracteres. 
## FALTA Agrupaciones, operaciones calculadas, multitablas, subconsultas. 



 ##Subconsultas
/*Consultas Anidadas SubQuery select 
select col1,col2
from tabla_Princial
where columna operador
	(select col1,col2
	from tabla_Secundaria
	where condicion); 
Escalar devuelve  un único valor o fila o columna 
de fila devuelve una sola fila con varias columnas ROw()
de tabla devuelve varias filas y varias columnas
correlacional

 1. reto 1 crear tabla empleados (id,nombre,deptoId, salario), producto (id,nombre,precio,categoria),
 departamento(id,nombre)
 2. Vamos a registrar 5 empleados 3 departamentos y 5 productos*/

CREATE DATABASE empresa_db;

USE empresa_db;

-- Tabla: departamentos

CREATE TABLE departamentos (

  idDepto INT PRIMARY KEY,

  nombreDepto VARCHAR(50)

);

-- Tabla: empleados

CREATE TABLE empleados (

  idEmp INT PRIMARY KEY,

  nombreEmp VARCHAR(50),

  depto_id INT,

  salarioEmp DECIMAL(10,2),

  FOREIGN KEY (depto_id) REFERENCES departamentos(idDepto)

);

-- Tabla: productos

CREATE TABLE productos (

  idProd INT PRIMARY KEY,

  nombreProd VARCHAR(60),

  precioProd DECIMAL(10,2),

  categoriaProd VARCHAR(40)

);
 
INSERT INTO departamentos (idDepto, nombreDepto) VALUES

(1, 'Recursos Humanos'),

(2, 'Tecnología'),

(3, 'Ventas'),

(4, 'Finanzas');
 
INSERT INTO empleados (idEmp, nombreEmp, depto_id, salarioEmp) VALUES

(101, 'Carlos Pérez', 2, 3500000.00),

(102, 'Laura Gómez', 1, 2800000.00),

(103, 'Andrés Rodríguez', 3, 3000000.00),

(104, 'María López', 4, 4000000.00),

(105, 'Juan Martínez', 2, 3700000.00);
 
INSERT INTO productos (idProd, nombreProd, precioProd, categoriaProd) VALUES

(201, 'Laptop Lenovo', 2500000.00, 'Tecnología'),

(202, 'Mouse Inalámbrico', 80000.00, 'Accesorios'),

(203, 'Teclado Mecánico', 150000.00, 'Accesorios'),

(204, 'Monitor 24 pulgadas', 700000.00, 'Tecnología'),

(205, 'Silla Ergonómica', 900000.00, 'Oficina');

select*from empleados;


/*Subconsultas*/
###-----Where----
select nombreEmp,salarioEmp 
from empleados
where salarioEmp>
	(select AVG(salarioEmp)
    from empleados);
    
 ###-----Where+in----
select nombreEmp,salarioEmp 
from empleados
where depto_id in 
	(select idDepto
    from departamentos
    where nombreDepto in ('Ventas','Tecnología'));
   
   
 ###-----tabla derivada----
select depto_id,prom_salario
from 
	(select depto_id,AVG(salarioEmpleado)as prom_salario
	from empleados
    group by depto_id) as promedios
where prom_salario > 2800000.000000

    
select nombreEmp, salarioEmp, 
  (select AVG(salarioEmp) from empleados) as promedio_general,
  (salarioEmp - (select AVG(salarioEmp) from empleados)) as diferencia
from empleados;


select nombreProducto, precioProducto, categoriaProducto
from productos
where precioProducto >(select AVG(precioProducto) from productos)
order by  precioProducto desc;
    
