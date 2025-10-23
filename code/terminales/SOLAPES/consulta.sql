-- CONSULTA ORIGINAL  COMO SE USA DESDE FASTREPORT DESDE UN DATASSET
SELECT * FROM fpresupuestosoptimizacion
WHERE CodigoSerie = :Serie AND CodigoNumero = :Numero AND CodigoPerfil = :CodigoArticulo
AND CodigoAcabado = :CodigoAcabado AND 
  ((CodigoAcabado2 = :CodigoAcabado2) OR ((CodigoAcabado2 is null) AND (:CodigoAcabado2 = '')))
ORDER BY CodigoPerfil,CodigoAcabado,CodigoAcabado2,Barra,Corte




--esta consulta me trae esta informacion si buscara con los siguientes parametros: CodigoNumero=3150, CodigoSerie='23FBA', CodigoPerfil='FEL64974', CodigoAcabado='9010', CodigoAcabado2=''  
-- RESULTADO DE LA CONSULTA
23FBA	3150	FEL64974	9010		1	1	6	6		1		5956	6000	11	1	1275	1037	1037	975	975	567															V03.01	V02.01	V02.01	V03.01	V03.01	V02.01					103	102	102	103	103	102	0	0	0	0											45	45	45	45	45	45					45	45	45	45	45	45					90	90	90	90	90	90					90	90	90	90	90	90					1	1	3	2	4	2															11	11	11	11	11	11					11	11	11	11	11	11					0	0	0	0	0	0					3	2	2	3	3	2					4	4	2	1	3	1					7	7	7	7	7	7					1	1	1	1	1	1						
23FBA	3150	FEL64974	9010		2	1	5	5		1		5950	6000	11	1	1355	1275	1135	1135	975																V04.01	V03.01	V01.01	V01.01	V04.01						104	103	101	101	104	0	0	0	0	0											45	45	45	45	45						45	45	45	45	45						90	90	90	90	90						90	90	90	90	90						1	3	1	3	2																11	11	11	11	11						11	11	11	11	11						0	0	0	0	0						4	3	1	1	4						4	2	4	2	1						7	7	7	7	7						1	1	1	1	1							
23FBA	3150	FEL64974	9010		3	1	5	5		1		5930	6000	11	1	1355	1355	1085	1085	975																V04.01	V04.02	V01.01	V01.01	V04.01						104	105	101	101	104	0	0	0	0	0											45	45	45	45	45						45	45	45	45	45						90	90	90	90	90						90	90	90	90	90						3	1	2	4	4																11	11	11	11	11						11	11	11	11	11						0	0	0	0	0						4	5	1	1	4						2	4	1	3	3						7	7	7	7	7						1	1	1	1	1							
23FBA	3150	FEL64974	9010		4	1	6	6		1		5912	6000	11	1	1355	975	975	975	975	567															V04.02	V04.02	V04.02	V04.03	V04.03	V02.01					105	105	105	106	106	102	0	0	0	0											45	45	45	45	45	45					45	45	45	45	45	45					90	90	90	90	90	90					90	90	90	90	90	90					3	2	4	2	4	4															11	11	11	11	11	11					11	11	11	11	11	11					0	0	0	0	0	0					5	5	5	6	6	2					2	1	3	1	3	3					7	7	7	7	7	7					1	1	1	1	1	1						
23FBA	3150	FEL64974	9010		5	1	2	2		1		2740	6000	11	1	1355	1355																			V04.03	V04.03									106	106	0	0	0	0	0	0	0	0											45	45									45	45									90	90									90	90									1	3																			11	11									11	11									0	0									6	6									4	2									7	7									1	1										
																																																																																																																																																																																																					





-- ESTRUCTURA DE LA TABLA fpresupuestosoptimizacion
CodigoNumero	int(11)	NO	PRI		
CodigoPerfil	char(20)	NO	PRI		
CodigoAcabado	char(20)	NO	PRI		
CodigoAcabado2	char(20)	NO	PRI		
Barra	int(11)	NO	PRI		
Corte	int(11)	NO	PRI		
Medidas	int(11)	YES			
Asignadas	int(11)	YES			
AsignadasB	int(11)	YES			
Cantidad	smallint(6)	YES			
BarraMaq	int(11)	YES			
Longitud	int(11)	YES			
Ancho	int(11)	YES			
Maquina	int(11)	YES			
Tipo	smallint(6)	NO	PRI		
Med0	double	YES			
Med1	double	YES			
Med2	double	YES			
Med3	double	YES			
Med4	double	YES			
Med5	double	YES			
Med6	double	YES			
Med7	double	YES			
Med8	double	YES			
Med9	double	YES			
MedH0	double	YES			
MedH1	double	YES			
MedH2	double	YES			
MedH3	double	YES			
MedH4	double	YES			
MedH5	double	YES			
MedH6	double	YES			
MedH7	double	YES			
MedH8	double	YES			
MedH9	double	YES			
Modulo0	char(20)	YES			
Modulo1	char(20)	YES			
Modulo2	char(20)	YES			
Modulo3	char(20)	YES			
Modulo4	char(20)	YES			
Modulo5	char(20)	YES			
Modulo6	char(20)	YES			
Modulo7	char(20)	YES			
Modulo8	char(20)	YES			
Modulo9	char(20)	YES			
CASILLERO0	int(11)	YES			
CASILLERO1	int(11)	YES			
CASILLERO2	int(11)	YES			
CASILLERO3	int(11)	YES			
CASILLERO4	int(11)	YES			
CASILLERO5	int(11)	YES			
CASILLERO6	int(11)	YES			
CASILLERO7	int(11)	YES			
CASILLERO8	int(11)	YES			
CASILLERO9	int(11)	YES			
CASILLEROB0	int(11)	YES			
CASILLEROB1	int(11)	YES			
CASILLEROB2	int(11)	YES			
CASILLEROB3	int(11)	YES			
CASILLEROB4	int(11)	YES			
CASILLEROB5	int(11)	YES			
CASILLEROB6	int(11)	YES			
CASILLEROB7	int(11)	YES			
CASILLEROB8	int(11)	YES			
CASILLEROB9	int(11)	YES			
Corte1_0	double	YES			
Corte1_1	double	YES			
Corte1_2	double	YES			
Corte1_3	double	YES			
Corte1_4	double	YES			
Corte1_5	double	YES			
Corte1_6	double	YES			
Corte1_7	double	YES			
Corte1_8	double	YES			
Corte1_9	double	YES			
Corte2_0	double	YES			
Corte2_1	double	YES			
Corte2_2	double	YES			
Corte2_3	double	YES			
Corte2_4	double	YES			
Corte2_5	double	YES			
Corte2_6	double	YES			
Corte2_7	double	YES			
Corte2_8	double	YES			
Corte2_9	double	YES			
Corte1b_0	double	YES			
Corte1b_1	double	YES			
Corte1b_2	double	YES			
Corte1b_3	double	YES			
Corte1b_4	double	YES			
Corte1b_5	double	YES			
Corte1b_6	double	YES			
Corte1b_7	double	YES			
Corte1b_8	double	YES			
Corte1b_9	double	YES			
Corte2b_0	double	YES			
Corte2b_1	double	YES			
Corte2b_2	double	YES			
Corte2b_3	double	YES			
Corte2b_4	double	YES			
Corte2b_5	double	YES			
Corte2b_6	double	YES			
Corte2b_7	double	YES			
Corte2b_8	double	YES			
Corte2b_9	double	YES			
ID0	int(11)	YES			
ID1	int(11)	YES			
ID2	int(11)	YES			
ID3	int(11)	YES			
ID4	int(11)	YES			
ID5	int(11)	YES			
ID6	int(11)	YES			
ID7	int(11)	YES			
ID8	int(11)	YES			
ID9	int(11)	YES			
KTN0	int(11)	YES			
KTN1	int(11)	YES			
KTN2	int(11)	YES			
KTN3	int(11)	YES			
KTN4	int(11)	YES			
KTN5	int(11)	YES			
KTN6	int(11)	YES			
KTN7	int(11)	YES			
KTN8	int(11)	YES			
KTN9	int(11)	YES			
MAQ0	int(11)	YES			
MAQ1	int(11)	YES			
MAQ2	int(11)	YES			
MAQ3	int(11)	YES			
MAQ4	int(11)	YES			
MAQ5	int(11)	YES			
MAQ6	int(11)	YES			
MAQ7	int(11)	YES			
MAQ8	int(11)	YES			
MAQ9	int(11)	YES			
MAQ2_0	int(11)	YES			
MAQ2_1	int(11)	YES			
MAQ2_2	int(11)	YES			
MAQ2_3	int(11)	YES			
MAQ2_4	int(11)	YES			
MAQ2_5	int(11)	YES			
MAQ2_6	int(11)	YES			
MAQ2_7	int(11)	YES			
MAQ2_8	int(11)	YES			
MAQ2_9	int(11)	YES			
REF0	int(11)	YES			
REF1	int(11)	YES			
REF2	int(11)	YES			
REF3	int(11)	YES			
REF4	int(11)	YES			
REF5	int(11)	YES			
REF6	int(11)	YES			
REF7	int(11)	YES			
REF8	int(11)	YES			
REF9	int(11)	YES			
Lin0	int(11)	YES			
Lin1	int(11)	YES			
Lin2	int(11)	YES			
Lin3	int(11)	YES			
Lin4	int(11)	YES			
Lin5	int(11)	YES			
Lin6	int(11)	YES			
Lin7	int(11)	YES			
Lin8	int(11)	YES			
Lin9	int(11)	YES			
Sit0	int(11)	YES			
Sit1	int(11)	YES			
Sit2	int(11)	YES			
Sit3	int(11)	YES			
Sit4	int(11)	YES			
Sit5	int(11)	YES			
Sit6	int(11)	YES			
Sit7	int(11)	YES			
Sit8	int(11)	YES			
Sit9	int(11)	YES			
Rec0	int(11)	YES			
Rec1	int(11)	YES			
Rec2	int(11)	YES			
Rec3	int(11)	YES			
Rec4	int(11)	YES			
Rec5	int(11)	YES			
Rec6	int(11)	YES			
Rec7	int(11)	YES			
Rec8	int(11)	YES			
Rec9	int(11)	YES			
UD0	int(11)	YES			
UD1	int(11)	YES			
UD2	int(11)	YES			
UD3	int(11)	YES			
UD4	int(11)	YES			
UD5	int(11)	YES			
UD6	int(11)	YES			
UD7	int(11)	YES			
UD8	int(11)	YES			
UD9	int(11)	YES			
Grafico	mediumblob	YES			
Parametros	mediumtext	YES		