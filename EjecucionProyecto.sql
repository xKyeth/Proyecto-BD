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
Declare
    
Begin
    
End;
/
--Requisito N�4
Declare
Usuario char(25) :='&Usuario';
Passwd char(12) :='&Passwd';
    
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
Declare
    
Begin
    
End;
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
Declare
    
Begin
    
End;
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
Declare
    
Begin
    
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
Declare
    
Begin
    
End;
/