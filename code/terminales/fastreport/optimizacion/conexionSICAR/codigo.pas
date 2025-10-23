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

//*******************************************

procedure MemoTotalOnBeforePrint(Sender: TfrxComponent);
var i:Integer;
   ltar:string;
begin

  lTOTAL:=#13#10;
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

  If (<CodigoTarea>= 'COMPACTO')  then
  begin
    lTOTAL:=lTOTAL+'TAREA......Compacto persiana (COMPACTO)'+#13#10;
    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'COMPACTOS','Todos.-');
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'GUIAS','Todos.-');
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'CONDENSACIONES','Todos.-');
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'ALARGADERAS','Todos.-');
  end;


  If (<CodigoTarea>= 'FRESADO')  then
  begin
    lTOTAL:=lTOTAL+'TAREA......Mecanizados principales (FRESADO)'+#13#10;
    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'HOJAS','R'+IntToStr(<Rectangulo>)+'.+Tipo');
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'FRESADORA','R'+IntToStr(<Rectangulo>)+'.');
  end;


  If (<CodigoTarea>= 'HERRAJEHOJA')  then
  begin
    lTOTAL:=lTOTAL+'TAREA......Herraje hoja (HERRAJEHOJA)'+#13#10;
    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'HERRAJEHOJA','R'+IntToStr(<Rectangulo>)+'.-Forma,Perfil,Zocalo');
  end;

  If (<CodigoTarea>= 'HOJAS')  then
  begin
    lTOTAL:=lTOTAL+'TAREA......Armado de hojas (HOJAS)'+#13#10;
    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'HOJAS','R'+IntToStr(<Rectangulo>)+'.-Forma');
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'HOJASGOMAS','R'+IntToStr(<Rectangulo>)+'.+Goma');
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'HOJASACCE','R'+IntToStr(<Rectangulo>)+'.+Accesorio');
  end;

  If (<CodigoTarea>= 'MARCOS')  then
  begin
    lTOTAL:=lTOTAL+'TAREA......Armado de marcos (MARCOS)'+#13#10;
    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'MARCOS','R'+IntToStr(<Rectangulo>)+'.-Forma');
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'MARCOSGOMAS','R'+IntToStr(<Rectangulo>)+'.');
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'MARCOSACCE','R'+IntToStr(<Rectangulo>)+'.');
  end;

  If (<CodigoTarea>= 'MATRIMONIO')  then
  begin
    lTOTAL:=lTOTAL+'TAREA......Acople de marcos y hojas (MATRIMONIO)'+#13#10;
    lTOTAL:=lTOTAL+#13#10;
    LTOTAL:=STI_TEInin(LTOTAL,<LotesLineasDS_FRT."DatosFabricacion">,'MATRIMONIO','Todos.+Tipo,+Dimension');
  end;

  MemoTotal.text :=LTOTAL;

  sqlSicar2.SQL.Text := 'select c.* from fpresupuestoslineascomponentes c ' +
    'where c.CodigoSerie="'+<LotesLineasDS_FRT2."OrigenSerie">+'"'+
      ' and c.CodigoNumero='+IntToStr(<LotesLineasDS_FRT2."OrigenNumero">)+
      ' and c.Linea='+IntToStr(<LotesLineasDS_FRT2."OrigenLinea">)+
      ' and c.Id='+IntToStr(<Id>)+' limit 1';
{
  sqlSicar2.SQL.Text := 'select c.* from fpresupuestoslineascomponentes c ' +
    'where c.CodigoSerie='''+<LotesLineasDS_FRT2."OrigenSerie">+''''+
      ' and c.CodigoNumero='+IntToStr(<LotesLineasDS_FRT2."OrigenNumero">)+
      ' and c.Linea='+IntToStr(110)+
      ' and c.Id='+IntToStr(9)+' limit 1';
}
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
  MemoTotal.Text := LTOTAL;



end;



procedure Memo11OnBeforePrint(Sender: TfrxComponent);
begin
{  Memo11.Visible := false;
  if <CodigoPuesto> = 'Marcos2' then Memo11.Visible := true;

  LTOTAL := '';
  LRESTO:= '';
  LRESTO := STI_EININ(<LotesLineasDS_FRT."DatosFabricacion">,'SeccionRec_'+IntToStr(<Rectangulo>),'Todos');
  IF LENGTH(LRESTO) > 0 THEN
   LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'');

  LRESTO:= '';
  LRESTO:=STI_EINI(<LotesLineasDS_FRT."DatosFabricacion">,'JUNQUILLOS','Todos');
  IF LENGTH(LRESTO)>0 THEN
   LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'Junquillo..: ');

  LRESTO:= '';
  LRESTO:=STI_EINI(<LotesLineasDS_FRT."DatosFabricacion">,'REMATES','JV');
  IF LENGTH(LRESTO) > 0 THEN
  begin
   if LRESTO = '10' then
     LRESTO := 'Junta Vidrio Negra'
   else
     LRESTO := 'Junta Vidrio Blanca';
   LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'');
  end;

  LRESTO:= '';
  LRESTO:=STI_EINI(<LotesLineasDS_FRT."DatosFabricacion">,<CodigoTarea>+'.REMATES','ACOP');
  IF LENGTH(LRESTO) > 0 THEN
  begin
   LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'');
  end;

  LRESTO:= '';
  LRESTO:=STI_EINI(<LotesLineasDS_FRT."DatosFabricacion">,<CodigoTarea>+'.REMATES','RI');
  IF LENGTH(LRESTO) > 0 THEN
  begin
   IF LRESTO = '0' THEN
     LRESTO := 'Registro Frontal'
   else
     LRESTO := 'Registro Inferior';
   LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'');
  end;

  LRESTO:= '';
  LRESTO:=STI_EINI(<LotesLineasDS_FRT."DatosFabricacion">,'REMATES','GUIAINT');
  IF LENGTH(LRESTO) > 0 THEN
  begin
   IF LRESTO = '0' THEN
     LRESTO := 'Persiana Exterior'
   else
     LRESTO := 'Persiana Interior';
   LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'');
  end;

  LRESTO := STI_EINI(<LotesLineasDS_FRT."DatosFabricacion">,<CodigoTarea>+'.REMATES','GC');
  IF LENGTH(LRESTO)>0 THEN
   LTOTAL:=STI_ADDLINEA(LTOTAL,'Doble guia ','');

  LRESTO:= '';
  LRESTO:=STI_EINI(<LotesLineasDS_FRT."DatosFabricacion">,<CodigoTarea>+'.REMATES','AI');
  IF (LENGTH(LRESTO)>0) and (LRESTO <> '0') THEN
  begin
   LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'Aumento Cajon Izq.');
  end;

  LRESTO:= '';
  LRESTO:=STI_EINI(<LotesLineasDS_FRT."DatosFabricacion">,<CodigoTarea>+'.REMATES','AD');
  IF (LENGTH(LRESTO)>0) and (LRESTO <> '0') THEN
  begin
   LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'Aumento Cajon Der.');
  end;

  LRESTO:= '';
  LRESTO:=STI_EINI(<LotesLineasDS_FRT."DatosFabricacion">,<CodigoTarea>+'.REMATES','LI');
  IF (LENGTH(LRESTO)>0) and (LRESTO <> '0') THEN
  begin
   LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'Aumento Alargadera Izq.');
  end;

  LRESTO:= '';
  LRESTO:=STI_EINI(<LotesLineasDS_FRT."DatosFabricacion">,<CodigoTarea>+'.REMATES','LD');
  IF (LENGTH(LRESTO)>0) and (LRESTO <> '0') THEN
  begin
   LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'Aumento Alargadera Der.');
  end;

  LRESTO:= '';
  LRESTO:=STI_EINI(<LotesLineasDS_FRT."DatosFabricacion">,'CONTRAS','Todos');
  IF LENGTH(LRESTO)>0 THEN
   LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'Contravent.: ');

  LRESTO:= '';
  LRESTO:=STI_EINI(<LotesLineasDS_FRT."DatosFabricacion">,<CodigoTarea>+'.REMATES','TM');
  IF (LENGTH(LRESTO)>0) and (LRESTO <> '0') THEN
   LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'Mosquitera.: ');

  LRESTO := STI_EININ(<LotesLineasDS_FRT."DatosFabricacion">,'ACCESORIOS','Todos');
  IF LENGTH(LRESTO) > 0 THEN
   LTOTAL:=STI_ADDLINEA(LTOTAL,LRESTO,'');     }
end;

procedure MasterData1OnBeforePrint(Sender: TfrxComponent);
begin
  MasterData1.Visible := true;
  if <LotesLineasDS_FRT."FabricacionNumero"> <> <LotesLineasDS_FRT2."FabricacionNumero"> then
    MasterData1.Visible := false;
  lmaxl := lmaxl +1;
  //if(lmaxl > 20) then
  //  MasterData1.Visible := false;
{  LTEXTO := '';
  LTAREA := '';
  LTAREA := Str([Tarea]);
  LC:= [LotesLineasT2."UP"];

  if LTAREA = [LotesLineasT2."CodigoTarea01"] then
  begin
    LC := [LotesLineasT2."UP01"];
  end else if LTAREA = [LotesLineasT2."CodigoTarea02"] then
  begin
    LC := [LotesLineasT2."UP02"];
  end else if LTAREA = [LotesLineasT2."CodigoTarea03"] then
  begin
    LC := [LotesLineasT2."UP03"];
  end else if LTAREA = [LotesLineasT2."CodigoTarea04"] then
  begin
    LC := [LotesLineasT2."UP04"];
  end else if LTAREA = [LotesLineasT2."CodigoTarea05"] then
  begin
    LC := [LotesLineasT2."UP05"];
  end else if LTAREA = [LotesLineasT2."CodigoTarea06"] then
  begin
    LC := [LotesLineasT2."UP06"];
  end else if LTAREA = [LotesLineasT2."CodigoTarea07"] then
  begin
    LC := [LotesLineasT2."UP07"];
  end else if LTAREA = [LotesLineasT2."CodigoTarea08"] then
  begin
    LC := [LotesLineasT2."UP08"];
  end else if LTAREA = [LotesLineasT2."CodigoTarea09"] then
  begin
    LC := [LotesLineasT2."UP09"];
  end;

  LTEXTO := Str(LC);
  LTEXTO := LTEXTO +' / '+Str([LotesLineasT2."Cantidad"]);
  Memo15.Font.Color := clGreen;
  if LC >= [LotesLineasT2."Cantidad"] then
    Memo15.Font.Color := clRed;
  //Memo14.Font.Color := Font.Color;
}
  if <LotesLineasDS_FRT2."UP"> = <LotesLineasDS_FRT2."Cantidad"> then
  begin
    MemoModulo.Font.Color := clGreen;
    MemoUnds.Font.Color := clGreen;
  end
  else
  if <LotesLineasDS_FRT2."UP"> > <LotesLineasDS_FRT2."Cantidad"> then
  begin
    MemoModulo.Font.Color := clYellow;
    MemoUnds.Font.Color := clYellow;
  end
  else
  begin
    MemoModulo.Font.Color := clRed;
    MemoUnds.Font.Color := clRed;
  end;

  LTEXTO := '';
end;

procedure DameUnidadesTarea(pCod : String; var pUP, pUT : Integer);
//Devuelve las unidades procesadas y totales de la tarea indicada.
//La busca en las columnas de la tabla.
var I, lNum : Integer;
begin
  pUP := 0;
  pUT := 0;

  if <FabricacionesDS_FRT."TC1"> = pCod then
    begin
      pUP :=  <FabricacionesDS_FRT."TUP1">;
      pUT :=  <FabricacionesDS_FRT."TUT1">;
    end else
  if <FabricacionesDS_FRT."TC2"> = pCod then
    begin
      pUP :=  <FabricacionesDS_FRT."TUP2">;
      pUT :=  <FabricacionesDS_FRT."TUT2">;
    end else
  if <FabricacionesDS_FRT."TC3"> = pCod then
    begin
      pUP :=  <FabricacionesDS_FRT."TUP3">;
      pUT :=  <FabricacionesDS_FRT."TUT3">;
    end else
  if <FabricacionesDS_FRT."TC4"> = pCod then
    begin
      pUP :=  <FabricacionesDS_FRT."TUP4">;
      pUT :=  <FabricacionesDS_FRT."TUT4">;
    end else
  if <FabricacionesDS_FRT."TC5"> = pCod then
    begin
      pUP :=  <FabricacionesDS_FRT."TUP5">;
      pUT :=  <FabricacionesDS_FRT."TUT5">;
    end else
  if <FabricacionesDS_FRT."TC6"> = pCod then
    begin
      pUP :=  <FabricacionesDS_FRT."TUP6">;
      pUT :=  <FabricacionesDS_FRT."TUT6">;
    end else
  if <FabricacionesDS_FRT."TC7"> = pCod then
    begin
      pUP :=  <FabricacionesDS_FRT."TUP7">;
      pUT :=  <FabricacionesDS_FRT."TUT7">;
    end else
  if <FabricacionesDS_FRT."TC8"> = pCod then
    begin
      pUP :=  <FabricacionesDS_FRT."TUP8">;
      pUT :=  <FabricacionesDS_FRT."TUT8">;
    end else
  if <FabricacionesDS_FRT."TC9"> = pCod then
    begin
      pUP :=  <FabricacionesDS_FRT."TUP9">;
      pUT :=  <FabricacionesDS_FRT."TUT9">;
    end else
  if <FabricacionesDS_FRT."TC10"> = pCod then
    begin
      pUP :=  <FabricacionesDS_FRT."TUP10">;
      pUT :=  <FabricacionesDS_FRT."TUT10">;
    end;
end;


procedure Memo19OnBeforePrint(Sender: TfrxComponent);
//PONER EN EL HINT DEL CUADRO EL CÓDIGO DE TAREA
var lMemo : TfrxMemoView;
begin
  lMemo := TfrxMemoView(Sender);

  LUP := 0;
  LUT := 0;
  LCT := lMemo.Hint;// 'TROQUEL', etc.;

  DameUnidadesTarea(LCT, LUP, LUT);

  lMemo.Color := clRed;
  if LUP < LUT then
  begin
    if LUP > 0 then lMemo.Color := clYellow;
  end else
  begin
    lMemo.Color := clLime;
  end;
  lMemo.Visible := true;
  if LUT < 1 then lMemo.Visible := false;
end;




procedure Page2OnBeforePrint(Sender: TfrxComponent);
begin
  lmaxl := 0;
end;


begin
  //Preparo la consulta de siguientes rectángulos:
//  if <CodigoTarea> = 'MATRIMONIO'
//    then SigRectT.SQL.Text := 'call F_ELEMENTOS_VENTANA_ALMACEN(0, ''' + <CodBarrasRect> + ''', ''C'', '''');';
end.