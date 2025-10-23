-- CONSULTA REORGANIZADA PARA OPERARIO
-- Cada registro tiene máximo 10 items (itemX), agrupados por ModuloX y MedX, y distribuidos en pares por registro
SELECT
  CodigoSerie,
  CodigoNumero,
  CodigoPerfil,
  CodigoAcabado,
  CodigoAcabado2,
  Barra,
  Corte,
  Medidas,
  Asignadas,
  AsignadasB,
  Cantidad,
  BarraMaq,
  Longitud,
  Ancho,
  Maquina,
  Tipo,
  -- Items 0 a 9
  Med0, MedH0, Modulo0, CASILLERO0, CASILLEROB0, Corte1_0, Corte2_0, Corte1b_0, Corte2b_0, ID0, KTN0, MAQ0, MAQ2_0, REF0, Lin0, Sit0, Rec0, UD0,
  Med1, MedH1, Modulo1, CASILLERO1, CASILLEROB1, Corte1_1, Corte2_1, Corte1b_1, Corte2b_1, ID1, KTN1, MAQ1, MAQ2_1, REF1, Lin1, Sit1, Rec1, UD1,
  Med2, MedH2, Modulo2, CASILLERO2, CASILLEROB2, Corte1_2, Corte2_2, Corte1b_2, Corte2b_2, ID2, KTN2, MAQ2, MAQ2_2, REF2, Lin2, Sit2, Rec2, UD2,
  Med3, MedH3, Modulo3, CASILLERO3, CASILLEROB3, Corte1_3, Corte2_3, Corte1b_3, Corte2b_3, ID3, KTN3, MAQ3, MAQ2_3, REF3, Lin3, Sit3, Rec3, UD3,
  Med4, MedH4, Modulo4, CASILLERO4, CASILLEROB4, Corte1_4, Corte2_4, Corte1b_4, Corte2b_4, ID4, KTN4, MAQ4, MAQ2_4, REF4, Lin4, Sit4, Rec4, UD4,
  Med5, MedH5, Modulo5, CASILLERO5, CASILLEROB5, Corte1_5, Corte2_5, Corte1b_5, Corte2b_5, ID5, KTN5, MAQ5, MAQ2_5, REF5, Lin5, Sit5, Rec5, UD5,
  Med6, MedH6, Modulo6, CASILLERO6, CASILLEROB6, Corte1_6, Corte2_6, Corte1b_6, Corte2b_6, ID6, KTN6, MAQ6, MAQ2_6, REF6, Lin6, Sit6, Rec6, UD6,
  Med7, MedH7, Modulo7, CASILLERO7, CASILLEROB7, Corte1_7, Corte2_7, Corte1b_7, Corte2b_7, ID7, KTN7, MAQ7, MAQ2_7, REF7, Lin7, Sit7, Rec7, UD7,
  Med8, MedH8, Modulo8, CASILLERO8, CASILLEROB8, Corte1_8, Corte2_8, Corte1b_8, Corte2b_8, ID8, KTN8, MAQ8, MAQ2_8, REF8, Lin8, Sit8, Rec8, UD8,
  Med9, MedH9, Modulo9, CASILLERO9, CASILLEROB9, Corte1_9, Corte2_9, Corte1b_9, Corte2b_9, ID9, KTN9, MAQ9, MAQ2_9, REF9, Lin9, Sit9, Rec9, UD9,
  Grafico,
  Parametros
FROM (
  -- Subconsulta que desglosa y reagrupa los items por ModuloX y MedX en pares, máximo 10 por registro
  -- Aquí deberías implementar la lógica de reagrupación en tu aplicación o con procedimientos almacenados, ya que SQL puro no puede reordenar dinámicamente los pares en filas
  SELECT * FROM fpresupuestosoptimizacion
  WHERE CodigoSerie = :Serie AND CodigoNumero = :Numero AND CodigoPerfil = :CodigoArticulo
    AND CodigoAcabado = :CodigoAcabado AND ((CodigoAcabado2 = :CodigoAcabado2) OR ((CodigoAcabado2 IS NULL) AND (:CodigoAcabado2 = '')))
  -- La lógica de reagrupación y distribución de pares debe hacerse en la capa de aplicación o con un procedimiento
) AS Reagrupados
ORDER BY CodigoPerfil, CodigoAcabado, CodigoAcabado2, Barra, Corte
