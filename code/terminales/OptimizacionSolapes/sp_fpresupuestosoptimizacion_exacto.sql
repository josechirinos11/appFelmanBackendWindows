-- =====================================================================
-- PROCEDIMIENTO CON REAGRUPACIÓN Y OPTIMIZACIÓN
-- 1. Extrae datos originales
-- 2. Descompone en ítems individuales  
-- 3. Reagrupa por módulo y medidas
-- 4. Aplica optimización de corte
-- 5. Regenera estructura original
-- =====================================================================

DROP PROCEDURE IF EXISTS sp_fpresupuestosoptimizacion_exacto;

DELIMITER $$

CREATE PROCEDURE sp_fpresupuestosoptimizacion_exacto(
    IN p_Serie VARCHAR(50),
    IN p_Numero INT,
    IN p_CodigoArticulo VARCHAR(50),
    IN p_CodigoAcabado VARCHAR(50),
    IN p_CodigoAcabado2 VARCHAR(50)
)
BEGIN
    -- Variables para optimización
    SET @barra_actual = 1;
    SET @longitud_acumulada = 0;
    SET @items_en_barra = 0;
    SET @barra_anterior = 1;
    SET @row_number = 0;
    
    -- PASO 1: Crear tabla temporal con ítems individuales descompuestos
    DROP TEMPORARY TABLE IF EXISTS temp_items_descompuestos;
    CREATE TEMPORARY TABLE temp_items_descompuestos AS
    SELECT 
        CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
        Ancho, Maquina, Tipo,
        -- Descomponer ítem 0
        Med0 AS Med, MedH0 AS MedH, Modulo0 AS Modulo,
        CASILLERO0 AS CASILLERO, CASILLEROB0 AS CASILLEROB,
        Corte1_0 AS Corte1, Corte2_0 AS Corte2, Corte1b_0 AS Corte1b, Corte2b_0 AS Corte2b,
        ID0 AS ID, KTN0 AS KTN, MAQ0 AS MAQ, MAQ2_0 AS MAQ2, REF0 AS REF,
        Lin0 AS Lin, Sit0 AS Sit, Rec0 AS Rec, UD0 AS UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE CodigoSerie = p_Serie AND CodigoNumero = p_Numero AND CodigoPerfil = p_CodigoArticulo
      AND CodigoAcabado = p_CodigoAcabado 
      AND ((CodigoAcabado2 = p_CodigoAcabado2) OR ((CodigoAcabado2 IS NULL) AND (p_CodigoAcabado2 = '')))
      AND Med0 IS NOT NULL AND Med0 > 0
    
    UNION ALL
    
    SELECT 
        CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
        Ancho, Maquina, Tipo,
        -- Descomponer ítem 1
        Med1 AS Med, MedH1 AS MedH, Modulo1 AS Modulo,
        CASILLERO1 AS CASILLERO, CASILLEROB1 AS CASILLEROB,
        Corte1_1 AS Corte1, Corte2_1 AS Corte2, Corte1b_1 AS Corte1b, Corte2b_1 AS Corte2b,
        ID1 AS ID, KTN1 AS KTN, MAQ1 AS MAQ, MAQ2_1 AS MAQ2, REF1 AS REF,
        Lin1 AS Lin, Sit1 AS Sit, Rec1 AS Rec, UD1 AS UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE CodigoSerie = p_Serie AND CodigoNumero = p_Numero AND CodigoPerfil = p_CodigoArticulo
      AND CodigoAcabado = p_CodigoAcabado 
      AND ((CodigoAcabado2 = p_CodigoAcabado2) OR ((CodigoAcabado2 IS NULL) AND (p_CodigoAcabado2 = '')))
      AND Med1 IS NOT NULL AND Med1 > 0
    
    UNION ALL
    
    SELECT 
        CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
        Ancho, Maquina, Tipo,
        -- Descomponer ítem 2
        Med2 AS Med, MedH2 AS MedH, Modulo2 AS Modulo,
        CASILLERO2 AS CASILLERO, CASILLEROB2 AS CASILLEROB,
        Corte1_2 AS Corte1, Corte2_2 AS Corte2, Corte1b_2 AS Corte1b, Corte2b_2 AS Corte2b,
        ID2 AS ID, KTN2 AS KTN, MAQ2 AS MAQ, MAQ2_2 AS MAQ2, REF2 AS REF,
        Lin2 AS Lin, Sit2 AS Sit, Rec2 AS Rec, UD2 AS UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE CodigoSerie = p_Serie AND CodigoNumero = p_Numero AND CodigoPerfil = p_CodigoArticulo
      AND CodigoAcabado = p_CodigoAcabado 
      AND ((CodigoAcabado2 = p_CodigoAcabado2) OR ((CodigoAcabado2 IS NULL) AND (p_CodigoAcabado2 = '')))
      AND Med2 IS NOT NULL AND Med2 > 0
    
    UNION ALL
    
    SELECT 
        CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
        Ancho, Maquina, Tipo,
        -- Descomponer ítem 3
        Med3 AS Med, MedH3 AS MedH, Modulo3 AS Modulo,
        CASILLERO3 AS CASILLERO, CASILLEROB3 AS CASILLEROB,
        Corte1_3 AS Corte1, Corte2_3 AS Corte2, Corte1b_3 AS Corte1b, Corte2b_3 AS Corte2b,
        ID3 AS ID, KTN3 AS KTN, MAQ3 AS MAQ, MAQ2_3 AS MAQ2, REF3 AS REF,
        Lin3 AS Lin, Sit3 AS Sit, Rec3 AS Rec, UD3 AS UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE CodigoSerie = p_Serie AND CodigoNumero = p_Numero AND CodigoPerfil = p_CodigoArticulo
      AND CodigoAcabado = p_CodigoAcabado 
      AND ((CodigoAcabado2 = p_CodigoAcabado2) OR ((CodigoAcabado2 IS NULL) AND (p_CodigoAcabado2 = '')))
      AND Med3 IS NOT NULL AND Med3 > 0
    
    UNION ALL
    
    SELECT 
        CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
        Ancho, Maquina, Tipo,
        -- Descomponer ítem 4
        Med4 AS Med, MedH4 AS MedH, Modulo4 AS Modulo,
        CASILLERO4 AS CASILLERO, CASILLEROB4 AS CASILLEROB,
        Corte1_4 AS Corte1, Corte2_4 AS Corte2, Corte1b_4 AS Corte1b, Corte2b_4 AS Corte2b,
        ID4 AS ID, KTN4 AS KTN, MAQ4 AS MAQ, MAQ2_4 AS MAQ2, REF4 AS REF,
        Lin4 AS Lin, Sit4 AS Sit, Rec4 AS Rec, UD4 AS UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE CodigoSerie = p_Serie AND CodigoNumero = p_Numero AND CodigoPerfil = p_CodigoArticulo
      AND CodigoAcabado = p_CodigoAcabado 
      AND ((CodigoAcabado2 = p_CodigoAcabado2) OR ((CodigoAcabado2 IS NULL) AND (p_CodigoAcabado2 = '')))
      AND Med4 IS NOT NULL AND Med4 > 0
    
    UNION ALL
    
    SELECT 
        CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
        Ancho, Maquina, Tipo,
        -- Descomponer ítem 5
        Med5 AS Med, MedH5 AS MedH, Modulo5 AS Modulo,
        CASILLERO5 AS CASILLERO, CASILLEROB5 AS CASILLEROB,
        Corte1_5 AS Corte1, Corte2_5 AS Corte2, Corte1b_5 AS Corte1b, Corte2b_5 AS Corte2b,
        ID5 AS ID, KTN5 AS KTN, MAQ5 AS MAQ, MAQ2_5 AS MAQ2, REF5 AS REF,
        Lin5 AS Lin, Sit5 AS Sit, Rec5 AS Rec, UD5 AS UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE CodigoSerie = p_Serie AND CodigoNumero = p_Numero AND CodigoPerfil = p_CodigoArticulo
      AND CodigoAcabado = p_CodigoAcabado 
      AND ((CodigoAcabado2 = p_CodigoAcabado2) OR ((CodigoAcabado2 IS NULL) AND (p_CodigoAcabado2 = '')))
      AND Med5 IS NOT NULL AND Med5 > 0
    
    UNION ALL
    
    SELECT 
        CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
        Ancho, Maquina, Tipo,
        -- Descomponer ítem 6
        Med6 AS Med, MedH6 AS MedH, Modulo6 AS Modulo,
        CASILLERO6 AS CASILLERO, CASILLEROB6 AS CASILLEROB,
        Corte1_6 AS Corte1, Corte2_6 AS Corte2, Corte1b_6 AS Corte1b, Corte2b_6 AS Corte2b,
        ID6 AS ID, KTN6 AS KTN, MAQ6 AS MAQ, MAQ2_6 AS MAQ2, REF6 AS REF,
        Lin6 AS Lin, Sit6 AS Sit, Rec6 AS Rec, UD6 AS UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE CodigoSerie = p_Serie AND CodigoNumero = p_Numero AND CodigoPerfil = p_CodigoArticulo
      AND CodigoAcabado = p_CodigoAcabado 
      AND ((CodigoAcabado2 = p_CodigoAcabado2) OR ((CodigoAcabado2 IS NULL) AND (p_CodigoAcabado2 = '')))
      AND Med6 IS NOT NULL AND Med6 > 0
    
    UNION ALL
    
    SELECT 
        CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
        Ancho, Maquina, Tipo,
        -- Descomponer ítem 7
        Med7 AS Med, MedH7 AS MedH, Modulo7 AS Modulo,
        CASILLERO7 AS CASILLERO, CASILLEROB7 AS CASILLEROB,
        Corte1_7 AS Corte1, Corte2_7 AS Corte2, Corte1b_7 AS Corte1b, Corte2b_7 AS Corte2b,
        ID7 AS ID, KTN7 AS KTN, MAQ7 AS MAQ, MAQ2_7 AS MAQ2, REF7 AS REF,
        Lin7 AS Lin, Sit7 AS Sit, Rec7 AS Rec, UD7 AS UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE CodigoSerie = p_Serie AND CodigoNumero = p_Numero AND CodigoPerfil = p_CodigoArticulo
      AND CodigoAcabado = p_CodigoAcabado 
      AND ((CodigoAcabado2 = p_CodigoAcabado2) OR ((CodigoAcabado2 IS NULL) AND (p_CodigoAcabado2 = '')))
      AND Med7 IS NOT NULL AND Med7 > 0
    
    UNION ALL
    
    SELECT 
        CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
        Ancho, Maquina, Tipo,
        -- Descomponer ítem 8
        Med8 AS Med, MedH8 AS MedH, Modulo8 AS Modulo,
        CASILLERO8 AS CASILLERO, CASILLEROB8 AS CASILLEROB,
        Corte1_8 AS Corte1, Corte2_8 AS Corte2, Corte1b_8 AS Corte1b, Corte2b_8 AS Corte2b,
        ID8 AS ID, KTN8 AS KTN, MAQ8 AS MAQ, MAQ2_8 AS MAQ2, REF8 AS REF,
        Lin8 AS Lin, Sit8 AS Sit, Rec8 AS Rec, UD8 AS UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE CodigoSerie = p_Serie AND CodigoNumero = p_Numero AND CodigoPerfil = p_CodigoArticulo
      AND CodigoAcabado = p_CodigoAcabado 
      AND ((CodigoAcabado2 = p_CodigoAcabado2) OR ((CodigoAcabado2 IS NULL) AND (p_CodigoAcabado2 = '')))
      AND Med8 IS NOT NULL AND Med8 > 0
    
    UNION ALL
    
    SELECT 
        CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
        Ancho, Maquina, Tipo,
        -- Descomponer ítem 9
        Med9 AS Med, MedH9 AS MedH, Modulo9 AS Modulo,
        CASILLERO9 AS CASILLERO, CASILLEROB9 AS CASILLEROB,
        Corte1_9 AS Corte1, Corte2_9 AS Corte2, Corte1b_9 AS Corte1b, Corte2b_9 AS Corte2b,
        ID9 AS ID, KTN9 AS KTN, MAQ9 AS MAQ, MAQ2_9 AS MAQ2, REF9 AS REF,
        Lin9 AS Lin, Sit9 AS Sit, Rec9 AS Rec, UD9 AS UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE CodigoSerie = p_Serie AND CodigoNumero = p_Numero AND CodigoPerfil = p_CodigoArticulo
      AND CodigoAcabado = p_CodigoAcabado 
      AND ((CodigoAcabado2 = p_CodigoAcabado2) OR ((CodigoAcabado2 IS NULL) AND (p_CodigoAcabado2 = '')))
      AND Med9 IS NOT NULL AND Med9 > 0;

    -- PASO 2: Crear tabla reagrupada por módulo y medidas
    DROP TEMPORARY TABLE IF EXISTS temp_items_reagrupados;
    CREATE TEMPORARY TABLE temp_items_reagrupados AS
    SELECT 
        CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
        Ancho, Maquina, Tipo, Modulo, Med,
        -- Mantener información del primer ítem del grupo (pero con valores reales)
        MedH, CASILLERO, CASILLEROB,
        Corte1, Corte2, Corte1b, Corte2b,
        ID, KTN, MAQ, MAQ2, REF,
        Lin, Sit, Rec, UD,
        Grafico, Parametros,
        COUNT(*) AS cantidad_items_reagrupados
    FROM temp_items_descompuestos
    GROUP BY CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
             Ancho, Maquina, Tipo, Modulo, Med,
             MedH, CASILLERO, CASILLEROB, Corte1, Corte2, Corte1b, Corte2b,
             ID, KTN, MAQ, MAQ2, REF, Lin, Sit, Rec, UD, Grafico, Parametros
    ORDER BY Med DESC, Modulo;

    -- PASO 3: Aplicar optimización con ordenamiento item a item
    DROP TEMPORARY TABLE IF EXISTS temp_items_expandidos;
    CREATE TEMPORARY TABLE temp_items_expandidos AS
    SELECT 
        r.*,
        numeros.n AS item_repeticion,
        @row_number := @row_number + 1 AS item_orden
    FROM temp_items_reagrupados r
    INNER JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
        UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
        UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
        UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
    ) numeros ON numeros.n <= r.cantidad_items_reagrupados
    CROSS JOIN (SELECT @row_number := 0) AS init
    ORDER BY r.Med DESC, r.Modulo, numeros.n;

    -- PASO 4: Aplicar lógica de optimización de barras
    SELECT 
        -- Campos básicos
        CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
        barra_asignada AS Barra,
        1 AS Corte,
        COUNT(*) AS Medidas,
        COUNT(*) AS Asignadas,
        0 AS AsignadasB,
        1 AS Cantidad,
        0 AS BarraMaq,
        SUM(Med) AS Longitud,
        MAX(Ancho) AS Ancho,
        MAX(Maquina) AS Maquina,
        MAX(Tipo) AS Tipo,
        
        -- Med0-Med9 (hasta 10 ítems por barra)
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN Med END), 0) AS Med0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN Med END), 0) AS Med1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN Med END), 0) AS Med2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN Med END), 0) AS Med3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN Med END), 0) AS Med4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN Med END), 0) AS Med5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN Med END), 0) AS Med6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN Med END), 0) AS Med7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN Med END), 0) AS Med8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN Med END), 0) AS Med9,
        
        -- MedH0-MedH9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN MedH END), 0) AS MedH0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN MedH END), 0) AS MedH1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN MedH END), 0) AS MedH2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN MedH END), 0) AS MedH3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN MedH END), 0) AS MedH4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN MedH END), 0) AS MedH5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN MedH END), 0) AS MedH6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN MedH END), 0) AS MedH7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN MedH END), 0) AS MedH8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN MedH END), 0) AS MedH9,
        
        -- Modulo0-Modulo9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN Modulo END), '') AS Modulo0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN Modulo END), '') AS Modulo1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN Modulo END), '') AS Modulo2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN Modulo END), '') AS Modulo3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN Modulo END), '') AS Modulo4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN Modulo END), '') AS Modulo5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN Modulo END), '') AS Modulo6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN Modulo END), '') AS Modulo7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN Modulo END), '') AS Modulo8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN Modulo END), '') AS Modulo9,
        
        -- CASILLERO0-CASILLERO9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN CASILLERO END), 0) AS CASILLERO0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN CASILLERO END), 0) AS CASILLERO1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN CASILLERO END), 0) AS CASILLERO2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN CASILLERO END), 0) AS CASILLERO3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN CASILLERO END), 0) AS CASILLERO4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN CASILLERO END), 0) AS CASILLERO5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN CASILLERO END), 0) AS CASILLERO6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN CASILLERO END), 0) AS CASILLERO7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN CASILLERO END), 0) AS CASILLERO8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN CASILLERO END), 0) AS CASILLERO9,
        
        -- CASILLEROB0-CASILLEROB9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN CASILLEROB END), 0) AS CASILLEROB0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN CASILLEROB END), 0) AS CASILLEROB1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN CASILLEROB END), 0) AS CASILLEROB2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN CASILLEROB END), 0) AS CASILLEROB3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN CASILLEROB END), 0) AS CASILLEROB4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN CASILLEROB END), 0) AS CASILLEROB5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN CASILLEROB END), 0) AS CASILLEROB6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN CASILLEROB END), 0) AS CASILLEROB7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN CASILLEROB END), 0) AS CASILLEROB8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN CASILLEROB END), 0) AS CASILLEROB9,
        
        -- Corte1_0-Corte1_9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN Corte1 END), 0) AS Corte1_0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN Corte1 END), 0) AS Corte1_1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN Corte1 END), 0) AS Corte1_2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN Corte1 END), 0) AS Corte1_3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN Corte1 END), 0) AS Corte1_4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN Corte1 END), 0) AS Corte1_5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN Corte1 END), 0) AS Corte1_6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN Corte1 END), 0) AS Corte1_7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN Corte1 END), 0) AS Corte1_8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN Corte1 END), 0) AS Corte1_9,
        
        -- Corte2_0-Corte2_9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN Corte2 END), 0) AS Corte2_0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN Corte2 END), 0) AS Corte2_1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN Corte2 END), 0) AS Corte2_2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN Corte2 END), 0) AS Corte2_3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN Corte2 END), 0) AS Corte2_4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN Corte2 END), 0) AS Corte2_5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN Corte2 END), 0) AS Corte2_6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN Corte2 END), 0) AS Corte2_7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN Corte2 END), 0) AS Corte2_8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN Corte2 END), 0) AS Corte2_9,
        
        -- Corte1b_0-Corte1b_9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN Corte1b END), 0) AS Corte1b_0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN Corte1b END), 0) AS Corte1b_1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN Corte1b END), 0) AS Corte1b_2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN Corte1b END), 0) AS Corte1b_3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN Corte1b END), 0) AS Corte1b_4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN Corte1b END), 0) AS Corte1b_5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN Corte1b END), 0) AS Corte1b_6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN Corte1b END), 0) AS Corte1b_7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN Corte1b END), 0) AS Corte1b_8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN Corte1b END), 0) AS Corte1b_9,
        
        -- Corte2b_0-Corte2b_9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN Corte2b END), 0) AS Corte2b_0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN Corte2b END), 0) AS Corte2b_1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN Corte2b END), 0) AS Corte2b_2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN Corte2b END), 0) AS Corte2b_3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN Corte2b END), 0) AS Corte2b_4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN Corte2b END), 0) AS Corte2b_5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN Corte2b END), 0) AS Corte2b_6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN Corte2b END), 0) AS Corte2b_7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN Corte2b END), 0) AS Corte2b_8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN Corte2b END), 0) AS Corte2b_9,
        
        -- ID0-ID9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN ID END), 0) AS ID0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN ID END), 0) AS ID1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN ID END), 0) AS ID2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN ID END), 0) AS ID3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN ID END), 0) AS ID4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN ID END), 0) AS ID5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN ID END), 0) AS ID6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN ID END), 0) AS ID7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN ID END), 0) AS ID8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN ID END), 0) AS ID9,
        
        -- KTN0-KTN9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN KTN END), 0) AS KTN0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN KTN END), 0) AS KTN1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN KTN END), 0) AS KTN2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN KTN END), 0) AS KTN3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN KTN END), 0) AS KTN4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN KTN END), 0) AS KTN5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN KTN END), 0) AS KTN6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN KTN END), 0) AS KTN7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN KTN END), 0) AS KTN8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN KTN END), 0) AS KTN9,
        
        -- MAQ0-MAQ9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN MAQ END), 0) AS MAQ0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN MAQ END), 0) AS MAQ1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN MAQ END), 0) AS MAQ2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN MAQ END), 0) AS MAQ3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN MAQ END), 0) AS MAQ4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN MAQ END), 0) AS MAQ5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN MAQ END), 0) AS MAQ6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN MAQ END), 0) AS MAQ7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN MAQ END), 0) AS MAQ8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN MAQ END), 0) AS MAQ9,
        
        -- MAQ2_0-MAQ2_9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN MAQ2 END), 0) AS MAQ2_0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN MAQ2 END), 0) AS MAQ2_1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN MAQ2 END), 0) AS MAQ2_2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN MAQ2 END), 0) AS MAQ2_3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN MAQ2 END), 0) AS MAQ2_4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN MAQ2 END), 0) AS MAQ2_5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN MAQ2 END), 0) AS MAQ2_6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN MAQ2 END), 0) AS MAQ2_7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN MAQ2 END), 0) AS MAQ2_8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN MAQ2 END), 0) AS MAQ2_9,
        
        -- REF0-REF9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN REF END), 0) AS REF0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN REF END), 0) AS REF1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN REF END), 0) AS REF2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN REF END), 0) AS REF3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN REF END), 0) AS REF4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN REF END), 0) AS REF5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN REF END), 0) AS REF6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN REF END), 0) AS REF7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN REF END), 0) AS REF8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN REF END), 0) AS REF9,
        
        -- Lin0-Lin9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN Lin END), 0) AS Lin0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN Lin END), 0) AS Lin1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN Lin END), 0) AS Lin2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN Lin END), 0) AS Lin3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN Lin END), 0) AS Lin4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN Lin END), 0) AS Lin5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN Lin END), 0) AS Lin6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN Lin END), 0) AS Lin7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN Lin END), 0) AS Lin8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN Lin END), 0) AS Lin9,
        
        -- Sit0-Sit9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN Sit END), 0) AS Sit0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN Sit END), 0) AS Sit1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN Sit END), 0) AS Sit2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN Sit END), 0) AS Sit3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN Sit END), 0) AS Sit4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN Sit END), 0) AS Sit5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN Sit END), 0) AS Sit6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN Sit END), 0) AS Sit7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN Sit END), 0) AS Sit8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN Sit END), 0) AS Sit9,
        
        -- Rec0-Rec9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN Rec END), 0) AS Rec0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN Rec END), 0) AS Rec1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN Rec END), 0) AS Rec2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN Rec END), 0) AS Rec3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN Rec END), 0) AS Rec4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN Rec END), 0) AS Rec5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN Rec END), 0) AS Rec6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN Rec END), 0) AS Rec7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN Rec END), 0) AS Rec8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN Rec END), 0) AS Rec9,
        
        -- UD0-UD9
        COALESCE(MAX(CASE WHEN posicion_en_barra = 1 THEN UD END), 0) AS UD0,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 2 THEN UD END), 0) AS UD1,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 3 THEN UD END), 0) AS UD2,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 4 THEN UD END), 0) AS UD3,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 5 THEN UD END), 0) AS UD4,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 6 THEN UD END), 0) AS UD5,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 7 THEN UD END), 0) AS UD6,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 8 THEN UD END), 0) AS UD7,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 9 THEN UD END), 0) AS UD8,
        COALESCE(MAX(CASE WHEN posicion_en_barra = 10 THEN UD END), 0) AS UD9,
        
        -- Campos finales
        MAX(Grafico) AS Grafico,
        MAX(Parametros) AS Parametros
        
    FROM (
        SELECT 
            *,
            @barra_actual := CASE 
                WHEN @longitud_acumulada + Med <= Ancho AND @items_en_barra < 10
                THEN @barra_actual
                ELSE @barra_actual + 1
            END AS barra_asignada,
            
            @items_en_barra := CASE
                WHEN @barra_actual <> @barra_anterior
                THEN 1
                ELSE @items_en_barra + 1
            END AS posicion_en_barra,
            
            @longitud_acumulada := CASE
                WHEN @barra_actual <> @barra_anterior
                THEN Med
                ELSE @longitud_acumulada + Med
            END AS longitud_actual,
            
            @barra_anterior := @barra_actual AS barra_anterior_track
            
        FROM temp_items_expandidos
        ORDER BY item_orden
    ) items_optimizados
    WHERE barra_asignada IS NOT NULL
    GROUP BY CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2, barra_asignada
    ORDER BY CodigoPerfil, CodigoAcabado, CodigoAcabado2, barra_asignada;
    
    -- Limpiar tablas temporales
    DROP TEMPORARY TABLE IF EXISTS temp_items_descompuestos;
    DROP TEMPORARY TABLE IF EXISTS temp_items_reagrupados;
    DROP TEMPORARY TABLE IF EXISTS temp_items_expandidos;

END$$

DELIMITER ;
