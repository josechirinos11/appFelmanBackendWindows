uses  SysUtils, StrUtils, Huecos, Figuras, uSistema, uAnalizador, uCalculador, uDatosHueco,uGeometrias,
      uGeometriasAristas,uAristas,uglobal,uCIN_Ini,uUtilidadesScripts,MyAccess, DB;
//Marco de ventana practicable

function Calcula(pHueco : THueco; pFigura : TFigura; pSistema : TSistema;
                  pAnalizador : TAnalizador; pId : Integer; pSerie : String;
                  pNumero : Integer; pLinea : Integer): Integer;

var
  PerfilSup, PerfilDer, PerfilInf, PerfilIzq, AcabI, AcabE, AcabEsc, AcabDes,AcabKitInst : String;
  Hueco : THueco;
  lPer,lPer2: TPerfil;
  lPadreDeTope : Boolean;
  lAltCorte, lDistCorte,lRetestado : Double;
  lArista : TArista;
  lCodTapa ,lAIREADOR,AcabAir,Descripcion,lKitInst,CodMObra,lKitSold : String;
  TiempoMano,lCuerpo, lAlaInt, lAlaExt , lAncho, lSoldadura, lXAncho,lXAlto : Double;
  I, lCantTapas, N_Tramos : Integer;
  Perfil : TPerfil;
  //PARA  KITS COLOCACION
  lMarcoAct : integer;
  lMarcoAct_PERI :Double;  
  
  //Informacion Ini txt cliente
  lID,lLongId,lNumRec : Integer;
  lCarro,lCasilla,lIDinicial,Ix : Integer;
  lID_Rec,lPerfil,Descripcion2,lTareaTerminal : String;
  lConForma,lDiferente : Bolean;
  lIni : TCIN_IniFile;
  lSQL : TMyQuery;
  
  //Para Tiempos Teminales Especiales
  lTT,TT_FIGURA_NUM : Integer;
  TT_FIGURA,TT_MO,TT_MODESC : String;
  TT_MIN : Double;
  
  //Para carga de kits espeicales a demanda
  lKIT,KIT_FIGURA_NUM : Integer;
  KIT_FIGURA,KIT_DESCINFO,KIT_COD,KIT_ACABI,KIT_ACABE : String;
  KIT_ANCHO,KIT_ALTO : Double;  
  
  //Descricpiones especiales añandidas desde el ini
  DES_FIGURA_NUM,lDES,DES_FIGURA_TIPO : Integer;
  DES_DATO : Double;
  DES_DESCINFO,DES_DESCINFO2,DES_FIGURA,lDescripcionINI : String;  

begin
  lAltCorte := 0; lDistCorte := 0;
  //----------------------------------------------------------------------------
  //---------------------------- INICIALIZACIONES ------------------------------
  //----------------------------------------------------------------------------

  Result := pID;

  lAlaInt:=0; lAlaExt:=0;lAncho:=0; lCuerpo:=0;

  PerfilSup := pAnalizador.BVarn('MS');
  PerfilDer := pAnalizador.BVarn('MD');
  PerfilInf := pAnalizador.BVarn('MI');
  PerfilIzq := pAnalizador.BVarn('MZ');
  lSoldadura := pAnalizador.BVar('SOLD');
  lKitSold:= pAnalizador.BVarn('KITSOLDCOD'); //Kit de control del hueco de perfiles para soldadura
  AcabI := pAnalizador.BVarn('ACABADO.I');
  AcabE := pAnalizador.BVarn('ACABADO.E');                     
  AcabEsc := pAnalizador.BVarn('ACABADOA.I'); //Acabado de escuadras   
  AcabDes := pAnalizador.BVarn('ACABADOA.E'); //Tapas de desagüe
  lAIREADOR := pAnalizador.BVarn('AIRMARCO');  //Aireado de marco
  AcabAir :=  pAnalizador.BVarn('ACAB_AIR');   //Acabado del aireador en marco
  lKitInst := pAnalizador.BVarn('KITINST');   //Kit instalacion de marco
  AcabKitInst := pAnalizador.BVarn('ACABADOA.I'); //Acabado para el kit de instalacion
  Descripcion :='';
  CodMObra :='';
  N_Tramos:=0;
  If (PerfilSup<>'') then N_Tramos:=N_Tramos+1;
  If (PerfilDer<>'') then N_Tramos:=N_Tramos+1;
  If (PerfilInf<>'') then N_Tramos:=N_Tramos+1;
  If (PerfilIzq<>'') then N_Tramos:=N_Tramos+1;
   

  //Tapa de desague
  If pAnalizador.BVar('CO') = 0 then lCodTapa := pAnalizador.BVarn('TDM1') else lCodTapa := pAnalizador.BVarn('TDM2');
  
  


   //Miramos qué es el padre para saber como unir las piezas:
   lPadreDeTope := False;
   if pHueco.FiguraPadre <> nil then lPadreDeTope := EsPadreDeTope(pHueco.FiguraPadre);

   
   //Despues de comprobaciones si es no padre de tope asigno valor o no a lretestado
   If lPadreDeTope=true then lRetestado:=pAnalizador.BVar('RET') else lRetestado:=0;
   //A PARTIR DE 19-09-2023 se aplica retestado de forma automatica, salvo que el perfil contactado tenga en variables ANULAR_RET con valor 1
   


  //Longitud del marco para las oscilo-paralelas
  pAnalizador.Obt_exp('LONMAR='+floattostr(pFigura.Hueco(5).Ancho));
  pAnalizador.Obt_exp('LONMARH='+floattostr(pFigura.Hueco(5).Alto));     
     
  //showmessage(pAnalizador.Obt_exp('LONMAR'));
  
  
  //Anadido para kits de colocacion 04/04/2022
  //Guardamos el numero de rectangulos de marco y su perimetro
  lMarcoAct:=0;lMarcoAct_PERI:=0;  
  
  pSistema.Calculador.DameAnalizador1.Obt_exp('COLMARCOSV=COLMARCOSV+1');
  lMarcoAct:=pSistema.Calculador.DameAnalizador1.Obt_exp('COLMARCOSV');
  lMarcoAct_PERI:=pHueco.DameLongitudAristasEnPosicion(1)+pHueco.DameLongitudAristasEnPosicion(2)+pHueco.DameLongitudAristasEnPosicion(3)+pHueco.DameLongitudAristasEnPosicion(4);
  pSistema.Calculador.DameAnalizador1.Obt_exp('COLMARCOSV'+IntToStr(lMarcoAct)+'_PERI='+FloatToStr(lMarcoAct_PERI));  
  
  
  //----------------------------------------------------------------------------
  //--------------------- DERCRIPCION OFERTA PROFESIONAL -----------------------
  //----------------------------------------------------------------------------  
    lIni := pSistema.Calculador.DameIniTxTCliente;
    Descripcion:='';
    Descripcion:=pSistema.Calculador.DameDescripcionTecnica(pAnalizador.BVarn('MA'));
    Descripcion:=pSistema.Calculador.DameDescripcionPresupuesto(pAnalizador.BVarn('MA'));
    Descripcion:=pSistema.Calculador.DameDescripcionArticulo(pAnalizador.BVarn('MA'));     
    lIni.WriteStringSimple('PERFILESUSADOS','R0.MARCO='+pAnalizador.BVarn('MA')+'.'+Descripcion);
    lIni.WriteStringSimple('INFORMACIONJOSECHIRINOS', 'INFOJOSE=ENVIO info DESDE SICA');
    //Guardo el nuevo ini:
    pSistema.Calculador.GuardaIniTxtCliente(lIni);    
    //Importante!  
    lIni.Free;    
  
  
  //----------------------------------------------------------------------------
  //----------------------- PERFILES TAPAS Y EXTRAS ----------------------------
  //----------------------------------------------------------------------------

  //Guardo en txtcliente el dato de hueco
  lIni := pSistema.Calculador.DameIniTxTCliente;
  Descripcion:='Marco ventana';
  pSistema.Calculador.DatosPerfil(PerfilSup,lCuerpo,lAlaInt,lAlaExt,lAncho);
  Descripcion:=Descripcion+'. Ancho '+FloatToStr(pFigura.Hueco(5).ancho+lCuerpo+lCuerpo+lAlaExt+lAlaExt);
  pSistema.Calculador.DatosPerfil(PerfilDer,lCuerpo,lAlaInt,lAlaExt,lAncho);
  Descripcion:=Descripcion+' alto '+FloatToStr(pFigura.Hueco(5).alto+lCuerpo+lCuerpo+lAlaExt+lAlaExt);  
  Descripcion:=Descripcion+';'+PerfilSup;
  If pSistema.Calculador.DameDescripcionTecnica(PerfilSup)<>'' then  Descripcion:=Descripcion+';'+pSistema.Calculador.DameDescripcionTecnica(PerfilSup)
  else Descripcion:=Descripcion+';'+pSistema.Calculador.DameDescripcionArticulo(PerfilSup);  
  lIni.WriteStringSimple('HUECOS','R'+IntToStr(pFigura.Hueco(5).Id)+'='+'10;'+Descripcion);
  pSistema.Calculador.GuardaIniTxtCliente(lIni);     
  lIni.Free;
  
  
  
  //Generamos los perfiles del marco:
  lTareaTerminal:='';
  lTareaTerminal:=pAnalizador.Obt_expn('TAR_MAR_VENT');  
  Hueco := pFigura.Hueco(5);
  Result := GeneraDescompuestos(pSistema,Hueco, pSerie, pNumero, pLinea, Result, pFigura.Id,
                                PerfilSup,PerfilDer,PerfilInf,PerfilIzq, AcabI, AcabE, '','', 'marco',
                                lRetestado,lSoldadura, True,True,lPadreDeTope,
                                '','','','', //Código de accesorios
                                0,0,0,0, //Cant de accesorios
                                0,0,0,0, //Modo de aplic de los accesorios
                                False, //Forzar perfiles "no generados"
                                AcabEsc,AcabDes, //Acabado escuadras, acabado topes
                                '','','','',lTareaTerminal); //Acabado de los 4 accesorios

  //Proceso Tapas de desague:
  Perfil := CreaPerfil;
  lArista := pHueco.Arista(0);
  if lCodTapa <> '' then
  For I := 0 to pHueco.NumAristas - 1 do
    begin

      //Si no hay perfil inferior no hago nada:
      if pAnalizador.BVar('MI') = 0 then break;

      //Tapas de desagüe, solo si el perfil inferior es "plano":
      if (lArista.Posicion = aInferior) AND (lArista.EsHorizontal) then
        begin
          //Obtengo los datos de la arista:
          pSistema.Calculador.DatosPerfil(PerfilInf,lCuerpo,lAlaInt,lAncho,lAlaExt);
          ProcesaPerfil(lArista,Perfil,lAlaInt,lCuerpo,lAlaExt);

          If pAnalizador.BVar('NUMTAPDES')<>0 then
          Begin
             lCantTapas := pAnalizador.BVar('NUMTAPDES');
          end else
          Begin
           //si uso condensacion
           If Perfil.Longitud > pAnalizador.BVar('LON_TDM5') then lCantTapas := 5 else
           If Perfil.Longitud > pAnalizador.BVar('LON_TDM4') then lCantTapas := 4 else
           If Perfil.Longitud > pAnalizador.BVar('LON_TDM3') then lCantTapas := 3 else lCantTapas := 2;
          end
          lTareaTerminal:='';
          lTareaTerminal:=pAnalizador.Obt_expn('TAR_MAR_VENT_TAPDES');          
          //Ahora añado la arista: (para poder sumar el retestado lo hago al final)
          Result := pSistema.Calculador.AnadeComponente(pSerie, pNumero, pLinea, Result, pFigura.ID, //IDs de la pieza y la figura
                                         lCodTapa, AcabDes,'', //Codigo de pieza y Acabados accesorios exterior
                                         0,0,0, //Medidas A,B y C
                                         lCantTapas {Cantidad}, 0, 0 {Corte1 y 2},
                                         0 {LinkID}, 0 {Situacion}, 0 {Num Rectangulo},
                                         True {Exterior}, True {Insertar sus auxiliares},
                                         'Tapas de desagüe' {Info}, '' {Familia Padre},
                                         0 {Grupo}, 0 {Tipo Segmento},
                                         0, 0 {Tipos Cortes},nil,'',0, 0, 0, 0, 0, 0 ,0,0, '', 0, 0, 90, 90, false, lTareaTerminal);
          Break;
        end;
      lArista := lArista.Siguiente;
    end;

  //----------------------------------------------------------------------------
  //----------------------- RESTO DE OPCIONES ----------------------------------
  //----------------------------------------------------------------------------

  //Mano de obra unificada para el marco
  If (pAnalizador.BVar('T_MARCO_VENTANA')<> 0) then
  Begin
    TiempoMano := (pAnalizador.BVar('T_MARCO_VENTANA')/4)*N_Tramos;
    lTareaTerminal:='';
    lTareaTerminal:=pAnalizador.Obt_expn('TAR_T_MARCO_VENTANA');    
    If (TiempoMano <> 0 ) then
    Result := pSistema.Calculador.AnadeComponente(pSerie, pNumero, pLinea, Result, pFigura.ID, //IDs de la pieza y la figura
                                               'MOFABRIC', '', '', //Codigo de pieza y Acabados
                                               0,0,0, //Medidas A,B y C
                                               TiempoMano {Cantidad},0,0 {Corte1 y 2},
                                               0 {LinkID}, 0 {Situacion},
                                               0 {Num Rectangulo}, False {Si es exterior},
                                               True {Insertar sus auxiliares},'Tiempo Marco Ventana' {Info},
                                               '' {Familia}, 0 {Grupo},0 {Tipo Segmento},
                                               0,0 {Tipos Cortes},nil,'',0, 0, 0, 0, 0, 0 ,0,0, '', 0, 0, 90, 90, false, lTareaTerminal);
  end;


  //MANO DE OBRA DE TIEMPOS DESGLOSADOS - O PARA TERMINALES.
  If (pAnalizador.BVari('TT_ACTIVAR')=1) then
  Begin
      //Tiempo de corte----------------------------------------------------------------------------------------------------------------
      If (pAnalizador.BVar('TT_MAR_VEN_COR')<> 0) then
      Begin
      lTareaTerminal:='';
      lTareaTerminal:=pAnalizador.Obt_expn('TAR_TT_MAR_VEN_COR');
      TiempoMano := (pAnalizador.BVar('TT_MAR_VEN_COR')/4)*N_Tramos;
      If (pAnalizador.BVarn('TT_MAR_VEN_COR_MO')<>'') then CodMObra:= pAnalizador.BVarn('TT_MAR_VEN_COR_MO') else CodMObra:='MOCORTAR';
      Result := pSistema.Calculador.AnadeComponente(pSerie, pNumero, pLinea, Result, pFigura.ID, //IDs de la pieza y la figura
                                                 CodMObra, '', '', //Codigo de pieza y Acabados
                                                 0,0,0, //Medidas A,B y C
                                                 TiempoMano {Cantidad},0,0 {Corte1 y 2},
                                                 0 {LinkID}, 0 {Situacion},
                                                 0 {Num Rectangulo}, False {Si es exterior},
                                                 True {Insertar sus auxiliares},'Marco Ventana-Cortar' {Info},
                                                 '' {Familia}, 0 {Grupo},0 {Tipo Segmento},
                                                 0,0 {Tipos Cortes});
      end;

      //Tiempo de mecanizado-------------------------------------------------------------------------------------------------------------
      If (pAnalizador.BVar('TT_MAR_VEN_MEC')<> 0) then
      Begin
      TiempoMano := (pAnalizador.BVar('TT_MAR_VEN_MEC')/4)*N_Tramos;
      lTareaTerminal:='';
      lTareaTerminal:=pAnalizador.Obt_expn('TAR_TT_MAR_VEN_MEC');
      If (pAnalizador.BVarn('TT_MAR_VEN_MEC_MO')<>'') then CodMObra:= pAnalizador.BVarn('TT_MAR_VEN_MEC_MO') else CodMObra:='MOMECANIZAR';
      Result := pSistema.Calculador.AnadeComponente(pSerie, pNumero, pLinea, Result, pFigura.ID, //IDs de la pieza y la figura
                                                 CodMObra, '', '', //Codigo de pieza y Acabados
                                                 0,0,0, //Medidas A,B y C
                                                 TiempoMano {Cantidad},0,0 {Corte1 y 2},
                                                 0 {LinkID}, 0 {Situacion},
                                                 0 {Num Rectangulo}, False {Si es exterior},
                                                 True {Insertar sus auxiliares},'Marco Ventana-Mecanizar' {Info},
                                                 '' {Familia}, 0 {Grupo},0 {Tipo Segmento},
                                                 0,0 {Tipos Cortes},nil,'',0, 0, 0, 0, 0, 0 ,0,0, '', 0, 0, 90, 90, false, lTareaTerminal);
      end;

      //Tiempo de amar --------------------------------------------------------------------------------------------------------------------
      If (pAnalizador.BVar('TT_MAR_VEN_ARM')<> 0) then
      Begin
      TiempoMano := (pAnalizador.BVar('TT_MAR_VEN_ARM')/4)*N_Tramos;
      lTareaTerminal:='';
      lTareaTerminal:=pAnalizador.Obt_expn('TAR_TT_MAR_VEN_ARM');
      If (pAnalizador.BVarn('TT_MAR_VEN_ARM_MO')<>'') then CodMObra:= pAnalizador.BVarn('TT_MAR_VEN_ARM_MO') else CodMObra:='MOARMAR';
      Result := pSistema.Calculador.AnadeComponente(pSerie, pNumero, pLinea, Result, pFigura.ID, //IDs de la pieza y la figura
                                                 CodMObra, '', '', //Codigo de pieza y Acabados
                                                 0,0,0, //Medidas A,B y C
                                                 TiempoMano {Cantidad},0,0 {Corte1 y 2},
                                                 0 {LinkID}, 0 {Situacion},
                                                 0 {Num Rectangulo}, False {Si es exterior},
                                                 True {Insertar sus auxiliares},'Marco Ventana-Armar' {Info},
                                                 '' {Familia}, 0 {Grupo},0 {Tipo Segmento},
                                                 0,0 {Tipos Cortes},nil,'',0, 0, 0, 0, 0, 0 ,0,0, '', 0, 0, 90, 90, false, lTareaTerminal);
      end;


      //Al terminar vuelvo a inicializar la variable de codigo de mano de obra
      CodMObra:='';
  end;


  //Si hay aireador lo metemos

  If (lAIREADOR<>'') then
  Begin
    lTareaTerminal:='';
    lTareaTerminal:=pAnalizador.Obt_expn('TAR_AIRMARCO');  
    Result := pSistema.Calculador.AnadeComponente(pSerie, pNumero, pLinea, Result, pFigura.ID, //IDs de la pieza y la figura
                                             lAIREADOR, AcabAir, '', //Codigo de pieza y Acabados
                                             pFigura.HuecoPadre.Ancho,pFigura.HuecoPadre.Alto,0, //Medidas A,B y C
                                             1,0,0, {Cantidad, Corte1 y Corte1}
                                             0,0, {LinkID y Situación}
                                             0, False, {Num Rectangulo y Si es exterior}
                                             True {Insertar sus auxiliares}, 'Pieza aireador en marco'{Info},
                                             '' {Familia}, 0 {Grupo},0 {Tipo Segmento},
                                             0,0 {Tipos Cortes},nil,'',0, 0, 0, 0, 0, 0 ,0,0, '', 0, 0, 90, 90, false, lTareaTerminal);


  end;

//Si hay kit instalacion lo metemos

  If (lKitInst<>'') then
  Begin
  //Si se mete kit de instalación primero guardo ancho y alto del hueco de marco para el usar dentro del kit
  pAnalizador.Obt_exp('KINST_L='+floattostr(pFigura.HuecoPadre.Ancho));
  pAnalizador.Obt_exp('KINST_H='+floattostr(pFigura.HuecoPadre.Alto));
  
  lTareaTerminal:='';
  lTareaTerminal:=pAnalizador.Obt_expn('TAR_MARVENT_KITINST');  
  Result := pSistema.Calculador.AnadeComponente(pSerie, pNumero, pLinea, Result, pFigura.ID, //IDs de la pieza y la figura
                                             lKitInst, AcabKitInst, AcabKitInst, //Codigo de pieza y Acabados
                                             pFigura.HuecoPadre.Ancho,pFigura.HuecoPadre.Alto,0, //Medidas A,B y C
                                             1,0,0, {Cantidad, Corte1 y Corte1}
                                             0,0, {LinkID y Situación}
                                             0, False, {Num Rectangulo y Si es exterior}
                                             True {Insertar sus auxiliares}, 'Kit instalación en marco'{Info},
                                             '' {Familia}, 0 {Grupo},0 {Tipo Segmento},
                                             0,0 {Tipos Cortes},nil,'',0, 0, 0, 0, 0, 0 ,0,0, '', 0, 0, 90, 90, false, lTareaTerminal);

  end;
  
  //Kit de control del hueco de perfiles para series con soldadura  
  If  (lKitSold <> '') then
      Begin
        //Ver si el hueco tiene forma o no
        If (pFigura.Hueco(0).AngulosDistintos90SinCurvas<>0) or (pFigura.Hueco(0).AristasCurvas<>0) then pAnalizador.Obt_exp('HUECO_CON_FORMA=1') 
        else  pAnalizador.Obt_exp('HUECO_CON_FORMA=0');

        pAnalizador.Obt_exp('KITSOLD_PSUP='+FloatToSTr(pFigura.Hueco(0).DameLongitudAristasEnPosicion(1)+ pAnalizador.BVar('MD.CUERPO')+ pAnalizador.BVar('MZ.CUERPO') + pAnalizador.BVar('MD.ALAEXT')+ pAnalizador.BVar('MZ.ALAEXT')));
        pAnalizador.Obt_exp('KITSOLD_PDER='+FloatToSTr(pFigura.Hueco(0).DameLongitudAristasEnPosicion(2)+ pAnalizador.BVar('MS.CUERPO')+ pAnalizador.BVar('MI.CUERPO') + pAnalizador.BVar('MS.ALAEXT')+ pAnalizador.BVar('MI.ALAEXT')));
        pAnalizador.Obt_exp('KITSOLD_PINF='+FloatToSTr(pFigura.Hueco(0).DameLongitudAristasEnPosicion(3)+ pAnalizador.BVar('MD.CUERPO')+ pAnalizador.BVar('MZ.CUERPO') + pAnalizador.BVar('MD.ALAEXT')+ pAnalizador.BVar('MZ.ALAEXT')));
        pAnalizador.Obt_exp('KITSOLD_PIZQ='+FloatToSTr(pFigura.Hueco(0).DameLongitudAristasEnPosicion(4)+ pAnalizador.BVar('MS.CUERPO')+ pAnalizador.BVar('MI.CUERPO') + pAnalizador.BVar('MS.ALAEXT')+ pAnalizador.BVar('MD.ALAEXT')));

        pAnalizador.Obt_exp('KITSOLD_TIPOP=10'); //Tipo perfil
        
        lTareaTerminal:='';
        lTareaTerminal:=pAnalizador.Obt_expn('TAR_MARVENT_KITSOLD');
        Result := pSistema.Calculador.AnadeComponente(pSerie, pNumero, pLinea, Result, pFigura.ID, //IDs de la pieza y la figura
                                                      lKitSold, AcabI,'', //Codigo de pieza y Acabados
                                                      0,0,0, //Medidas A,B y C
                                                      1 {Cantidad},0,0 {Corte1 y 2},
                                                      0 {LinkID}, 0 {Situacion},
                                                      0 {Num Rectangulo}, False {Si es exterior},
                                                      True {Insertar sus auxiliares},'Kit hueco de perfiles soldadura' {Info},
                                                      '' {Familia}, 0 {Grupo},0 {Tipo Segmento},
                                                      0,0 {Tipos Cortes}, Hueco,'',0, 0, 0, 0, 0, 0 ,0,0, '', 0, 0, 90, 90, false, lTareaTerminal);


      end;


  //----------------------------------------------------------------------------
  //------------------ TIEMPOS ESPECIALES PARA TERMINALES ----------------------
  //----------------------------------------------------------------------------
  TT_FIGURA_NUM:=0;
  TT_FIGURA := pAnalizador.Obt_expn('FIGURA');
  TT_FIGURA_NUM := pAnalizador.Obt_exp('TT_' + TT_FIGURA + '_NUM');

  If (TT_FIGURA_NUM <> 0) then
   Begin
   //Inicializamos la variable
   TT_MO := '';
   TT_MIN := 0;
   TT_MODESC := '';
     //Analizamos el bucle
     For lTT :=1 to TT_FIGURA_NUM do
      Begin
       TT_MO := pAnalizador.Obt_expn('TT_'+ TT_FIGURA + IntToStr(lTT) + '_COD');
       TT_MODESC := pAnalizador.Obt_expn('TT_' + TT_FIGURA + IntToStr(lTT) + '_TEX');
       TT_MIN := pAnalizador.Obt_exp('TT_' + TT_FIGURA +IntToStr(lTT) + '_UND');

       //Generamos los tiempos
       If (TT_MIN<>0) then
        Begin
         TiempoMano := (TT_MIN/4)*N_Tramos;
         lTareaTerminal:='';
         lTareaTerminal:=pAnalizador.Obt_expn('TT_'+ TT_FIGURA + IntToStr(lTT) + '_TAREA');         
         Result := pSistema.Calculador.AnadeComponente(pSerie, pNumero, pLinea, Result, pFigura.ID, //IDs de la pieza y la figura
                                                 TT_MO, '', '', //Codigo de pieza y Acabados
                                                 0,0,0, //Medidas A,B y C
                                                 TiempoMano {Cantidad},0,0 {Corte1 y 2},
                                                 0 {LinkID}, 0 {Situacion},
                                                 0 {Num Rectangulo}, False {Si es exterior},
                                                 True {Insertar sus auxiliares},TT_MODESC {Info},
                                                 '' {Familia}, 0 {Grupo},0 {Tipo Segmento},
                                                 0,0 {Tipos Cortes},NIL,'',0, 0, 0, 0,0, 0 ,0, 0,'', 0, 0, 90, 90, false, lTareaTerminal);
        end;
      end;
   end;


  //--------------------------------------------------------------------------------------------------------------------------------------
  //------------------ AUTO CARGA DE KITS  ESPECIALES SEGUN NECESIDAD ----------------------
  //--------------------------------------------------------------------------------------------------------------------------------------
  KIT_FIGURA_NUM:=0;
  KIT_FIGURA := pAnalizador.Obt_expn('FIGURA');
  KIT_FIGURA_NUM := pAnalizador.Obt_exp('KIT_' + KIT_FIGURA + '_NUM');

  If (KIT_FIGURA_NUM <> 0) then
   Begin
   //Inicializamos la variable
   KIT_COD := '';
   KIT_DESCINFO := '';
   KIT_ANCHO:=0;
   KIT_ALTO:=0;
     //Analizamos el bucle
     For lKIT :=1 to KIT_FIGURA_NUM do
      Begin
       KIT_COD := pAnalizador.Obt_expn('KIT_'+ KIT_FIGURA + IntToStr(lKIT) + '_COD');
       KIT_DESCINFO := pAnalizador.Obt_expn('KIT_' + KIT_FIGURA + IntToStr(lKIT) + '_DESCINFO');
       KIT_ANCHO := pAnalizador.Obt_exp('KIT_' + KIT_FIGURA +IntToStr(lKIT) + '_ANCHO');
       KIT_ALTO := pAnalizador.Obt_exp('KIT_' + KIT_FIGURA +IntToStr(lKIT) + '_ALTO');
       KIT_ACABI := pAnalizador.Obt_expn('KIT_' + KIT_FIGURA +IntToStr(lKIT) + '_ACABI');    
       KIT_ACABE := pAnalizador.Obt_expn('KIT_' + KIT_FIGURA +IntToStr(lKIT) + '_ACABE'); 

       //Generamos los kits
       If (KIT_COD<>'') then
        Begin
         lTareaTerminal:='';
         lTareaTerminal:=pAnalizador.Obt_expn('KIT_' + KIT_FIGURA +IntToStr(lKIT) + '_TAREA');        
         Result := pSistema.Calculador.AnadeComponente(pSerie, pNumero, pLinea, Result, pFigura.ID, //IDs de la pieza y la figura
                                                 KIT_COD, KIT_ACABI, KIT_ACABE, //Codigo de pieza y Acabados
                                                 KIT_ANCHO,KIT_ALTO,0, //Medidas A,B y C
                                                 1 {Cantidad},0,0 {Corte1 y 2},
                                                 0 {LinkID}, 0 {Situacion},
                                                 0 {Num Rectangulo}, False {Si es exterior},
                                                 True {Insertar sus auxiliares},KIT_DESCINFO {Info},
                                                 '' {Familia}, 0 {Grupo},0 {Tipo Segmento},
                                                 0,0 {Tipos Cortes});
        end;
      end;
   end;



  //----------------------------------------------------------------------------
  //----------------------- DESCRIPCIÓN AUTOMATICA -----------------------------
  //----------------------------------------------------------------------------

  Descripcion:='';
  
  //DESCRIPTIVO PRESUPUESTO.
  //Descripcion del aireador del marco
  If (lAIREADOR<>'') and (pSistema.Calculador.DameDescripcionPresupuesto(lAIREADOR) <> '')then
   Begin
    Descripcion := Descripcion + (pSistema.Calculador.DameDescripcionPresupuesto(lAIREADOR));
  end;

  
   //Descripciones añadidas a desde el ini. 
  //Si tipo es 0 lo escribe despues de la seccion automatica de la figura 1 lo escribira al final de la descripcion completa del modulo
  //Si es 10 primero se anula la descripcion de la figura y luego se escribe al final de la descripcion completa del modulo 
  DES_FIGURA_NUM:=0;
  DES_FIGURA := pAnalizador.Obt_expn('FIGURA');
  DES_FIGURA_NUM := pAnalizador.Obt_exp('DES_' + DES_FIGURA + '_NUM');
  DES_FIGURA_TIPO := pAnalizador.Obt_exp('DES_' + DES_FIGURA + '_TIPO');
  lDescripcionINI:='';
  //Si existe la variable anular descripciones con valor 1 fuerzo la figura al tipo 10
  If (pAnalizador.Obt_exp('ANULAR_DESCRIPCIONES')=1) then DES_FIGURA_TIPO:=10; 

  If (DES_FIGURA_NUM <> 0) then
   Begin
    If (DES_FIGURA_TIPO<>0) then lDescripcionINI:='.'+#13#10; 
     //Analizamos el bucle     
     For lDES :=1 to DES_FIGURA_NUM do
      Begin
       //Inicializamos las variable
       DES_DESCINFO := '';
       DES_DATO:=0;
       DES_DESCINFO2 := ''; 
 
       DES_DESCINFO := pAnalizador.Obt_expn('DES_' + DES_FIGURA + IntToStr(lDES) + '_DESCINFO');
       DES_DATO := pAnalizador.Obt_exp('DES_' + DES_FIGURA +IntToStr(lDES) + '_DATO');
       DES_DESCINFO2 := pAnalizador.Obt_expn('DES_' + DES_FIGURA + IntToStr(lDES) + '_DESCINFO2'); 
       If (DES_DESCINFO <>'') then 
        Begin
          If (DES_FIGURA_TIPO=0) then lDescripcionINI:= lDescripcionINI+ ' ' + DES_DESCINFO;
          If (DES_FIGURA_TIPO<>0) then lDescripcionINI:= lDescripcionINI + DES_DESCINFO;
          If (DES_DATO<>0) then lDescripcionINI:= lDescripcionINI +' '+ FloatToStr(DES_DATO); 
          If (DES_DESCINFO2<>'') then lDescripcionINI:= lDescripcionINI +' '+ DES_DESCINFO2;
         end; 
       If (DES_FIGURA_TIPO<>0) then lDescripcionINI:=lDescripcionINI+#13#10; 
      end;
    end;  
   //Sistema normal de descripcion cuando no hay textos declarados manualmente en el ini de la figura en curso
   If (DES_FIGURA_TIPO=0) then  Descripcion:=Descripcion+lDescripcionINI;   
   //Lanzo al final de todo la descripcion generadada desde el ini si asi que quiere
   If (DES_FIGURA_TIPO<>0) then  pSistema.Calculador.AnadeDescAutoSecundaria('OTROS','',lDescripcionINI,True,False);

      
   //GENERO LA DESCRIPCION FINAL   
   If (DES_FIGURA_TIPO<>10) then pSistema.Calculador.AnadeDescAuto('MARVE','',Descripcion,False,True);

  //DESCRIPTIVO TALLER.
    lXAncho:= pFigura.Hueco(5).Ancho+ pAnalizador.BVar('MD.CUERPO')+ pAnalizador.BVar('MZ.ALAEXT') + pAnalizador.BVar('MZ.CUERPO')+ pAnalizador.BVar('MD.ALAEXT');
    lXAncho:= (Round(lXAncho*100)/100);
    lXAlto:= pFigura.Hueco(5).Alto+ pAnalizador.BVar('MS.CUERPO')+ pAnalizador.BVar('MS.ALAEXT') + pAnalizador.BVar('MI.CUERPO')+ pAnalizador.BVar('MI.ALAEXT');
    lXAlto:= (Round(lXAlto*100)/100);
    psistema.Calculador.AnadeLineaTaller ( 'Marco : ' + VartoStr(pAnalizador.BVarn('MA')+'  '+ FloatToStr(lXAncho)+' x '+ FloatToStr(lXAlto))+ ' (Ancho x Alto)');


    If (lAIREADOR<>'') and (pSistema.Calculador.DameDescripcionPresupuesto(lAIREADOR) <> '') then
    psistema.Calculador.AnadeLineaTaller (pSistema.Calculador.DameDescripcionPresupuesto(lAIREADOR));


  
  

  //DATOS PARA TERMINALES. 
  If(pAnalizador.BVar('INITERMINALES') = 1) then
  BEGIN
    lIni := pSistema.Calculador.DameIniTxTCliente;

    //ejemplo de envio de informacion a terminales
    lIni.WriteStringSimple('INFORMACIONJOSECHIRINOS', 'INFOJOSE=ENVIO info DESDE SICA');
    
    //Id del rectangulo
    lNumRec:= pFigura.Hueco(5).Id;
    //GUARDO EL RECTANGULO CON EL TIPO 
    IF pFigura.Hueco(5).EsRectangulo then lConForma := false else  lConForma := true;
    lID_Rec:='R'+IntToStr(lNumRec)+'.'; 
    
    lIni.WriteStringSimple('RECTANGULOS',lID_Rec+'Tipo=Marco');
    lIni.WriteStringSimple('SOLDADORA',lID_Rec+'Tipo=Marco Rec.'+IntToStr(lNumRec));
    lIni.WriteStringSimple('MATRIMONIO',lID_Rec+'Tipo=Marco Rec.'+IntToStr(lNumRec));
    
    //Guardo el rectangulo y sus medidas
    Descripcion:=''; 
    Descripcion:=FloatToStr(Round(pHueco.Ancho))+'x'+FloatToStr(Round(pHueco.Alto));
    lIni.WriteStringSimple('MARCOS',lID_Rec+'Dimension='+Descripcion);
    lIni.WriteStringSimple('SOLDADORA',lID_Rec+'Dimension='+Descripcion);
    lIni.WriteStringSimple('MATRIMONIO',lID_Rec+'Dimension='+Descripcion);
    
    
    Descripcion:=''; 
    If lConForma then Descripcion:='SI'else Descripcion:='NO';
    lIni.WriteStringSimple('MARCOS',lID_Rec+'Forma='+Descripcion);
    lIni.WriteStringSimple('SOLDADORA',lID_Rec+'Forma='+Descripcion);
    lIni.WriteStringSimple('MATRIMONIO',lID_Rec+'Forma='+Descripcion);
             
    //Asisno un perfil inicial para comparar entre todos y declarar todos los que hay
    If (PerfilSup<>'') then lPerfil:=PerfilSup else
    If (PerfilDer<>'') then lPerfil:=PerfilDer else
    If (PerfilInf<>'') then lPerfil:=PerfilInf else
    If (PerfilDer<>'') then lPerfil:=PerfilDer;
    lDiferente:=False;
    
    
    
    //Guardo el codigo y descripcion tecnica o presupuesto y si no hay ninguna de las dos la del articulo.
    If (lPerfil<>'') then
    Begin
      Descripcion:='';
      I:=1;
      If (pSistema.Calculador.DameDescripcionTecnica(lPerfil)<>'') then Descripcion:=lPerfil+'_'+pSistema.Calculador.DameDescripcionTecnica(lPerfil)
      else If (pSistema.Calculador.DameDescripcionPresupuesto(lPerfil)<>'') then Descripcion:=lPerfil+'_'+pSistema.Calculador.DameDescripcionPresupuesto(lPerfil)
      else Descripcion:=lPerfil+'_'+pSistema.Calculador.DameDescripcionArticulo(lPerfil); 
      lIni.WriteStringSimple('MARCOS',lID_Rec+'Perfil='+Descripcion); 
      lIni.WriteStringSimple('MATRIMONIO',lID_Rec+'Perfil='+Descripcion); 
 
      //Ahora comparo si hay alguno distinto a los demas y si asi fuese lo declararia tambien 
      //Derecho
      If (PerfilDer<>lPerfil) and (PerfilDer<>'') then
        Begin
          Descripcion:='';
          If (pSistema.Calculador.DameDescripcionTecnica(PerfilDer)<>'') then Descripcion:=PerfilDer+'_'+pSistema.Calculador.DameDescripcionTecnica(PerfilDer)
          else If (pSistema.Calculador.DameDescripcionPresupuesto(PerfilDer)<>'') then Descripcion:=PerfilDer+'_'+pSistema.Calculador.DameDescripcionPresupuesto(PerfilDer)
          else Descripcion:=PerfilDer+'_'+pSistema.Calculador.DameDescripcionArticulo(PerfilDer); 
          lIni.WriteStringSimple('MARCOS',lID_Rec+'Perfil'+FloatToStr(I+1)+'='+Descripcion);
          lIni.WriteStringSimple('MATRIMONIO',lID_Rec+'Perfil'+FloatToStr(I+1)+'='+Descripcion);
          lDiferente:=True; 
        end;
      //inferior
      If (PerfilInf<>lPerfil) and (PerfilInf<>'') then
        Begin
          Descripcion:='';
          If (pSistema.Calculador.DameDescripcionTecnica(PerfilInf)<>'') then Descripcion:=PerfilInf+'_'+pSistema.Calculador.DameDescripcionTecnica(PerfilInf)
          else If (pSistema.Calculador.DameDescripcionPresupuesto(PerfilInf)<>'') then Descripcion:=PerfilInf+'_'+pSistema.Calculador.DameDescripcionPresupuesto(PerfilInf)
          else Descripcion:=PerfilInf+'_'+pSistema.Calculador.DameDescripcionArticulo(PerfilInf); 
          lIni.WriteStringSimple('MARCOS',lID_Rec+'Perfil'+FloatToStr(I+1)+'='+Descripcion);
          lIni.WriteStringSimple('MATRIMONIO',lID_Rec+'Perfil'+FloatToStr(I+1)+'='+Descripcion);
          lDiferente:=True;
        end;  
      //izquierdo
      If (PerfilIzq<>lPerfil) and (PerfilIzq<>'') then
        Begin
          Descripcion:='';
          If (pSistema.Calculador.DameDescripcionTecnica(PerfilIzq)<>'') then Descripcion:=PerfilIzq+'_'+pSistema.Calculador.DameDescripcionTecnica(PerfilIzq)
          else If (pSistema.Calculador.DameDescripcionPresupuesto(PerfilIzq)<>'') then Descripcion:=PerfilIzq+'_'+pSistema.Calculador.DameDescripcionPresupuesto(PerfilIzq)
          else Descripcion:=PerfilIzq+'_'+pSistema.Calculador.DameDescripcionArticulo(PerfilIzq); 
          lIni.WriteStringSimple('MARCOS',lID_Rec+'Perfil'+FloatToStr(I+1)+'='+Descripcion);
          lIni.WriteStringSimple('MATRIMONIO',lID_Rec+'Perfil'+FloatToStr(I+1)+'='+Descripcion);
          lDiferente:=True;
        end;                        
    end;
    
    //Compongo la informacion para soldadora 
    Descripcion2:='';lIDinicial:=0;
      //Superior ----------------------------------------------------------------------------------------------------    
    lID := pSistema.Calculador.DameIdDescompuestoMem(PerfilSup,1,pFigura.Hueco(5).Id);     
    If (lID > 0) then
    Begin
    If (lIDinicial=0) or (lIDinicial>lID) then lIDinicial:=lID;
    lLongId:=0;
    lSQL := pSistema.Calculador.DameLineaDescompuestoMem(lID);    
    if lSQL <> nil then
      begin          
        lLongId := (Round(lSQL.FieldByName('A').AsFloat*100))/100;                      
        lSQL.Free; //Importante!
      end; 
      Descripcion:='_'+PerfilSup;
      lIni.WriteStringSimple('MARCOS',lID_Rec+'Superior=ID'+ IntToStr(lID)+Descripcion+'_Long='+FloatToStr(lLongId)); 
      lIni.WriteStringSimple('SOLDADORA',lID_Rec+'Superior=ID'+ IntToStr(lID)+Descripcion+'_Long='+FloatToStr(lLongId));
      lIni.WriteStringSimple('MATRIMONIO',lID_Rec+'Superior=ID'+ IntToStr(lID)+Descripcion+'_Long='+FloatToStr(lLongId));
    end;
    
    //Derecha ----------------------------------------------------------------------------------------------------
    lID := pSistema.Calculador.DameIdDescompuestoMem(PerfilDer,2,pFigura.Hueco(5).Id);      
    If (lID > 0) then
    Begin 
    If (lIDinicial=0) or (lIDinicial>lID) then lIDinicial:=lID;
    lLongId:=0;
    lSQL := pSistema.Calculador.DameLineaDescompuestoMem(lID);   
    if lSQL <> nil then
      begin        
        lLongId := (Round(lSQL.FieldByName('A').AsFloat*100))/100;                      
        lSQL.Free; //Importante!
      end;  
      Descripcion:='_'+PerfilDer;
      lIni.WriteStringSimple('MARCOS',lID_Rec+'Derecha=ID'+ IntToStr(lID)+Descripcion+'_Long='+FloatToStr(lLongId));
      lIni.WriteStringSimple('SOLDADORA',lID_Rec+'Derecha=ID'+ IntToStr(lID)+Descripcion+'_Long='+FloatToStr(lLongId));
      lIni.WriteStringSimple('MATRIMONIO',lID_Rec+'Derecha=ID'+ IntToStr(lID)+Descripcion+'_Long='+FloatToStr(lLongId));
    end; 
    
    //Inferior ----------------------------------------------------------------------------------------------------
    lID := pSistema.Calculador.DameIdDescompuestoMem(PerfilInf,3,pFigura.Hueco(5).Id);  
    If (lID > 0) then
    Begin 
    If (lIDinicial=0) or (lIDinicial>lID) then lIDinicial:=lID;
    lLongId:=0;
    lSQL := pSistema.Calculador.DameLineaDescompuestoMem(lID); 
    if lSQL <> nil then
      begin        
        lLongId := (Round(lSQL.FieldByName('A').AsFloat*100))/100;                      
        lSQL.Free; //Importante!
      end; 
      Descripcion:='_'+PerfilInf;
      lIni.WriteStringSimple('MARCOS',lID_Rec+'Inferior=ID'+ IntToStr(lID)+Descripcion+'_Long='+FloatToStr(lLongId));
      lIni.WriteStringSimple('SOLDADORA',lID_Rec+'Inferior=ID'+ IntToStr(lID)+Descripcion+'_Long='+FloatToStr(lLongId));
      lIni.WriteStringSimple('MATRIMONIO',lID_Rec+'Inferior=ID'+ IntToStr(lID)+Descripcion+'_Long='+FloatToStr(lLongId));
    end;
    
    //Izquierda ----------------------------------------------------------------------------------------------------
    lID := pSistema.Calculador.DameIdDescompuestoMem(PerfilIzq,4,pFigura.Hueco(5).Id);
    If (lID > 0) then
    Begin
    If (lIDinicial=0) or (lIDinicial>lID) then lIDinicial:=lID;
    lLongId:=0;
    lSQL := pSistema.Calculador.DameLineaDescompuestoMem(lID); 
    if lSQL <> nil then
      begin        
        lLongId := (Round(lSQL.FieldByName('A').AsFloat*100))/100;                      
        lSQL.Free; //Importante!
      end;  
      Descripcion:='_'+PerfilIzq;
      lIni.WriteStringSimple('MARCOS',lID_Rec+'Izquierda=ID'+ IntToStr(lID)+Descripcion+'_Long='+FloatToStr(lLongId));
      lIni.WriteStringSimple('SOLDADORA',lID_Rec+'Izquierda=ID'+ IntToStr(lID)+Descripcion+'_Long='+FloatToStr(lLongId));
      lIni.WriteStringSimple('MATRIMONIO',lID_Rec+'Izquierda=ID'+ IntToStr(lID)+Descripcion+'_Long='+FloatToStr(lLongId));
    end;

    //Me quedo lIDinicial que es el ID de pieza inicial para escanerar escuadras y gomas.   
      //ShowMessage(lIDinicial);
      Ix:=1000;
      For I:=1 to Ix do
        begin              
          lSQL := pSistema.Calculador.DameLineaDescompuestoMem(lIDinicial+I); 
          If lSQL <> nil then
              begin 
                Descripcion:='';Descripcion2:='';
                // Si el articulo a continuacion pertene al mismo rectangulo que el ID inicial
                If lSQL.FieldByName('NumeroRectangulo').AsInteger=lNumRec then  
                  Begin
                    //Si se trata de un articulo accesorios y si tiene precio (no se que sea un sol0 aux)
                    If (lSQL.FieldByName('TipoArticulo').AsInteger=2) and (lSQL.FieldByName('Coste').AsFloat<>0) then
                       Begin
                        Descripcion:=lSQL.FieldByName('CodigoArticulo').AsString;
                        Descripcion2:=lSQL.FieldByName('Descripcion').AsString;
                        Descripcion2:=Descripcion2+'   ('+lSQL.FieldByName('CodigoAcabado').AsString+')';
                        //Segun sea por unidad o por metro - los guardo en HOJASACCE o en HOJASGOMAS
                        If (lSQL.FieldByName('TipoMedida').AsInteger=1) then lIni.WriteStringSimple('MARCOSACCE',lID_Rec+'Marcos_Accesorio='+Descripcion+' '+Descripcion2) 
                        else lIni.WriteStringSimple('MARCOSGOMAS',lID_Rec+'Marcos_Goma='+Descripcion+' '+Descripcion2);                                                
                       end;
                  end else
                  Begin
                   //Showmessage(I);
                   lSQL.Free; //Importante!
                   Break
                  end;
                  lSQL.Free; //Importante!
              end;           
        end;    


      lIni.WriteStringSimple('INFORMACIONJOSECHIRINOS', 'INFOJOSE=ENVIO info DESDE SICA');

    //Guardo el nuevo ini:
    pSistema.Calculador.GuardaIniTxtCliente(lIni);
    
    //Importante!  
    lIni.Free;  
    
    END;      
  

end;