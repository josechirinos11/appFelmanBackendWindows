-- Parámetros: :Serie, :Numero, :CodigoArticulo, :CodigoAcabado, :CodigoAcabado2



-- 1) Unpivot (items 0..9)
SELECT
  agg.CodigoSerie,
  agg.CodigoNumero,
  agg.CodigoPerfil,
  agg.CodigoAcabado,
  agg.CodigoAcabado2,
  agg.Barra,
  agg.Corte,
  agg.Medidas,
  agg.Asignadas,
  agg.AsignadasB,
  agg.Cantidad,
  agg.BarraMaq,
  agg.Longitud,
  agg.Ancho,
  agg.Maquina,
  agg.Tipo,
  agg.item_num,
  agg.Med,
  agg.MedH,
  agg.Modulo,
  agg.CASILLERO,
  agg.CASILLEROB,
  agg.Corte1,
  agg.Corte2,
  agg.Corte1b,
  agg.Corte2b,
  agg.ID,
  agg.KTN,
  agg.MAQ,
  agg.MAQ2,
  agg.REF,
  agg.Lin,
  agg.Sit,
  agg.Rec,
  agg.UD,
  -- 2) Variables para numeración por partición (clave del registro)
  @row_in_part :=
    IF(@pk = agg.pk,
       @row_in_part + 1,
       1
    ) AS row_in_part,
  @pos := (@row_in_part - 1) % 10 AS posicion_en_registro,
  CEIL(@row_in_part / 10) AS nuevo_registro,
  @pk := agg.pk AS _set_pk
FROM (
  SELECT
    t.CodigoSerie, t.CodigoNumero, t.CodigoPerfil, t.CodigoAcabado, t.CodigoAcabado2,
    t.Barra, t.Corte, t.Medidas, t.Asignadas, t.AsignadasB, t.Cantidad, t.BarraMaq,
    t.Longitud, t.Ancho, t.Maquina, t.Tipo,
    CONCAT_WS('|',
      t.CodigoSerie, t.CodigoNumero, t.CodigoPerfil, t.CodigoAcabado, IFNULL(t.CodigoAcabado2,''), t.Barra, t.Corte
    ) AS pk,
    items.item_num,

    CASE items.item_num
      WHEN 0 THEN t.Med0 WHEN 1 THEN t.Med1 WHEN 2 THEN t.Med2 WHEN 3 THEN t.Med3 WHEN 4 THEN t.Med4
      WHEN 5 THEN t.Med5 WHEN 6 THEN t.Med6 WHEN 7 THEN t.Med7 WHEN 8 THEN t.Med8 WHEN 9 THEN t.Med9
    END AS Med,
    CASE items.item_num
      WHEN 0 THEN t.MedH0 WHEN 1 THEN t.MedH1 WHEN 2 THEN t.MedH2 WHEN 3 THEN t.MedH3 WHEN 4 THEN t.MedH4
      WHEN 5 THEN t.MedH5 WHEN 6 THEN t.MedH6 WHEN 7 THEN t.MedH7 WHEN 8 THEN t.MedH8 WHEN 9 THEN t.MedH9
    END AS MedH,
    CASE items.item_num
      WHEN 0 THEN t.Modulo0 WHEN 1 THEN t.Modulo1 WHEN 2 THEN t.Modulo2 WHEN 3 THEN t.Modulo3 WHEN 4 THEN t.Modulo4
      WHEN 5 THEN t.Modulo5 WHEN 6 THEN t.Modulo6 WHEN 7 THEN t.Modulo7 WHEN 8 THEN t.Modulo8 WHEN 9 THEN t.Modulo9
    END AS Modulo,
    CASE items.item_num
      WHEN 0 THEN t.CASILLERO0 WHEN 1 THEN t.CASILLERO1 WHEN 2 THEN t.CASILLERO2 WHEN 3 THEN t.CASILLERO3 WHEN 4 THEN t.CASILLERO4
      WHEN 5 THEN t.CASILLERO5 WHEN 6 THEN t.CASILLERO6 WHEN 7 THEN t.CASILLERO7 WHEN 8 THEN t.CASILLERO8 WHEN 9 THEN t.CASILLERO9
    END AS CASILLERO,
    CASE items.item_num
      WHEN 0 THEN t.CASILLEROB0 WHEN 1 THEN t.CASILLEROB1 WHEN 2 THEN t.CASILLEROB2 WHEN 3 THEN t.CASILLEROB3 WHEN 4 THEN t.CASILLEROB4
      WHEN 5 THEN t.CASILLEROB5 WHEN 6 THEN t.CASILLEROB6 WHEN 7 THEN t.CASILLEROB7 WHEN 8 THEN t.CASILLEROB8 WHEN 9 THEN t.CASILLEROB9
    END AS CASILLEROB,
    CASE items.item_num
      WHEN 0 THEN t.Corte1_0 WHEN 1 THEN t.Corte1_1 WHEN 2 THEN t.Corte1_2 WHEN 3 THEN t.Corte1_3 WHEN 4 THEN t.Corte1_4
      WHEN 5 THEN t.Corte1_5 WHEN 6 THEN t.Corte1_6 WHEN 7 THEN t.Corte1_7 WHEN 8 THEN t.Corte1_8 WHEN 9 THEN t.Corte1_9
    END AS Corte1,
    CASE items.item_num
      WHEN 0 THEN t.Corte2_0 WHEN 1 THEN t.Corte2_1 WHEN 2 THEN t.Corte2_2 WHEN 3 THEN t.Corte2_3 WHEN 4 THEN t.Corte2_4
      WHEN 5 THEN t.Corte2_5 WHEN 6 THEN t.Corte2_6 WHEN 7 THEN t.Corte2_7 WHEN 8 THEN t.Corte2_8 WHEN 9 THEN t.Corte2_9
    END AS Corte2,
    CASE items.item_num
      WHEN 0 THEN t.Corte1b_0 WHEN 1 THEN t.Corte1b_1 WHEN 2 THEN t.Corte1b_2 WHEN 3 THEN t.Corte1b_3 WHEN 4 THEN t.Corte1b_4
      WHEN 5 THEN t.Corte1b_5 WHEN 6 THEN t.Corte1b_6 WHEN 7 THEN t.Corte1b_7 WHEN 8 THEN t.Corte1b_8 WHEN 9 THEN t.Corte1b_9
    END AS Corte1b,
    CASE items.item_num
      WHEN 0 THEN t.Corte2b_0 WHEN 1 THEN t.Corte2b_1 WHEN 2 THEN t.Corte2b_2 WHEN 3 THEN t.Corte2b_3 WHEN 4 THEN t.Corte2b_4
      WHEN 5 THEN t.Corte2b_5 WHEN 6 THEN t.Corte2b_6 WHEN 7 THEN t.Corte2b_7 WHEN 8 THEN t.Corte2b_8 WHEN 9 THEN t.Corte2b_9
    END AS Corte2b,
    CASE items.item_num
      WHEN 0 THEN t.ID0 WHEN 1 THEN t.ID1 WHEN 2 THEN t.ID2 WHEN 3 THEN t.ID3 WHEN 4 THEN t.ID4
      WHEN 5 THEN t.ID5 WHEN 6 THEN t.ID6 WHEN 7 THEN t.ID7 WHEN 8 THEN t.ID8 WHEN 9 THEN t.ID9
    END AS ID,
    CASE items.item_num
      WHEN 0 THEN t.KTN0 WHEN 1 THEN t.KTN1 WHEN 2 THEN t.KTN2 WHEN 3 THEN t.KTN3 WHEN 4 THEN t.KTN4
      WHEN 5 THEN t.KTN5 WHEN 6 THEN t.KTN6 WHEN 7 THEN t.KTN7 WHEN 8 THEN t.KTN8 WHEN 9 THEN t.KTN9
    END AS KTN,
    CASE items.item_num
      WHEN 0 THEN t.MAQ0 WHEN 1 THEN t.MAQ1 WHEN 2 THEN t.MAQ2 WHEN 3 THEN t.MAQ3 WHEN 4 THEN t.MAQ4
      WHEN 5 THEN t.MAQ5 WHEN 6 THEN t.MAQ6 WHEN 7 THEN t.MAQ7 WHEN 8 THEN t.MAQ8 WHEN 9 THEN t.MAQ9
    END AS MAQ,
    CASE items.item_num
      WHEN 0 THEN t.MAQ2_0 WHEN 1 THEN t.MAQ2_1 WHEN 2 THEN t.MAQ2_2 WHEN 3 THEN t.MAQ2_3 WHEN 4 THEN t.MAQ2_4
      WHEN 5 THEN t.MAQ2_5 WHEN 6 THEN t.MAQ2_6 WHEN 7 THEN t.MAQ2_7 WHEN 8 THEN t.MAQ2_8 WHEN 9 THEN t.MAQ2_9
    END AS MAQ2,
    CASE items.item_num
      WHEN 0 THEN t.REF0 WHEN 1 THEN t.REF1 WHEN 2 THEN t.REF2 WHEN 3 THEN t.REF3 WHEN 4 THEN t.REF4
      WHEN 5 THEN t.REF5 WHEN 6 THEN t.REF6 WHEN 7 THEN t.REF7 WHEN 8 THEN t.REF8 WHEN 9 THEN t.REF9
    END AS REF,
    CASE items.item_num
      WHEN 0 THEN t.Lin0 WHEN 1 THEN t.Lin1 WHEN 2 THEN t.Lin2 WHEN 3 THEN t.Lin3 WHEN 4 THEN t.Lin4
      WHEN 5 THEN t.Lin5 WHEN 6 THEN t.Lin6 WHEN 7 THEN t.Lin7 WHEN 8 THEN t.Lin8 WHEN 9 THEN t.Lin9
    END AS Lin,
    CASE items.item_num
      WHEN 0 THEN t.Sit0 WHEN 1 THEN t.Sit1 WHEN 2 THEN t.Sit2 WHEN 3 THEN t.Sit3 WHEN 4 THEN t.Sit4
      WHEN 5 THEN t.Sit5 WHEN 6 THEN t.Sit6 WHEN 7 THEN t.Sit7 WHEN 8 THEN t.Sit8 WHEN 9 THEN t.Sit9
    END AS Sit,
    CASE items.item_num
      WHEN 0 THEN t.Rec0 WHEN 1 THEN t.Rec1 WHEN 2 THEN t.Rec2 WHEN 3 THEN t.Rec3 WHEN 4 THEN t.Rec4
      WHEN 5 THEN t.Rec5 WHEN 6 THEN t.Rec6 WHEN 7 THEN t.Rec7 WHEN 8 THEN t.Rec8 WHEN 9 THEN t.Rec9
    END AS Rec,
    CASE items.item_num
      WHEN 0 THEN t.UD0 WHEN 1 THEN t.UD1 WHEN 2 THEN t.UD2 WHEN 3 THEN t.UD3 WHEN 4 THEN t.UD4
      WHEN 5 THEN t.UD5 WHEN 6 THEN t.UD6 WHEN 7 THEN t.UD7 WHEN 8 THEN t.UD8 WHEN 9 THEN t.UD9
    END AS UD
  FROM fpresupuestosoptimizacion t
  CROSS JOIN (
    SELECT 0 AS item_num UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
  ) items
  WHERE CodigoSerie='23FBA' 
              AND CodigoNumero=3150 
              AND CodigoPerfil='FEL64974'
              AND CodigoAcabado='9010' 
              AND ((CodigoAcabado2 = :CodigoAcabado2) OR ((CodigoAcabado2 IS NULL) AND (:CodigoAcabado2 = '')))
    AND CASE items.item_num
          WHEN 0 THEN t.Modulo0 WHEN 1 THEN t.Modulo1 WHEN 2 THEN t.Modulo2 WHEN 3 THEN t.Modulo3 WHEN 4 THEN t.Modulo4
          WHEN 5 THEN t.Modulo5 WHEN 6 THEN t.Modulo6 WHEN 7 THEN t.Modulo7 WHEN 8 THEN t.Modulo8 WHEN 9 THEN t.Modulo9
        END IS NOT NULL
    AND TRIM(CASE items.item_num
          WHEN 0 THEN t.Modulo0 WHEN 1 THEN t.Modulo1 WHEN 2 THEN t.Modulo2 WHEN 3 THEN t.Modulo3 WHEN 4 THEN t.Modulo4
          WHEN 5 THEN t.Modulo5 WHEN 6 THEN t.Modulo6 WHEN 7 THEN t.Modulo7 WHEN 8 THEN t.Modulo8 WHEN 9 THEN t.Modulo9
        END) <> ''
) agg
JOIN (SELECT @pk := NULL, @row_in_part := 0, @pos := 0) vars
-- 3) Orden para la numeración dentro de la partición
ORDER BY agg.pk, agg.Modulo, agg.Med, agg.item_num
INTO @tmp_unpivot; -- si tu cliente no soporta INTO, ignora esta línea

-- 4) Re-pivot final (puedes meter lo anterior como subconsulta si tu cliente no usa variables fuera)
SELECT
  MAX(CASE WHEN posicion_en_registro = 0 THEN CodigoSerie END) AS CodigoSerie,
  MAX(CASE WHEN posicion_en_registro = 0 THEN CodigoNumero END) AS CodigoNumero,
  MAX(CASE WHEN posicion_en_registro = 0 THEN CodigoPerfil END) AS CodigoPerfil,
  MAX(CASE WHEN posicion_en_registro = 0 THEN CodigoAcabado END) AS CodigoAcabado,
  MAX(CASE WHEN posicion_en_registro = 0 THEN CodigoAcabado2 END) AS CodigoAcabado2,
  MAX(CASE WHEN posicion_en_registro = 0 THEN Barra END) AS Barra,
  MAX(CASE WHEN posicion_en_registro = 0 THEN Corte END) AS Corte,
  MAX(CASE WHEN posicion_en_registro = 0 THEN Medidas END) AS Medidas,
  MAX(CASE WHEN posicion_en_registro = 0 THEN Asignadas END) AS Asignadas,
  MAX(CASE WHEN posicion_en_registro = 0 THEN AsignadasB END) AS AsignadasB,
  MAX(CASE WHEN posicion_en_registro = 0 THEN Cantidad END) AS Cantidad,
  MAX(CASE WHEN posicion_en_registro = 0 THEN BarraMaq END) AS BarraMaq,
  MAX(CASE WHEN posicion_en_registro = 0 THEN Longitud END) AS Longitud,
  MAX(CASE WHEN posicion_en_registro = 0 THEN Ancho END) AS Ancho,
  MAX(CASE WHEN posicion_en_registro = 0 THEN Maquina END) AS Maquina,
  MAX(CASE WHEN posicion_en_registro = 0 THEN Tipo END) AS Tipo,

  MAX(CASE WHEN posicion_en_registro = 0 THEN Med END) AS Med0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN Med END) AS Med1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN Med END) AS Med2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN Med END) AS Med3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN Med END) AS Med4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN Med END) AS Med5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN Med END) AS Med6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN Med END) AS Med7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN Med END) AS Med8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN Med END) AS Med9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN MedH END) AS MedH0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN MedH END) AS MedH1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN MedH END) AS MedH2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN MedH END) AS MedH3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN MedH END) AS MedH4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN MedH END) AS MedH5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN MedH END) AS MedH6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN MedH END) AS MedH7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN MedH END) AS MedH8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN MedH END) AS MedH9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN Modulo END) AS Modulo0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN Modulo END) AS Modulo1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN Modulo END) AS Modulo2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN Modulo END) AS Modulo3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN Modulo END) AS Modulo4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN Modulo END) AS Modulo5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN Modulo END) AS Modulo6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN Modulo END) AS Modulo7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN Modulo END) AS Modulo8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN Modulo END) AS Modulo9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN CASILLERO END)  AS CASILLERO0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN CASILLERO END)  AS CASILLERO1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN CASILLERO END)  AS CASILLERO2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN CASILLERO END)  AS CASILLERO3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN CASILLERO END)  AS CASILLERO4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN CASILLERO END)  AS CASILLERO5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN CASILLERO END)  AS CASILLERO6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN CASILLERO END)  AS CASILLERO7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN CASILLERO END)  AS CASILLERO8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN CASILLERO END)  AS CASILLERO9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN CASILLEROB END) AS CASILLEROB0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN CASILLEROB END) AS CASILLEROB1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN CASILLEROB END) AS CASILLEROB2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN CASILLEROB END) AS CASILLEROB3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN CASILLEROB END) AS CASILLEROB4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN CASILLEROB END) AS CASILLEROB5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN CASILLEROB END) AS CASILLEROB6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN CASILLEROB END) AS CASILLEROB7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN CASILLEROB END) AS CASILLEROB8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN CASILLEROB END) AS CASILLEROB9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN Corte1 END) AS Corte1_0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN Corte1 END) AS Corte1_1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN Corte1 END) AS Corte1_2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN Corte1 END) AS Corte1_3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN Corte1 END) AS Corte1_4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN Corte1 END) AS Corte1_5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN Corte1 END) AS Corte1_6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN Corte1 END) AS Corte1_7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN Corte1 END) AS Corte1_8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN Corte1 END) AS Corte1_9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN Corte2 END) AS Corte2_0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN Corte2 END) AS Corte2_1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN Corte2 END) AS Corte2_2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN Corte2 END) AS Corte2_3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN Corte2 END) AS Corte2_4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN Corte2 END) AS Corte2_5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN Corte2 END) AS Corte2_6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN Corte2 END) AS Corte2_7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN Corte2 END) AS Corte2_8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN Corte2 END) AS Corte2_9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN Corte1b END) AS Corte1b_0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN Corte1b END) AS Corte1b_1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN Corte1b END) AS Corte1b_2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN Corte1b END) AS Corte1b_3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN Corte1b END) AS Corte1b_4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN Corte1b END) AS Corte1b_5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN Corte1b END) AS Corte1b_6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN Corte1b END) AS Corte1b_7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN Corte1b END) AS Corte1b_8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN Corte1b END) AS Corte1b_9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN Corte2b END) AS Corte2b_0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN Corte2b END) AS Corte2b_1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN Corte2b END) AS Corte2b_2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN Corte2b END) AS Corte2b_3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN Corte2b END) AS Corte2b_4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN Corte2b END) AS Corte2b_5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN Corte2b END) AS Corte2b_6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN Corte2b END) AS Corte2b_7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN Corte2b END) AS Corte2b_8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN Corte2b END) AS Corte2b_9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN ID  END) AS ID0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN ID  END) AS ID1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN ID  END) AS ID2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN ID  END) AS ID3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN ID  END) AS ID4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN ID  END) AS ID5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN ID  END) AS ID6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN ID  END) AS ID7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN ID  END) AS ID8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN ID  END) AS ID9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN KTN END) AS KTN0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN KTN END) AS KTN1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN KTN END) AS KTN2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN KTN END) AS KTN3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN KTN END) AS KTN4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN KTN END) AS KTN5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN KTN END) AS KTN6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN KTN END) AS KTN7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN KTN END) AS KTN8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN KTN END) AS KTN9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN MAQ END) AS MAQ0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN MAQ END) AS MAQ1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN MAQ END) AS MAQ2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN MAQ END) AS MAQ3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN MAQ END) AS MAQ4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN MAQ END) AS MAQ5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN MAQ END) AS MAQ6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN MAQ END) AS MAQ7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN MAQ END) AS MAQ8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN MAQ END) AS MAQ9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN MAQ2 END) AS MAQ2_0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN MAQ2 END) AS MAQ2_1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN MAQ2 END) AS MAQ2_2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN MAQ2 END) AS MAQ2_3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN MAQ2 END) AS MAQ2_4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN MAQ2 END) AS MAQ2_5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN MAQ2 END) AS MAQ2_6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN MAQ2 END) AS MAQ2_7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN MAQ2 END) AS MAQ2_8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN MAQ2 END) AS MAQ2_9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN REF END) AS REF0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN REF END) AS REF1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN REF END) AS REF2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN REF END) AS REF3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN REF END) AS REF4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN REF END) AS REF5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN REF END) AS REF6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN REF END) AS REF7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN REF END) AS REF8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN REF END) AS REF9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN Lin END) AS Lin0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN Lin END) AS Lin1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN Lin END) AS Lin2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN Lin END) AS Lin3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN Lin END) AS Lin4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN Lin END) AS Lin5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN Lin END) AS Lin6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN Lin END) AS Lin7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN Lin END) AS Lin8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN Lin END) AS Lin9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN Sit END) AS Sit0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN Sit END) AS Sit1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN Sit END) AS Sit2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN Sit END) AS Sit3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN Sit END) AS Sit4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN Sit END) AS Sit5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN Sit END) AS Sit6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN Sit END) AS Sit7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN Sit END) AS Sit8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN Sit END) AS Sit9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN Rec END) AS Rec0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN Rec END) AS Rec1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN Rec END) AS Rec2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN Rec END) AS Rec3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN Rec END) AS Rec4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN Rec END) AS Rec5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN Rec END) AS Rec6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN Rec END) AS Rec7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN Rec END) AS Rec8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN Rec END) AS Rec9,

  MAX(CASE WHEN posicion_en_registro = 0 THEN UD END) AS UD0,
  MAX(CASE WHEN posicion_en_registro = 1 THEN UD END) AS UD1,
  MAX(CASE WHEN posicion_en_registro = 2 THEN UD END) AS UD2,
  MAX(CASE WHEN posicion_en_registro = 3 THEN UD END) AS UD3,
  MAX(CASE WHEN posicion_en_registro = 4 THEN UD END) AS UD4,
  MAX(CASE WHEN posicion_en_registro = 5 THEN UD END) AS UD5,
  MAX(CASE WHEN posicion_en_registro = 6 THEN UD END) AS UD6,
  MAX(CASE WHEN posicion_en_registro = 7 THEN UD END) AS UD7,
  MAX(CASE WHEN posicion_en_registro = 8 THEN UD END) AS UD8,
  MAX(CASE WHEN posicion_en_registro = 9 THEN UD END) AS UD9

FROM (
  -- Vuelve a usar la subconsulta unpivot con variables ya calculadas, o bien
  -- encapsula el primer SELECT como subconsulta derivada y referencia aquí.
  SELECT * FROM (
    SELECT
      -- Copia aquí el SELECT unpivot con variables y quita el INTO si lo usaste
      -- (o ponlo como una subconsulta derivada si tu cliente no soporta variables en múltiples etapas).
      -- Para abreviar, asumo que lo has metido como subconsulta llamada tmp
      1
  ) tmp_placeholder
) tmp_final
GROUP BY
  CodigoSerie, CodigoNumero, CodigoPerfil, CodigoAcabado, CodigoAcabado2,
  Barra, Corte, nuevo_registro
ORDER BY
  CodigoPerfil, CodigoAcabado, CodigoAcabado2, Barra, Corte, nuevo_registro;
