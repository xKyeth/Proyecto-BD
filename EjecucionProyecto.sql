SET SERVEROUTPUT ON;
--Requisito N�1
Declare
    
Begin
    
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
    
Begin
    
End;
/
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
    
Begin
    
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
    
Begin
    
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
Declare
    cupon varchar2(200):=('&Cupon');
    precio number:=('&Precio');
Begin

    DBMS_OUTPUT.PUT_LINE(aplicarDescuento(cupon,precio));
    
End;
/
--Requisito N�13
Declare
    
Begin
    
End;
/
--Requisito N�14
Declare
    id number:=('&ID_Reserva');
Begin
    imprReserva(id);
End;
/
--Requisito N�15
Declare
    
Begin
    
End;
/