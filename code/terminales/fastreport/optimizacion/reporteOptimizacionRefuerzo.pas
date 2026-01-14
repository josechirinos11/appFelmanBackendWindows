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

Var
lNum :Integer;

procedure Memo8OnBeforePrint(Sender: TfrxComponent);
begin


end;

procedure MasterData1OnBeforePrint(Sender: TfrxComponent);
begin

end;



procedure Memo17OnBeforePrint(Sender: TfrxComponent);
begin

end;

procedure Memo16OnBeforePrint(Sender: TfrxComponent);
begin


end;



procedure Memo18OnBeforePrint(Sender: TfrxComponent);
begin

end;

procedure DetailData1OnBeforePrint(Sender: TfrxComponent);
var visibilidad : boolean;
    lsit : array [0..7] of string;
begin
  visibilidad := true;
  if <OptimizacionT."Med0"> = 0 then
  begin
    visibilidad := false;
  end;
  Mod0.Visible  := visibilidad;
  Med0.Visible  := visibilidad;
  Cor01.Visible := visibilidad;
  Cor02.Visible := visibilidad;
  C0.Visible := visibilidad;
  Memo20.Visible := visibilidad;
  Memo21.Visible := visibilidad;
  Memo53.Visible := visibilidad;


  visibilidad := true;
  if <OptimizacionT."Med1"> = 0 then
  begin
    visibilidad := false;
  end;
  Mod1.Visible  := visibilidad;
  Med1.Visible  := visibilidad;
  Cor11.Visible := visibilidad;
  Cor12.Visible := visibilidad;
  C1.Visible := visibilidad;
  Memo22.Visible := visibilidad;
  Memo23.Visible := visibilidad;
  Memo54.Visible := visibilidad;

  visibilidad := true;
  if <OptimizacionT."Med2"> = 0 then
  begin
    visibilidad := false;
  end;
  Mod2.Visible  := visibilidad;
  Med2.Visible  := visibilidad;
  Cor21.Visible := visibilidad;
  Cor22.Visible := visibilidad;
  C2.Visible := visibilidad;
  Memo24.Visible := visibilidad;
  Memo28.Visible := visibilidad;
  Memo52.Visible := visibilidad;

  visibilidad := true;
  if <OptimizacionT."Med3"> = 0 then
  begin
    visibilidad := false;
  end;
  Mod3.Visible  := visibilidad;
  Med3.Visible  := visibilidad;
  Cor31.Visible := visibilidad;
  Cor32.Visible := visibilidad;
  C3.Visible := visibilidad;
  Memo29.Visible := visibilidad;
  Memo30.Visible := visibilidad;
  Memo55.Visible := visibilidad;

  visibilidad := true;
  if <OptimizacionT."Med4"> = 0 then
  begin
    visibilidad := false;
  end;
  Mod4.Visible  := visibilidad;
  Med4.Visible  := visibilidad;
  Cor41.Visible := visibilidad;
  Cor42.Visible := visibilidad;
  C4.Visible := visibilidad;
  Memo31.Visible := visibilidad;
  Memo32.Visible := visibilidad;
  Memo57.Visible := visibilidad;

  visibilidad := true;
  if <OptimizacionT."Med5"> = 0 then
  begin
    visibilidad := false;
  end;
  Mod5.Visible  := visibilidad;
  Med5.Visible  := visibilidad;
  Cor51.Visible := visibilidad;
  Cor52.Visible := visibilidad;
  C5.Visible := visibilidad;
  Memo33.Visible := visibilidad;
  Memo34.Visible := visibilidad;
  Memo58.Visible := visibilidad;

  visibilidad := true;
  if <OptimizacionT."Med6"> = 0 then
  begin
    visibilidad := false;
  end;
  Mod6.Visible  := visibilidad;
  Med6.Visible  := visibilidad;
  Cor61.Visible := visibilidad;
  Cor62.Visible := visibilidad;
  C6.Visible := visibilidad;
  Memo35.Visible := visibilidad;
  Memo36.Visible := visibilidad;
  Memo59.Visible := visibilidad;

  visibilidad := true;
  if <OptimizacionT."Med7"> = 0 then
  begin
    visibilidad := false;
  end;
  Mod7.Visible  := visibilidad;
  Med7.Visible  := visibilidad;
  Cor71.Visible := visibilidad;
  Cor72.Visible := visibilidad;
  C7.Visible := visibilidad;
  Memo37.Visible := visibilidad;
  Memo38.Visible := visibilidad;
  Memo60.Visible := visibilidad;

  visibilidad := true;
  if <OptimizacionT."Med8"> = 0 then
  begin
    visibilidad := false;
  end;
  Mod8.Visible  := visibilidad;
  Med8.Visible  := visibilidad;
  Cor81.Visible := visibilidad;
  Cor82.Visible := visibilidad;
  C8.Visible := visibilidad;
  Memo39.Visible := visibilidad;
  Memo40.Visible := visibilidad;
  Memo61.Visible := visibilidad;

  visibilidad := true;
  if <OptimizacionT."Med9"> = 0 then
  begin
    visibilidad := false;
  end;
  Mod9.Visible  := visibilidad;
  Med9.Visible  := visibilidad;
  Cor91.Visible := visibilidad;
  Cor92.Visible := visibilidad;
  C9.Visible := visibilidad;
  Memo42.Visible := visibilidad;
  Memo43.Visible := visibilidad;
  Memo62.Visible := visibilidad;

  lsit[0] := '';
  lsit[1] := 'S';
  lsit[2] := 'D';
  lsit[3] := 'I';
  lsit[4] := 'Z';
  lsit[5] := 'V';
  lsit[6] := 'H';
  lsit[7] := '?';

  Memo20.Text := lsit[<OptimizacionT."Sit0">]+' '+chr(64+(<OptimizacionT."Casillero0"> div 100))+'.'+IntToStr(<OptimizacionT."Casillero0"> mod 100);
  Memo22.Text := lsit[<OptimizacionT."Sit1">]+' '+chr(64+(<OptimizacionT."Casillero1"> div 100))+'.'+IntToStr(<OptimizacionT."Casillero1"> mod 100);
  Memo24.Text := lsit[<OptimizacionT."Sit2">]+' '+chr(64+(<OptimizacionT."Casillero2"> div 100))+'.'+IntToStr(<OptimizacionT."Casillero2"> mod 100);
  Memo29.Text := lsit[<OptimizacionT."Sit3">]+' '+chr(64+(<OptimizacionT."Casillero3"> div 100))+'.'+IntToStr(<OptimizacionT."Casillero3"> mod 100);
  Memo31.Text := lsit[<OptimizacionT."Sit4">]+' '+chr(64+(<OptimizacionT."Casillero4"> div 100))+'.'+IntToStr(<OptimizacionT."Casillero4"> mod 100);
  Memo33.Text := lsit[<OptimizacionT."Sit5">]+' '+chr(64+(<OptimizacionT."Casillero5"> div 100))+'.'+IntToStr(<OptimizacionT."Casillero5"> mod 100);
  Memo35.Text := lsit[<OptimizacionT."Sit6">]+' '+chr(64+(<OptimizacionT."Casillero6"> div 100))+'.'+IntToStr(<OptimizacionT."Casillero6"> mod 100);
  Memo37.Text := lsit[<OptimizacionT."Sit7">]+' '+chr(64+(<OptimizacionT."Casillero7"> div 100))+'.'+IntToStr(<OptimizacionT."Casillero7"> mod 100);
  Memo39.Text := lsit[<OptimizacionT."Sit8">]+' '+chr(64+(<OptimizacionT."Casillero8"> div 100))+'.'+IntToStr(<OptimizacionT."Casillero8"> mod 100);
  Memo42.Text := lsit[<OptimizacionT."Sit9">]+' '+chr(64+(<OptimizacionT."Casillero9"> div 100))+'.'+IntToStr(<OptimizacionT."Casillero9"> mod 100);
end;

procedure Memo20OnBeforePrint(Sender: TfrxComponent);
begin
//  Memo20.Text := 'Desconocida';

  If (<OptimizacionT."Sit0"> = 1) then Memo20.Text := 'Superior' else
  If (<OptimizacionT."Sit0"> = 2) then Memo20.Text := 'Derecha' else
  If (<OptimizacionT."Sit0"> = 3) then Memo20.Text := 'Inferior' else
  If (<OptimizacionT."Sit0"> = 4) then Memo20.Text := 'Izquierda' else
  If (<OptimizacionT."Sit0"> = 5) then Memo20.Text := 'Vertical' else
  If (<OptimizacionT."Sit0"> = 6) then Memo20.Text := 'Horizont' else Memo20.Text := '';
end;

procedure Page1OnBeforePrint(Sender: TfrxComponent);
begin

end;

procedure Memo22OnBeforePrint(Sender: TfrxComponent);
begin
  If (<OptimizacionT."Sit1"> = 1) then Memo22.Text := 'Superior' else
  If (<OptimizacionT."Sit1"> = 2) then Memo22.Text := 'Derecha' else
  If (<OptimizacionT."Sit1"> = 3) then Memo22.Text := 'Inferior' else
  If (<OptimizacionT."Sit1"> = 4) then Memo22.Text := 'Izquierda' else
  If (<OptimizacionT."Sit1"> = 5) then Memo22.Text := 'Vertical' else
  If (<OptimizacionT."Sit1"> = 6) then Memo22.Text := 'Horizont' else Memo22.Text := '';
end;

procedure Memo24OnBeforePrint(Sender: TfrxComponent);
begin
  If (<OptimizacionT."Sit2"> = 1) then Memo24.Text := 'Superior' else
  If (<OptimizacionT."Sit2"> = 2) then Memo24.Text := 'Derecha' else
  If (<OptimizacionT."Sit2"> = 3) then Memo24.Text := 'Inferior' else
  If (<OptimizacionT."Sit2"> = 4) then Memo24.Text := 'Izquierda' else
  If (<OptimizacionT."Sit2"> = 5) then Memo24.Text := 'Vertical' else
  If (<OptimizacionT."Sit2"> = 6) then Memo24.Text := 'Horizont' else Memo24.Text := '';
end;

procedure Memo29OnBeforePrint(Sender: TfrxComponent);
begin
  If (<OptimizacionT."Sit3"> = 1) then Memo29.Text := 'Superior' else
  If (<OptimizacionT."Sit3"> = 2) then Memo29.Text := 'Derecha' else
  If (<OptimizacionT."Sit3"> = 3) then Memo29.Text := 'Inferior' else
  If (<OptimizacionT."Sit3"> = 4) then Memo29.Text := 'Izquierda' else
  If (<OptimizacionT."Sit3"> = 5) then Memo29.Text := 'Vertical' else
  If (<OptimizacionT."Sit3"> = 6) then Memo29.Text := 'Horizont' else Memo29.Text := '';
end;

procedure Memo31OnBeforePrint(Sender: TfrxComponent);
begin
  If (<OptimizacionT."Sit4"> = 1) then Memo31.Text := 'Superior' else
  If (<OptimizacionT."Sit4"> = 2) then Memo31.Text := 'Derecha' else
  If (<OptimizacionT."Sit4"> = 3) then Memo31.Text := 'Inferior' else
  If (<OptimizacionT."Sit4"> = 4) then Memo31.Text := 'Izquierda' else
  If (<OptimizacionT."Sit4"> = 5) then Memo31.Text := 'Vertical' else
  If (<OptimizacionT."Sit4"> = 6) then Memo31.Text := 'Horizont' else Memo31.Text := '';
end;

procedure Memo33OnBeforePrint(Sender: TfrxComponent);
begin
  If (<OptimizacionT."Sit5"> = 1) then Memo33.Text := 'Superior' else
  If (<OptimizacionT."Sit5"> = 2) then Memo33.Text := 'Derecha' else
  If (<OptimizacionT."Sit5"> = 3) then Memo33.Text := 'Inferior' else
  If (<OptimizacionT."Sit5"> = 4) then Memo33.Text := 'Izquierda' else
  If (<OptimizacionT."Sit5"> = 5) then Memo33.Text := 'Vertical' else
  If (<OptimizacionT."Sit5"> = 6) then Memo33.Text := 'Horizont' else Memo33.Text := '';

end;

procedure Memo35OnBeforePrint(Sender: TfrxComponent);
begin
  If (<OptimizacionT."Sit6"> = 1) then Memo35.Text := 'Superior' else
  If (<OptimizacionT."Sit6"> = 2) then Memo35.Text := 'Derecha' else
  If (<OptimizacionT."Sit6"> = 3) then Memo35.Text := 'Inferior' else
  If (<OptimizacionT."Sit6"> = 4) then Memo35.Text := 'Izquierda' else
  If (<OptimizacionT."Sit6"> = 5) then Memo35.Text := 'Vertical' else
  If (<OptimizacionT."Sit6"> = 6) then Memo35.Text := 'Horizontal' else Memo35.Text := '';

end;

procedure Memo37OnBeforePrint(Sender: TfrxComponent);
begin
  If (<OptimizacionT."Sit7"> = 1) then Memo37.Text := 'Superior' else
  If (<OptimizacionT."Sit7"> = 2) then Memo37.Text := 'Derecha' else
  If (<OptimizacionT."Sit7"> = 3) then Memo37.Text := 'Inferior' else
  If (<OptimizacionT."Sit7"> = 4) then Memo37.Text := 'Izquierda' else
  If (<OptimizacionT."Sit7"> = 5) then Memo37.Text := 'Vertical' else
  If (<OptimizacionT."Sit7"> = 6) then Memo37.Text := 'Horizont' else Memo37.Text := '';

end;

procedure Memo39OnBeforePrint(Sender: TfrxComponent);
begin
  If (<OptimizacionT."Sit8"> = 1) then Memo39.Text := 'Superior' else
  If (<OptimizacionT."Sit8"> = 2) then Memo39.Text := 'Derecha' else
  If (<OptimizacionT."Sit8"> = 3) then Memo39.Text := 'Inferior' else
  If (<OptimizacionT."Sit8"> = 4) then Memo39.Text := 'Izquierda' else
  If (<OptimizacionT."Sit8"> = 5) then Memo39.Text := 'Vertical' else
  If (<OptimizacionT."Sit8"> = 6) then Memo39.Text := 'Horizont' else Memo39.Text := '';

end;

procedure Memo42OnBeforePrint(Sender: TfrxComponent);
begin
  If (<OptimizacionT."Sit9"> = 1) then Memo42.Text := 'Superior' else
  If (<OptimizacionT."Sit9"> = 2) then Memo42.Text := 'Derecha' else
  If (<OptimizacionT."Sit9"> = 3) then Memo42.Text := 'Inferior' else
  If (<OptimizacionT."Sit9"> = 4) then Memo42.Text := 'Izquierda' else
  If (<OptimizacionT."Sit9"> = 5) then Memo42.Text := 'Vertical' else
  If (<OptimizacionT."Sit9"> = 6) then Memo42.Text := 'Horizont' else Memo42.Text := '';

end;







procedure GroupHeader3OnBeforePrint(Sender: TfrxComponent);
begin
  lNum :=0;
end;

procedure MasterData3OnBeforePrint(Sender: TfrxComponent);
begin
   lNum:=lNum+1;
end;

procedure GroupFooter3OnBeforePrint(Sender: TfrxComponent);
begin
  If (lNum=1) then
    Begin
      TituloInfo.text:='LISTADO DE CORTE';
    end else
  If (lNum>1) then
    Begin
      TituloInfo.text:='LISTADO DE CORTE';
    end else
    Begin
      TituloInfo.text:='LISTADO DE CORTE';
    end;
end;

var
  Cod : String;
begin

  //Creo el codigo de barras para el puesto de corte:
  Cod := '';
  Cod := Cod + FormatFloat('0000',<PerfilesOptimizadosT."CodigoNumero">); //Fab num
  Cod := Cod + FormatFloat('0',0); //Bloque
  Cod := Cod + FormatFloat('00000',<OptimizacionT."Lin0">); //Línea fab

  BarCode.Text := Cod;
end.


begin
  Cod := '';
  Cod := Cod + FormatFloat('0000',<fBaseFRT."Numero">); //Fab num
  Cod := Cod + FormatFloat('0',0); //Bloque
  Cod := Cod + FormatFloat('000',<LineaQ."Linea">); //Línea fab

  BarCode.Text := Cod;

end.