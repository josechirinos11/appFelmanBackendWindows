var
  LTOTAL, LMENSAJES: String;
  LTOTAL2: String;
  LRESTO: String;
  LTEXTO: String;
  LTXTCLIENTE: String;
  LUP: Integer;
  LUT: Integer;
  LCT: String;
  LMAXL: Integer;
  LHAYBLOQUES, lMostrarComandos: Boolean;
  ALMDEST: String; // Almacén de destino de la pieza
  UPLinea: Integer; // Para unidades procesadas de columna de la derecha
  lSL: TStringList;
  lIDFigura: String;
  NumImg: Integer = 0;
  RutaImg: String = '\\SERVER-M2\imagenes\'; // Debe terminar en "\"
  Imagenes: TStringList; // Para evitar duplicados imágenes

// Utilidades para leer datos del INI
function DameIni: TMemIniFile;
var
  lSL: TStringList;
begin
  Result := TMemIniFile.Create('');
  lSL := TStringList.Create;
  try
    lSL.Text := <LineaLoteT."DatosFabricacion">;
    Result.SetStrings(lSL);
  finally
    lSL.Free;
  end;
end;

function DameClavesRectangulo(pIni: TMemIniFile; pSeccion: String; pRec: Integer): TStringList;
var
  lSL: TStringList;
  I, lNum: Integer;
begin
  Result := TStringList.Create;
  lSL := TStringList.Create;
  try
    pIni.ReadSection(pSeccion, lSL);
    lNum := lSL.Count - 1;
    for I := 0 to lNum do
      if Pos('R' + IntToStr(pRec) + '.', lSL.Strings[I]) > 0 then
        Result.Add(lSL.Strings[I]);
  finally
    lSL.Free;
  end;
end;

function DameClavesSeccion(pIni: TMemIniFile; pSeccion: String): TStringList;
var
  lSL: TStringList;
  I, lNum: Integer;
begin
  Result := TStringList.Create;
  lSL := TStringList.Create;
  try
    pIni.ReadSection(pSeccion, lSL);
    lNum := lSL.Count - 1;
    for I := 0 to lNum do
      if Pos('R', lSL.Strings[I]) > 0 then
        Result.Add(lSL.Strings[I]);
  finally
    lSL.Free;
  end;
end;

function DameClavesMecArti(pIni: TMemIniFile; pSeccion: String; pID: Integer): TStringList;
var
  lSL: TStringList;
  I, lNum: Integer;
begin
  Result := TStringList.Create;
  lSL := TStringList.Create;
  try
    pIni.ReadSection(pSeccion, lSL);
    lNum := lSL.Count - 1;
    for I := 0 to lNum do
      if Copy(lSL.Strings[I], 1, Length(IntToStr(pID)) + 1) = IntToStr(pID) + '.' then
        Result.Add(lSL.Strings[I]);
  finally
    lSL.Free;
  end;
end;

function RectanguloEnSeccion(pIni: TMemIniFile; pRec: Integer; pSeccion: String): Boolean;
var
  lSL: TStringList;
begin
  lSL := DameClavesRectangulo(pIni, pSeccion, pRec);
  try
    Result := lSL.Count > 0;
  finally
    lSL.Free;
  end;
end;

function DameClavesLinkIDTipo(pIni: TMemIniFile; pSeccion: String; pLinkID: String; pTipo: Integer): TStringList;
var
  lSL: TStringList;
  I, lNum: Integer;
begin
  Result := TStringList.Create;
  lSL := TStringList.Create;
  try
    pIni.ReadSection(pSeccion, lSL);
    lNum := lSL.Count - 1;
    for I := 0 to lNum do
      if (pTipo = StrToInt(DameParametro(pIni.ReadString(pSeccion, lSL.Strings[I], ''), 2)))
        and (pLinkID = DameParametro(pIni.ReadString(pSeccion, lSL.Strings[I], ''), 8)) then
        Result.Add(lSL.Strings[I]);
  finally
    lSL.Free;
  end;
end;

function DameParametro(pCad: String; pNum: Integer): String;
var
  I: Integer;
  lValor: String;
begin
  I := 1;
  Result := '';
  while Pos(';', pCad) > 0 do
  begin
    lValor := Copy(pCad, 1, Pos(';', pCad) - 1);
    pCad := Copy(pCad, Pos(';', pCad) + 1, Length(pCad));
    if I = pNum then
    begin
      Result := lValor;
      Exit;
    end;
    Inc(I);
  end;
  if pCad <> '' then
    Result := pCad;
end;

function DameClavesRectanguloTipo(pSeccion: String; pRec: Integer; pTipo: Integer): TStringList;
var
  lSL: TStringList;
  I, lNum: Integer;
  lTipo: String;
  lIni: TMemIniFile;
begin
  Result := TStringList.Create;
  lIni := DameIni;
  try
    lSL := DameClavesRectangulo(lIni, pSeccion, pRec);
    try
      lNum := lSL.Count - 1;
      for I := 0 to lNum do
      begin
        lTipo := DameParametro(lIni.ReadString(pSeccion, lSL.Strings[I], ''), 2);
        if lTipo = IntToStr(pTipo) then
          Result.Add(lSL.Strings[I]);
      end;
    finally
      lSL.Free;
    end;
  finally
    lIni.Free;
  end;
end;

function CarroCasilla(pCadena: String): String;
var
  ltemp: String;
  lpos: Integer;
begin
  Result := '';
  lpos := Pos('.', pCadena);
  while (lpos > 0) do
  begin
    ltemp := Copy(pCadena, 1, lpos - 1);
    try
      ltemp := Chr(64 + StrToInt(ltemp));
    except
    end;
    Result := Copy(pCadena, 1, lpos - 2) + ltemp + Copy(pCadena, lpos, 3);
    pCadena := Copy(pCadena, lpos + 2, Length(pCadena));
    lpos := Pos('.', pCadena);
  end;
end;

procedure InsertaImagen(pImagen: String);
var
  lFile: String;
begin
  lFile := RutaImg + pImagen + '.png';
  if NumImg >= 8 then
    Exit;
  if not FileExists(lFile) then
  begin
    lFile := RutaImg + pImagen + '.jpg';
    if not FileExists(lFile) then
      Exit;
  end;
  if Imagenes.IndexOf(pImagen) > -1 then
    Exit;
  if NumImg = 0 then
    Pic1.LoadFromFile(lFile)
  else if NumImg = 1 then
    Pic2.LoadFromFile(lFile)
  else if NumImg = 2 then
    Pic3.LoadFromFile(lFile)
  else if NumImg = 3 then
    Pic4.LoadFromFile(lFile)
  else if NumImg = 4 then
    Pic5.LoadFromFile(lFile)
  else if NumImg = 5 then
    Pic6.LoadFromFile(lFile)
  else if NumImg = 6 then
    Pic7.LoadFromFile(lFile)
  else if NumImg = 7 then
    Pic8.LoadFromFile(lFile);
  Imagenes.Add(pImagen);
  NumImg := NumImg + 1;
end;

procedure MemoTotalOnBeforePrint(Sender: TfrxComponent);
var
  I, I2, lRectangulo, lMiRect: Integer;
  lImg, lCad, lDato, lHoja, lCodbarrascompleto, lPosText, lID: String;
  lIni: TMemIniFile;
  lTexto, lSL, lSL2: TStringList;
  SECCION, SECCIONTEXT, TAREAENCURSO: String;
  lPos: Integer;
begin
  lIDFigura := '-1';
  lIni := DameIni;
  lTexto := TStringList.Create;
  lHoja := '';
  lTOTAL := '';
  lTOTAL := #13#10;
  lCodbarrascompleto := <CodBarrasCompleto>;
  try
    lMiRect := StrToInt(Copy(lCodbarrascompleto, 10, 3));
  except
    lMiRect := 0;
  end;
  TAREAENCURSO := <CodigoTarea>;
  lRectangulo := <Rectangulo>;
  if (lRectangulo = -1) then
    lRectangulo := lMiRect;

  if (TAREAENCURSO <> '') then
  begin
    if lMostrarComandos then
      Memo34.Text := Memo34.Text + 'Rectangulo ' + IntToStr(lRectangulo) + ' ';
    if RectanguloEnSeccion(lIni, lRectangulo, 'HOJA_ACT') then
    begin
      SECCION := 'HOJA_ACT';
      SECCIONTEXT := 'HOJA ACTIVA';
      lHoja := '1';
    end
    else if RectanguloEnSeccion(lIni, lRectangulo, 'HOJA_PAS') then
    begin
      SECCION := 'HOJA_PAS';
      SECCIONTEXT := 'HOJA PASIVA';
      lHoja := '2';
    end
    else if RectanguloEnSeccion(lIni, lRectangulo, 'MARCOS') then
    begin
      SECCION := 'MARCOS';
      SECCIONTEXT := 'MARCO';
    end;
    if lMostrarComandos then
      Memo34.Text := Memo34.Text + 'lHoja ' + lHoja + Chr(10);

    lTexto.Insert(0, '<- AVISOS Y TAREAS ->');
    LMENSAJES := lTexto.Text;

    // Verificación de RutaImg
    if DirectoryExists(RutaImg) then
      LMENSAJES := LMENSAJES + 'Ruta de imágenes existe: ' + RutaImg + #13#10
    else
      LMENSAJES := LMENSAJES + 'Ruta de imágenes NO existe: ' + RutaImg + #13#10;

    // Imágenes enviadas directamente a la tarea
    lTexto.Text := '';
    lIni.ReadSection('PREARMADO_IMAGENES', lTexto);
    if lTexto.Text <> '' then
    begin
      for I := 0 to lTexto.Count - 1 do
      begin
        lImg := lTexto.Strings[I];
        InsertaImagen(lImg);
      end;
    end;

    // Imágenes por sección
    lTexto.Text := '';
    if (SECCION = 'MARCOS') then
      lIni.ReadSection('PREARMADO_MARCO_IMAGENES', lTexto)
    else if (SECCION = 'HOJA_ACT') or (SECCION = 'HOJA_PAS') then
      lIni.ReadSection('PREARMADO_HOJA_IMAGENES', lTexto);
    if lTexto.Text <> '' then
    begin
      for I := 0 to lTexto.Count - 1 do
      begin
        lImg := lTexto.Strings[I];
        InsertaImagen(lImg);
      end;
    end;

    // Mensajes por sección
    lTexto.Text := '';
    if (SECCION = 'MARCOS') then
      lIni.ReadSection('PREARMADO_MARCO_MENSAJES', lTexto)
    else if (SECCION = 'HOJA_ACT') or (SECCION = 'HOJA_PAS') then
      lIni.ReadSection('PREARMADO_HOJA_MENSAJES', lTexto);
    LMENSAJES := LMENSAJES + lTexto.Text;

    // Lógica específica para PREARMADO
    if (TAREAENCURSO = 'PREARMADO') then
    begin
      // Perfiles de la sección (MARCOS, HOJA_ACT, HOJA_PAS)
      lSL := DameClavesRectanguloTipo(SECCION, lRectangulo, 1);
      if (lSL.Count <> 0) then
        lTexto.Add('PERFILES ' + SECCIONTEXT);
      for I := 0 to lSL.Count - 1 do
      begin
        lCad := DameParametro(lIni.ReadString(SECCION, lSL.Strings[I], ''), 1) + ' - ' +
                DameParametro(lIni.ReadString(SECCION, lSL.Strings[I], ''), 5) +
                '  - ' + DameParametro(lIni.ReadString(SECCION, lSL.Strings[I], ''), 10) + ' mm';
        lDato := DameParametro(lIni.ReadString(SECCION, lSL.Strings[I], ''), 3);
        lPos := StrToInt(DameParametro(lIni.ReadString(SECCION, lSL.Strings[I], ''), 4));
        if lPos = 1 then
          lPosText := 'Superior'
        else if lPos = 2 then
          lPosText := 'Derecha'
        else if lPos = 3 then
          lPosText := 'Inferior'
        else if lPos = 4 then
          lPosText := 'Izquierda';
        if (lDato = '10') or (lDato = '20') then
        begin
          lTexto.Add(lCad + ' - ' + lPosText);
          lID := Copy(lSL.Strings[I], Pos('.', lSL.Strings[I]) + 1, Length(lSL.Strings[I]));
          lSL2 := DameClavesMecArti(lIni, 'PREARMADO_MEC_ARTI', StrToInt(lID));
          for I2 := 0 to lSL2.Count - 1 do
          begin
            lCad := DameParametro(lIni.ReadString('PREARMADO_MEC_ARTI', lSL2.Strings[I2], ''), 1) + ' - ' +
                    DameParametro(lIni.ReadString('PREARMADO_MEC_ARTI', lSL2.Strings[I2], ''), 2);
            lTexto.Add('                        (' + lCad + ')');
          end;
          lSL2.Free;
          lSL2 := DameClavesMecArti(lIni, 'PREARMADO_MEC_IMAGEN', StrToInt(lID));
          for I2 := 0 to lSL2.Count - 1 do
          begin
            lCad := DameParametro(lIni.ReadString('PREARMADO_MEC_IMAGEN', lSL2.Strings[I2], ''), 1);
            InsertaImagen(lCad);
          end;
          lSL2.Free;
        end;
      end;
      lSL.Free;

      // Zancas
      lSL := DameClavesRectanguloTipo('ZANCAS', lRectangulo, 1);
      if (lSL.Count <> 0) then
      begin
        lTexto.Add('');
        lTexto.Add('PERFILES ZANCAS');
        LMENSAJES := LMENSAJES + 'Fijar topes al perfil.';
      end;
      for I := 0 to lSL.Count - 1 do
      begin
        lCad := DameParametro(lIni.ReadString('ZANCAS', lSL.Strings[I], ''), 1) + ' - ' +
                DameParametro(lIni.ReadString('ZANCAS', lSL.Strings[I], ''), 5) +
                '  - ' + DameParametro(lIni.ReadString('ZANCAS', lSL.Strings[I], ''), 10) + ' mm';
        lDato := DameParametro(lIni.ReadString('ZANCAS', lSL.Strings[I], ''), 3);
        lPos := StrToInt(DameParametro(lIni.ReadString('ZANCAS', lSL.Strings[I], ''), 4));
        if lPos = 5 then
          lPosText := 'Vertical'
        else if lPos = 6 then
          lPosText := 'Horizontal';
        if (lDato = '50') or (lDato = '60') then
        begin
          lTexto.Add(lCad + ' - ' + lPosText);
          lID := Copy(lSL.Strings[I], Pos('.', lSL.Strings[I]) + 1, Length(lSL.Strings[I]));
          lSL2 := DameClavesMecArti(lIni, 'PREARMADO_MEC_ARTI', StrToInt(lID));
          for I2 := 0 to lSL2.Count - 1 do
          begin
            lCad := DameParametro(lIni.ReadString('PREARMADO_MEC_ARTI', lSL2.Strings[I2], ''), 1) + ' - ' +
                    DameParametro(lIni.ReadString('PREARMADO_MEC_ARTI', lSL2.Strings[I2], ''), 2);
            lTexto.Add('                        (' + lCad + ')');
          end;
          lSL2.Free;
          lSL2 := DameClavesMecArti(lIni, 'PREARMADO_MEC_IMAGEN', StrToInt(lID));
          for I2 := 0 to lSL2.Count - 1 do
          begin
            lCad := DameParametro(lIni.ReadString('PREARMADO_MEC_IMAGEN', lSL2.Strings[I2], ''), 1);
            InsertaImagen(lCad);
          end;
          lSL2.Free;
        end;
      end;
      lSL.Free;

      // Artículos vinculados directamente a la tarea
      lSL := TStringList.Create;
      lIni.ReadSection('PREARMADO', lSL);
      if (lSL.Count <> 0) then
      begin
        lTexto.Add('');
        lTexto.Add('OTROS ARTICULOS');
        for I := 0 to lSL.Count - 1 do
        begin
          lCad := DameParametro(lIni.ReadString('PREARMADO', lSL.Strings[I], ''), 5) + '    (' +
                  DameParametro(lIni.ReadString('PREARMADO', lSL.Strings[I], ''), 1) + ')';
          if lTexto.IndexOf(lCad) < 0 then
          begin
            lTexto.Add(lCad);
            lCad := DameParametro(lIni.ReadString('PREARMADO', lSL.Strings[I], ''), 1);
            InsertaImagen(lCad);
          end;
        end;
      end;
      lSL.Free;

      // Gomas batiente
      lSL := DameClavesRectanguloTipo(SECCION, lRectangulo, 2);
      if (lSL.Count > 0) then
      begin
        lTexto.Add('');
        lTexto.Add('GOMAS BATIENTE:');
      end;
      for I := 0 to lSL.Count - 1 do
      begin
        lCad := DameParametro(lIni.ReadString(SECCION, lSL.Strings[I], ''), 10);
        if lCad <> '0' then
        begin
          lCad := DameParametro(lIni.ReadString(SECCION, lSL.Strings[I], ''), 1) + ' - ' +
                  DameParametro(lIni.ReadString(SECCION, lSL.Strings[I], ''), 5);
          if lTexto.IndexOf(lCad) < 0 then
          begin
            lTexto.Add(lCad);
            lImg := DameParametro(lIni.ReadString(SECCION, lSL.Strings[I], ''), 1);
            InsertaImagen(lImg);
          end;
        end;
      end;
      lSL.Free;

      // Goma central (solo para MARCOS)
      if (SECCION = 'MARCOS') then
      begin
        lSL := DameClavesRectanguloTipo('GOMACENTRAL', 0, 2);
        if (lSL.Count > 0) then
        begin
          lTexto.Add('');
          lTexto.Add('GOMA CENTRAL');
        end;
        for I := 0 to lSL.Count - 1 do
        begin
          lCad := DameParametro(lIni.ReadString('GOMACENTRAL', lSL.Strings[I], ''), 10);
          if lCad <> '0' then
          begin
            lCad := DameParametro(lIni.ReadString('GOMACENTRAL', lSL.Strings[I], ''), 1) + ' - ' +
                    DameParametro(lIni.ReadString('GOMACENTRAL', lSL.Strings[I], ''), 5);
            if lTexto.IndexOf(lCad) < 0 then
            begin
              lTexto.Add(lCad);
              lImg := DameParametro(lIni.ReadString('GOMACENTRAL', lSL.Strings[I], ''), 1);
              InsertaImagen(lImg);
              InsertaImagen(lImg + 'POSI');
            end;
          end;
        end;
        lSL.Free;
      end;

      // Gomas de acristalamiento
      lSL := DameClavesRectanguloTipo(SECCION, lRectangulo, 1);
      for I := 0 to lSL.Count - 1 do
      begin
        lID := Copy(lSL.Strings[I], Pos('.', lSL.Strings[I]) + 1, Length(lSL.Strings[I]));
        lSL2 := DameClavesLinkIDTipo(lIni, 'VIDRIOS', lID, 2);
        for I2 := 0 to lSL2.Count - 1 do
        begin
          lCad := 'GOMAS DE ACRISTALAMIENTO.';
          if lTexto.IndexOf(lCad) < 0 then
            lTexto.Add(lCad);
          lCad := DameParametro(lIni.ReadString('VIDRIOS', lSL2.Strings[I2], ''), 1) + ' - ' +
                  DameParametro(lIni.ReadString('VIDRIOS', lSL2.Strings[I2], ''), 5);
          if lTexto.IndexOf(lCad) < 0 then
          begin
            lTexto.Add(lCad);
            lImg := DameParametro(lIni.ReadString('VIDRIOS', lSL2.Strings[I2], ''), 1);
            InsertaImagen(lImg);
            InsertaImagen(lImg + 'POSI');
          end;
        end;
        lSL2.Free;
      end;
      lSL.Free;

      // Gomas de acristalamiento para hojas ocultas
      if (SECCION = 'HOJA_ACT') or (SECCION = 'HOJA_PAS') then
      begin
        lSL := DameClavesSeccion(lIni, 'GOMAVIDHOJA');
        if (lSL.Count > 0) then
        begin
          lTexto.Add('');
          lTexto.Add('GOMAS DE ACRISTALAMIENTO.');
        end;
        for I := 0 to lSL.Count - 1 do
        begin
          lCad := DameParametro(lIni.ReadString('GOMAVIDHOJA', lSL.Strings[I], ''), 10);
          if lCad <> '0' then
          begin
            lCad := DameParametro(lIni.ReadString('GOMAVIDHOJA', lSL.Strings[I], ''), 1) + ' - ' +
                    DameParametro(lIni.ReadString('GOMAVIDHOJA', lSL.Strings[I], ''), 5);
            if lTexto.IndexOf(lCad) < 0 then
            begin
              lTexto.Add(lCad);
              lImg := DameParametro(lIni.ReadString('GOMAVIDHOJA', lSL.Strings[I], ''), 1);
              InsertaImagen(lImg);
              InsertaImagen(lImg + 'POSI');
            end;
          end;
        end;
        lSL.Free;
      end;

      // Información de carros para PREARMADO
      if (SECCION = 'MARCOS') then
      begin
        lTexto.Add('');
        MemoInformacionTexto.Text := 'Verificando marcos';
        lTexto.Add('CARRO CASILLA MARCO: ' + CarroCasilla(STI_TEInin('', <LineaLoteT."DatosFabricacion">, 'CARROSMARCO', 'Rec' + IntToStr(lRectangulo))));
        lSL := DameClavesRectanguloTipo('ZANCAS', lRectangulo, 1);
        if (STI_TEInin('', <LineaLoteT."DatosFabricacion">, 'CARROSZANCAS', 'Carros') <> '') then
          lTexto.Add('CARRO CASILLA ZANCAS: ' + CarroCasilla(STI_TEInin('', <LineaLoteT."DatosFabricacion">, 'CARROSZANCAS', 'Carros')));
        lSL.Free;
      end;
      if (SECCION = 'HOJA_ACT') or (SECCION = 'HOJA_PAS') then
      begin
        lTexto.Add('');
        lTexto.Add(STI_TEInin('CARRO CASILLA HOJA: ', <LineaLoteT."DatosFabricacion">, 'CARROSHOJA', 'Rec' + IntToStr(lRectangulo)));
        lSL := DameClavesRectanguloTipo('ZANCAS', lRectangulo, 1);
        if (lSL.Count <> 0) then
          lTexto.Add('CARRO CASILLA ZANCAS: ' + CarroCasilla(STI_TEInin('', <LineaLoteT."DatosFabricacion">, 'CARROSZANCAS', 'Carros')));
        lSL.Free;
      end;

      lTexto.Add('TAREA.....' + TAREAENCURSO);
      lTexto.Add('');
    end
    else
    begin
      LMENSAJES := LMENSAJES + 'Tarea no reconocida: ' + TAREAENCURSO + #13#10;
    end;
  end
  else
  begin
    LMENSAJES := 'No se especificó ninguna tarea.' + #13#10;
  end;

  lTOTAL := lTexto.Text;
  MemoTotal.Text := lTOTAL;
  lTexto.Free;
  lIni.Free;
end;

function UnidadesProcesadasEstaTareaLinea(pCodigoLote: String; pLinea: Integer): Integer;
var
  lTarea, lCampo: String;
  I: Integer;
begin
  Result := 0;
  lTarea := <CodigoTarea>;
  for I := 1 to 20 do
  begin
    if I < 10 then
      lCampo := '0' + IntToStr(I)
    else
      lCampo := IntToStr(I);
    if EstadoLineasLoteT.FieldByName('CodigoTarea' + lCampo).AsString = lTarea then
    begin
      Result := EstadoLineasLoteT.FieldByName('UP' + lCampo).AsInteger;
      Exit;
    end;
  end;
end;

procedure MasterData1OnBeforePrint(Sender: TfrxComponent);
begin
  MasterData1.Visible := True;
  if <LineaLoteT."FabricacionNumero"> <> <EstadoLineasLoteT."FabricacionNumero"> then
    MasterData1.Visible := False;
  UPLinea := UnidadesProcesadasEstaTareaLinea(<EstadoLineasLoteT."CodigoLote">, <EstadoLineasLoteT."Linea">);
  if UPLinea = <EstadoLineasLoteT."Cantidad"> then
  begin
    MemoModulo.Font.Color := clGreen;
    MemoUnds.Font.Color := clGreen;
  end
  else if UPLinea > <EstadoLineasLoteT."Cantidad"> then
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

procedure Page2OnBeforePrint(Sender: TfrxComponent);
begin
  lmaxl := 0;
end;

begin
  Imagenes := TStringList.Create;
  lMostrarComandos := False;
end.