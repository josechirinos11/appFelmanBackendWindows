    If (TAREAENCURSO='HERRAJEHOJA')  then
    BEGIN

      //Cargo la apertura y las medidas de hoja

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
         //lTexto.Add('');
         //lTexto.Add(' ');
         lUso:='';lSituacion:=0;lDato:='';
         For I := 0 to lSL.Count - 1 do
           begin

              lUso:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
              lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              If (lUso='2') and (Pos('km',lowercase(lDato)) <= 0)  and (Pos('mk',lowercase(lDato)) <= 0) then
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
   // showmessage(seccion);
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
               // showmessage(DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),4));
                lSituacion := 0;
              end;
              lCad2 :=  DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
              lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              //If (lUso='2') and ((lSituacion>=40) or ((lSituacion>=1) and (lSituacion<=10))) and (lSituacion<>4) and (Pos('kit',lowercase(lCad2)) <= 0) and (Pos('tor',lowercase(lCad2)) <= 0) and (Pos('km',lowercase(lDato)) <= 0)  and (Pos('mk',lowercase(lDato)) <= 0) then
              If (lUso='2') and ((lSituacion>=40) or ((lSituacion>=1) and (lSituacion<=10))) and (lSituacion<>4) {and (Pos('kit',lowercase(lCad2)) <= 0) and (Pos('tor',lowercase(lCad2)) <= 0) and (Pos('km',lowercase(lDato)) <= 0)  and (Pos('mk',lowercase(lDato)) <= 0)} then
               Begin
              // lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
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
               // showmessage(DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),4));
                lSituacion := 0;
              end;
              lCad2 :=  DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
               lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              //If (lUso='2') and  ((lSituacion>=10) and (lSituacion<=20)) and (Pos('kit',lowercase(lCad2)) <= 0) and (Pos('tor',lowercase(lCad2)) <= 0) and (Pos('km',lowercase(lDato)) <= 0)  and (Pos('mk',lowercase(lDato)) <= 0) then
              If (lUso='2') and  ((lSituacion>=10) and (lSituacion<=20)) {and (Pos('kit',lowercase(lCad2)) <= 0) and (Pos('tor',lowercase(lCad2)) <= 0) and (Pos('km',lowercase(lDato)) <= 0)  and (Pos('mk',lowercase(lDato)) <= 0)} then
               Begin
              // lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
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
               // showmessage(DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),4));
                lSituacion := 0;
              end;
              lCad2 :=  DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
              lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              //If (lUso='2') and  ((lSituacion>=20) and (lSituacion<=30)) and (Pos('kit',lowercase(lCad2)) <= 0) and (Pos('tor',lowercase(lCad2)) <= 0) and (Pos('km',lowercase(lDato)) <= 0)  and (Pos('mk',lowercase(lDato)) <= 0) then
              If (lUso='2') and  ((lSituacion>=20) and (lSituacion<=30)) {and (Pos('kit',lowercase(lCad2)) <= 0) and (Pos('tor',lowercase(lCad2)) <= 0) and (Pos('km',lowercase(lDato)) <= 0)  and (Pos('mk',lowercase(lDato)) <= 0)} then
               Begin
              // lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
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
         ////showmessage(lHoja);
         lUso:='';lSituacion:=0;
         For I := 0 to lSL.Count - 1 do
           begin
              if(Copy(lSL.Strings[I],1,2)<>'R'+lHoja) then continue;
              lUso:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),2);
              try
                lSituacion:= StrToInt(DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),4));
              except
               // showmessage(DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),4));
                lSituacion := 0;
              end;
              lCad2 :=  DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
              lDato:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1);
              //If (lUso='2') and  ((lSituacion=4) or ((lSituacion>=30) and (lSituacion<=40))) and (Pos('kit',lowercase(lCad2)) <= 0) and (Pos('tor',lowercase(lCad2)) <= 0) and (Pos('km',lowercase(lDato)) <= 0)  and (Pos('mkvbh',lowercase(lDato)) <= 0) then
              If (lUso='2') and  ((lSituacion=4) or ((lSituacion>=30) and (lSituacion<=40))) {and (Pos('kit',lowercase(lCad2)) <= 0) and (Pos('tor',lowercase(lCad2)) <= 0) and (Pos('km',lowercase(lDato)) <= 0)  and (Pos('mkvbh',lowercase(lDato)) <= 0)} then
               Begin
              // lCad2:= DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),1) + ' - ' + DameParametro(lIni.ReadString(lCad,lSL.Strings[I],''),5);
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



    END;
    
