SET SERVEROUTPUT ON;
--Requisito Nº1
Declare
    
Begin
    
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
    
Begin
    
End;
/
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
    
Begin
    
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
    
Begin
    
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
Declare
    cupon varchar2(200):=('&Cupon');
    precio number:=('&Precio');
Begin

    DBMS_OUTPUT.PUT_LINE(aplicarDescuento(cupon,precio));
    
End;
/
--Requisito Nº13
Declare
    
Begin
    
End;
/
--Requisito Nº14
Declare
    id number:=('&ID_Reserva');
Begin
    imprReserva(id);
End;
/
--Requisito Nº15
Declare
    
Begin
    
End;
/