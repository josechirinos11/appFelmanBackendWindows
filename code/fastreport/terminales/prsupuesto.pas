function ExtraeEntreCorchetes(pTexto:String):String;
var
    Pos1,Pos2:Integer;
begin
  Result := '';
  pTexto := Trim(pTexto);
 { pTexto := ReplaceStr(pTexto,chr(10),' ');
  pTexto := ReplaceStr(pTexto,chr(13),' ');
  pTexto := ReplaceStr(pTexto,chr(9),' ');     }
  Pos1 := Pos('[',pTexto);
  Pos2 := Pos(']',pTexto);
  try
  if((Pos1 > 0) and (Pos2 > (Pos1+1))) then
  begin
    Result := Copy(pTexto,Pos1+1,Pos2-Pos1-1);
   { Result := Copy(pTexto,1,Pos2-1);
    Pos1 := Pos('[',pTexto);
    Result := Copy(pTexto,Pos1+1,Length(pTexto));  }

  end;
  except
    Result :=pTexto;
    //showmessage(pTexto+' '+IntToStr(Pos1+1)+' '+IntToStr(Pos2-Pos1-1)+' '+Result);
  end;
end;

procedure DescOnBeforePrint(Sender: TfrxComponent);
begin
  If <LineasT."NoUsarDescAuto"> = 'True'
     then Desc.Memo.Text := <LineasT."Descripcion">
     else Desc.Memo.Text := <LineasT."DescripcionAutomatica">+' '+<LineasT."Descripcion">;
//  If <LineasT."NoUsarDescAuto"> = 'True'
//     then Desc.Memo.Text := <BaseT."AreaNombre">+' '+<LineasT."Descripcion">
//     else Desc.Memo.Text := <BaseT."AreaNombre">+' '+<LineasT."DescripcionAutomatica">+<LineasT."Descripcion">;

end;



procedure Image1OnClick(Sender: TfrxComponent);
begin
    ShowMessage ('OPCIONES DE IMPRESION POR MODULO'
    +#13#10+''
    +#13#10+'Ver precio, oculta o muestra los precios de cada línea.'
    +#13#10+''
    +#13#10+'Ver acabados, oculta o muestra los acabados de cada línea. Cuando el presupuesto se hace en un color'
    +#13#10+'especial el cual no tenemos creado (ni interesa crear)pero cuyo precio es similar a otro existente. '
    +#13#10+'Desmarcaremos "Ver acabados" e indicamos en la descripción del presupuesto el color real.'
    +#13#10+''
    +#13#10+'Ver series en el módulo. El concepto es parecido a la opción ver acabados, si precisamos crear '
    +#13#10+'un presupuesto en una serie no disponible cuyo presupuesto real nos suministra otra empresa.'
    +#13#10+'Hacemos el presupuesto en una serie similiar, según sea corredera o practicable, y cuadraremos'
    +#13#10+'los precios. Al imprimir desmarcamos "Ver series" en el módulo e incluiremos la descripción de esta,'
    +#13#10+'la serie que nos ha solicitado y de la cual no disponemos, en la descripción del presupuesto.'
    +#13#10+''
    +#13#10+'Ver situación. Muestra la ubiación del módulo si se ha indicado el dato dentro de la pestaña'
    +#13#10+'Situación/Origen de la línea.'
    +#13#10+''
    +#13#10+'Ver observaciones. Muestra las observaciones del módulo si se ha indicado el dato dentro de la pestaña'
    +#13#10+'de observaciones de la línea'
    +#13#10+''

    +#13#10+'OPCIONES IVA'
    +#13#10+''
    +#13#10+'No imprimir Iva. Esta opción anula la visualización del importe y porcentaje de iva aplicado, asi como'
    +#13#10+'el precio del total iva incluido. En su lugar incluye el aviso de que los precios se incrementarán con'
    +#13#10+'el porcentaje de iva correspondiente.'
    +#13#10+''
    +#13#10+'Imprimir total Iva incluido. Esta opción anula automáticamente el precio en cada línea, ya que solo se'
    +#13#10+'imprimirá al final del presupuesto el precio total del mismo, sin hacer alusión alguna al Iva, ni al %'
    +#13#10+'aplicado ni al importe del mismo.'
    +#13#10+''
    +#13#10+'OPCIONES DE TEXTOS ADICIONALES'
    +#13#10+''
    +#13#10+'Imprimir texto inicial. En el apartado de textos del presupuesto dispone de tres opciones Texto Principal,'
    +#13#10+'Auxiliar 1, y Auxiliar 2. Si marca esta opción de impresión, "Imprimir texto inicial" , el texto incluido'
    +#13#10+'en el presupuesto en Texto Principal se imprimirá en la primera hoja. Se suele utilizar como una carta de'
    +#13#10+'presentación que se le entrega al cliente junto con el presupuesto.'
    +#13#10+''
    +#13#10+'Imprimir condiciones de la venta. Esta también relacionado con la pestaña de Textos de presupuestos.'
    +#13#10+'Si marcamos esta opción, se imprimirá una hoja final con el texto insertado en Auxiliar 2 de la pestaña'
    +#13#10+'texto del presupuesto. Se ha dejado este apartado para textos especificos de condiciones de la venta.'
    +#13#10+''
    +#13#10+'NOTA. Lo que se incluya en Auxiliar 1 de la pestaña textos de presupuestos se imprime automáticamente al '
    +#13#10+'pie del mismo junto con los importes totales. Lo habitual es meter en Auxiliar 1 textos mas cortos donde se'
    +#13#10+'hace alusion al tiempo de validéz del presupuesto, o que se precisa la firma de las condiciones generales'
    +#13#10+'de la venta cuando sea aceptado el mismo, etc.'
    );


end;




procedure BotonAceptarOnClick(Sender: TfrxComponent);
begin
  TextoInicial.visible:=ImpHojaInic.checked;
  CondicionesGenerales.visible:=ImpCondicionesG.checked;

  //Segun check ver series muestro o escondo lod datos
  If VerSeries.checked then
    Begin
     TituloSeries.visible := True;
     DatoSerie1.visible := True;
     DatoSerie2.visible := True;
    end else
    Begin
     TituloSeries.visible := false;
     DatoSerie1.visible := false;
     DatoSerie2.visible := false;
    end;

   //Segun check de ver acabados muestro o escondo los acabados
   If VerAcabados.checked then
    Begin
     TituloAcabados.visible := True;
     TituloAcabadosI.visible := True;
     TituloAcabadosE.visible := True;
     TituloAcabadosPerf.visible := True;
     TituloAcabadosAcce.visible := True;
     DatoAcabPerfI.visible := True;
     DatoAcabPerfE.visible := True;
     DatoAcabAcceI.visible := True;
     DatoAcabAcceE.visible := True;
    end else
    Begin
     TituloAcabados.visible := false;
     TituloAcabadosI.visible := false;
     TituloAcabadosE.visible := false;
     TituloAcabadosPerf.visible := false;
     TituloAcabadosAcce.visible := false;
     DatoAcabPerfI.visible := false;
     DatoAcabPerfE.visible := false;
     DatoAcabAcceI.visible := false;
     DatoAcabAcceE.visible := false;
    end;

   //Si ver precios total iva incluido es verdadero muestro solo resultado total

   If TotalIVA.checked then
   Begin
     //Datos de cada linea
     LinPrecioT.visible := false;
     LinPrecioD.visible := false;
     LinDtoT.visible := false;
     LinDtoD.visible := false;
     LinImporteT.visible := false;
     LinImporteD.visible := false;
     LinUnds.visible := false;
     LinTotalT.visible := false;
     LinTotalD.visible := false;

     //Oculto en los datos finales
     TituloSuma.visible := false;
     DatoSuma.visible := false;
     TituloIva.visible := false;
     DatoIva.visible := false;
     DatoIvaImporte.visible := false;
     TituloIvaAparte.visible:= false;
     //Muestro en los datos finales
     TituloTotal.visible := true;
     DatoTotal.visible := true;

   end else
   //Si no está marcado Total iva incluido
   Begin
    //Si esta marcado ver precios unidad...
    If ImpPreciosUnd.checked then
     Begin
     If (<LineasT."Descuento"> <> 0) then LinPrecioT.visible := true else  LinPrecioT.visible :=false;;
     If (<LineasT."Descuento"> <> 0) then LinPrecioD.visible := true else  LinPrecioD.visible :=false;;
     If (<LineasT."Descuento"> <> 0) then LinDtoT.visible := true else  LinDtoT.visible :=false;
     If (<LineasT."Descuento"> <> 0) then LinDtoD.visible := true else  LinDtoD.visible :=false;;
     LinImporteT.visible := true;
     LinImporteD.visible := true;
     LinUnds.visible := true;
     LinTotalT.visible := true;
     LinTotalD.visible := true;
     end else
     Begin
     LinPrecioT.visible := false;
     LinPrecioD.visible := false;
     LinDtoT.visible := false;
     LinDtoD.visible := false;
     LinImporteT.visible := false;
     LinImporteD.visible := false;
     LinUnds.visible := false;
     LinTotalT.visible := false;
     LinTotalD.visible := false;
     end;
     //Si esta marcado no ver iva
     If NoImpIVA.checked then
      Begin
       TituloIva.visible := false;
       DatoIva.visible := false;
       DatoIvaImporte.visible := false;
       TituloTotal.visible := false;
       DatoTotal.visible := false;
       TituloIvaAparte.visible:=true;
      end else
      Begin
       TituloIva.visible := true;
       DatoIva.visible := true;
       DatoIvaImporte.visible := true;
       TituloTotal.visible := true;
       DatoTotal.visible := true;
       TituloIvaAparte.visible:= false;
      end;


   end;
     //Mostrar los graficos 3d o 2d
   If Grafico3d.checked then
    Begin
     //LineasGraficosT.SQL.Text :=  LineasGraficosT.SQL.Text +' order by Automatico ';
     LineasGraficosT.SQL.Text := 'select * from opresupuestoslineasgraficos where CodigoSerie=:CodigoSerie and CodigoNumero=:CodigoNumero and Linea=:Linea and Automatico = false union '+
                                 'select * from opresupuestoslineasgraficos where CodigoSerie=:CodigoSerie and CodigoNumero=:CodigoNumero and Linea=:Linea and Automatico = true ';
    end else
   If Grafico2d.checked then
    Begin
     //LineasGraficosT.SQL.Text :=  LineasGraficosT.SQL.Text +' order by Automatico DESC ';
     LineasGraficosT.SQL.Text := 'select * from opresupuestoslineasgraficos where CodigoSerie=:CodigoSerie and CodigoNumero=:CodigoNumero and Linea=:Linea and Automatico = true union '+
                                 'select * from opresupuestoslineasgraficos where CodigoSerie=:CodigoSerie and CodigoNumero=:CodigoNumero and Linea=:Linea and Automatico = false ';
    end else
    Begin
    end;


end;


procedure UbicacionTOnBeforePrint(Sender: TfrxComponent);
begin
  If VerUbicacion.checked then
    Begin
     If (<LineasT."Situacion"> <>'') then
     Begin
      UbicacionT.visible:=True;
      UbicacionD.Visible:=True;
      UbicacionT2.visible:=True;
      UbicacionD2.Visible:=True;
     end else
     Begin
      UbicacionT.visible:=False;
      UbicacionD.Visible:=False;
      UbicacionT2.visible:=False;
      UbicacionD2.Visible:=False;
     end;
    end else
    Begin
     UbicacionT.visible:=False;
     UbicacionD.Visible:=False;
     UbicacionT2.visible:=False;
     UbicacionD2.Visible:=False;
    end;

end;

procedure ObservacionesTOnBeforePrint(Sender: TfrxComponent);
begin
  If VerObservaciones.checked then
   Begin
    If (<LineasT."Observaciones"> <>'') then
    Begin
     ObservacionesT.visible:=True;
     ObservacionesD.Visible:=True;
     ObservacionesT2.visible:=True;
     ObservacionesD2.Visible:=True;
    end else
    Begin
    ObservacionesT.visible:=False;
    ObservacionesD.Visible:=False;
    ObservacionesT2.visible:=False;
    ObservacionesD2.Visible:=False;
    end;
   end else
   Begin
    ObservacionesT.visible:=False;
    ObservacionesD.Visible:=False;
    ObservacionesT2.visible:=False;
    ObservacionesD2.Visible:=False;
   end;
end;



procedure GroupHeader1OnBeforePrint(Sender: TfrxComponent);
begin

end;

procedure MasterData1OnBeforePrint(Sender: TfrxComponent);
begin
  if <LineasT."LineaManual"> then
    begin
      MasterData1.Visible:= False;
      Child1.Visible:= False;
    end
  else
    begin
      Child1.Visible := not MasterData1.Visible;
    end;
end;

begin

end.