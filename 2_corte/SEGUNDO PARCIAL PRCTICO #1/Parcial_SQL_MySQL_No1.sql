-- ===================================================== 

-- DDL: CREACION DE BASE DE DATOS Y TABLAS 

-- ===================================================== 

DROP DATABASE IF EXISTS tienda_tech; 

CREATE DATABASE tienda_tech CHARACTER SET utf8mb4; 

USE tienda_tech; 

 
CREATE TABLE clientes ( 
    cliente_id      INT AUTO_INCREMENT PRIMARY KEY, 
    nombre          VARCHAR(100) NOT NULL, 
    email           VARCHAR(100) UNIQUE NOT NULL, 
    ciudad          VARCHAR(60), 
    fecha_registro  DATE DEFAULT (CURRENT_DATE) 
); 

CREATE TABLE productos ( 
    producto_id  INT AUTO_INCREMENT PRIMARY KEY, 
    nombre       VARCHAR(100) NOT NULL, 
    categoria    VARCHAR(60), 
    precio       DECIMAL(10,2) NOT NULL CHECK (precio > 0), 
    stock        INT DEFAULT 0 
); 

CREATE TABLE pedidos ( 
    pedido_id    INT AUTO_INCREMENT PRIMARY KEY, 
    cliente_id   INT NOT NULL, 
    producto_id  INT NOT NULL, 
    cantidad     INT NOT NULL CHECK (cantidad > 0), 
    fecha_pedido DATE DEFAULT (CURRENT_DATE), 
    estado       VARCHAR(20) DEFAULT "pendiente" 
	CHECK (estado IN ("pendiente","entregado","cancelado")), 
    FOREIGN KEY (cliente_id)  REFERENCES clientes(cliente_id), 
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id) 
); 


-- ===================================================== 

-- DML: DATOS DE PRUEBA 

-- ===================================================== 

INSERT INTO clientes VALUES 
 (1,"Ana Lopez","ana@mail.com","Bogota","2023-01-15"), 
 (2,"Carlos Ruiz","carlos@mail.com","Medellin","2023-03-22"), 
 (3,"Maria Torres","maria@mail.com","Cali","2023-05-10"), 
 (4,"Pedro Gomez","pedro@mail.com","Bogota","2023-07-08"), 
 (5,"Sofia Herrera","sofia@mail.com","Barranquilla","2023-09-01"), 
 (6,"Luis Martinez","luis@mail.com","Bogota","2024-01-20"), 
 (7,"Camila Vargas","camila@mail.com","Cali","2024-02-14"),
 (8,"Diego Morales","diego@mail.com","Medellin","2024-03-30"); 

INSERT INTO productos VALUES 
 (1,"Laptop Pro 15","Computadores",3500000.00,12), 
 (2,"Mouse Inalambrico","Perifericos",85000.00,50), 
 (3,"Teclado Mecanico","Perifericos",220000.00,30), 
 (4,"Monitor 27","Pantallas",1200000.00,8), 
 (5,"Auriculares BT","Audio",350000.00,25), 
 (6,"Webcam HD","Perifericos",180000.00,20), 
 (7,"Disco SSD 1TB","Almacenamiento",420000.00,40), 
 (8,"Tablet 10","Moviles",1800000.00,6); 
 
INSERT INTO pedidos VALUES 
 (1,1,1,1,"2024-01-10","entregado"),(2,1,2,2,"2024-01-15","entregado"), 
 (3,2,3,1,"2024-02-05","entregado"),(4,2,5,1,"2024-02-20","cancelado"), 
 (5,3,4,1,"2024-03-01","entregado"),(6,3,7,2,"2024-03-15","pendiente"), 
 (7,4,2,3,"2024-04-02","entregado"),(8,4,6,1,"2024-04-10","pendiente"), 
 (9,5,8,1,"2024-04-18","entregado"),(10,6,1,2,"2024-05-05","entregado"), 
 (11,6,3,1,"2024-05-12","pendiente"),(12,7,5,2,"2024-05-20","entregado"), 
 (13,1,7,1,"2024-06-01","entregado"),(14,8,4,1,"2024-06-10","cancelado"), 
 (15,5,2,4,"2024-06-15","entregado"),(16,3,1,1,"2024-07-01","pendiente");
 

 
 
 
 /*
 Agregue a la tabla pedidos una columna total_valor DECIMAL(12,2)
 generada automáticamente como la multiplicacion de cantidad por el precio del producto
 (columna calculada persistida con AS ... STORED, o en su defecto agréguela como columna normal
 y luego actualice su valor mediante un UPDATE con JOIN entre pedidos y productos).
 Finalmente, agregue un índice sobre la columna estado. 

Clausulas requeridas: ALTER TABLE, UPDATE ... JOIN, CREATE INDEX 

 */
 
 -- Agregue la colummna total_valor
 ALTER TABLE pedidos
 ADD total_valor DECIMAL(12,2);
 
 
 UPDATE pedidos
 -- Interseccion de productos a pedidos, y los valores 'comunes' se sacan con el producto_id fk
 JOIN productos ON pedidos.producto_id = productos.producto_id -- puentea pedidos y productos mediante producto_id (solo los en comun)
-- set asigna valor calculado
 SET pedidos.total_valor = pedidos.cantidad * productos.precio; -- el producto que ya me traje
 
 
 CREATE INDEX estado_index
 ON pedidos(estado);
 
 
 /*
 Cree la tabla log_cambios_estado
 (log_id PK AI, pedido_id FK, estado_anterior VARCHAR(20), estado_nuevo VARCHAR(20),
 fecha_cambio DATETIME DEFAULT NOW()).
 A continuación, cree una vista llamada vista_log_reciente que muestre los últimos 10 registros
 de log_cambios_estado ordenados por fecha_cambio descendente. 
 
Clausula requeridas: CREATE TABLE, FOREIGN KEY, CREATE VIEW, ORDER BY, LIMIT 
 
 */
 
 CREATE TABLE log_cambios_estado(
    log_id      			INT AUTO_INCREMENT PRIMARY KEY, 
    pedido_id				INT,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id),
    estado_anterior         VARCHAR(20) NOT NULL, 
    estado_nuevo            VARCHAR(20) NOT NULL, 
	fecha_cambio			DATETIME DEFAULT NOW() 
 );
 
  
-- creamos la vista
CREATE VIEW vista_log_reciente AS
-- seleccionamos todas las columnas de la tabla
SELECT * FROM log_cambios_estado
-- No usamos where ya que no lo necesito, si no pongo condicion muestra todos los registros

-- Ordenamos por fecha de modo decendente
ORDER BY fecha_cambio DESC
-- Limitamos que muestre solo los 10 primeros resultados
LIMIT 10;

-- Ejecutamos la vista
SELECT * FROM vista_log_reciente;
 
 
 /*
 Realice las siguientes operaciones en una misma sesión:
 (a) Inserte un nuevo cliente (nombre=Laura Rios, email=laura@mail.com, ciudad=Manizales).
 (b) Inserte un pedido para ese cliente del producto_id=3 con cantidad=2 y estado=pendiente.
 (c) Actualice el stock del producto_id=3 decrementandolo en 2.
 (d) Consulte con un JOIN el nombre del cliente,
 nombre del producto y estado del pedido recién creado. 

Clausula requeridas: INSERT, UPDATE, SELECT con JOIN, WHERE 
 
 */
 
 
 -- (A) y (B) NOTA: LAST_INSERT_ID() para el ultimo insertado
 INSERT INTO clientes(nombre, email, ciudad) VALUES ('Laura Rios', 'laura@mail.com', 'Manizales');
 INSERT INTO pedidos(cliente_id, producto_id, cantidad, estado) VALUES (LAST_INSERT_ID(), 3, 2, 'pendiente' );

-- guardamos ese ultimo pedido que insertamos para consultarlo mas tarde
 SET @ultimo_pedido = LAST_INSERT_ID();
 
 -- reducimos el stock solo al pedido de ID = 3
 UPDATE productos
 SET stock = stock -2 -- seteo lo que me piden
 WHERE producto_id = 3;
 
 -- Select de las columnas que queremos mostar
 SELECT
 clientes.nombre AS cliente,
 productos.nombre AS producto,
 pedidos.estado AS estado
 -- esto viene de pedidos
 FROM pedidos
 
 -- Con dos JOINS nos traemos lo de clientes y productos
 JOIN clientes ON pedidos.cliente_id = clientes.cliente_id
 JOIN productos ON pedidos.producto_id = productos.producto_id
 -- solo mostramos las columnas del select para el ultimo pedido
 WHERE pedidos.pedido_id = @ultimo_pedido;
 
 
 
 
 /*
 Actualice el precio de todos los productos cuyo stock sea menor al promedio de stock
 de su misma categoría (use subconsulta correlacionada), incrementando el precio un 8%.
 Luego elimine los pedidos con estado cancelado cuyos clientes no tengan ningún otro pedido
 en estado entregado (use subconsulta con NOT EXISTS). 

Clausulas requeridas: UPDATE con subconsulta correlacionada, DELETE con NOT EXISTS 
 
 */
 
  SET SQL_SAFE_UPDATES = 1;
 
 
 UPDATE productos
 SET precio = precio * 1.08 -- seteo lo que me piden le sumo el 8%
 WHERE stock < ( -- coja solo el stock actual y miro si es menor al resultado del parentesis
	SELECT avg_stock FROM ( -- promedio de stocks
    -- selecciono la categoria y el AVG STOCK de productos, ordenandolos por cada categoria por separado
		SELECT categoria, AVG(stock) AS avg_stock FROM productos GROUP BY categoria -- por categoria
	) AS p1
    WHERE productos.categoria = p1.categoria -- correlacionada - asegurar que sea la misma categoria
 );
 
 DELETE FROM pedidos
 WHERE estado = 'cancelado' AND
 NOT EXISTS ( -- Lo de dentro del parentesis no se debe devolver ningun resultado, si se devuelve cagamos
	SELECT 1 -- cogemos uno de
    FROM (SELECT * FROM pedidos) AS p1 -- toda la tabla de pedidos
    WHERE pedidos.cliente_id = p1.cliente_id AND p1.estado = 'entregado'
 );
 
 
 /*
 Liste el nombre del cliente, ciudad, nombre del producto, cantidad y fecha_pedido de
 todos los pedidos entregados cuyo total (cantidad * precio) supere el promedio general de
 totales de pedidos entregados. Ordene los resultados por total descendente. 

Clausulas requeridas: JOIN tres tablas, WHERE con subconsulta escalar AVG, ORDER BY DESC 
 
 */
 
 
SELECT
clientes.nombre AS cliente,
clientes.ciudad,
productos.nombre AS producto,
pedidos.cantidad,
pedidos.fecha_pedido AS fecha
FROM pedidos
JOIN clientes ON pedidos.cliente_id = clientes.cliente_id
JOIN productos ON pedidos.producto_id = productos.producto_id
WHERE pedidos.estado = 'entregado' AND
(pedidos.cantidad * productos.precio) > (
	SELECT AVG(p2.cantidad * pr2.precio)
    FROM pedidos p2
    JOIN productos pr2 ON p2.producto_id = pr2.producto_id
    WHERE p2.estado = 'entregado'
)
ORDER BY (pedidos.cantidad * productos.precio) DESC;

-- creamos unos alias alternativos p2, pr2 pero es la misma monda

 /*
 Cree la vista vista_ventas_ciudad que muestre:
 ciudad, total_pedidos_entregados, suma_ingresos (SUM de cantidad*precio) y
 promedio_ingreso_por_pedido. Luego consulte la vista para mostrar solo las ciudades
 cuyo suma_ingresos supere los 5,000,000, ordenadas de mayor a menor. 

Clausula requeridas: CREATE VIEW con JOIN, GROUP BY, CREATE INDEX opcional, SELECT FROM vista con WHERE y ORDER BY 
 
 */
 
CREATE VIEW vista_ventas_ciudad AS
SELECT 
    clientes.ciudad,
    -- por la naturaleza es un COUNT, que esten entregados nos encargamos despues, por ahora todos
    COUNT(pedidos.pedido_id) AS total_pedidos_entregados,
    SUM(pedidos.cantidad * productos.precio) AS suma_ingresos,
    AVG(pedidos.cantidad * productos.precio) AS promedio_ingreso_por_pedido
FROM pedidos
JOIN clientes ON clientes.cliente_id = pedidos.cliente_id
JOIN productos ON productos.producto_id = pedidos.producto_id
WHERE pedidos.estado = 'entregado'
GROUP BY clientes.ciudad;

SELECT * FROM vista_ventas_ciudad
WHERE suma_ingresos > 5000000
ORDER BY suma_ingresos DESC;




/*
Cree la vista vista_productos_populares que liste los productos que hayan sido
pedidos por más de un cliente distinto (en pedidos entregados).
La vista debe mostrar: producto_id, nombre, categoria, precio y total_clientes_distintos.
Luego use la vista para obtener unicamente los productos de la categoría Perifericos. 

Clausula requeridas: CREATE VIEW con subconsulta o HAVING COUNT(DISTINCT), SELECT FROM vista con WHERE 

*/


CREATE VIEW vista_productos_populares AS
SELECT 
productos.producto_id AS producto,
productos.nombre AS cliente,
productos.categoria AS categoria,
productos.precio AS precio,

-- Count para el total, y DISTINCT para que no se repita
COUNT(DISTINCT pedidos.cliente_id) AS total_clientes_distintos
FROM productos
JOIN pedidos ON productos.producto_id = pedidos.producto_id
WHERE pedidos.estado = 'entregado'
-- Agrupa por producto y muestra solo aquellos comprados por más de un cliente diferente.
GROUP BY productos.producto_id
HAVING total_clientes_distintos > 1; -- Having es un WHERE (condicion) pero con operaciones matematicas unicamente


SELECT * FROM vista_productos_populares
WHERE categoria = 'Perifericos';

/*
Cree la función fn_ingreso_cliente(p_cliente_id INT)
que retorne el ingreso total acumulado de un cliente
(suma de cantidad*precio solo para pedidos entregados, usando JOIN entre pedidos y productos).
Luego use esa función en un SELECT sobre la tabla clientes para mostrar nombre, ciudad y su ingreso_total,
ordenados de mayor a menor ingreso. 

Clausulas requeridas: CREATE FUNCTION con SELECT JOIN, RETURN; SELECT usando la función en la lista de columnas 

*/

DELIMITER //

CREATE FUNCTION fn_ingreso_cliente(p_cliente_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC -- es un calculo
BEGIN
    -- variable donde guardaremos el resultado de la suma
    DECLARE v_total DECIMAL(12,2);
    -- Calculamos la suma cruzando las tablas y filtrando por el cliente
    SELECT SUM(pedidos.cantidad * productos.precio) INTO v_total -- la meto aca
    FROM pedidos
    JOIN productos ON productos.producto_id = pedidos.producto_id
    -- Me aseguro de que sobre quien hice la funcion sea igual al parametro ingresado en la funcion
    WHERE pedidos.cliente_id = p_cliente_id AND pedidos.estado = 'Entregado';
    RETURN v_total;
END //

DELIMITER ;


SELECT nombre, ciudad, fn_ingreso_cliente(cliente_id) AS ingreso_total
FROM clientes
ORDER BY ingreso_total DESC;


/*
Cree la función fn_stock_suficiente(p_producto_id INT, p_cantidad_solicitada INT)
que retorne 1 si el stock actual del producto es mayor o igual a la cantidad solicitada, o 0 en caso contrario.
Luego escriba una consulta que liste nombre y stock de todos los productos donde
fn_stock_suficiente(producto_id, 5) = 0, es decir, productos con menos de 5 unidades disponibles. 

Clausulas requeridas: CREATE FUNCTION, SELECT con WHERE usando la función, subconsulta o logica equivalente 

*/


DELIMITER //

CREATE FUNCTION fn_stock_suficiente(p_producto_id INT, p_cantidad_solicitada INT)
RETURNS INT -- retorna 1 o 0
DETERMINISTIC -- es un calculo
BEGIN
    -- variable donde tenemos el stock del momento
    DECLARE stock_actual INT;
    
    SET stock_actual = (
		SELECT productos.stock -- va a ser el stock
        From productos
        -- Me aseguro de que el stock del que cojo sea igual al que meti en el parametro
        WHERE productos.producto_id = p_producto_id
	);
    
	IF stock_actual  >= p_cantidad_solicitada THEN RETURN 1;
	ELSE RETURN 0;
	END IF;
END //

DELIMITER ;

DROP FUNCTION fn_stock_suficiente;
 
SELECT 
nombre, 
stock
FROM productos
-- Consulto el nombre y stock de los que cumplen:
WHERE fn_stock_suficiente(producto_id, 5) =0;



-- Hasta aca trabaja JuanDa e intenta entender, su buen amigo Gemi va a hacer los otros por si necesita algo de los demas

/*
10. Cree el procedimiento sp_actualizar_estado_pedido(p_pedido_id INT, p_nuevo_estado VARCHAR(20))
*/

DELIMITER //
CREATE PROCEDURE sp_actualizar_estado_pedido(p_pedido_id INT, p_nuevo_estado VARCHAR(20))
BEGIN
    -- Variables para guardar lo que encuentre del pedido
    DECLARE v_estado_anterior VARCHAR(20);
    DECLARE v_producto_id INT;
    DECLARE v_cantidad INT;
    DECLARE v_existe INT DEFAULT 0;

    -- 1. Verifico si el pedido existe contándolo
    SELECT COUNT(*) INTO v_existe FROM pedidos WHERE pedido_id = p_pedido_id;

    IF v_existe = 0 THEN
        -- Si no existe, saco un mensaje y corto acá
        SELECT 'Error: El pedido no existe' AS mensaje;
    ELSE
        -- Me traigo los datos actuales del pedido para usarlos ahorita
        SELECT estado, producto_id, cantidad INTO v_estado_anterior, v_producto_id, v_cantidad 
        FROM pedidos WHERE pedido_id = p_pedido_id;

        -- 2. Guardo la historia en el log
        INSERT INTO log_cambios_estado (pedido_id, estado_anterior, estado_nuevo)
        VALUES (p_pedido_id, v_estado_anterior, p_nuevo_estado);

        -- 3. Actualizo el estado en la tabla real
        UPDATE pedidos SET estado = p_nuevo_estado WHERE pedido_id = p_pedido_id;

        -- 4. Si el nuevo estado es cancelado, le devuelvo el stock al producto
        IF p_nuevo_estado = 'cancelado' THEN
            UPDATE productos SET stock = stock + v_cantidad WHERE producto_id = v_producto_id;
        END IF;

        SELECT 'Pedido actualizado correctamente' AS mensaje;
    END IF;
END //
DELIMITER ;


/*
11. Cree el procedimiento sp_resumen_cliente(p_cliente_id INT)
*/

DELIMITER //
CREATE PROCEDURE sp_resumen_cliente(p_cliente_id INT)
BEGIN
    SELECT 
        clientes.nombre,
        clientes.ciudad,
        -- Cuento los pedidos según su estado sumando unos (1) y ceros (0)
        SUM(CASE WHEN pedidos.estado = 'entregado' THEN 1 ELSE 0 END) AS total_entregados,
        SUM(CASE WHEN pedidos.estado = 'pendiente' THEN 1 ELSE 0 END) AS total_pendientes,
        SUM(CASE WHEN pedidos.estado = 'cancelado' THEN 1 ELSE 0 END) AS total_cancelados,
        -- Sumo la plata solo de los que sí se entregaron
        SUM(CASE WHEN pedidos.estado = 'entregado' THEN (pedidos.cantidad * productos.precio) ELSE 0 END) AS ingreso_total
    FROM clientes
    -- Hago LEFT JOIN por si el cliente no tiene pedidos igual salga su nombre
    LEFT JOIN pedidos ON clientes.cliente_id = pedidos.cliente_id
    LEFT JOIN productos ON pedidos.producto_id = productos.producto_id
    WHERE clientes.cliente_id = p_cliente_id
    GROUP BY clientes.cliente_id;
END //
DELIMITER ;


/*
12. Cree la vista vista_pedidos_pendientes y el proc sp_alertar_retrasos
*/

CREATE OR REPLACE VIEW vista_pedidos_pendientes AS
SELECT 
    pedidos.pedido_id,
    clientes.nombre AS cliente,
    productos.nombre AS producto,
    pedidos.cantidad,
    productos.precio AS precio_unitario,
    -- Calculo los días que han pasado desde que se pidió hasta hoy
    DATEDIFF(CURDATE(), pedidos.fecha_pedido) AS dias_espera
FROM pedidos
JOIN clientes ON pedidos.cliente_id = clientes.cliente_id
JOIN productos ON pedidos.producto_id = productos.producto_id
WHERE pedidos.estado = 'pendiente';

DELIMITER //
CREATE PROCEDURE sp_alertar_retrasos(p_dias_limite INT)
BEGIN
    -- Consulto la vista que acabo de crear filtrando por el límite ingresado
    SELECT * FROM vista_pedidos_pendientes 
    WHERE dias_espera > p_dias_limite;
END //
DELIMITER ;


/*
13. Agregue descuento, cree fn_precio_final y haga el SELECT
*/

-- Agrego la columna con sus reglas de límite (0 a 50)
ALTER TABLE productos 
ADD descuento DECIMAL(5,2) DEFAULT 0 
CHECK (descuento >= 0 AND descuento <= 50);

DELIMITER //
CREATE FUNCTION fn_precio_final(p_producto_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_precio_final DECIMAL(10,2);
    
    -- Busco el precio y le aplico la fórmula de descuento
    SELECT precio * (1 - descuento/100) INTO v_precio_final
    FROM productos
    WHERE producto_id = p_producto_id;
    
    RETURN v_precio_final;
END //
DELIMITER ;

-- Consulto usando la función para sacar el top 3 de los más caros
SELECT 
    nombre, 
    precio, 
    descuento, 
    fn_precio_final(producto_id) AS precio_final
FROM productos
ORDER BY precio_final DESC
LIMIT 3;


/*
14. Cree el procedimiento sp_registrar_pedido
*/

DELIMITER //
CREATE PROCEDURE sp_registrar_pedido(p_cliente_id INT, p_producto_id INT, p_cantidad INT)
BEGIN
    DECLARE v_existe_cliente INT DEFAULT 0;
    DECLARE v_stock_actual INT DEFAULT 0;
    DECLARE v_nuevo_pedido_id INT;

    -- 1. Valido si el cliente de verdad existe
    SELECT COUNT(*) INTO v_existe_cliente FROM clientes WHERE cliente_id = p_cliente_id;
    
    -- 2. Busco cuánto stock hay del producto
    SELECT stock INTO v_stock_actual FROM productos WHERE producto_id = p_producto_id;

    IF v_existe_cliente = 0 THEN
        SELECT 'Error: El cliente no existe' AS mensaje;
    ELSEIF v_stock_actual < p_cantidad THEN
        SELECT 'Error: Stock insuficiente' AS mensaje;
    ELSE
        -- 3. Creo el pedido si todo está bien
        INSERT INTO pedidos (cliente_id, producto_id, cantidad, estado) 
        VALUES (p_cliente_id, p_producto_id, p_cantidad, 'pendiente');
        
        -- Capturo el ID del pedido que acabo de crear
        SET v_nuevo_pedido_id = LAST_INSERT_ID();

        -- 4. Le resto lo que compró al stock del producto
        UPDATE productos SET stock = stock - p_cantidad WHERE producto_id = p_producto_id;

        -- 5. Muestro el resumen del pedido recién creado
        SELECT 
            pedidos.pedido_id,
            clientes.nombre AS cliente,
            productos.nombre AS producto,
            pedidos.cantidad
        FROM pedidos
        JOIN clientes ON pedidos.cliente_id = clientes.cliente_id
        JOIN productos ON pedidos.producto_id = productos.producto_id
        WHERE pedidos.pedido_id = v_nuevo_pedido_id;
    END IF;
END //
DELIMITER ;


/*
15. Cree fn_clasificar_producto, vista_catalogo_clasificado y su consulta
*/

DELIMITER //
CREATE FUNCTION fn_clasificar_producto(p_producto_id INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_clasificacion VARCHAR(20);
    
    -- Saco el precio del producto
    SELECT precio INTO v_precio FROM productos WHERE producto_id = p_producto_id;
    
    -- Miro en qué rango de plata cae
    IF v_precio > 1000000 THEN
        SET v_clasificacion = 'PREMIUM';
    ELSEIF v_precio >= 200000 AND v_precio <= 1000000 THEN
        SET v_clasificacion = 'ESTANDAR';
    ELSE
        SET v_clasificacion = 'BASICO';
    END IF;
    
    RETURN v_clasificacion;
END //
DELIMITER ;

CREATE OR REPLACE VIEW vista_catalogo_clasificado AS
SELECT 
    nombre, 
    categoria, 
    precio, 
    fn_clasificar_producto(producto_id) AS clasificacion, 
    stock
FROM productos;

-- Muestro solo los PREMIUM que sí tienen unidades en stock
SELECT * FROM vista_catalogo_clasificado
WHERE clasificacion = 'PREMIUM' AND stock > 5;


/*
16. Cree vista_clientes_vip y consulte los últimos 2 pedidos con ROW_NUMBER
*/

CREATE OR REPLACE VIEW vista_clientes_vip AS
SELECT 
    clientes.cliente_id, 
    clientes.nombre, 
    clientes.ciudad, 
    COUNT(pedidos.pedido_id) AS total_pedidos_entregados
FROM clientes
JOIN pedidos ON clientes.cliente_id = pedidos.cliente_id
WHERE pedidos.estado = 'entregado'
GROUP BY clientes.cliente_id
-- Filtro clientes que superen el promedio global de pedidos entregados
HAVING COUNT(pedidos.pedido_id) > (
    -- Subconsulta: calculo el promedio general de entregas
    SELECT AVG(conteo_pedidos) FROM (
        SELECT COUNT(pedido_id) AS conteo_pedidos 
        FROM pedidos 
        WHERE estado = 'entregado' 
        GROUP BY cliente_id
    ) AS promedios
);

-- Consulta usando ROW_NUMBER para sacar los 2 últimos pedidos de cada VIP
SELECT 
    vip.nombre AS cliente,
    productos.nombre AS producto,
    ultimos_pedidos.fecha_pedido
FROM vista_clientes_vip AS vip
JOIN (
    -- Numero los pedidos de cada cliente ordenados por fecha (el 1 es el más reciente)
    SELECT 
        pedido_id, 
        cliente_id, 
        producto_id, 
        fecha_pedido,
        ROW_NUMBER() OVER(PARTITION BY cliente_id ORDER BY fecha_pedido DESC) AS num_fila
    FROM pedidos
) AS ultimos_pedidos ON vip.cliente_id = ultimos_pedidos.cliente_id
JOIN productos ON ultimos_pedidos.producto_id = productos.producto_id
-- Me quedo solo con los que quedaron en la posición 1 y 2
WHERE ultimos_pedidos.num_fila <= 2;
 
 