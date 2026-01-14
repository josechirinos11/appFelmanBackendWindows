var
  LTOTAL : String;
  LTOTAL2 : String;
  LRESTO : String;
  LTEXTO : String;
  LTXTCLIENTE : String;
  LUP : Integer;
  LUT : Integer;
  LCT : String;
  LMAXL :Integer;
  LHAYBLOQUES: boolean;
  ALMDEST : String; //almacen de destino de la pieza
  UPLinea : Integer; //PAra unidades procesadas de columna de la derecha


//----------------------------------------------------------------------------------------------------

//Funcion para traducir el almacén al sistema TVITEC:
function DameAlmacenTVITEC(pAlm : String; pCas : Integer) : String;
//Porque los almacenes en TVITEC están divididos en bloques de 12 casillas, por lo que
//El A de 24 pasaría a A1 de 12 y A2 de 12. Etnonces: A.18 Sería A2.6
var
  lA : String;
  lC : Integer;
begin
  //Debo restar 1 (la primera será la 0) para usar el algoritmo
  pCas := pCas - 1;

  if pAlm = '' then Result := '' //No hay almacén indicado...
  else
    begin
      lA := pAlm + IntToStr((pCas div 12) + 1);
      lC :=(pCas mod 12) + 1;
      Result := lA + '.' + IntToStr(lC);
    end;
end;

//************ INICIO DEL REPORT ************

procedure Page1OnBeforePrint(Sender: TfrxComponent);
begin
end;

//----------------------------------------------------------------------------------------------------

procedure MemoTotalOnBeforePrint(Sender: TfrxComponent);
var i:Integer;
   ltar,ltipo:string;
    lH, lM, lS, lD: Word;
begin
  lTOTAL:='';
  //exit;
  ltipo := 'ELEMENTO NO VÁLIDO FICHAR EN ESTE PUESTO ';
  if(<RectanguloT."TipoRectangulo"> = 10) then
  begin
    lTipo := 'MARCO';
  end else
  if(<RectanguloT."TipoRectangulo"> = 20) then
  begin
    lTipo := 'HOJA';
  end else
  if(<RectanguloT."TipoRectangulo"> >= 200) AND (<RectanguloT."TipoRectangulo"> <= 230)then
  begin
    lTipo := 'MARCO CORREDERA';
  end else
  if(<RectanguloT."TipoRectangulo"> >= 240) AND (<RectanguloT."TipoRectangulo"> <= 270)then
  begin
    lTipo := 'HOJA CORREDERA';
  end;
  lTOTAL:=LTIPO+' '+<RectanguloT."CodigoLote">+'-'+RectanguloT.FieldByName('Linea').AsString+'-'+RectanguloT.FieldByName('Rectangulo').AsString+'/'+IntToStr(<RectanguloT."TipoRectangulo">)+#13#10;
 { If TRUE  then
  begin
    lTOTAL:=lTOTAL+'TAREA......Herraje hoja (HERRAJEHOJA)'+#13#10;
    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'HERRAJEHOJA','R'+IntToStr(<Rectangulo>)+'.-Forma,Perfil,Zocalo');


    //LRESTO:=STI_EINIn(<LotesLineasDS_FRT."DatosFabricacion">,'MARCOS',IntToStr<Rectangulo>+'.-Forma');
    //IF LENGTH(LRESTO)>0 THEN  LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'');

  end;

  If (<CodigoTarea>= '')  then
  begin

  end;   }

  If (<CodigoTarea>= 'COMPACTO') or  (<CodigoTarea>= 'COMPACTOP') then
  begin
    lTOTAL:=lTOTAL+'TAREA......Compacto persiana ('+<CodigoTarea>+')'+#13#10;
    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'COMPACTOS','Todos.-');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'GUIAS','Todos.-');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'CONDENSACIONES','Todos.-');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'ALARGADERAS','Todos.-');
  end;


  If (<CodigoTarea>= 'FRESADO')  then
  begin
    lTOTAL:=lTOTAL+'TAREA......Mecanizados principales ('+<CodigoTarea>+')'+#13#10;
    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HOJAS','R'+IntToStr(<Rectangulo>)+'.+Tipo');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'FRESADORA','R'+IntToStr(<Rectangulo>)+'.-Nada');
  end;


  If (<CodigoTarea>= 'HERRAJEHOJA') or (<CodigoTarea>= 'HERRAJEHOJAP') then
  begin
    lTOTAL:=lTOTAL+'TAREA......Herraje hoja ('+<CodigoTarea>+')'+#13#10;
    lTOTAL:=lTOTAL+#13#10;
    //LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HERRAJEHOJA','R'+IntToStr(<Rectangulo>)+'.-Forma,Perfil,Zocalo');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HERRAJEHOJA','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HERRAJEHOJA_MANILLA','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL := LTOTAL+'<b>';
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HERRAJEHOJA_ARTICULOS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL := LTOTAL+'</b>';

  end;

  If (<CodigoTarea> = 'HOJAS') or (<CodigoTarea> = 'HOJASP') then
  begin

    lTOTAL:=lTOTAL+'TAREA......Armado de hojas ('+<CodigoTarea>+')'+#13#10;

    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HOJAS','R'+IntToStr(<Rectangulo>)+'.-Forma,Inversor');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HOJASGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HOJASACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HERRAJEHOJA','R'+IntToStr(<Rectangulo>)+'.+Perf.Manilla,Manilla,Eje');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HOJAS','R'+IntToStr(<Rectangulo>)+'.+Inversor');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'INVERSORESGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'INVERSORESACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'POSTES','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'POSTESGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'POSTESACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'TRAVESAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'TRAVESASGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'TRAVESASACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'GOMAVIDRIO','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'GOMACHAPA','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'GOMAPANEL','R'+IntToStr(<Rectangulo>)+'.-Nada');

  end;

  If (<CodigoTarea>= 'MARCOS') or (<CodigoTarea>= 'MARCOSP') then
  begin
    lTOTAL:=lTOTAL+'TAREA......Armado de marcos ('+<CodigoTarea>+')'+#13#10;
    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'MARCOS','R'+IntToStr(<Rectangulo>)+'.-Forma');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'MARCOSGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'MARCOSACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'POSTES','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'POSTESGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'POSTESACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'TRAVESAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'TRAVESASGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'TRAVESASACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'GOMAVIDRIO','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'GOMACHAPA','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'GOMAPANEL','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'MATRIMONIO','Todos.+Tipo,Dimension');
  end;

  If (<CodigoTarea>= 'MATRIMONIO') or (<CodigoTarea>= 'MATRIMONIOP')  then
  begin
    lTOTAL:=lTOTAL+'TAREA......Acople de marcos y hojas ('+<CodigoTarea>+')'+#13#10;
    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'MARCOS','R'+IntToStr(<Rectangulo>)+'.-Forma');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'MARCOSGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'MARCOSACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'POSTES','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'POSTESGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'POSTESACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'TRAVESAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'TRAVESASGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'TRAVESASACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'GOMAVIDRIO','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'GOMACHAPA','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'GOMAPANEL','R'+IntToStr(<Rectangulo>)+'.-Nada');

    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'MATRIMONIO','Todos.+Tipo,Dimension');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'TRAVESAS','Todos.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'POSTES','Todos.-Nada');
  end;

  If (<CodigoTarea>= 'ENSAMBLAJE') or (<CodigoTarea>= 'ENSAMBLAJEP')  or (<CodigoTarea>= 'PREENSAMBLAJE') then
  begin
    lTOTAL:=lTOTAL+'TAREA.....Ensamblaje de rectangulos('+<CodigoTarea>+')'+#13#10;
    lTOTAL:=lTOTAL+#13#10;

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'MARCOS','R'+IntToStr(<Rectangulo>)+'.-Forma');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'MARCOSGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'MARCOSACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'POSTES','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'POSTESGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'POSTESACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'TRAVESAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'TRAVESASGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'TRAVESASACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HOJAS','R'+IntToStr(<Rectangulo>)+'.-Forma,Inversor,Perfil,Perfil1,Perfil2,Perfil3,Perfil Engatillado,Tipo Engatillado');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HOJASGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HOJASACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HERRAJEHOJA','R'+IntToStr(<Rectangulo>)+'.Kit');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HERRAJEHOJA_ARTICULOS','R'+IntToStr(<Rectangulo>)+'.-Nada');


    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HERRAJEHOJA','R'+IntToStr(<Rectangulo>)+'.+Perf.Manilla,Manilla,Eje');

    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'HOJAS','R'+IntToStr(<Rectangulo>)+'.+Inversor');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'INVERSORESGOMAS','R'+IntToStr(<Rectangulo>)+'.-Nada');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'INVERSORESACCE','R'+IntToStr(<Rectangulo>)+'.-Nada');


  end;

  If (<CodigoTarea>= 'ACRISTALADO') or (<CodigoTarea>= 'ACRISTALADOP')  then
  begin
    lTOTAL:=lTOTAL+'TAREA......Acristalado                   ('+<CodigoTarea>+')'+#13#10;
    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'VIDRIOS','Todos.+Numero Sup,Vidrio,Dimension');
    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'JUNQUILLOS','Todos.+Tipo,NunSup.Vidrio,Superior,Derecho');
    LTOTAL:=STI_TEInin(LTOTAL,<LineaLoteT."DatosFabricacion">,'CARROSJUNQUILLO','Todos-nada');


  end;





  MemoTotal.text :=LTOTAL;

{
  sqlSicar2.SQL.Text := 'select c.* from fpresupuestoslineascomponentes c ' +
    'where c.CodigoSerie="'+<LotesLineasDS_FRT2."OrigenSerie">+'"'+
      ' and c.CodigoNumero='+IntToStr(<LotesLineasDS_FRT2."OrigenNumero">)+
      ' and c.Linea='+IntToStr(<LotesLineasDS_FRT2."OrigenLinea">)+
      ' and c.Id='+IntToStr(<Id>)+' limit 1';

  if(sqlSicar2.active = false)  then
  begin
    sqlSicar2.Open;
  end;

  //ShowMessage(sqlSicar2.recordCount);

 if(sqlSicar2.recordCount > 0) and (<sqlSicar2."Mecanizados"> <> '') then
  begin
    ltar := 'ManVenInt';
    LTOTAL := STI_TEInim(LTOTAL, <sqlSicar2."Mecanizados">,ltar,'Manilla    ');

    ltar := 'CerraCorRailInt';
    LTOTAL := STI_TEInim(LTOTAL, <sqlSicar2."Mecanizados">,ltar,'Cierre Int ');

    ltar := 'CerraCorRailExt';
    LTOTAL := STI_TEInim(LTOTAL, <sqlSicar2."Mecanizados">,ltar,'Cierre Ext ');

    ltar := 'CierreCorredera';
    LTOTAL := STI_TEInim(LTOTAL, <sqlSicar2."Mecanizados">,ltar,'Cierre Corredera ');

    ltar := 'RecogedorIntMarco';
    LTOTAL := STI_TEInim(LTOTAL, <sqlSicar2."Mecanizados">,ltar,'Recogedor  ');

    //LTOTAL := LTOTAL + CHR(10) + sqlSicar2.SQL.Text;
  end else
  begin
     MemoTotal.Text :=  MemoTotal.Text+chr(10)+'NE'+' '+sqlSicar2.SQL.Text;
     //MemoTotal.Text :=  MemoTotal.Text+chr(10)+'NE'+' '+<LotesLineasDS_FRT2.Params."FabricacionSerie">+' '+IntToStr(<LotesLineasDS_FRT2."OrigenNumero">)+' '+IntToStr(<LotesLineasDS_FRT2."OrigenLinea">)+' '+<ID>;
  end;
  sqlSicar2.Close;
}
  MemoTotal.Text := LTOTAL;


  //Tiempos previstos usando función interna de la base de datos:
{  QTiempoP.Close;
  QTiempoP.SQL.Text := 'CALL F_TIEMPOS_TAREAS('''+<LineaLoteT."CodigoLote">+''','''+IntToStr(<LineaLoteT."Linea">)+''','''+<CodigoTarea>+''')';
  QTiempoP.Open;

  lH := 0; lM := 0; lS := 0; lD := 0;
  lD := <QTiempoP."TiempoPrevisto">-<QTiempoP."TiempoAcumulado">;
  lH := ld div 3600; lD := lD mod 3600;
  lM := ld div 60; lD := lD mod 60;
  lS := ld div 60; lD := lD mod 60;

  MemoTiempo.Text := '';
  if(lH > 0) then
    MemoTiempo.Text := MemoTiempo.Text+FormatFloat('00',lH)+':';

  MemoTiempo.Text := MemoTiempo.Text+FormatFloat('00',lM)+':'+FormatFloat('00',lS);
}


end;

//----------------------------------------------------------------------------------------------------

function UnidadesProcesadasEstaTareaLinea(pCodigoLote : String; pLinea : Integer) : Integer;
//Devuelve el número de unidades procesadas de esta línea del lote y la tarea del report.
//Se usa para calcular el nº de unidades procesadas en la columna de la derecha,
//se usa la función para que localice el campo de la línea del lote CodigoTarea01, 02, etc
//Para obtener fácilmente el nº de unidades.
var
  lTarea, lCampo : String;
  I : Integer;
begin
  Result := 0;
  lTarea := <CodigoTarea>;
  For I := 1 to 20 do
    begin
      if I < 10 then lCampo := '0' + IntToStr(I) else lCampo := IntToStr(I);
      if EstadoLineasLoteT.FieldByName('CodigoTarea' + lCampo).AsString = lTarea then
        begin
          Result := EstadoLineasLoteT.FieldByName('UP' + lCampo).AsInteger;
          Exit;
        end;
    end;
end;

//----------------------------------------------------------------------------------------------------

procedure MasterData1OnBeforePrint(Sender: TfrxComponent);
begin
  MasterData1.Visible := true;
  if <LineaLoteT."FabricacionNumero"> <> <EstadoLineasLoteT."FabricacionNumero"> then
    MasterData1.Visible := false;

  //Obtengo el número de líneas terminadas de esta línea de lote y la tarea actual:
  UPLinea := UnidadesProcesadasEstaTareaLinea(<EstadoLineasLoteT."CodigoLote">,<EstadoLineasLoteT."Linea">);

  if UPLinea = <EstadoLineasLoteT."Cantidad"> then
  begin
    MemoModulo.Font.Color := clGreen;
    MemoUnds.Font.Color := clGreen;
  end
  else
  if UPLinea > <EstadoLineasLoteT."Cantidad"> then
  begin
    MemoModulo.Font.Color := clYellow;
    MemoUnds.Font.Color := clYellow;
  end
  else
  begin
    MemoModulo.Font.Color := clRed;
    MemoUnds.Font.Color := clRed;
  end;
end;

//----------------------------------------------------------------------------------------------------

procedure Page2OnBeforePrint(Sender: TfrxComponent);
begin
  lmaxl := 0;
end;


//----------------------------------------------------------------------------------------------------

begin
  //Preparo la consulta de siguientes rectángulos:

  if (<CodigoTarea> = 'MATRIMONIOP')
    then SigRectT.SQL.Text := 'call F_ELEMENTOS_VENTANA_ALMACEN(''' + <CodigoPuesto> + ''', 0, ''' + <CodBarrasRect> + ''', ''C'', '''');';
  if (<CodigoTarea> = 'MATRIMONIO')
    then SigRectT.SQL.Text := 'call F_ELEMENTOS_VENTANA_ALMACEN(''' + <CodigoPuesto> + ''', 0, ''' + <CodBarrasRect> + ''', ''C'', '''');';

end.