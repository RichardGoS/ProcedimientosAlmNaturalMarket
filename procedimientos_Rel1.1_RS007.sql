# ===================================================================================bodega==========================================================================================================

# ==============================================================================================================================================================================================
# @date 20/05/2022
# @Descripcion 
DROP PROCEDURE IF EXISTS obtenerItemsPromocionVentasPorProductoMayorAFechaInventario;

DELIMITER $$
CREATE PROCEDURE obtenerItemsPromocionVentasPorProductoMayorAFechaInventario(IN product_id INT, IN fecha_inventario datetime, OUT ventas VARCHAR(5000))

BEGIN
	DECLARE id_venta INTEGER;
    DECLARE venta varchar(200);
    DECLARE var_final INTEGER DEFAULT 0;
	DECLARE cursor1 CURSOR FOR SELECT id FROM venta WHERE fecha > fecha_inventario;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
    
    OPEN cursor1;
    FETCH cursor1 INTO id_venta;
    set ventas = '';
    
    while var_final !=1 do
        
        
        set ventas := CONCAT(ventas,  ',');
        
        FETCH cursor1 INTO id_venta;
    
    end while;
    
    CLOSE cursor1;
    
END$$

DELIMITER ;

# ==============================================================================================================================================================================================
# @date 20/05/2022
# @Descripcion 
DROP PROCEDURE IF EXISTS obtenerItemPromocionVentaPorPromocionVentaProducto;

DELIMITER $$
CREATE PROCEDURE obtenerItemPromocionVentaPorPromocionVentaProducto(IN product_id INT, IN promocion_venta_id INT, OUT ventas VARCHAR(5000))

BEGIN
	DECLARE id_venta INTEGER;
    DECLARE venta varchar(200);
    DECLARE var_final INTEGER DEFAULT 0;
	DECLARE cursor1 CURSOR FOR SELECT id FROM venta WHERE fecha > fecha_inventario;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
    
    OPEN cursor1;
    FETCH cursor1 INTO id_venta;
    set ventas = '';
    
    while var_final !=1 do
        
        set ventas := CONCAT(ventas, obtenerItemPromocionVentaPorPromocionVentaProducto(), ',');
        
        FETCH cursor1 INTO id_venta;
    
    end while;
    
    CLOSE cursor1;
    
END$$

DELIMITER ;


# ==============================================================================================================================================================================================
# @date 10/02/2022
# @Descripcion 
DROP PROCEDURE IF EXISTS obtenerItemsVentasPorProductoMayorAFechaInventario;

DELIMITER $$
CREATE PROCEDURE obtenerItemsVentasPorProductoMayorAFechaInventario(IN product_id INT, IN fecha_inventario datetime, OUT ventas VARCHAR(5000))

BEGIN
	DECLARE id_venta INTEGER;
    DECLARE venta varchar(200);
    DECLARE var_final INTEGER DEFAULT 0;
	DECLARE cursor1 CURSOR FOR SELECT id FROM venta WHERE fecha > fecha_inventario;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
    
    OPEN cursor1;
    FETCH cursor1 INTO id_venta;
    set ventas = '';
    
    while var_final !=1 do

    	SELECT  CONCAT(id, ';', cant_peso, ';', total, ';', venta_id ) INTO venta
    	FROM item_venta
    	WHERE venta_id = id_venta;
        
        set ventas := CONCAT(ventas, venta, ',');
        
        FETCH cursor1 INTO id_venta;
    
    end while;
    
    CLOSE cursor1;
    
END$$

DELIMITER ;


# ==============================================================================================================================================================================================
# ==================================================     --         -- DESARROLLANDO --          --      ===================================================================
# ==============================================================================================================================================================================================





# ==============================================================================================================================================================================================
# ==============================================================================================================================================================================================
# ==============================================================================================================================================================================================
# ==================================================              APLICADOS                ===================================================================
# ==============================================================================================================================================================================================
# ==============================================================================================================================================================================================







# ==============================================================================================================================================================================================
# ==================================================              DESARROLLO                ===================================================================
# ==============================================================================================================================================================================================






# ==============================================================================================================================================================================================
# ==================================================              PRODUCCION                ===================================================================
# ==============================================================================================================================================================================================




# ==============================================================================================================================================================================================
# ============================================= Rel 1.1 ========================================================================================================
# ==============================================================================================================================================================================================


# ==============================================================================================================================================================================================
# @date 21/05/2022
# Version Rel 1.1 RS 007
# @Descripcion Metodo permite obtener los items de las ventas mayores a la fecha que contienen promociones
DROP PROCEDURE IF EXISTS obtenerItemsVentasMayorAFechaConPromocionPorProducto;

DELIMITER $$
CREATE PROCEDURE obtenerItemsVentasMayorAFechaConPromocionPorProducto(IN fecha_parametro datetime, IN id_producto INT, OUT ventas VARCHAR(5000))

BEGIN
	DECLARE id_venta INTEGER;
    DECLARE promo_venta_id INTEGER;
	DECLARE venta varchar(500);
    DECLARE var_final INTEGER DEFAULT 0;
    DECLARE var_final_2 INTEGER DEFAULT 0;
	DECLARE cursor1 CURSOR FOR SELECT id FROM venta WHERE fecha > fecha_parametro;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
    
    OPEN cursor1;
    FETCH cursor1 INTO id_venta;
    set ventas = '';
    
    while var_final !=1 do
    
		call obtenerItemsPromocionVentaPorPromocionVentaProducto(id_venta, id_producto, venta);

		IF (venta != '') THEN
			set ventas := CONCAT(ventas, venta, ',');
        END IF;
	
        FETCH cursor1 INTO id_venta;
    
    end while;
    
    CLOSE cursor1;
    
END$$

DELIMITER ;

# ==============================================================================================================================================================================================
# @date 21/05/2022
# Version Rel 1.1 RS 007
# @Descripcion Metodo permite obtener los items de las ventas mayores a la fecha que contienen promociones
DROP PROCEDURE IF EXISTS obtenerItemsPromocionVentaPorPromocionVentaProducto;

DELIMITER $$
CREATE PROCEDURE obtenerItemsPromocionVentaPorPromocionVentaProducto(IN id_venta INT, IN id_producto INT, OUT ventas VARCHAR(500))

BEGIN
	DECLARE id_promocion INTEGER;
	DECLARE venta varchar(200);
    DECLARE var_final INTEGER DEFAULT 0;
	DECLARE cursor1 CURSOR FOR SELECT promocion_venta_id FROM item_venta WHERE venta_id = id_venta AND promocion_venta_id != '';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
    
    OPEN cursor1;
    FETCH cursor1 INTO id_promocion;
    set ventas = '';
    
    while var_final !=1 do
    
		SELECT CONCAT(promocion_venta_id , ';', id, ';', cant_peso, ';', total ) INTO venta FROM item_promocion_venta WHERE promocion_venta_id = id_promocion  AND producto_id = id_producto;
        set ventas := CONCAT(ventas, venta, '|');
	
        FETCH cursor1 INTO id_promocion;
    
    end while;
    
    CLOSE cursor1;
    
END$$

DELIMITER ;



# ==============================================================================================================================================================================================
# @date 18/05/2022
# Version Rel 1.1 RS 007
# @Descripcion Metodo permite obtener los items de las promocion venta por producto
DROP PROCEDURE IF EXISTS obtenerItemsPromocionVentasPorProducto;

DELIMITER $$
CREATE PROCEDURE obtenerItemsPromocionVentasPorProducto(IN product_id INT, OUT items VARCHAR(5000))

BEGIN
	DECLARE id_item_promocion_venta INTEGER;
    DECLARE item varchar(200);
    DECLARE var_final INTEGER DEFAULT 0;
	DECLARE cursor1 CURSOR FOR SELECT id FROM item_promocion_venta WHERE producto_id = product_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
    
    OPEN cursor1;
    FETCH cursor1 INTO id_item_promocion_venta;
    set items = '';
    
    while var_final !=1 do

    	SELECT  CONCAT(id, ';', cant_peso, ';', total, ';', promocion_venta_id ) INTO item
    	FROM item_promocion_venta
    	WHERE id = id_item_promocion_venta;
        
        set items := CONCAT(items, item, ',');
        
        FETCH cursor1 INTO id_item_promocion_venta;
    
    end while;
    
    CLOSE cursor1;
    
END$$

DELIMITER ;


# ==============================================================================================================================================================================================
# ============================================= Rel 1.0 ========================================================================================================
# ==============================================================================================================================================================================================

# ==============================================================================================================================================================================================
# @date 10/02/2022
# Version Rel 1.0 RS 001
# @Descripcion Metodo permite obtener los items de las inversiones por producto mayor a la fecha inventariada
DROP PROCEDURE IF EXISTS obtenerItemsInversionesPorProductoMayorAFechaInventario;

DELIMITER $$
CREATE PROCEDURE obtenerItemsInversionesPorProductoMayorAFechaInventario(IN product_id INT, IN fecha_inventario datetime, OUT inversiones VARCHAR(5000))

BEGIN
	DECLARE id_inversion INTEGER;
    DECLARE id_item INTEGER;
    DECLARE inversion varchar(200);
    DECLARE var_final INTEGER DEFAULT 0;
	DECLARE cursor1 CURSOR FOR SELECT id FROM inversion WHERE fecha > fecha_inventario;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
    
    OPEN cursor1;
    FETCH cursor1 INTO id_inversion;
    set inversiones = '';
    
    while var_final !=1 do

		
    	SELECT  CONCAT(id, ';', cant_comprado, ';', precio_total, ';', precio_unitario, ';', inversion_id) INTO inversion
        FROM item_inversion 
    	WHERE inversion_id = id_inversion AND producto_id = product_id;
        
        #SELECT CONCAT (id_inversion, ' ; ', product_id) ;
        
        set inversiones := CONCAT(inversiones, inversion, ',');
        
        FETCH cursor1 INTO id_inversion;
    
    end while;
    
    CLOSE cursor1;
    
END$$

DELIMITER ;

# ==============================================================================================================================================================================================
# @date 09/02/2022
# Version Rel 1.0 RS 001
# @Descripcion Metodo permite obtener los items de las ventas por producto
DROP PROCEDURE IF EXISTS obtenerItemsVentasPorProducto;

DELIMITER $$
CREATE PROCEDURE obtenerItemsVentasPorProducto(IN product_id INT, OUT ventas VARCHAR(5000))

BEGIN
	DECLARE id_inversion INTEGER;
    DECLARE id_item INTEGER;
    DECLARE venta varchar(200);
    DECLARE var_final INTEGER DEFAULT 0;
	DECLARE cursor1 CURSOR FOR SELECT id FROM item_venta WHERE producto_id = product_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
    
    OPEN cursor1;
    FETCH cursor1 INTO id_item;
    set ventas = '';
    
    while var_final !=1 do

    	SELECT  CONCAT(id, ';', cant_peso, ';', total, ';', venta_id ) INTO venta
    	FROM item_venta
    	WHERE id = id_item;
        
        set ventas := CONCAT(ventas, venta, ',');
        
        FETCH cursor1 INTO id_item;
    
    end while;
    
    CLOSE cursor1;
    
END$$

DELIMITER ;

# ==============================================================================================================================================================================================
# @date 09/02/2022
# Version Rel 1.0 RS 001
# @Descripcion Metodo permite obtener los items de las inversiones por producto
DROP PROCEDURE IF EXISTS obtenerInversionesPorProducto;

DELIMITER $$
CREATE PROCEDURE obtenerInversionesPorProducto(IN product_id INT, OUT inversiones VARCHAR(5000))

BEGIN
	DECLARE id_inversion INTEGER;
    DECLARE id_item INTEGER;
    DECLARE inversion varchar(200);
    DECLARE var_final INTEGER DEFAULT 0;
	DECLARE cursor1 CURSOR FOR SELECT id FROM item_inversion WHERE producto_id = product_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
    
    OPEN cursor1;
    FETCH cursor1 INTO id_item;
    set inversiones = '';
    
    while var_final !=1 do

    	SELECT  CONCAT(id, ';', cant_comprado, ';', precio_total, ';', precio_unitario, ';', inversion_id ) INTO inversion
    	FROM item_inversion
    	WHERE id = id_item;
        
        set inversiones := CONCAT(inversiones, inversion, ',');
        
        FETCH cursor1 INTO id_item;
    
    end while;
    
    CLOSE cursor1;
    
END$$

DELIMITER ;

# ==============================================================================================================================================================================================
# @date 09/02/2022
# Version Rel 1.0 RS 001
# @Descripcion Metodo permite obtener los items de las ventas por producto mayor a fecha
DROP PROCEDURE IF EXISTS obtenerItemsVentasPorProductoMayorAFecha;

DELIMITER $$
CREATE PROCEDURE obtenerItemsVentasPorProductoMayorAFecha(IN product_id INT, IN fecha_inventario datetime, OUT ventas VARCHAR(5000))
	BEGIN
		DECLARE id_venta INTEGER;
		DECLARE venta varchar(500);
		DECLARE var_final INTEGER DEFAULT 0;
		DECLARE cursor1 CURSOR FOR SELECT id FROM venta WHERE fecha > fecha_inventario;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
		
		OPEN cursor1;
		FETCH cursor1 INTO id_venta;
		set ventas = '';
		
		while var_final !=1 do

			SELECT  CONCAT(id, ';', cant_peso, ';', total, ';', venta_id ) INTO venta
			FROM item_venta
			WHERE venta_id = id_venta AND producto_id = product_id;
			
			set ventas := CONCAT(ventas, venta, ',');
			
			FETCH cursor1 INTO id_venta;
		
		end while;
		
		CLOSE cursor1;
		
END$$
DELIMITER ;