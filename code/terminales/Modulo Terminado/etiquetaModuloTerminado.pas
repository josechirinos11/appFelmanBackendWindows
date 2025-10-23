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

procedure Button1OnClick(Sender: TfrxComponent);
begin
  //LogoEmpresa.visible:=CheckVerlogo.checked;
end;

procedure BarCode1OnBeforePrint(Sender: TfrxComponent);
begin
  Barcode1.Text := FormatFloat('0000',<EtiT."CodigoNumero">)+FormatFloat('0',0)+FormatFloat('00000',<EtiT."Linea">);
end;

procedure MasterData9OnBeforePrint(Sender: TfrxComponent);
var ltexto:String;
begin
  ltexto := '';
  if(<EtiT."Situacion"> = '') then
  begin
    if(<EtiT."Portal"> <> '') then
    begin
      ltexto := ltexto + 'Portal '+<EtiT."Portal">+' ';
    end;
    if(<EtiT."Planta"> <> '') then
    begin
      ltexto := ltexto + 'Planta '+<EtiT."Planta">+' ';
    end;
    if(<EtiT."Apartamento"> <> '') then
    begin
      ltexto := ltexto + ' '+<EtiT."Apartamento">+' ';
    end;
    if(<EtiT."Hueco"> <> '') then
    begin
      ltexto := ltexto + '('+<EtiT."Hueco">+') ';
    end;
    SituacionM.Text := ltexto;
  end else
  begin
    SituacionM.Text := <EtiT."Situacion">;
  end;
end;

Begin


end.