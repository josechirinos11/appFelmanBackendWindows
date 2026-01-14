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



procedure ListaPerfilesOnBeforePrint(Sender: TfrxComponent);

begin
  if RbtnConResumen.checked then
    begin
      ListaPerfiles.visible:=true;
      If ((<PerT."Fabricacion"> AND 1) <> 1) then ListaPerfiles.visible:=false;
    end;
    ListaPerfiles.visible:=True;
    If NoImpPerf.checked then  ListaPerfiles.visible:=false;
end;

procedure ListaHerrajeOnBeforePrint(Sender: TfrxComponent);
begin
    ListaHerraje.visible :=  true;
    If ((<AccT."Fabricacion"> AND 1) <>1) then ListaHerraje.visible:=false;
end;



procedure MemoClaveOnBeforePrint(Sender: TfrxComponent);
begin
    iF (<PerT2."Situacion">=1) then
      Begin
       MemoClave.text:='Sup';
      end else
    iF (<PerT2."Situacion">=2) then
      Begin
       MemoClave.text:='Drcha';
      end else
    iF (<PerT2."Situacion">=3) then
      Begin
       MemoClave.text:='Inf';
      end else
    iF (<PerT2."Situacion">=4) then
      Begin
       MemoClave.text:='Izqda';
      end else
    iF (<PerT2."Situacion">=5) then
      Begin
       MemoClave.text:='Vert';
      end else
    iF (<PerT2."Situacion">=3) then
      Begin
       MemoClave.text:='Horz';
      end else
      Begin
       MemoClave.text:='';
      end;
end;

procedure MasterData6OnBeforePrint(Sender: TfrxComponent);
begin
  if RbtnSinResumen.checked then
    begin
     MasterData6.visible:=true;
     If ((<PerT2."Fabricacion"> AND 1) <> 1) then MasterData6.visible:=false;
    end;
//   MasterData6.visible:=True;
    If NoImpPerf.checked then  MasterData6.visible:=false;

end;

procedure BtnAceptarOnClick(Sender: TfrxComponent);
begin
  MasterData6.visible:= RbtnSinResumen.checked;
  ListaPerfiles.visible:= RbtnConResumen.checked

end;

var
  Cod:String;



begin
  Cod := '';
  Cod := Cod + FormatFloat('0000',<fBaseFRT."Numero">); //Fab num
  Cod := Cod + FormatFloat('0',0); //Bloque
  Cod := Cod + FormatFloat('000',<LineaQ."Linea">); //Línea fab

  BarCode.Text := Cod;
 //  BarCode1.Text := Cod;

end.