SET SERVEROUTPUT ON;
--Requisito Nº1
Declare
 cod char(2) := '&cod';
 cod2 number(5,0):= '&cod2';
Begin
    
    buscaHabitacion(cod , cod2);
    
End;
/
--Requisito Nº2
Declare
    
Begin
    ocuparHabitaciones;
End;
/
--Requisito Nº3

DECLARE

idH NUMBER;
idP NUMBER;

BEGIN

idH:='&IDHuespd';
idP:='&IDPrepago';

rellenarprephuesped(idH,idP);

END;
/

--Requisito Nº4
Declare
Usuario char(25) :='&Usuario';
Passwd varchar2(12) :='&Passwd';
    
Begin 
    creaUsuario2(Usuario , Passwd);
    
End;
/

 select usremail  , usrpwd from usuario ;

--Requisito Nº5
Declare
    Nombre varchar2(20):='&Nombre';
Begin
    BuscarHotel(Nombre);
End;
/
--Requisito Nº6

DECLARE

v_idH NUMBER;

BEGIN

v_idH:='&IDHuesped';
fichahuesped(v_idH);

END;
/
--Requisito Nº7

Declare
    Codigo number(5,0) := '&codigo';
    
Begin
    fichaHoteles(codigo);
    
End;
/

--Requisito Nº8
Declare
    Nombre varchar2(20):='&Nombre';
Begin
    reservasPais(Nombre);
End;
/
--Requisito Nº9
DECLARE

idH NUMBER;

BEGIN

idH:='&IDHuespd';

    IF comprHuesped(idH) THEN
        DBMS_OUTPUT.PUT_LINE('Correcto');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Incorrecto');
    END IF;    

END;
/

--Requisito Nº10

Declare
    Codigo number(2,0) :='&codigo';
    
Begin
    PAGOCORRECTO(codigo);
End;
/

--Requisito Nº11
Declare
    ano number:='&AÑO';
    id number:='&ID_Cliente';
Begin
    pagosAnuales(id, ano);
End;
/
--Requisito Nº12

--L13Bm39JVd cupon
Declare
    cupon varchar2(200):=('&Cupon');
    precio number:=('&Precio');
Begin

    DBMS_OUTPUT.PUT_LINE(aplicarDescuento(cupon,precio));
    
End;
/
--Requisito Nº13


INSERT INTO usuario VALUES ('usr8@gmail.com','pwd8');
INSERT INTO reserva VALUES (11,'usr8@gmail.com',14325,1,1,'MP','31-12-2014','01-02-2015','15-02-2015');
select * from reservaPorPagar;

--Requisito Nº14
Declare
    id number:=('&ID_Reserva');
Begin
    imprReserva(id);
End;
/
--Requisito Nº15
s
--Son las auditorias
