select * from (select c.*,l.modulo,l.PresupNumMan,l.cantidad as cantidad2,a.descripcion as descripcion2,a.num29,a.soldadura_limpieza,
       l.codigopresuplinea,l.identificadorlinea,l.codigopresupnumero,c.tipoperfil as mitipo                                                                                                                   
from fpresupuestoslineascomponentes c
  
left join fpresupuestoslineas l on c.codigoserie=l.codigoserie and 
           c.codigonumero=l.codigonumero and c.linea=l.linea
             
left join fpresupuestosarticulos a on c.codigoserie=a.codigoserie and c.codigonumero=a.codigonumero and 
           c.codigoarticulo=a.codigoarticulo and
           c.codigoacabado=a.codigoacabado and c.codigoacabado2=a.codigoacabado2
             
where c.codigoserie = :serie and c.codigonumero = :numero  and 
       c.tipoarticulo >= 1000 and c.tipoperfil > 0 and ((c.tipoperfil < 100) )) x

union          

select * from (select c.*,l.modulo,l.PresupNumMan,l.cantidad as cantidad2,a.descripcion as descripcion2,a.num29,a.soldadura_limpieza,
       l.codigopresuplinea,l.identificadorlinea,l.codigopresupnumero,220 as mitipo                                                                                                                   
from fpresupuestoslineascomponentes c
  
left join fpresupuestoslineas l on c.codigoserie=l.codigoserie and 
           c.codigonumero=l.codigonumero and c.linea=l.linea
             
left join fpresupuestosarticulos a on c.codigoserie=a.codigoserie and c.codigonumero=a.codigonumero and 
           c.codigoarticulo=a.codigoarticulo and
           c.codigoacabado=a.codigoacabado and c.codigoacabado2=a.codigoacabado2
             
where c.codigoserie = :serie and c.codigonumero = :numero  and 
       c.tipoarticulo >= 1000 and c.tipoperfil > 0 and (((c.tipoperfil >= 200) and (c.tipoperfil <= 230)))) y
           
union          

select * from (select c.*,l.modulo,l.PresupNumMan,l.cantidad as cantidad2,a.descripcion as descripcion2,a.num29,a.soldadura_limpieza,
       l.codigopresuplinea,l.identificadorlinea,l.codigopresupnumero,240 as mitipo                                                                                                                   
from fpresupuestoslineascomponentes c
  
left join fpresupuestoslineas l on c.codigoserie=l.codigoserie and 
           c.codigonumero=l.codigonumero and c.linea=l.linea
             
left join fpresupuestosarticulos a on c.codigoserie=a.codigoserie and c.codigonumero=a.codigonumero and 
           c.codigoarticulo=a.codigoarticulo and
           c.codigoacabado=a.codigoacabado and c.codigoacabado2=a.codigoacabado2
             
where c.codigoserie = :serie and c.codigonumero = :numero  and 
       c.tipoarticulo >= 1000 and c.tipoperfil > 0 and (((c.tipoperfil >= 240) and (c.tipoperfil <= 280)))) z
           
order by tipoperfil,num29,linea,codigoarticulo,codigoacabado,codigoacabado2,id