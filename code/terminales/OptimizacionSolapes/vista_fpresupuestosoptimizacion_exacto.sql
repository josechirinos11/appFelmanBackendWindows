-- Vista que replica exactamente la lógica del procedimiento sp_fpresupuestosoptimizacion_exacto
-- Genera la misma estructura de 185 columnas con reagrupación y optimización
-- Compatible con FastReport para consultas directas
-- Versión compatible con MySQL < 8.0 (sin CTEs)

CREATE OR REPLACE VIEW vista_fpresupuestosoptimizacion_exacto AS
SELECT 
    -- Campos fijos (no posicionales)
    CodigoNumero,
    CodigoPerfil,
    CodigoAcabado,
    CodigoAcabado2,
    1 as Barra,
    1 as Corte,
    Medidas,
    Asignadas,
    COALESCE(AsignadasB, 0) as AsignadasB,
    Cantidad,
    0 as BarraMaq,
    SUM(Med) as Longitud,
    Ancho,
    Maquina,
    Tipo,
    
    -- Med0-Med9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN Med END), 0) AS Med0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN Med END), 0) AS Med1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN Med END), 0) AS Med2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN Med END), 0) AS Med3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN Med END), 0) AS Med4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN Med END), 0) AS Med5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN Med END), 0) AS Med6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN Med END), 0) AS Med7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN Med END), 0) AS Med8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN Med END), 0) AS Med9,
    
    -- MedH0-MedH9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN MedH END), 0) AS MedH0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN MedH END), 0) AS MedH1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN MedH END), 0) AS MedH2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN MedH END), 0) AS MedH3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN MedH END), 0) AS MedH4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN MedH END), 0) AS MedH5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN MedH END), 0) AS MedH6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN MedH END), 0) AS MedH7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN MedH END), 0) AS MedH8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN MedH END), 0) AS MedH9,
    
    -- Modulo0-Modulo9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN Modulo END), '') AS Modulo0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN Modulo END), '') AS Modulo1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN Modulo END), '') AS Modulo2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN Modulo END), '') AS Modulo3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN Modulo END), '') AS Modulo4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN Modulo END), '') AS Modulo5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN Modulo END), '') AS Modulo6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN Modulo END), '') AS Modulo7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN Modulo END), '') AS Modulo8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN Modulo END), '') AS Modulo9,
    
    -- CASILLERO0-CASILLERO9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN CASILLERO END), 0) AS CASILLERO0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN CASILLERO END), 0) AS CASILLERO1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN CASILLERO END), 0) AS CASILLERO2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN CASILLERO END), 0) AS CASILLERO3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN CASILLERO END), 0) AS CASILLERO4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN CASILLERO END), 0) AS CASILLERO5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN CASILLERO END), 0) AS CASILLERO6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN CASILLERO END), 0) AS CASILLERO7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN CASILLERO END), 0) AS CASILLERO8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN CASILLERO END), 0) AS CASILLERO9,
    
    -- CASILLEROB0-CASILLEROB9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN CASILLEROB END), 0) AS CASILLEROB0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN CASILLEROB END), 0) AS CASILLEROB1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN CASILLEROB END), 0) AS CASILLEROB2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN CASILLEROB END), 0) AS CASILLEROB3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN CASILLEROB END), 0) AS CASILLEROB4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN CASILLEROB END), 0) AS CASILLEROB5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN CASILLEROB END), 0) AS CASILLEROB6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN CASILLEROB END), 0) AS CASILLEROB7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN CASILLEROB END), 0) AS CASILLEROB8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN CASILLEROB END), 0) AS CASILLEROB9,
    
    -- Corte1_0-Corte1_9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN Corte1 END), 0) AS Corte1_0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN Corte1 END), 0) AS Corte1_1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN Corte1 END), 0) AS Corte1_2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN Corte1 END), 0) AS Corte1_3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN Corte1 END), 0) AS Corte1_4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN Corte1 END), 0) AS Corte1_5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN Corte1 END), 0) AS Corte1_6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN Corte1 END), 0) AS Corte1_7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN Corte1 END), 0) AS Corte1_8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN Corte1 END), 0) AS Corte1_9,
    
    -- Corte2_0-Corte2_9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN Corte2 END), 0) AS Corte2_0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN Corte2 END), 0) AS Corte2_1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN Corte2 END), 0) AS Corte2_2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN Corte2 END), 0) AS Corte2_3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN Corte2 END), 0) AS Corte2_4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN Corte2 END), 0) AS Corte2_5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN Corte2 END), 0) AS Corte2_6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN Corte2 END), 0) AS Corte2_7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN Corte2 END), 0) AS Corte2_8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN Corte2 END), 0) AS Corte2_9,
    
    -- Corte1b_0-Corte1b_9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN Corte1b END), 0) AS Corte1b_0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN Corte1b END), 0) AS Corte1b_1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN Corte1b END), 0) AS Corte1b_2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN Corte1b END), 0) AS Corte1b_3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN Corte1b END), 0) AS Corte1b_4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN Corte1b END), 0) AS Corte1b_5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN Corte1b END), 0) AS Corte1b_6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN Corte1b END), 0) AS Corte1b_7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN Corte1b END), 0) AS Corte1b_8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN Corte1b END), 0) AS Corte1b_9,
    
    -- Corte2b_0-Corte2b_9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN Corte2b END), 0) AS Corte2b_0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN Corte2b END), 0) AS Corte2b_1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN Corte2b END), 0) AS Corte2b_2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN Corte2b END), 0) AS Corte2b_3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN Corte2b END), 0) AS Corte2b_4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN Corte2b END), 0) AS Corte2b_5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN Corte2b END), 0) AS Corte2b_6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN Corte2b END), 0) AS Corte2b_7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN Corte2b END), 0) AS Corte2b_8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN Corte2b END), 0) AS Corte2b_9,
    
    -- ID0-ID9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN ID END), 0) AS ID0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN ID END), 0) AS ID1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN ID END), 0) AS ID2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN ID END), 0) AS ID3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN ID END), 0) AS ID4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN ID END), 0) AS ID5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN ID END), 0) AS ID6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN ID END), 0) AS ID7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN ID END), 0) AS ID8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN ID END), 0) AS ID9,
    
    -- KTN0-KTN9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN KTN END), 0) AS KTN0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN KTN END), 0) AS KTN1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN KTN END), 0) AS KTN2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN KTN END), 0) AS KTN3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN KTN END), 0) AS KTN4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN KTN END), 0) AS KTN5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN KTN END), 0) AS KTN6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN KTN END), 0) AS KTN7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN KTN END), 0) AS KTN8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN KTN END), 0) AS KTN9,
    
    -- MAQ0-MAQ9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN MAQ END), 0) AS MAQ0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN MAQ END), 0) AS MAQ1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN MAQ END), 0) AS MAQ2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN MAQ END), 0) AS MAQ3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN MAQ END), 0) AS MAQ4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN MAQ END), 0) AS MAQ5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN MAQ END), 0) AS MAQ6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN MAQ END), 0) AS MAQ7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN MAQ END), 0) AS MAQ8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN MAQ END), 0) AS MAQ9,
    
    -- MAQ2_0-MAQ2_9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN MAQ2 END), 0) AS MAQ2_0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN MAQ2 END), 0) AS MAQ2_1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN MAQ2 END), 0) AS MAQ2_2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN MAQ2 END), 0) AS MAQ2_3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN MAQ2 END), 0) AS MAQ2_4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN MAQ2 END), 0) AS MAQ2_5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN MAQ2 END), 0) AS MAQ2_6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN MAQ2 END), 0) AS MAQ2_7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN MAQ2 END), 0) AS MAQ2_8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN MAQ2 END), 0) AS MAQ2_9,
    
    -- REF0-REF9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN REF END), 0) AS REF0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN REF END), 0) AS REF1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN REF END), 0) AS REF2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN REF END), 0) AS REF3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN REF END), 0) AS REF4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN REF END), 0) AS REF5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN REF END), 0) AS REF6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN REF END), 0) AS REF7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN REF END), 0) AS REF8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN REF END), 0) AS REF9,
    
    -- Lin0-Lin9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN Lin END), 0) AS Lin0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN Lin END), 0) AS Lin1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN Lin END), 0) AS Lin2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN Lin END), 0) AS Lin3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN Lin END), 0) AS Lin4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN Lin END), 0) AS Lin5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN Lin END), 0) AS Lin6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN Lin END), 0) AS Lin7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN Lin END), 0) AS Lin8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN Lin END), 0) AS Lin9,
    
    -- Sit0-Sit9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN Sit END), 0) AS Sit0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN Sit END), 0) AS Sit1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN Sit END), 0) AS Sit2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN Sit END), 0) AS Sit3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN Sit END), 0) AS Sit4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN Sit END), 0) AS Sit5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN Sit END), 0) AS Sit6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN Sit END), 0) AS Sit7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN Sit END), 0) AS Sit8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN Sit END), 0) AS Sit9,
    
    -- Rec0-Rec9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN Rec END), 0) AS Rec0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN Rec END), 0) AS Rec1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN Rec END), 0) AS Rec2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN Rec END), 0) AS Rec3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN Rec END), 0) AS Rec4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN Rec END), 0) AS Rec5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN Rec END), 0) AS Rec6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN Rec END), 0) AS Rec7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN Rec END), 0) AS Rec8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN Rec END), 0) AS Rec9,
    
    -- UD0-UD9
    COALESCE(MAX(CASE WHEN item_index = 0 THEN UD END), 0) AS UD0,
    COALESCE(MAX(CASE WHEN item_index = 1 THEN UD END), 0) AS UD1,
    COALESCE(MAX(CASE WHEN item_index = 2 THEN UD END), 0) AS UD2,
    COALESCE(MAX(CASE WHEN item_index = 3 THEN UD END), 0) AS UD3,
    COALESCE(MAX(CASE WHEN item_index = 4 THEN UD END), 0) AS UD4,
    COALESCE(MAX(CASE WHEN item_index = 5 THEN UD END), 0) AS UD5,
    COALESCE(MAX(CASE WHEN item_index = 6 THEN UD END), 0) AS UD6,
    COALESCE(MAX(CASE WHEN item_index = 7 THEN UD END), 0) AS UD7,
    COALESCE(MAX(CASE WHEN item_index = 8 THEN UD END), 0) AS UD8,
    COALESCE(MAX(CASE WHEN item_index = 9 THEN UD END), 0) AS UD9,
    
    -- Campos finales
    MAX(Grafico) as Grafico,
    MAX(Parametros) as Parametros

FROM (
    -- DESCOMPOSICIÓN DE ITEMS: Convertir columnas Med0-Med9 en filas
    SELECT 
        CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2, Barra, Corte, Tipo,
        Medidas, Asignadas, AsignadasB, Cantidad, BarraMaq, Longitud, Ancho, Maquina,
        0 as item_index, Med0 as Med, MedH0 as MedH, Modulo0 as Modulo, CASILLERO0 as CASILLERO, CASILLEROB0 as CASILLEROB,
        Corte1_0 as Corte1, Corte2_0 as Corte2, Corte1b_0 as Corte1b, Corte2b_0 as Corte2b,
        ID0 as ID, KTN0 as KTN, MAQ0 as MAQ, MAQ2_0 as MAQ2, REF0 as REF, Lin0 as Lin, Sit0 as Sit, Rec0 as Rec, UD0 as UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE Med0 IS NOT NULL AND Med0 > 0
    
    UNION ALL
    
    SELECT 
        CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2, Barra, Corte, Tipo,
        Medidas, Asignadas, AsignadasB, Cantidad, BarraMaq, Longitud, Ancho, Maquina,
        1 as item_index, Med1 as Med, MedH1 as MedH, Modulo1 as Modulo, CASILLERO1 as CASILLERO, CASILLEROB1 as CASILLEROB,
        Corte1_1 as Corte1, Corte2_1 as Corte2, Corte1b_1 as Corte1b, Corte2b_1 as Corte2b,
        ID1 as ID, KTN1 as KTN, MAQ1 as MAQ, MAQ2_1 as MAQ2, REF1 as REF, Lin1 as Lin, Sit1 as Sit, Rec1 as Rec, UD1 as UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE Med1 IS NOT NULL AND Med1 > 0
    
    UNION ALL
    
    SELECT 
        CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2, Barra, Corte, Tipo,
        Medidas, Asignadas, AsignadasB, Cantidad, BarraMaq, Longitud, Ancho, Maquina,
        2 as item_index, Med2 as Med, MedH2 as MedH, Modulo2 as Modulo, CASILLERO2 as CASILLERO, CASILLEROB2 as CASILLEROB,
        Corte1_2 as Corte1, Corte2_2 as Corte2, Corte1b_2 as Corte1b, Corte2b_2 as Corte2b,
        ID2 as ID, KTN2 as KTN, MAQ2 as MAQ, MAQ2_2 as MAQ2, REF2 as REF, Lin2 as Lin, Sit2 as Sit, Rec2 as Rec, UD2 as UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE Med2 IS NOT NULL AND Med2 > 0
    
    UNION ALL
    
    SELECT 
        CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2, Barra, Corte, Tipo,
        Medidas, Asignadas, AsignadasB, Cantidad, BarraMaq, Longitud, Ancho, Maquina,
        3 as item_index, Med3 as Med, MedH3 as MedH, Modulo3 as Modulo, CASILLERO3 as CASILLERO, CASILLEROB3 as CASILLEROB,
        Corte1_3 as Corte1, Corte2_3 as Corte2, Corte1b_3 as Corte1b, Corte2b_3 as Corte2b,
        ID3 as ID, KTN3 as KTN, MAQ3 as MAQ, MAQ2_3 as MAQ2, REF3 as REF, Lin3 as Lin, Sit3 as Sit, Rec3 as Rec, UD3 as UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE Med3 IS NOT NULL AND Med3 > 0
    
    UNION ALL
    
    SELECT 
        CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2, Barra, Corte, Tipo,
        Medidas, Asignadas, AsignadasB, Cantidad, BarraMaq, Longitud, Ancho, Maquina,
        4 as item_index, Med4 as Med, MedH4 as MedH, Modulo4 as Modulo, CASILLERO4 as CASILLERO, CASILLEROB4 as CASILLEROB,
        Corte1_4 as Corte1, Corte2_4 as Corte2, Corte1b_4 as Corte1b, Corte2b_4 as Corte2b,
        ID4 as ID, KTN4 as KTN, MAQ4 as MAQ, MAQ2_4 as MAQ2, REF4 as REF, Lin4 as Lin, Sit4 as Sit, Rec4 as Rec, UD4 as UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE Med4 IS NOT NULL AND Med4 > 0
    
    UNION ALL
    
    SELECT 
        CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2, Barra, Corte, Tipo,
        Medidas, Asignadas, AsignadasB, Cantidad, BarraMaq, Longitud, Ancho, Maquina,
        5 as item_index, Med5 as Med, MedH5 as MedH, Modulo5 as Modulo, CASILLERO5 as CASILLERO, CASILLEROB5 as CASILLEROB,
        Corte1_5 as Corte1, Corte2_5 as Corte2, Corte1b_5 as Corte1b, Corte2b_5 as Corte2b,
        ID5 as ID, KTN5 as KTN, MAQ5 as MAQ, MAQ2_5 as MAQ2, REF5 as REF, Lin5 as Lin, Sit5 as Sit, Rec5 as Rec, UD5 as UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE Med5 IS NOT NULL AND Med5 > 0
    
    UNION ALL
    
    SELECT 
        CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2, Barra, Corte, Tipo,
        Medidas, Asignadas, AsignadasB, Cantidad, BarraMaq, Longitud, Ancho, Maquina,
        6 as item_index, Med6 as Med, MedH6 as MedH, Modulo6 as Modulo, CASILLERO6 as CASILLERO, CASILLEROB6 as CASILLEROB,
        Corte1_6 as Corte1, Corte2_6 as Corte2, Corte1b_6 as Corte1b, Corte2b_6 as Corte2b,
        ID6 as ID, KTN6 as KTN, MAQ6 as MAQ, MAQ2_6 as MAQ2, REF6 as REF, Lin6 as Lin, Sit6 as Sit, Rec6 as Rec, UD6 as UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE Med6 IS NOT NULL AND Med6 > 0
    
    UNION ALL
    
    SELECT 
        CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2, Barra, Corte, Tipo,
        Medidas, Asignadas, AsignadasB, Cantidad, BarraMaq, Longitud, Ancho, Maquina,
        7 as item_index, Med7 as Med, MedH7 as MedH, Modulo7 as Modulo, CASILLERO7 as CASILLERO, CASILLEROB7 as CASILLEROB,
        Corte1_7 as Corte1, Corte2_7 as Corte2, Corte1b_7 as Corte1b, Corte2b_7 as Corte2b,
        ID7 as ID, KTN7 as KTN, MAQ7 as MAQ, MAQ2_7 as MAQ2, REF7 as REF, Lin7 as Lin, Sit7 as Sit, Rec7 as Rec, UD7 as UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE Med7 IS NOT NULL AND Med7 > 0
    
    UNION ALL
    
    SELECT 
        CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2, Barra, Corte, Tipo,
        Medidas, Asignadas, AsignadasB, Cantidad, BarraMaq, Longitud, Ancho, Maquina,
        8 as item_index, Med8 as Med, MedH8 as MedH, Modulo8 as Modulo, CASILLERO8 as CASILLERO, CASILLEROB8 as CASILLEROB,
        Corte1_8 as Corte1, Corte2_8 as Corte2, Corte1b_8 as Corte1b, Corte2b_8 as Corte2b,
        ID8 as ID, KTN8 as KTN, MAQ8 as MAQ, MAQ2_8 as MAQ2, REF8 as REF, Lin8 as Lin, Sit8 as Sit, Rec8 as Rec, UD8 as UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE Med8 IS NOT NULL AND Med8 > 0
    
    UNION ALL
    
    SELECT 
        CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2, Barra, Corte, Tipo,
        Medidas, Asignadas, AsignadasB, Cantidad, BarraMaq, Longitud, Ancho, Maquina,
        9 as item_index, Med9 as Med, MedH9 as MedH, Modulo9 as Modulo, CASILLERO9 as CASILLERO, CASILLEROB9 as CASILLEROB,
        Corte1_9 as Corte1, Corte2_9 as Corte2, Corte1b_9 as Corte1b, Corte2b_9 as Corte2b,
        ID9 as ID, KTN9 as KTN, MAQ9 as MAQ, MAQ2_9 as MAQ2, REF9 as REF, Lin9 as Lin, Sit9 as Sit, Rec9 as Rec, UD9 as UD,
        Grafico, Parametros
    FROM fpresupuestosoptimizacion
    WHERE Med9 IS NOT NULL AND Med9 > 0
    
) as items_descompuestos
GROUP BY 
    CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2, Tipo,
    Medidas, Asignadas, AsignadasB, Cantidad, Ancho, Maquina, Grafico, Parametros;
               ) + t.Med <= t.Ancho
        ) as barra_asignada
    FROM temp_items_expandidos t
)

-- RESULTADO FINAL: Estructura completa de 185 columnas
SELECT 
    -- Campos fijos (no posicionales)
    CodigoNumero,
    CodigoPerfil,
    CodigoAcabado,
    CodigoAcabado2,
    barra_asignada as Barra,
    1 as Corte,
    Medidas,
    Asignadas,
    COALESCE(AsignadasB, 0) as AsignadasB,
    Cantidad,
    0 as BarraMaq,
    SUM(Med) as Longitud,
    Ancho,
    Maquina,
    Tipo,
    
    -- Med0-Med9
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
    MAX(Grafico) as Grafico,
    MAX(Parametros) as Parametros

FROM temp_optimizacion
GROUP BY 
    CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2, Tipo, barra_asignada,
    Medidas, Asignadas, AsignadasB, Cantidad, Ancho, Maquina, Grafico, Parametros;
