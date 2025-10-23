 var
  LTOTAL,LMENSAJES : String;
  LTOTAL2 : String;
  LRESTO : String;
  LTEXTO : String;
  LTXTCLIENTE : String;
  LUP : Integer;
  LUT : Integer;
  LCT : String;
  LMAXL :Integer;
  LHAYBLOQUES,lMostrarComandos: boolean;
  ALMDEST : String; //almacen de destino de la pieza
  UPLinea : Integer; //PAra unidades procesadas de columna de la derecha
  lSL : TStringList;
    // VERIABLES POR JOSE CHIRINOS
    lMarcosList: TStringList;
  lIDFigura : String;
  NumImg : Integer = 0;
  RutaImg : String = '\\SERVER-M1\Compartido\Sicar\datos\z_felman2023\imagenes\'; //Debe terminar en "\"
  
  // Variables para cronómetro OPTIMIZACION
  TiempoInicioOptimizacion : TDateTime;
  ContadorOptimizacion : String;
  IndicadorActividad : String;






  //RutaImg : String = '\\SERVER-M2\imagenes\'; //Debe terminar en "\"
  //RutaImg = String.raw`\\192.168.1.6\imagenes\`;
  // Duplicas cada barra invertida:
  // RutaImg: string = '\\\\192.168.1.6\\imagenes\\';
// Así la variable apunta a \\192.168.1.6\imagenes\



  Imagenes : TStringList; //Para evitar duplicados imagenes






//----------------------------------------------------------------------------------------------------



// USO de trimer para enviar mensaje si existe ruta de imagenes
// codigo borrado no funciona aun


//Utilidades para leer datos del ini:

function DameIni : TMemIniFile;
var lSL : TStringList;
begin
  Result := TMemInifile.Create('');
  lSL := TStringList.Create;
  lSL.Text := <LineaLoteT."DatosFabricacion">;
  Result.SetStrings(lSL);
  lSL.Free;
end;

function DameClavesRectangulo(pIni : TMemIniFile; pSeccion : String; pRec : Integer) : TStringList;
//Devuelve la lista de claves de la sección cono ese rectángulo y ese tipo de artículo.
var
  lSL : TStringList;
  I, lNum : Integer;
begin
  Result := TStringList.Create;

  lSL := TStringList.Create;
  pIni.ReadSection(pSeccion,lSL);

  lNum := lSL.Count-1;
  For I := 0 to lNum do
    if Pos('R'+IntToStr(pRec)+'.',lSL.Strings[I]) > 0 then Result.Add(lSL.Strings[I]);

lSL.Free;
end;


function DameClavesSeccion(pIni : TMemIniFile; pSeccion : String) : TStringList;
//Devuelve la lista de claves de la sección cono ese rectángulo y ese tipo de artículo.
var
  lSL : TStringList;
  I, lNum : Integer;
begin
  Result := TStringList.Create;

  lSL := TStringList.Create;
  pIni.ReadSection(pSeccion,lSL);

  lNum := lSL.Count-1;
  For I := 0 to lNum do
    if Pos('R',lSL.Strings[I]) > 0 then Result.Add(lSL.Strings[I]);

lSL.Free;
end;


function DameClavesMecArti(pIni : TMemIniFile; pSeccion : String; pID : Integer) : TStringList;
//Devuelve la lista de claves de la sección con ese id de pieza delante (16.Mecanzuiado=Valor).
var
  lSL : TStringList;
  I, lNum : Integer;
begin
  Result := TStringList.Create;

  lSL := TStringList.Create;
  pIni.ReadSection(pSeccion,lSL);

  lNum := lSL.Count-1;
  For I := 0 to lNum do
//    if Pos(IntToStr(pID)+'.',lSL.Strings[I]) > 0 then Result.Add(lSL.Strings[I]);
    if Copy(lSL.Strings[I],1,Length(IntToStr(pID))+1) = IntToStr(pID)+'.' then Result.Add(lSL.Strings[I]);

  lSL.Free;
end;


function RectanguloEnSeccion(pIni : TMemIniFile; pRec : Integer; pSeccion : String) : Boolean;
var lSL : TStringList;
begin
  lSL := DameClavesRectangulo(pIni,pSeccion,pRec);
  Result := lSL.Count > 0;
  lSl.Free;
end;



function DameClavesLinkID(pIni : TMemIniFile; pSeccion : String; pLinkID : String) : TStringList;
//Devuelve la lista de claves de la sección con ese linkId.
var
  lSL : TStringList;
  I, lNum : Integer;
begin
  Result := TStringList.Create;

  lSL := TStringList.Create;
  pIni.ReadSection(pSeccion,lSL);

  lNum := lSL.Count-1;
  For I := 0 to lNum do
    if pLinkID = DameParametro(pIni.ReadString(pSeccion,lSL.Strings[I],''),8)
      then Result.Add(lSL.Strings[I]);

  lSL.Free;
end;

function DameClavesFiguraID(pIni : TMemIniFile; pSeccion : String; pFiguraID : String) : TStringList;
//Devuelve la lista de claves de la sección con ese linkId.
var
  lSL : TStringList;
  I, lNum : Integer;
begin
  Result := TStringList.Create;

  lSL := TStringList.Create;
  pIni.ReadSection(pSeccion,lSL);

  lNum := lSL.Count-1;
  For I := 0 to lNum do
    if pFiguraID = DameParametro(pIni.ReadString(pSeccion,lSL.Strings[I],''),14)
      then Result.Add(lSL.Strings[I]);

  lSL.Free;
end;

function DameClavesLinkIDTipo(pIni : TMemIniFile; pSeccion : String; pLinkID : String; pTipo : Integer) : TStringList;
//Devuelve la lista de claves de la sección con ese linkId.
var
  lSL : TStringList;
  I, lNum : Integer;
begin
  Result := TStringList.Create;

  lSL := TStringList.Create;
  pIni.ReadSection(pSeccion,lSL);

  lNum := lSL.Count-1;
  For I := 0 to lNum do
    if (pTipo = StrToInt(DameParametro(pIni.ReadString(pSeccion,lSL.Strings[I],''),2)))
    AND (pLinkID = DameParametro(pIni.ReadString(pSeccion,lSL.Strings[I],''),8))
      then Result.Add(lSL.Strings[I]);

  lSL.Free;
end;

function DameParametro(pCad : String; pNum : Integer) : String;
var
  I : Integer;
  lValor : String;
begin
  I := 1;
  Result := '';
  While Pos(';',pCad) > 0 do
    begin
      lValor := Copy(pCad,1,Pos(';',pCad)-1);
      //ShowMessage(lValor);
      pCad := Copy(pCad,Pos(';',pCad)+1,Length(pCad));
      if I = pNum then
        begin
          Result := lValor;
          Exit;
        end;
      Inc(I);
    end;
  //Si llega aqui es el último parámetro
  if pCad <> '' then Result := pCad;
end;

function FormatearTiempoOptimizacion(TiempoInicio: TDateTime): String;
//Calcula y formatea el tiempo transcurrido desde el inicio en formato HH:MM:SS
var
  TiempoTranscurrido: TDateTime;
  Horas, Minutos, Segundos: Integer;
  HorasStr, MinutosStr, SegundosStr: String;
begin
  TiempoTranscurrido := Now - TiempoInicio;
  
  // Convertir a segundos totales y luego extraer horas, minutos, segundos
  Segundos := Round(TiempoTranscurrido * 24 * 60 * 60);
  Horas := Segundos div 3600;
  Minutos := (Segundos mod 3600) div 60;
  Segundos := Segundos mod 60;
  
  // Formatear manualmente como HH:MM:SS
  if Horas < 10 then HorasStr := '0' + IntToStr(Horas) else HorasStr := IntToStr(Horas);
  if Minutos < 10 then MinutosStr := '0' + IntToStr(Minutos) else MinutosStr := IntToStr(Minutos);
  if Segundos < 10 then SegundosStr := '0' + IntToStr(Segundos) else SegundosStr := IntToStr(Segundos);
  
  Result := HorasStr + ':' + MinutosStr + ':' + SegundosStr;
end;

function SimularTiempoReal(): Boolean;
//Función para forzar la actualización del cronómetro en FastReport
//Devuelve TRUE para indicar que debe continuar la actualización
begin
  // Esta función se ejecuta cada vez que se renderiza el reporte
  // permitiendo que el cronómetro se actualice "en tiempo real"
  Result := True;
  
  // En FastReport, cada vez que se imprime una página o se actualiza
  // esta función recalcula el tiempo actual automáticamente
end;

function ExtraerComponentesOptimizacion(pIni: TMemIniFile; pLinea: Integer): TStringList;
//Extrae información COMPLETA de todos los componentes para optimización
var
  lSL, lSeccion: TStringList;
  I: Integer;
  lClave, lValor, lCodigo, lDescripcion, lTipo, lAncho, lAlto: String;
  lSeccionNombre: String;
begin
  Result := TStringList.Create;
  lSL := TStringList.Create;
  lSeccion := TStringList.Create;
  
  try
    // =================== MARCOS Y REFUERZOS ===================
    lSeccionNombre := 'MARCOS';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        if Pos('R' + IntToStr(pLinea) + '.', lClave) > 0 then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 1);
          lDescripcion := DameParametro(lValor, 5);
          lTipo := DameParametro(lValor, 13);
          lAncho := DameParametro(lValor, 10);
          lAlto := DameParametro(lValor, 11);
          
          if (lCodigo <> '') and (lDescripcion <> '') then
          begin
            if (Pos('Refuerzo', lDescripcion) > 0) or (lTipo = 'Refuerzo') then
              Result.Add('🔩 Refuerzo Marco: ' + lCodigo + ' - ' + lDescripcion + ' (' + lAncho + 'x' + lAlto + ')')
            else
              Result.Add('🔧 Marco: ' + lCodigo + ' - ' + lDescripcion + ' (' + lAncho + 'x' + lAlto + ')');
          end;
        end;
      end;
    end;
    
    // =================== HOJAS PASIVAS ===================
    lSeccionNombre := 'HOJA_PAS';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        if Pos('R' + IntToStr(pLinea) + '.', lClave) > 0 then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 1);
          lDescripcion := DameParametro(lValor, 5);
          lTipo := DameParametro(lValor, 13);
          lAncho := DameParametro(lValor, 10);
          lAlto := DameParametro(lValor, 11);
          
          if (lCodigo <> '') and (lDescripcion <> '') then
          begin
            if (Pos('Refuerzo', lDescripcion) > 0) or (lTipo = 'Refuerzo') then
              Result.Add('🔩 Refuerzo Hoja Pasiva: ' + lCodigo + ' - ' + lDescripcion + ' (' + lAncho + 'x' + lAlto + ')')
            else if (Pos('Hoja', lDescripcion) > 0) or (lTipo = 'Hoja') then
              Result.Add('🚪 Hoja Pasiva: ' + lCodigo + ' - ' + lDescripcion + ' (' + lAncho + 'x' + lAlto + ')');
          end;
        end;
      end;
    end;
    
    // =================== HOJAS ACTIVAS ===================
    lSeccionNombre := 'HOJA_ACT';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        if Pos('R' + IntToStr(pLinea) + '.', lClave) > 0 then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 1);
          lDescripcion := DameParametro(lValor, 5);
          lTipo := DameParametro(lValor, 13);
          lAncho := DameParametro(lValor, 10);
          lAlto := DameParametro(lValor, 11);
          
          if (lCodigo <> '') and (lDescripcion <> '') then
          begin
            if (Pos('Refuerzo', lDescripcion) > 0) or (lTipo = 'Refuerzo') then
              Result.Add('🔩 Refuerzo Hoja Activa: ' + lCodigo + ' - ' + lDescripcion + ' (' + lAncho + 'x' + lAlto + ')')
            else if (Pos('Hoja', lDescripcion) > 0) or (lTipo = 'Hoja') then
              Result.Add('🚪 Hoja Activa: ' + lCodigo + ' - ' + lDescripcion + ' (' + lAncho + 'x' + lAlto + ')');
          end;
        end;
      end;
    end;
    
    // =================== VIDRIOS ===================
    lSeccionNombre := 'VIDRIOS';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        if Pos('R' + IntToStr(pLinea) + '.', lClave) > 0 then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 1);
          lDescripcion := DameParametro(lValor, 5);
          lAncho := DameParametro(lValor, 10);
          lAlto := DameParametro(lValor, 11);
          
          if (lCodigo <> '') and (lDescripcion <> '') then
            Result.Add('🪟 Vidrio: ' + lCodigo + ' - ' + lDescripcion + ' (' + lAncho + 'x' + lAlto + ')');
        end;
      end;
    end;
    
    // =================== JUNQUILLOS (TODOS LOS TIPOS) ===================
    lSeccionNombre := 'VIDRIOS';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        // Buscar todos los tipos de junquillos R46, R86, R88, R100, R102, etc.
        if (Pos('R46.', lClave) > 0) or (Pos('R86.', lClave) > 0) or 
           (Pos('R88.', lClave) > 0) or (Pos('R100.', lClave) > 0) or
           (Pos('R102.', lClave) > 0) then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 1);
          lDescripcion := DameParametro(lValor, 5);
          lAncho := DameParametro(lValor, 10);
          lAlto := DameParametro(lValor, 11);
          
          if (lCodigo <> '') and (lDescripcion <> '') and (Pos('Junq', lDescripcion) > 0) then
            Result.Add('📏 Junquillo: ' + lCodigo + ' - ' + lDescripcion + ' (' + lAncho + 'x' + lAlto + ')');
        end;
      end;
    end;
    
    // =================== HERRAJES Y AUXILIARES ===================
    lSeccionNombre := 'HERRAJE';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        if Pos('R' + IntToStr(pLinea) + '.', lClave) > 0 then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 1);
          lDescripcion := DameParametro(lValor, 5);
          
          if (lCodigo <> '') and (lDescripcion <> '') then
            Result.Add('🔧 Herraje: ' + lCodigo + ' - ' + lDescripcion);
        end;
      end;
    end;
    
    // =================== SOLAPES Y HUECOS ===================
    lSeccionNombre := 'HUECOS';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        if Pos('R' + IntToStr(pLinea), lClave) > 0 then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 3);
          lDescripcion := DameParametro(lValor, 2);
          
          if (lDescripcion <> '') then
          begin
            if Pos('solape', LowerCase(lDescripcion)) > 0 then
            begin
              if lCodigo <> '' then
                Result.Add('🔗 Solape: ' + lDescripcion + ' - ' + lCodigo)
              else
                Result.Add('� Solape: ' + lDescripcion);
            end
            else
            begin
              if lCodigo <> '' then
                Result.Add('�🔲 Hueco: ' + lDescripcion + ' - ' + lCodigo)
              else
                Result.Add('🔲 Hueco: ' + lDescripcion);
            end;
          end;
        end;
      end;
    end;
    
    // =================== JAMBAS ===================
    lSeccionNombre := 'JAMBA';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        if Pos('R' + IntToStr(pLinea) + '.', lClave) > 0 then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 1);
          lDescripcion := DameParametro(lValor, 5);
          lAncho := DameParametro(lValor, 10);
          
          if (lCodigo <> '') and (lDescripcion <> '') then
            Result.Add('📐 Jamba: ' + lCodigo + ' - ' + lDescripcion + ' (' + lAncho + ')');
        end;
      end;
    end;
    
    // =================== AUXILIARES Y ACCESORIOS ===================
    lSeccionNombre := 'COMPACTO';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        if Pos('R' + IntToStr(pLinea) + '.', lClave) > 0 then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 1);
          lDescripcion := DameParametro(lValor, 5);
          
          if (lCodigo <> '') and (lDescripcion <> '') then
            Result.Add('⚙️ Auxiliar: ' + lCodigo + ' - ' + lDescripcion);
        end;
      end;
    end;
    
  finally
    lSL.Free;
    lSeccion.Free;
  end;
end;
var
  lSL, lSeccion: TStringList;
  I: Integer;
  lClave, lValor, lCodigo, lDescripcion, lTipo: String;
  lSeccionNombre: String;
begin
  Result := TStringList.Create;
  lSL := TStringList.Create;
  lSeccion := TStringList.Create;
  
  try
    // Buscar en sección MARCOS
    lSeccionNombre := 'MARCOS';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        if Pos('R' + IntToStr(pLinea) + '.', lClave) > 0 then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 1);
          lDescripcion := DameParametro(lValor, 5);
          lTipo := DameParametro(lValor, 13); // Parámetro que indica el tipo (Marco/Refuerzo)
          
          if (lCodigo <> '') and (lDescripcion <> '') then
          begin
            // Diferenciar entre marco y refuerzo
            if (Pos('Refuerzo', lDescripcion) > 0) or (lTipo = 'Refuerzo') then
              Result.Add('� Refuerzo: ' + lCodigo + ' - ' + lDescripcion)
            else
              Result.Add('�🔧 Marco: ' + lCodigo + ' - ' + lDescripcion);
          end;
        end;
      end;
    end;
    
    // Buscar también en sección HOJA_PAS (puede contener refuerzos)
    lSeccionNombre := 'HOJA_PAS';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        if Pos('R' + IntToStr(pLinea) + '.', lClave) > 0 then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 1);
          lDescripcion := DameParametro(lValor, 5);
          lTipo := DameParametro(lValor, 13);
          
          if (lCodigo <> '') and (lDescripcion <> '') then
          begin
            if (Pos('Refuerzo', lDescripcion) > 0) or (lTipo = 'Refuerzo') then
              Result.Add('🔩 Refuerzo Hoja: ' + lCodigo + ' - ' + lDescripcion)
            else if (Pos('Hoja', lDescripcion) > 0) or (lTipo = 'Hoja') then
              Result.Add('🚪 Hoja: ' + lCodigo + ' - ' + lDescripcion);
          end;
        end;
      end;
    end;
    
    // Buscar también en sección HOJA_ACT (puede contener refuerzos)
    lSeccionNombre := 'HOJA_ACT';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        if Pos('R' + IntToStr(pLinea) + '.', lClave) > 0 then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 1);
          lDescripcion := DameParametro(lValor, 5);
          lTipo := DameParametro(lValor, 13);
          
          if (lCodigo <> '') and (lDescripcion <> '') then
          begin
            if (Pos('Refuerzo', lDescripcion) > 0) or (lTipo = 'Refuerzo') then
              Result.Add('🔩 Refuerzo Hoja Activa: ' + lCodigo + ' - ' + lDescripcion)
            else if (Pos('Hoja', lDescripcion) > 0) or (lTipo = 'Hoja') then
              Result.Add('🚪 Hoja Activa: ' + lCodigo + ' - ' + lDescripcion);
          end;
        end;
      end;
    end;
    
    // Buscar en sección VIDRIOS
    lSeccionNombre := 'VIDRIOS';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        if Pos('R' + IntToStr(pLinea) + '.', lClave) > 0 then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 1);
          lDescripcion := DameParametro(lValor, 5);
          if (lCodigo <> '') and (lDescripcion <> '') then
            Result.Add('🪟 Vidrio: ' + lCodigo + ' - ' + lDescripcion);
        end;
      end;
    end;
    
    // Buscar junquillos en VIDRIOS (R46.xx o R86.xx, R88.xx, R100.xx)
    lSeccionNombre := 'VIDRIOS';
    if pIni.SectionExists(lSeccionNombre) then
    begin
      pIni.ReadSection(lSeccionNombre, lSeccion);
      for I := 0 to lSeccion.Count - 1 do
      begin
        lClave := lSeccion.Strings[I];
        // Buscar junquillos que empiecen con R46, R86, R88, R100 seguido del rectángulo
        if (Pos('R46.', lClave) > 0) or (Pos('R86.', lClave) > 0) or 
           (Pos('R88.', lClave) > 0) or (Pos('R100.', lClave) > 0) then
        begin
          lValor := pIni.ReadString(lSeccionNombre, lClave, '');
          lCodigo := DameParametro(lValor, 1);
          lDescripcion := DameParametro(lValor, 5);
          if (lCodigo <> '') and (lDescripcion <> '') and (Pos('Junq', lDescripcion) > 0) then
            Result.Add('📏 Junquillo: ' + lCodigo + ' - ' + lDescripcion);
        end;
      end;
    end;
    
  finally
    lSL.Free;
    lSeccion.Free;
  end;
end;

function DameClavesRectanguloTipo(pSeccion : String; pRec : Integer; pTipo : Integer) : TStringList;
var
  lSL : TStringList;
  I, lNum : Integer;
  lTipo : String;
  lIni : TMemIniFile;
begin
  Result := TStringList.Create;
  lIni := DameIni;
  lSL := DameClavesRectangulo(lIni,pSeccion,pRec);

  //Obtengo los que cumplen el tipo:
  lNum := lSL.Count-1;
  For I := 0 to lNum do
    begin
      lTipo := DameParametro(lIni.ReadString(pSeccion,lSL.Strings[I],''),2);
      if lTipo = IntToStr(pTipo) then Result.Add(lSL.Strings[I]);
    end;

  lSL.Free;
  lIni.Free;
end;

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

function CarroCasilla(pCadena:String):String;
var ltemp:String;
    lpos:Integer;
begin
  Result := '';
  lpos := Pos('.',pCadena);
  while(lpos > 0) do
  begin
    ltemp := Copy(pCadena,1,lpos-1);
    try
      ltemp := chr(64+StrToInt(ltemp));
    except
    end;
    Result := Copy(pCadena,1,lpos-2)+ltemp+Copy(pCadena,lpos,3);
    pCadena := Copy(pCadena,lpos+2,Length(pCadena));
    lpos := Pos('.',pCadena);
  end;
end;
//************ INICIO DEL REPORT ************

procedure Page1OnBeforePrint(Sender: TfrxComponent);
begin







end;

//----------------------------------------------------------------------------------------------------

procedure MemoTotalOnBeforePrint(Sender: TfrxComponent);
var
  I,I2,I3,lPos,lRectangulo,lHayAux,lRecAct,lRecPas,lmiRect:Integer;
  ltar, lImg,lFiguraId:string;
  lH, lM, lS, lD: Word;
  lIni : TMemIniFile;
  lTexto : TStringList;
  lCad,lCad2,lDato,lUso,lHoja,lCodbarrascompleto : String;
  lID : String;
  lSL2 : TStringList;
  lEsAct,lEsKit : Boolean;
  SECCION,lPosText,SECCIONTEXT,TAREAENCURSO : String;
  SECCION1,SECCION2,SECCION3,SECCION4 :String;
  lSituacion : Integer;


begin
  lIDFigura := '-1';
  lIni := DameIni;
  lTexto := TStringList.Create;
  lHoja := '';
  lTOTAL:='';
  lTOTAL:=#13#10;
  lcodbarrascompleto := <CodBarrasCompleto>;
  try
    lMiRect := StrToInt(Copy(lCodBarrasCompleto,10,3));
  except
  end;
  //***LINEA 1 TVITEC ***********************************************************
  TAREAENCURSO:= <CodigoTarea>;
  lRectangulo :=<Rectangulo>;
  if(lRectangulo = -1) then
    lRectangulo :=lMiRect;

  //TAREAENCURSO:='PREENS1';
  //TAREAENCURSO:='PREENS2';
  //TAREAENCURSO:='PREENS3';
  //TAREAENCURSO:='PREENS4';
  //TAREAENCURSO:='POSENS';
  //TAREAENCURSO:='PINVERSORES';
  //TAREAENCURSO:='PMARCOS';
  //TAREAENCURSO:='PMATRIMONIO';
  //TAREAENCURSO:='PACRISTALAR';
  //TAREAENCURSO:='PHERRAJE';
  //TAREAENCURSO:='PCLASIEMB';
  //if(TAREAENCURSO='HERRAJEHOJAP') then
  // TAREAENCURSO:='HERRAJEHOJA';
  //lRectangulo :=23;

  If (TAREAENCURSO<> '') then  ///----INICIO TAREAS---------
  BEGIN
    if lMostrarComandos then
      Memo34.Text := Memo34.Text +'Rectangulo '+IntToStr(lRectangulo)+' ';
    //PRIMERO GUARDO LA SECCION SEGUN RECTANGULO

If RectanguloEnSeccion(lIni,lRectangulo,'HOJA_ACT') then
Begin
  SECCION:='HOJA_ACT';
  SECCIONTEXT := 'HOJA ACTIVA';
  lHoja := '1';
end else
If RectanguloEnSeccion(lIni,lRectangulo,'HOJA_PAS') then
Begin
  SECCION:='HOJA_PAS';
  SECCIONTEXT := 'HOJA PASIVA';
  lHoja := '2';
end else
If RectanguloEnSeccion(lIni,lRectangulo,'MARCOS') then
Begin
  SECCION:='MARCOS';
  SECCIONTEXT :='MARCO';
end else
If RectanguloEnSeccion(lIni,lRectangulo,'HOJA_COR') then
Begin
  SECCION:='HOJA_COR';
  SECCIONTEXT:='HOJA CORREDERA';
  lHoja:='3';
end;





    if lMostrarComandos then
      Memo34.Text := Memo34.Text +'lHoja '+lHoja+chr(10);

    //ShowMessage(SECCION);


     //IMAGENES Y TEXTOS ------------------------------------------------------------

     //Inicializacion del texto de mensajes avisos
     lTexto.Insert(0,'<- AVISOS Y TAREAS ->');
     LMENSAJES  := lTexto.Text;


     //IMAGENES ENVIADOS DIRECTAMENTE A UNA TAREA
     lTexto.Text:='';
     lIni.ReadSection(TAREAENCURSO+'_IMAGENES',lTexto);
     if lTexto.Text <> '' then
      Begin
        For I := 0 to lTexto.Count - 1 do
          begin
            lImg := lTexto.Strings[I];
            InsertaImagen(lImg);
          end;
       end;


     //TEXTOS ENVIADOS DIRECTAMENTE A UNA TAREA
     lTexto.Text:='';
     lIni.ReadSection(TAREAENCURSO+'_MENSAJES',lTexto);

     LMENSAJES  := LMENSAJES+lTexto.Text;

    lTexto.Text:='';
    //Textos directo a tarea por seccion
    lSL := DameClavesRectanguloTipo(SECCION,lRectangulo,1);
    If (lSL.Count<>0) then
     Begin
     lTexto.Text:='';
     If (SECCION='MARCOS') then lIni.ReadSection(TAREAENCURSO+'_MARCO_IMAGENES',lTexto);
     If (SECCION='HOJA_ACT') or  (SECCION='HOJA_PAS') then lIni.ReadSection(TAREAENCURSO+'_HOJA_IMAGENES',lTexto);
     if lTexto.Text <> '' then
      Begin
        For I := 0 to lTexto.Count - 1 do
          begin
            lImg := lTexto.Strings[I];
            InsertaImagen(lImg);
          end;
       end;
     //Los mensajes
     lTexto.Text:='';
     If (SECCION='MARCOS') then lIni.ReadSection(TAREAENCURSO+'_MARCO_MENSAJES',lTexto);
     If (SECCION='HOJA_ACT') or  (SECCION='HOJA_PAS') then lIni.ReadSection(TAREAENCURSO+'_HOJA_MENSAJES',lTexto);
     lSL.Free;
    end;

    LMENSAJES  := LMENSAJES+lTexto.Text;

    //Especiales para las tareas de PMARCOS ********
    If  (TAREAENCURSO='COMPACTO') then
    Begin
   // MemoInformacionTexto.Text := 'Buscando Informacion necesaria a mostrar en Compacto';
     //lTexto.Text:='';
     //Textos directo a tarea por seccion
     //Declaro en numero de pasadas y la variante
     I3:=4;
     For I2:=1 to I3 do
     Begin
      If I2=1 then lCad:='CONDENSACION';
      If I2=2 then lCad:='ALARGADERA';
      If I2=3 then lCad:='GUIASMB';
      If I2=4 then lCad:='COMPACTOMB';

      If I2=1 then lCad2:='PMARCOS_CONDENSACION_IMAGENES';
      If I2=2 then lCad2:='PMARCOS_ALARGADERA_IMAGENES';
      If I2=3 then lCad2:='PMARCOS_GUIAS_IMAGENES';
      If I2=4 then lCad2:='PMARCOS_MONOBLOC_IMAGENES';

      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
      Begin
      lTexto.Text:='';
      lIni.ReadSection(lCad2,lTexto);
      If lTexto.Text <> '' then
       Begin
         For I := 0 to lTexto.Count - 1 do
           begin
             lImg := lTexto.Strings[I];
             InsertaImagen(lImg);
           end;
        end;
      end;
      lSL.Free;

      //Los mensajes
      lTexto.Text:='';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
      Begin
      If I2=1 then lCad2:='PMARCOS_CONDENSACION_MENSAJES';
      If I2=2 then lCad2:='PMARCOS_ALARGADERA_MENSAJES';
      If I2=3 then lCad2:='PMARCOS_GUIAS_MENSAJES';
      If I2=4 then lCad2:='PMARCOS_MONOBLOC_MENSAJES';
      lIni.ReadSection(lCad2,lTexto);

      LMENSAJES  := LMENSAJES+lTexto.Text;
       end;
      lSL.Free;
     end;
    end;



    lTexto.Text:='';

    //A PARTIR DE AQUI INFORMACION PROPIA POR TAREA Y SECCION

    lTexto.Add('TAREA.....'+TAREAENCURSO);
    lTexto.Add('');

    //Si esamos procesando en puesto de marcos, si se lee una hoja lo debe advertir
    If (TAREAENCURSO='COMPACTO') and (SECCION<>'MARCOS') then
      Begin
       LMENSAJES:='EN EL PUESTO DE MARCOS SOLO SE PUEDEN PROCESAR MARCOS' + #13#10 + 'La etiqueta escaneada de corresponde con: '+ #13#10 + SECCION;
       //Pongo seccion y tarea a comillas para que no procese nada.
       SECCION:=''; //ANULO SECCION PARA QUE NO SE MUESTRE INFORMACION
       TAREAENCURSO:=''; //ANULO TAREA PARA QUE NO SE MUESTRE INFORMACION
      end;

    //Si estoy en acristalamiento no cargo mas informacion que la propia de acristamiento.
    If (TAREAENCURSO='ACRISTALAR') then
      Begin
        SECCION:='';// Para que no se carge informacion por rectangulo todo por tarea
        lRectangulo:=0;
      end;


    //Si estoy en acristalamiento no cargo mas informacion que la propia de acristamiento.
    If (TAREAENCURSO='HERRAJEHOJA') then
      Begin
        //SECCION:='';// Para que no se carge informacion por rectangulo todo por tarea
        //lRectangulo:=0;
      end;


If (TAREAENCURSO='PREARMADO') OR (TAREAENCURSO='ARMADO') then
begin
  lSL := DameClavesRectanguloTipo(SECCION,lRectangulo,1);
  If (lSL.Count<>0) then lTexto.Add('PERFILES '+SECCIONTEXT);
  For I := 0 to lSL.Count-1 do
  begin


    lCad := DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),1) + ' - ' +
            DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),5) + '  - ' +
            DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),10) + ' mm';
    lDato := DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),12); // Use parameter 12 for type (e.g., 'Marco', 'Refuerzo')

    lPos := StrToInt(DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),4));
    If lPos=1 then lPosText:='Superior' else
    If lPos=2 then lPosText:='Derecha' else
    If lPos=3 then lPosText:='Inferior' else
    If lPos=4 then lPosText:='Izquierda';

    // Exclude reinforcements
    If (lDato<>'Refuerzo') then
    begin
      lTexto.Add(lCad+' - '+lPosText);
      lID := Copy(lSL.Strings[I],Pos('.',lSL.Strings[I])+1,Length(lSL.Strings[I]));

      lSL2 := DameClavesMecArti(lIni,TAREAENCURSO+'_MEC_ARTI',StrToInt(lID));
      For I2 := 0 to lSL2.Count - 1 do
      begin
        lCad := DameParametro(lIni.ReadString(TAREAENCURSO+'_MEC_ARTI',lSL2.Strings[I2],''),1) +
                ' - ' +
                DameParametro(lIni.ReadString(TAREAENCURSO+'_MEC_ARTI',lSL2.Strings[I2],''),2);
        lTexto.Add('                        ('+lCad+')');
      end;
      lSL2.Free;

      lSL2 := DameClavesMecArti(lIni,TAREAENCURSO+'_MEC_IMAGEN',StrToInt(lID));
      lCad := '';
      For I2 := 0 to lSL2.Count - 1 do
      begin
        lCad := DameParametro(lIni.ReadString(TAREAENCURSO+'_MEC_IMAGEN',lSL2.Strings[I2],''),1);
        InsertaImagen(lCad);
      end;
      lSL2.Free;
    end;
  end;
  lSL.Free;





    //ADJUNTO LAS ZANCAS VINCULADAS AL MISMO RECTANGULO
    lCad:='';lDato:='';
    lSL := DameClavesRectanguloTipo('ZANCAS',lRectangulo,1);
    If (lSL.Count<>0) then lTexto.Add('');
    If (lSL.Count<>0) then lTexto.Add('PERFILES ZANCAS');















    //Añado a las tareas que pongan los topes.
    If (TAREAENCURSO= 'PREARMADO')and (lSL.Count<>0) then LMENSAJES  := LMENSAJES + 'Fijar topes al perfil.';

    For I := 0 to lSL.Count-1 do
      begin
        lCad := DameParametro(lIni.ReadString('ZANCAS',lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString('ZANCAS',lSL.Strings[I],''),5) +
        '  - ' + DameParametro(lIni.ReadString('ZANCAS',lSL.Strings[I],''),10)+ ' mm';
        lDato:= DameParametro(lIni.ReadString('ZANCAS',lSL.Strings[I],''),3);

        lPos:=StrToInt(DameParametro(lIni.ReadString('ZANCAS',lSL.Strings[I],''),4));
        If lPos=5 then lPosText:='Vertical' else
        If lPos=6 then lPosText:='Horizontal';

        //Solo si es poste o travesa
        If (lDato='50') or (lDato='60') then
         begin
           lID :='';
           lTexto.Add(lCad+' - '+lPosText);
           lID := Copy(lSL.Strings[I],Pos('.',lSL.Strings[I])+1,Length(lSL.Strings[I]));

          //CARGO INFORMACION DESDE LOS MECANIZADOS VINCULADA CON LA TAREA EN CURSO

           //ADJUNTO ARTICULO VINCULADO AL MECANIZADO
           lSL2 := DameClavesMecArti(lIni,TAREAENCURSO+'_MEC_ARTI',StrToInt(lID));
           For I2 := 0 to lSL2.Count - 1 do
            begin
              lCad:=DameParametro(lIni.ReadString(TAREAENCURSO+'_MEC_ARTI',lSL2.Strings[I2],''),1) + ' - ' +DameParametro(lIni.ReadString(TAREAENCURSO+'_MEC_ARTI',lSL2.Strings[I2],''),2);
              lTexto.Add('                        ('+lCad+')');
            end;
              lSL2.Free;

            //ADJUNTO LAS IMAGENES EXISTENTES EN LOS MECANIZADOS
            lSL2 := DameClavesMecArti(lIni,TAREAENCURSO+'_MEC_IMAGEN',StrToInt(lID));
            lCad:='';
            For I2 := 0 to lSL2.Count - 1 do
              begin
                lCad:=DameParametro(lIni.ReadString(TAREAENCURSO+'_MEC_IMAGEN',lSL2.Strings[I2],''),1);
                InsertaImagen(lCad);
              end;
              lSL2.Free;

        end;

      end;
    lSL.Free;
    end;

      //LOS ARTICULOS VINCULADOS DE FORMA DIRECTA A LA TAREA/TERMINAL
      lCad:=TAREAENCURSO;
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lTexto.Add('');
         lTexto.Add('OTROS ARTICULOS ');
         For I := 0 to lSL.Count - 1 do
           begin
              lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5) + '    (' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1)+')';
              If lTexto.IndexOf(lCad2) < 0 then
              Begin
              lTexto.Add(lCad2);
              lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              InsertaImagen(lCad2);
              end;
           end;
        end;




   //EN LA TAREA PMARCOS TENGO QUE AÑADIR LOS DATOS DE LA SECCIONES DE CONDENSACION, ALARGADERA, GUIASMB Y COMPACTOMB
   If TAREAENCURSO='COMPACTO' then
    Begin
      //EL CAJON
      lCad:='COMPACTOMB';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lTexto.Add('');
         lTexto.Add('PERSIANA');
         For I := 0 to lSL.Count - 1 do
           begin
            lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
            lCad2:= lCad2 + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),10) + ' X ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),11);
            lTexto.Add(lCad2);
            lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
            InsertaImagen(lCad2);
           end;
        end;
       lSL.Free;

      //LAS GUIAS
      lCad:='GUIASMB';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lHayAux:=1;
         lTexto.Add('');
         lTexto.Add('GUIAS');
         For I := 0 to lSL.Count - 1 do
           begin
            lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
            lPos:=StrToInt(DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),4));
            If lPos=2 then lPosText:='Derecha' else
            If lPos=4 then lPosText:='Izquierda';
            If lDato='1' then
             Begin
              lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
              lCad2:= lCad2 + ' ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),10) + ' mm - ' + lPosText;
              lTexto.Add(lCad2);
              lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              InsertaImagen(lCad2);
             end;
           end;
        end;
       lSL.Free;


      //LA ALARGADERA
      lCad:='ALARGADERA';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lHayAux:=1;
         lTexto.Add('');
         lTexto.Add('ALARGADERA');
         For I := 0 to lSL.Count - 1 do
           begin
            lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
            lPos:=StrToInt(DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),4));
            If lPos=3 then lPosText:='Inferior';
            If lDato='1' then
             Begin
              lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
              lCad2:= lCad2 + ' ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),10) + ' mm - ' + lPosText;
              lTexto.Add(lCad2);
              lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              InsertaImagen(lCad2);
             end;
           end;
        end;
       lSL.Free;


      //LA CONDENSACION
      lCad:='CONDENSACION';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lHayAux:=1;
         lTexto.Add('');
         lTexto.Add('CONDENSACION');
         For I := 0 to lSL.Count - 1 do
           begin
            lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
            lPos:=StrToInt(DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),4));
            If lPos=3 then lPosText:='Inferior';
            If lDato='1' then
             Begin
              lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
              lCad2:= lCad2 + ' ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),10) + ' mm  - ' + lPosText;
              lTexto.Add(lCad2);
              lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              InsertaImagen(lCad2);
             end;
           end;
        end;
       lSL.Free;

      // INFOMACION DE CARROS DE PERFILES AUXILIARES, SIEMPRE QUE SE METIESE ALGO DE LO ANTERIOR.
      If (lHayAux=1) then
        Begin
         lTexto.Add('');
         //lCad:=STI_TEInin('CARRO PERFILES AUXILIARES: ',<LineaLoteT."DatosFabricacion">,'CARROSPERFILESA','Carros');
         lCad:='CARRO PERFILES AUXILIARES: '+CarroCasilla(STI_TEInin('',<LineaLoteT."DatosFabricacion">,'CARROSPERFILESA','Carros'));
         //lTexto.Add(STI_TEInin('CARRO PERFILES AUXILIARES: ',<LineaLoteT."DatosFabricacion">,'CARROSPERFILESA','Carros'));
         lTexto.Add('CARRO PERFILES AUXILIARES: '+CarroCasilla(STI_TEInin('',<LineaLoteT."DatosFabricacion">,'CARROSPERFILESA','Carros')));
        end;

    end; ///----- ESPECIAL PARA TAREA PMARCOS


   If TAREAENCURSO='ARMADO' then
    Begin
      lCad:='HUECOS';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lTexto.Add('');
         lTexto.Add('RECTANGULO '+IntToStr(lRectangulo));
         For I := 0 to lSL.Count - 1 do
           begin
              if(Copy(lSL.Strings[I],1,3)<>Copy('R'+IntToStr(lRectangulo)+'=',1,3)) then continue;
              lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              //if(lDato <> '440') then continue;
              lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
              If (lTexto.IndexOf(lCad2) < 0) then
               Begin
                lTexto.Add(lCad2);
                lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
                InsertaImagen(lCad2);
               end;
           end;
         end;
      lSl.Free;
                //LOS JUNQUILLOS DE ESTE VIDRIO
                lSL2 := TStringList.Create;
                lIni.ReadSection('VIDRIOS',lSL2);
                If lSL2.Count > 0 then
                begin
                 For I := 0 to lSL2.Count-1 do
                  Begin
                   If lFiguraId  = DameParametro(lIni.ReadString('VIDRIOS',lSL.Strings[I],''),14) then
                     Begin
                       If DameParametro(lIni.ReadString('VIDRIOS',lSL.Strings[I],''),2) = '1' then
                         Begin
                           lPos:=StrToInt(DameParametro(lIni.ReadString('VIDRIOS',lSL.Strings[I],''),4));
                           If lPos=1 then lPosText:='Superior' else
                           If lPos=2 then lPosText:='Derecha' else
                           If lPos=3 then lPosText:='Inferior' else
                           If lPos=4 then lPosText:='Izquierda';

                           lCad := DameParametro(lIni.ReadString('VIDRIOS',lSL2.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString('VIDRIOS',lSL2.Strings[I],''),5)+ ' - ';
                           lCad2 := DameParametro(lIni.ReadString('VIDRIOS',lSL2.Strings[I],''),10);
                           lTexto.Add('           '+lCad+lCad2+ ' mm'+' -'+lPosText);
                           lImg :=  DameParametro(lIni.ReadString('VIDRIOS',lSL2.Strings[I],''),1);
                           InsertaImagen(lImg);
                         end;
                     end;
                  end;
                end;
                lSL2.Free;
                         lTexto.Add('');
                         lTexto.Add(STI_TEInin('CARRO CASILLA JUNQUILLOS: ',<LineaLoteT."DatosFabricacion">,'CARROSJUNQUILLO','Todos'));


    end;
   //EN LA TAREA PCLASIEMB TENGO QUE AÑADIR LOS DATOS DE LA SECCIONES DE JAMBA
   If TAREAENCURSO='EMBALAJE' then
    Begin
      //EL TAPAJUNTAS
      lCad:='JAMBA';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lTexto.Add('');
         lTexto.Add('TAPAJUNTAS');
         For I := 0 to lSL.Count - 1 do
           begin
            lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),3);
            if(lDato <> '440') then continue;

            lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5) + ' -  (' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1)+')';
            //lCad2:= lCad2 + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),10) + ' X ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),11);
            lCad2:= lCad2 + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),10);
            lTexto.Add(lCad2);
            lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
            InsertaImagen(lCad2);
           end;
           For I := 0 to lSL.Count - 1 do
           begin
             lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
             InsertaImagen(lCad2);
           end;
        end;
       lSL.Free;

      lCad:='HUECOS';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lTexto.Add('');
         lTexto.Add('TAPAJUNTAS ');
         For I := 0 to lSL.Count - 1 do
           begin
             // if(Copy(lSL.Strings[I],1,3)<>Copy('R'+IntToStr(lRectangulo)+'=',1,3)) then continue;
              lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              if(lDato <> '440') then continue;
              lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
              If (lTexto.IndexOf(lCad2) < 0) then
               Begin
                lTexto.Add(lCad2);
                lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
                InsertaImagen(lCad2);
               end;
           end;
         end;
      lSl.Free;


      lCad:='JAMBA';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lTexto.Add('');
         lTexto.Add('ACCESORIOS FIJACION');
         For I := 0 to lSL.Count - 1 do
           begin
             lCad2 := DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),10);
              //Si no tiene longitud es escuadra
             If lCad2='0' then
              Begin
               lCad2 := DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5) + ' -  (' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1)+')';
               if lTexto.IndexOf(lCad2) < 0 then
                Begin
                 lTexto.Add(lCad2);
                 lImg :=  DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
                 InsertaImagen(lImg);
                end;
               end;
             end;
         end;
        lSl.Free;


      //LA ALARGADERA
      lCad:='ALARGADERA';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lHayAux:=1;
         lTexto.Add('');
         lTexto.Add('ALARGADERA');
         For I := 0 to lSL.Count - 1 do
           begin
            lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
            lPos:=StrToInt(DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),4));
            If lPos=3 then lPosText:='Inferior';
            If lDato='1' then
             Begin
              lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
              lCad2:= lCad2 + ' ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),10) + ' mm - ' + lPosText;
              lTexto.Add(lCad2);
              lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              InsertaImagen(lCad2);
             end;
           end;
        end;
       lSL.Free;



      // INFOMACION DE CARROS DE PERFILES AUXILIARES, SIEMPRE QUE SE METIESE ALGO DE LO ANTERIOR.
      If (lHayAux=1) then
        Begin
         lTexto.Add('');
         //lCad:=STI_TEInin('CARRO PERFILES AUXILIARES: ',<LineaLoteT."DatosFabricacion">,'CARROSPERFILESA','Carros');
         lCad:='CARRO PERFILES AUXILIARES: '+CarroCasilla(STI_TEInin('',<LineaLoteT."DatosFabricacion">,'CARROSPERFILESA','Carros'));
         //lTexto.Add(STI_TEInin('CARRO PERFILES AUXILIARES: ',<LineaLoteT."DatosFabricacion">,'CARROSPERFILESA','Carros'));
         lTexto.Add('CARRO PERFILES AUXILIARES: '+CarroCasilla(STI_TEInin('',<LineaLoteT."DatosFabricacion">,'CARROSPERFILESA','Carros')));
        end;

    end; ///----- ESPECIAL PARA TAREA PMARCOS


    //CUANDO ESTAMOS EN MATRIMONIO TENGO QUE AÑADIR A LA INFORMACION DEL MARCO LA DE LAS HOJAS.
    //COMUN EN MARCOS Y HOJAS.........................................................
    //PARA PREENSAMBLADO1 MUESTRO INFORMACION DE CARROS
    If TAREAENCURSO='PREARMADO' then
    Begin
     IF (SECCION='MARCOS') then
      Begin
       lTexto.Add('');
     //  MemoInformacionTexto.text := 'Verificando marcos';
       //lTexto.Add(STI_TEInin('CARRO CASILLA MARCO: ',<LineaLoteT."DatosFabricacion">,'CARROSMARCO','Rec'+IntToStr(lRectangulo)));
       lTexto.Add('CARRO CASILLA MARCO: '+CarroCasilla(STI_TEInin('',<LineaLoteT."DatosFabricacion">,'CARROSMARCO','Rec'+IntToStr(lRectangulo))));
       //Compruebo si hay zancas, y si es asi añado la informacion de carro
       lSL := DameClavesRectanguloTipo('ZANCAS',lRectangulo,1);
       //showmessage(STI_TEInin('',<LineaLoteT."DatosFabricacion">,'CARROSZANCAS','Carros'));
      // If (lSL.Count<>0) then lTexto.Add(STI_TEInin('CARRO CASILLA ZANCAS: ',<LineaLoteT."DatosFabricacion">,'CARROSZANCAS','Carros'));
       If (STI_TEInin('',<LineaLoteT."DatosFabricacion">,'CARROSZANCAS','Carros')<>'') then lTexto.Add(STI_TEInin('CARRO CASILLA ZANCAS: ',<LineaLoteT."DatosFabricacion">,'CARROSZANCAS','Carros'));
       //If (lSL.Count<>0) then lTexto.Add('CARRO CASILLA ZANCAS: '+CarroCasilla(STI_EIni(<LineaLoteT."DatosFabricacion">,'CARROSZANCAS','Carros')));
       lSL.Free;
      end;

     IF (SECCION='HOJA_ACT') or (SECCION='HOJA_PAS') then
      Begin
       lTexto.Add('');
       lTexto.Add(STI_TEInin('CARRO CASILLA HOJA: ',<LineaLoteT."DatosFabricacion">,'CARROSHOJA','Rec'+IntToStr(lRectangulo)));
       lSL := DameClavesRectanguloTipo('ZANCAS',lRectangulo,1);
       //If (lSL.Count<>0) then lTexto.Add(STI_TEInin('CARRO CASILLA ZANCAS: ',<LineaLoteT."DatosFabricacion">,'CARROSZANCAS','Carros'));
       If (lSL.Count<>0) then lTexto.Add('CARRO CASILLA ZANCAS: '+CarroCasilla(STI_TEInin('',<LineaLoteT."DatosFabricacion">,'CARROSZANCAS','Carros')));
       lSL.Free;
      end;
    end;

  //SOLO EN PREENSAMBLADO 2
  If (TAREAENCURSO= 'PREARMADO') then

  Begin
    lSL := DameClavesRectanguloTipo(SECCION,lRectangulo,2);
    iF (lSL.Count>0) then lTexto.Add('');
    iF (lSL.Count>0) then lTexto.Add('GOMAS BATIENTE:');
    For I := 0 to lSL.Count-1 do
      begin
        lCad := DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),10);
        //Solo si tiene longitud es una goma
        If lCad<>'0' then
          Begin
           lCad := DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),5);
           if lTexto.IndexOf(lCad) < 0 then
             Begin
             lTexto.Add(lCad);
             lImg :=  DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),1);
             InsertaImagen(lImg);
             //InsertaImagen(lImg+'POSI');
             end;
          end;
       end;
      lSL.Free;
    end;

   //SOLO EN CASO DE PREENSAMBLADO 3
   If (TAREAENCURSO= 'PREARMADO') then

   BEGIN
      //Si estoy en marcos cargo la goma central
      IF (SECCION='MARCOS') then
      Begin
       lSL := DameClavesRectanguloTipo('GOMACENTRAL',0,2);
       iF (lSL.Count>0) then lTexto.Add('');
       iF (lSL.Count>0) then lTexto.Add('GOMA CENTRAL');
        For I := 0 to lSL.Count-1 do
         begin
          lCad := DameParametro(lIni.ReadString('GOMACENTRAL',lSL.Strings[I],''),10);
          //Solo si tiene longitud es una goma
          If lCad<>'0' then
          Begin
           lCad := DameParametro(lIni.ReadString('GOMACENTRAL',lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString('GOMACENTRAL',lSL.Strings[I],''),5);
           if lTexto.IndexOf(lCad) < 0 then
             Begin
             lTexto.Add(lCad);
             lImg :=  DameParametro(lIni.ReadString('GOMACENTRAL',lSL.Strings[I],''),1);
             InsertaImagen(lImg);
             InsertaImagen(lImg+'POSI');//Si hay imagen de indicacion de posicion
             end;
           end;
          end;
       lSL.Free;
      end;

    lTexto.Add('');
    lSL := DameClavesRectanguloTipo(SECCION,lRectangulo,1);
    For I := 0 to lSL.Count-1 do
      begin
        //Obtengo el ID de este perfil:
        lID := Copy(lSL.Strings[I],Pos('.',lSL.Strings[I])+1,Length(lSL.Strings[I]));

        lSL2 := DameClavesLinkIDTipo(lIni,'VIDRIOS',lID,2);
        For I2 := 0 to lSL2.Count - 1 do
          begin
            lCad:='GOMAS DE ACRISTALAMIENTO.';
            if lTexto.IndexOf(lCad) < 0 then lTexto.Add(lCad);
            lCad := DameParametro(lIni.ReadString('VIDRIOS',lSL2.Strings[I2],''),1) + ' - ' + DameParametro(lIni.ReadString('VIDRIOS',lSL2.Strings[I2],''),5);
            if lTexto.IndexOf(lCad) < 0 then
             Begin
              lTexto.Add(lCad);
              lImg := DameParametro(lIni.ReadString('VIDRIOS',lSL2.Strings[I2],''),1);
              InsertaImagen(lImg);
              InsertaImagen(lImg+'POSI');//Si hay imagen de indicacion de posicion
             end;

          end;
          //Si en cuentro la goma, la cargo en imagenes.
        lSL2.Free;
      end;
    lSL.Free;

    ///EN LOS CASOS DE HOJA OCULTA, LA COMA DE ACRISTALAMIENTO QUE VA EN EL PERFIL NO ES LA EXTERIOR (QUE NO HAY)
    //EN ESAS SERIES LA GOMA DE ACRISTALMIENTO DE LA HOJA HAY QUE ENVIARLA A LA SECCION  GOMAVIDHOJA
    //SI ESTOY EN UNA HOJA CARGO ESA SECCION SI EXISTE EN ACTIVA Y EN PASIVA
    //Si estoy en marcos cargo la goma central
     IF (SECCION='HOJA_ACT') or (SECCION='HOJA_PAS') then
      Begin
       lSL := DameClavesSeccion(lIni,'GOMAVIDHOJA');
       iF (lSL.Count>0) then lTexto.Add('');
        For I := 0 to lSL.Count-1 do
         begin
          lCad := DameParametro(lIni.ReadString('GOMAVIDHOJA',lSL.Strings[I],''),10);
          //Solo si tiene longitud es una goma
          If lCad<>'0' then
          Begin
           lCad:='GOMAS DE ACRISTALAMIENTO.';
           if lTexto.IndexOf(lCad) < 0 then lTexto.Add(lCad);
           lCad := DameParametro(lIni.ReadString('GOMAVIDHOJA',lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString('GOMAVIDHOJA',lSL.Strings[I],''),5);
           if lTexto.IndexOf(lCad) < 0 then
             Begin
              lTexto.Add(lCad);
              lImg := DameParametro(lIni.ReadString('GOMAVIDHOJA',lSL.Strings[I],''),1);
              InsertaImagen(lImg);
              InsertaImagen(lImg+'POSI');//Si hay imagen de indicacion de posicion
             end;
          end;
          end;
       lSL.Free;
      end;

   END; //Fin de PREENSAMBALDO3 textos


  //SOLO EN PREENSAMBLADO 4
  If (TAREAENCURSO= 'ARMADO') then
  Begin
    lSL := DameClavesRectanguloTipo(SECCION,lRectangulo,2);
    iF (lSL.Count>0) then lTexto.Add('');
    iF (lSL.Count>0) then lTexto.Add('ESCUADRAS:');
    For I := 0 to lSL.Count-1 do
      begin
        lCad := DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),10);
        //Si no tiene longitud es escuadra
        If lCad='0' then
          Begin
           lCad := DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),5);
           if lTexto.IndexOf(lCad) < 0 then
             Begin
             lTexto.Add(lCad);
             lImg :=  DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),1);
             InsertaImagen(lImg);
             end;
          end;
       end;
      lSL.Free;
    end;


   //SOLO TAREA INVERSORES

  If (TAREAENCURSO= 'PINVERSORES') then
  Begin
    If SECCION='HOJA_PAS' then
     Begin
      lSL := TStringList.Create;
      lIni.ReadSection('INVERSOR',lSL);

      iF (lSL.Count>0) then lTexto.Add('');
      iF (lSL.Count>0) then lTexto.Add('INVERSOR:');
      For I := 0 to lSL.Count-1 do
        begin
           lCad2 := DameParametro(lIni.ReadString('INVERSOR',lSL.Strings[I],''),10);
           If (lCad2<>'0') then lCad2:=' - '+ lCad2 + ' mm' else lCad2:='';
           lCad := DameParametro(lIni.ReadString('INVERSOR',lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString('INVERSOR',lSL.Strings[I],''),5);
           if lTexto.IndexOf(lCad) < 0 then
             Begin
             lTexto.Add(lCad+lCad2);
             lImg :=  DameParametro(lIni.ReadString('INVERSOR',lSL.Strings[I],''),1);
             InsertaImagen(lImg);
             end;
        end;
       lSL.Free;
       lTexto.Add('');
       lTexto.Add(STI_TEInin('CARRO CASILLA INVERSOR: ',<LineaLoteT."DatosFabricacion">,'CARROSINVERSORES','Carros'));
     end;

    //Si la hoja que pasa es una activa y es escaneada. Indico que no procede
    If SECCION='HOJA_ACT' then
     Begin
     lTexto.Add('');
     lTexto.Add('');
     lCad:='************************************';
     lTexto.Add(lCad);
     lTexto.Add('');
     lCad:='    ESTA ES HOJA ACTIVA';
     lTexto.Add(lCad);
     lCad:='    NO TIENE INVERSOR';
     lTexto.Add(lCad);
     lTexto.Add('');
     lCad:='************************************';
     lTexto.Add(lCad);
     LMENSAJES  :='***HOJA ACTIVA*** '+#13#10+'NO APLICABLE TAREA DE INVERSOR';
     end;

   end;

    //ACRISTALAMIENTO.
    //Proceso ini completo de VIDRIOS buscando los vidrios.
    IF (TAREAENCURSO='ACRISTALADO') then
     BEGIN

      lSL := TStringList.Create;
      lIni.ReadSection('VIDRIOS',lSL);
      For I := 0 to lSL.Count-1 do
        begin
           lDato := DameParametro(lIni.ReadString('VIDRIOS',lSL.Strings[I],''),2); //Me dice si son vidrios
           lFiguraId  := DameParametro(lIni.ReadString('VIDRIOS',lSL.Strings[I],''),14); //Me dice el id de figura comun en todos los elementos del mismo vidrio
           If (lDato='5') then
            Begin
              //Para saber el rectangulo de cada superficie
              lSL2 := TStringList.Create;
              lIni.ReadSection('VIDRIOS',lSL2);
              I3 := 0;
              If lSL2.Count > 0 then I3 := StrToInt(Copy(lSL2.Strings[I],2,Pos('.',lSL2.Strings[0])-2));
              If (I3<10) then lDato:='R0'+ IntToSTr(I3)+'  - '  else lDato:=' R'+ IntToSTr(I3)+'  - ';
              lSL2.Free;
              //----
              lCad := DameParametro(lIni.ReadString('VIDRIOS',lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString('VIDRIOS',lSL.Strings[I],''),5)+ ' - ';
              lCad2 := DameParametro(lIni.ReadString('VIDRIOS',lSL.Strings[I],''),10) + ' x ' + DameParametro(lIni.ReadString('VIDRIOS',lSL.Strings[I],''),11);
              if lTexto.IndexOf(lCad) < 0 then
              Begin
               lTexto.Add(lDato+lCad+lCad2);
               lImg :=  DameParametro(lIni.ReadString('VIDRIOS',lSL.Strings[I],''),1);
               InsertaImagen(lImg);
              end;
                //LOS JUNQUILLOS DE ESTE VIDRIO
                lSL2 := TStringList.Create;
                lIni.ReadSection('VIDRIOS',lSL2);
                If lSL2.Count > 0 then
                 For I := 0 to lSL2.Count-1 do
                  Begin
                   If lFiguraId  = DameParametro(lIni.ReadString('VIDRIOS',lSL.Strings[I],''),14) then
                     Begin
                       If DameParametro(lIni.ReadString('VIDRIOS',lSL.Strings[I],''),2) = '1' then
                         Begin
                           lPos:=StrToInt(DameParametro(lIni.ReadString('VIDRIOS',lSL.Strings[I],''),4));
                           If lPos=1 then lPosText:='Superior' else
                           If lPos=2 then lPosText:='Derecha' else
                           If lPos=3 then lPosText:='Inferior' else
                           If lPos=4 then lPosText:='Izquierda';

                           lCad := DameParametro(lIni.ReadString('VIDRIOS',lSL2.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString('VIDRIOS',lSL2.Strings[I],''),5)+ ' - ';
                           lCad2 := DameParametro(lIni.ReadString('VIDRIOS',lSL2.Strings[I],''),10);
                           lTexto.Add('           '+lCad+lCad2+ ' mm'+' -'+lPosText);
                           lImg :=  DameParametro(lIni.ReadString('VIDRIOS',lSL2.Strings[I],''),1);
                           InsertaImagen(lImg);
                         end;
                     end;
                  end;
                lSL2.Free;

                //LAS GOMAS DE ESTE VIDRIO
                lSL2 := TStringList.Create;
                lIni.ReadSection('GOMAVIDJUN',lSL2);
                If lSL2.Count > 0 then
                 For I := 0 to lSL2.Count-1 do
                  Begin
                   lCad :=DameParametro(lIni.ReadString('GOMAVIDJUN',lSL2.Strings[I],''),1);
                   If lFiguraId  = DameParametro(lIni.ReadString('GOMAVIDJUN',lSL2.Strings[I],''),14) then
                     Begin
                       lCad := DameParametro(lIni.ReadString('GOMAVIDJUN',lSL2.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString('GOMAVIDJUN',lSL2.Strings[I],''),5)+ ' - ';
                       lCad2 := DameParametro(lIni.ReadString('GOMAVIDJUN',lSL2.Strings[I],''),10);
                       lTexto.Add('           '+lCad+lCad2+ ' mm');
                       lImg :=  DameParametro(lIni.ReadString('GOMAVIDJUN',lSL2.Strings[I],''),1);
                       InsertaImagen(lImg);
                      end;
                  end;
                lSL2.Free;

                //LOS CALZOS DE ESTE VIDRIO
                lSL2 := TStringList.Create;
                lIni.ReadSection('CALZOSCRI',lSL2);
                If lSL2.Count > 0 then
                 For I := 0 to lSL2.Count-1 do
                  Begin
                   lCad :=DameParametro(lIni.ReadString('CALZOSCRI',lSL2.Strings[I],''),1);
                   If lFiguraId  = DameParametro(lIni.ReadString('CALZOSCRI',lSL2.Strings[I],''),14) then
                     Begin
                       lCad := DameParametro(lIni.ReadString('CALZOSCRI',lSL2.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString('CALZOSCRI',lSL2.Strings[I],''),5)+ ' - ';
                       lCad2 := DameParametro(lIni.ReadString('CALZOSCRI',lSL2.Strings[I],''),9);
                       lTexto.Add('           '+lCad+lCad2+ ' Unds');
                       lImg :=  DameParametro(lIni.ReadString('CALZOSCRI',lSL2.Strings[I],''),1);
                       InsertaImagen(lImg);
                      end;
                  end;
                lSL2.Free;

            end;

          end;
       lSL.Free;


       lTexto.Add('');
       lTexto.Add(STI_TEInin('CARRO CASILLA JUNQUILLOS: ',<LineaLoteT."DatosFabricacion">,'CARROSJUNQUILLO','Todos'));

     END; // --- FIN DE ACRISTALAMIENTO


     //ESPECIFICA PARA HERRAJES
     //ESPECIFICA PARA HERRAJES
     //ESPECIFICA PARA HERRAJES
     //ESPECIFICA PARA HERRAJES




    If (TAREAENCURSO='HERRAJEHOJA') then
BEGIN
  // Cargo la apertura y medidas de hoja
  lCad:='HUECOS';
  lSL := TStringList.Create;
  lIni.ReadSection(lCad,lSL);
  If (lSL.Count<>0) then
  Begin
    lTexto.Add('');
    lTexto.Add('Hoja ');
    For I := 0 to lSL.Count - 1 do
    begin
      if(Copy(lSL.Strings[I],1,3)<>Copy('R'+IntToStr(lRectangulo)+'=',1,3)) then continue;
      lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
      If (lTexto.IndexOf(lCad2) < 0) then
      Begin
        lTexto.Add(lCad2);
        lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
        InsertaImagen(lCad2);
      end;
    end;
  end;
  lSl.Free;

  lCad:='HOJA_ACT_HERRAJE';
  lSL := TStringList.Create;
  lIni.ReadSection(lCad,lSL);
  If (lSL.Count<>0) and (lHoja='1') then
  Begin
    lUso:='';lSituacion:=0;lDato:='';
    For I := 0 to lSL.Count - 1 do
    begin
      lUso:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
      lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
      If (lUso='2') and (Pos('km',lowercase(lDato)) <= 0) and (Pos('mk',lowercase(lDato)) <= 0) then
      Begin
        lCad2:=  DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5)+' '+DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
        If (lTexto.IndexOf(lCad2) < 0) then
        Begin
          lTexto.Add(lCad2);
          lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
          InsertaImagen(lCad2);
        end;
      end;
    end;
  end;
  lSl.Free;

  If SECCION='HOJA_PAS' then
  Begin
    lSL := TStringList.Create;
    lIni.ReadSection('INVERSOR',lSL);
    iF (lSL.Count>0) then lTexto.Add('');
    iF (lSL.Count>0) then lTexto.Add('INVERSOR:');
    For I := 0 to lSL.Count-1 do
    begin
      lCad2 := DameParametro(lIni.ReadString('INVERSOR',lSL.Strings[I],''),10);
      If (lCad2<>'0') then lCad2:=' - '+ lCad2 + ' mm' else lCad2:='';
      lCad := DameParametro(lIni.ReadString('INVERSOR',lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString('INVERSOR',lSL.Strings[I],''),5);
      if lTexto.IndexOf(lCad) < 0 then
      Begin
        lTexto.Add(lCad+lCad2);
        lImg :=  DameParametro(lIni.ReadString('INVERSOR',lSL.Strings[I],''),1);
        InsertaImagen(lImg);
      end;
    end;
    lSL.Free;
    lTexto.Add('');
    lTexto.Add(STI_TEInin('CARRO CASILLA INVERSOR: ',<LineaLoteT."DatosFabricacion">,'CARROSINVERSORES','Carros'));
  end;

  lCad:='HERRAJE';
  lSL := TStringList.Create;
  lIni.ReadSection(lCad,lSL);
  If (lSL.Count<>0) then
  Begin
    lTexto.Add('');
    lTexto.Add('Lado superior');
    lUso:='';lSituacion:=0;
    For I := 0 to lSL.Count - 1 do
    begin
      if(Copy(lSL.Strings[I],1,2)<>'R'+lHoja) then continue;
      lUso:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
      try
        lSituacion:= StrToInt(DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),4));
      except
        lSituacion := 0;
      end;
      lCad2 :=  DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
      lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
      If (lUso='2') and ((lSituacion>=40) or ((lSituacion>=1) and (lSituacion<=10))) and (lSituacion<>4) then
      Begin
        lCad2:=   DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5)+' ('+DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1)+'-'+IntToStr(lSituacion)+')';
        If (lTexto.IndexOf(lCad2) < 0) then
        Begin
          lTexto.Add(lCad2);
          lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
          InsertaImagen(lCad2);
        end;
      end;
    end;

    lTexto.Add('');
    lTexto.Add('Lado bisagra');
    lUso:='';lSituacion:=0;
    For I := 0 to lSL.Count - 1 do
    begin
      if(Copy(lSL.Strings[I],1,2)<>'R'+lHoja) then continue;
      lUso:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
      try
        lSituacion:= StrToInt(DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),4));
      except
        lSituacion := 0;
      end;
      lCad2 :=  DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
      lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
      If (lUso='2') and ((lSituacion>=10) and (lSituacion<=20)) then
      Begin
        lCad2:=   DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5)+' ('+DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1)+'-'+IntToStr(lSituacion)+')';
        If (lTexto.IndexOf(lCad2) < 0) then
        Begin
          lTexto.Add(lCad2);
          lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
          InsertaImagen(lCad2);
        end;
      end;
    end;

    lTexto.Add('');
    lTexto.Add('Lado inferior');
    lUso:='';lSituacion:=0;
    For I := 0 to lSL.Count - 1 do
    begin
      if(Copy(lSL.Strings[I],1,2)<>'R'+lHoja) then continue;
      lUso:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
      try
        lSituacion:= StrToInt(DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),4));
      except
        lSituacion := 0;
      end;
      lCad2 :=  DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
      lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
      If (lUso='2') and ((lSituacion>=20) and (lSituacion<=30)) then
      Begin
        lCad2:=   DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5)+' ('+DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1)+'-'+IntToStr(lSituacion)+')';
        If (lTexto.IndexOf(lCad2) < 0) then
        Begin
          lTexto.Add(lCad2);
          lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
          InsertaImagen(lCad2);
        end;
      end;
    end;

    lTexto.Add('');
    lTexto.Add('Lado cremona');
    lUso:='';lSituacion:=0;
    For I := 0 to lSL.Count - 1 do
    begin
      if(Copy(lSL.Strings[I],1,2)<>'R'+lHoja) then continue;
      lUso:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
      try
        lSituacion:= StrToInt(DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),4));
      except
        lSituacion := 0;
      end;
      lCad2 :=  DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
      lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
      If (lUso='2') and ((lSituacion=4) or ((lSituacion>=30) and (lSituacion<=40))) then
      Begin
        lCad2:=   DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5)+' ('+DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1)+'-'+IntToStr(lSituacion)+')';
        If (lTexto.IndexOf(lCad2) < 0) then
        Begin
          lTexto.Add(lCad2);
          lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
          InsertaImagen(lCad2);
        end;
      end;
    end;
  end;
  lSL.Free;

  If SECCION='HOJA_ACT' then
  Begin
    lTexto.Add('');
    lTexto.Add('');
    lCad:='************************************';
    lTexto.Add(lCad);
    lTexto.Add('');
    lCad:='    ESTA ES HOJA ACTIVA';
    lTexto.Add(lCad);
    lCad:='    NO TIENE INVERSOR';
    lTexto.Add(lCad);
    lTexto.Add('');
    lCad:='************************************';
    lTexto.Add(lCad);
    LMENSAJES := '***HOJA ACTIVA*** '+#13#10+'NO APLICABLE TAREA DE INVERSOR';
  end;
END;





    //FIN TAREA PHERRAJE

      //FIN TAREA PHERRAJE
        //FIN TAREA PHERRAJE  //FIN TAREA PHERRAJE
          //FIN TAREA PHERRAJE



















    //*** TAREA OPTIMIZACION - ANÁLISIS DE CORTES Y TIEMPOS ****
    If TAREAENCURSO='OPTIMIZACION' then
    BEGIN
      // Inicializar cronómetro si es la primera vez
      if TiempoInicioOptimizacion = 0 then
        TiempoInicioOptimizacion := Now;
      
      // SIMULACIÓN TIEMPO REAL: Llamar función que fuerza actualización
      SimularTiempoReal();
      
      // ACTUALIZACIÓN EN TIEMPO REAL: Recalcular siempre el tiempo actual
      ContadorOptimizacion := FormatearTiempoOptimizacion(TiempoInicioOptimizacion);
      
      // Agregar indicador visual de actividad (cambia cada segundo)
      IndicadorActividad := '';
      case Trunc(Frac(Now) * 86400) mod 4 of
        0: IndicadorActividad := '⏱️';
        1: IndicadorActividad := '⏰';
        2: IndicadorActividad := '🕐';
        3: IndicadorActividad := '⏲️';
      end;
      
      lTexto.Add('🔧 ESTACIÓN DE OPTIMIZACIÓN ' + IndicadorActividad);
      lTexto.Add('⏱️ Tiempo en estación: ' + ContadorOptimizacion);
      lTexto.Add('🔄 Última actualización: ' + FormatDateTime('hh:nn:ss', Now));
      lTexto.Add('📊 Estado: ACTIVO - Procesando en tiempo real');
      lTexto.Add('');
      lTexto.Add('� INFORMACIÓN DEL LOTE:');
      lTexto.Add('═══════════════════════════════');
      lTexto.Add('�📦 Fabricación: ' + IntToStr(<EstadoLineasLoteT."FabricacionNumero">));
      lTexto.Add('🏷️ Lote: ' + <EstadoLineasLoteT."CodigoLote">);
      lTexto.Add('📍 Línea: ' + IntToStr(<EstadoLineasLoteT."Linea">));
      lTexto.Add('🏭 Serie: ' + <EstadoLineasLoteT."FabricacionSerie">);
      lTexto.Add('📐 Módulo: ' + <EstadoLineasLoteT."Modulo">);
      lTexto.Add('📝 Descripción: ' + <EstadoLineasLoteT."Descripcion">);
      lTexto.Add('🔢 Cantidad: ' + IntToStr(<EstadoLineasLoteT."Cantidad">));
      
      // Información adicional si existe
      if <EstadoLineasLoteT."Cliente"> <> '' then
        lTexto.Add('👤 Cliente: ' + <EstadoLineasLoteT."Cliente">);
      if <EstadoLineasLoteT."Observaciones"> <> '' then
        lTexto.Add('📝 Observaciones: ' + <EstadoLineasLoteT."Observaciones">);
      
      lTexto.Add('✂️ Optimizando cortes del pedido...');
      
      // AGREGAR INFORMACIÓN DE COMPONENTES PARA OPTIMIZACIÓN
      lTexto.Add('');
      lTexto.Add('📋 COMPONENTES A OPTIMIZAR:');
      lTexto.Add('═══════════════════════════════');
      
      // Extraer componentes del INI para la línea actual
      lSL := ExtraerComponentesOptimizacion(lIni, <EstadoLineasLoteT."Linea">);
      if lSL.Count > 0 then
      begin
        for I := 0 to lSL.Count - 1 do
          lTexto.Add(lSL.Strings[I]);
      end
      else
      begin
        lTexto.Add('⚠️ No se encontraron componentes para línea ' + IntToStr(<EstadoLineasLoteT."Linea">));
      end;
      
      lSL.Free;
    END;

    //*** SIEMPRE COMO ULTIMA ****
    //CUANDO ESTAMOS EN MATRIMONIO TENGO QUE AÑADIR A LA INFORMACION DEL MARCO LA DE LAS HOJAS.
    If TAREAENCURSO='MATRIMONIO' then
    BEGIN
      lCad:='HERRAJEMARCO';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lTexto.Add('');
         lTexto.Add('HERRAJE');
         For I := 0 to lSL.Count - 1 do
           begin
            lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5) + '    (' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1)+')';
            //lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
            //lCad2:= lCad2 + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),10) + ' X ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),11);
            lTexto.Add(lCad2);
            lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
            InsertaImagen(lCad2);
           end;
        end;
       lSL.Free;
    lSL := TStringList.Create;
    lIni.ReadSection('HOJA_ACT',lSL);
    lRecAct := 0;
    if lSL.Count > 0 then lRecAct := StrToInt(Copy(lSL.Strings[0],2,Pos('.',lSL.Strings[0])-2));
    lSL.Free;

      lCad:='HUECOS';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lTexto.Add('');
         lTexto.Add('Marco ');
         For I := 0 to lSL.Count - 1 do
           begin
             // if(Copy(lSL.Strings[I],1,3)<>Copy('R'+IntToStr(lRectangulo)+'=',1,3)) then continue;
              lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              if(lDato <> '10')  then continue;
              lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
              If (lTexto.IndexOf(lCad2) < 0) then
               Begin

                lTexto.Add(lCad2);
                lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
                InsertaImagen(lCad2);
               end;
           end;

         lTexto.Add('');
         lTexto.Add('Hojas ');
         For I := 0 to lSL.Count - 1 do
           begin
             // if(Copy(lSL.Strings[I],1,3)<>Copy('R'+IntToStr(lRectangulo)+'=',1,3)) then continue;
              lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              if (lDato <> '20') then continue;
              lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
              If (lTexto.IndexOf(lCad2) < 0) then
               Begin

                lTexto.Add(lCad2);
                lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
                InsertaImagen(lCad2);
               end;
           end;
         end;
      lSl.Free;
{
    //Proceso la hoja activa
    SECCION:='HOJA_ACT';
    lSL := DameClavesRectanguloTipo(SECCION,lRecAct,1);
    If (lSL.Count<>0) then lTexto.Add('');
    If (lSL.Count<>0) then lTexto.Add('PERFILES HOJA ACTIVA');
    For I := 0 to lSL.Count-1 do
      begin
        lCad := DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),5) +
        '  - ' + DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),10)+ ' mm';
        lDato:= DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),3);

        lPos:=StrToInt(DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),4));
        If lPos=1 then lPosText:='Superior' else
        If lPos=2 then lPosText:='Derecha' else
        If lPos=3 then lPosText:='Inferior' else
        If lPos=4 then lPosText:='Izquierda';

        //así no metemos los refuerzos
        If (lDato='10') or (lDato='20') then
          begin
           lTexto.Add(lCad+' - '+lPosText);
           lID := Copy(lSL.Strings[I],Pos('.',lSL.Strings[I])+1,Length(lSL.Strings[I]));
           //ShowMessage(lID);

          //CARGO INFORMACION DESDE LOS MECANIZADOS VINCULADA CON LA TAREA EN CURSO

           //ADJUNTO ARTICULO VINCULADO AL MECANIZADO
           lSL2 := DameClavesMecArti(lIni,TAREAENCURSO+'_MEC_ARTI',StrToInt(lID));
           For I2 := 0 to lSL2.Count - 1 do
            begin
              lCad:=DameParametro(lIni.ReadString(TAREAENCURSO+'_MEC_ARTI',lSL2.Strings[I2],''),1) + ' - ' +DameParametro(lIni.ReadString(TAREAENCURSO+'_MEC_ARTI',lSL2.Strings[I2],''),2);
              lTexto.Add('                        ('+lCad+')');
            end;
              lSL2.Free;

            //ADJUNTO LAS IMAGENES EXISTENTES EN LOS MECANIZADOS
            lSL2 := DameClavesMecArti(lIni,TAREAENCURSO+'_MEC_IMAGEN',StrToInt(lID));
            lCad:='';
            For I2 := 0 to lSL2.Count - 1 do
              begin
                lCad:=DameParametro(lIni.ReadString(TAREAENCURSO+'_MEC_IMAGEN',lSL2.Strings[I2],''),1);
                InsertaImagen(lCad);
              end;
              lSL2.Free;

           end;
          end;
         lSL.Free;


    //Proceso la hoja pasiva
    lSL := TStringList.Create;
    lIni.ReadSection('HOJA_PAS',lSL);
    lRecPas := 0;
    if lSL.Count > 0 then lRecPas := StrToInt(Copy(lSL.Strings[0],2,Pos('.',lSL.Strings[0])-2));
    lSL.Free;

    SECCION:='HOJA_PAS';
    lSL := DameClavesRectanguloTipo(SECCION,lRecPas,1);
    If (lSL.Count<>0) then lTexto.Add('');
    If (lSL.Count<>0) then lTexto.Add('PERFILES HOJA PASIVA');
    For I := 0 to lSL.Count-1 do
      begin
        lCad := DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),5) +
        '  - ' + DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),10)+ ' mm';
        lDato:= DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),3);

        lPos:=StrToInt(DameParametro(lIni.ReadString(SECCION,lSL.Strings[I],''),4));
        If lPos=1 then lPosText:='Superior' else
        If lPos=2 then lPosText:='Derecha' else
        If lPos=3 then lPosText:='Inferior' else
        If lPos=4 then lPosText:='Izquierda';

        //así no metemos los refuerzos
        If (lDato='10') or (lDato='20') then
          begin
           lTexto.Add(lCad+' - '+lPosText);
           lID := Copy(lSL.Strings[I],Pos('.',lSL.Strings[I])+1,Length(lSL.Strings[I]));
           //ShowMessage(lID);

          //CARGO INFORMACION DESDE LOS MECANIZADOS VINCULADA CON LA TAREA EN CURSO

           //ADJUNTO ARTICULO VINCULADO AL MECANIZADO
           lSL2 := DameClavesMecArti(lIni,TAREAENCURSO+'_MEC_ARTI',StrToInt(lID));
           For I2 := 0 to lSL2.Count - 1 do
            begin
              lCad:=DameParametro(lIni.ReadString(TAREAENCURSO+'_MEC_ARTI',lSL2.Strings[I2],''),1) + ' - ' +DameParametro(lIni.ReadString(TAREAENCURSO+'_MEC_ARTI',lSL2.Strings[I2],''),2);
              lTexto.Add('                        ('+lCad+')');
            end;
              lSL2.Free;

            //ADJUNTO LAS IMAGENES EXISTENTES EN LOS MECANIZADOS
            lSL2 := DameClavesMecArti(lIni,TAREAENCURSO+'_MEC_IMAGEN',StrToInt(lID));
            lCad:='';
            For I2 := 0 to lSL2.Count - 1 do
              begin
                lCad:=DameParametro(lIni.ReadString(TAREAENCURSO+'_MEC_IMAGEN',lSL2.Strings[I2],''),1);
                InsertaImagen(lCad);
              end;
              lSL2.Free;


           end;
        end;
        lSL.Free;

}
      lCad:='HERRAJECOLGADO';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lTexto.Add('');
         lTexto.Add('HERRAJE');
         For I := 0 to lSL.Count - 1 do
           begin
            lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5) + '    (' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1)+')';
            //lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
            //lCad2:= lCad2 + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),10) + ' X ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),11);
            lTexto.Add(lCad2);
            lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
            InsertaImagen(lCad2);
           end;
        end;
       lSL.Free;
      lCad:='HERRAJEREMATE';
      lSL := TStringList.Create;
      lIni.ReadSection(lCad,lSL);
      If (lSL.Count<>0) then
        Begin
         lTexto.Add('');
         lTexto.Add('HERRAJE REMATE');
         For I := 0 to lSL.Count - 1 do
           begin
            lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5) + '    (' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1)+')';
            //lCad2:= lCad2 + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),10) + ' X ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),11);
            lTexto.Add(lCad2);
            lCad2:=DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
            InsertaImagen(lCad2);
           end;
        end;
       lSL.Free;
      END; // PROCESADO DE HOJAS PARA MATRIMONIO


   lTOTAL := lTexto.Text;




  END; ///-------------------------------------------FIN TAREAS LINEA NUEVA-------------------------------------------------------------------------

  MemoTotal.text :=LTOTAL;



  lTexto.Free;
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

procedure InsertaImagen(pImagen : String);
//Inserta una imagen desde un fichero
//Ejemplo: InsertaImagen('CERSEG000');
var lFile : String;
begin
  lFile := RutaImg + pImagen + '.png';

  if NumImg >= 8 then Exit; //Máximo de imágenes cargadas
  If Not FileExists(lFile) then //Por si no existe el archivo de imagen
  begin
    lFile := RutaImg + pImagen + '.jpg';
    If Not FileExists(lFile) then Exit; //Por si no existe el archivo de imagen
  end;
  If Imagenes.IndexOf(pImagen) > -1 then Exit;

  if NumImg = 0 then Pic1.LoadFromFile(lFile) else
  if NumImg = 1 then Pic2.LoadFromFile(lFile) else
  if NumImg = 2 then Pic3.LoadFromFile(lFile) else
  if NumImg = 3 then Pic4.LoadFromFile(lFile) else
  if NumImg = 4 then Pic5.LoadFromFile(lFile) else
  if NumImg = 5 then Pic6.LoadFromFile(lFile) else
  if NumImg = 6 then Pic7.LoadFromFile(lFile) else
  if NumImg = 7 then Pic8.LoadFromFile(lFile);

  Imagenes.Add(pImagen);
  NumImg := NumImg + 1;
end;

//----------------------------------------------------------------------------------------------------


procedure MasterData3OnBeforePrint(Sender: TfrxComponent);
begin

end;

begin
  Imagenes := TStringList.Create;
  lMostrarComandos := false;
  
  // Control del cronómetro de OPTIMIZACION
  // Si cambiamos de tarea, reseteamos el cronómetro
  if <CodigoTarea> <> 'OPTIMIZACION' then
    TiempoInicioOptimizacion := 0;
  
  //Preparo la consulta de siguientes rectángulos:
  if <CodigoTarea> = 'MATRIMONIO'
    then SigRectT.SQL.Text := 'call F_ELEMENTOS_VENTANA_ALMACEN(''' + <CodigoPuesto> + ''', 0, ''' + <CodBarrasRect> + ''', ''C'', '''');';

end.