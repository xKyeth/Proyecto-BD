SET SERVEROUTPUT ON;
--Requisito N�1
Declare
 cod char(2) := '&cod';
 cod2 number(5,0):= '&cod2';
Begin
    
    buscaHabitacion(cod , cod2);
    
End;
/
--Requisito N�2
Declare
    
Begin
    ocuparHabitaciones;
End;
/
--Requisito N�3

DECLARE

idH NUMBER;
idP NUMBER;

BEGIN

idH:='&IDHuespd';
idP:='&IDPrepago';

rellenarprephuesped(idH,idP);

END;
/

--Requisito N�4
Declare
Usuario char(25) :='&Usuario';
Passwd varchar2(12) :='&Passwd';
    
Begin 
    creaUsuario2(Usuario , Passwd);
    
End;
/

 select usremail  , usrpwd from usuario ;

--Requisito N�5
Declare
    Nombre varchar2(20):='&Nombre';
Begin
    BuscarHotel(Nombre);
End;
/
--Requisito N�6

DECLARE

v_idH NUMBER;

BEGIN

v_idH:='&IDHuesped';
fichahuesped(v_idH);

END;
/
--Requisito N�7

Declare
    Codigo number(5,0) := '&codigo';
    
Begin
    fichaHoteles(codigo);
    
End;
/

--Requisito N�8
Declare
    Nombre varchar2(20):='&Nombre';
Begin
    reservasPais(Nombre);
End;
/
--Requisito N�9
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

--Requisito N�10

Declare
    Codigo number(2,0) :='&codigo';
    
Begin
    PAGOCORRECTO(codigo);
End;
/

--Requisito N�11
Declare
    ano number:='&A�O';
    id number:='&ID_Cliente';
Begin
    pagosAnuales(id, ano);
End;
/
--Requisito N�12

--L13Bm39JVd cupon
Declare
    cupon varchar2(200):=('&Cupon');
    precio number:=('&Precio');
Begin

    DBMS_OUTPUT.PUT_LINE(aplicarDescuento(cupon,precio));
    
End;
/
--Requisito N�13


INSERT INTO usuario VALUES ('usr8@gmail.com','pwd8');
INSERT INTO reserva VALUES (11,'usr8@gmail.com',14325,1,1,'MP','31-12-2014','01-02-2015','15-02-2015');
select * from reservaPorPagar;

--Requisito N�14
Declare
    id number:=('&ID_Reserva');
Begin
    imprReserva(id);
End;
/
--Requisito N�15
s
--Son las auditorias
