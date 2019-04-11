--Requisito N�1
--Requisito N�2
CREATE OR REPLACE PROCEDURE ocuparHabitaciones
IS
    Cursor habitaciones is Select h.NUMHABITACION, h.idHotel
        from habitacion h;
BEGIN
    for reg in habitaciones loop
        if comprHabitacion(reg.NUMHABITACION, reg.idHotel) then
            ocuparHab(reg.NUMHABITACION, reg.idHotel, 1);
        else
            ocuparHab(reg.numHabitacion, reg.idHotel, 0);
        end if;
    end loop;
END ocuparHabitaciones;
/
CREATE OR REPLACE FUNCTION comprHabitacion(numHab number, idHot number)
return boolean is
    Cursor reservas is Select r.fchDesde, r.fchHasta from reserva r where r.numHabitacion=numHab and idHotel=idHot;
    ocupar boolean:=false;
begin
    for reg in reservas loop
        if reg.fchDesde<=Sysdate and Sysdate<=reg.fchHasta then
            ocupar:=true;
        end if;
    end loop;
    return ocupar;
end comprHabitacion;
/
Create or replace procedure ocuparHab(numHab number, idHot number, ocupar number)
is
begin
    Update usoHab set ocupada=ocupar where idHotel=idHot and numHabitacion=numHab;
end ocuparHab;
/
--Requisito N�3
CREATE OR REPLACE PROCEDURE RellenarPrepHuesped IS

v_idH NUMBER(12);
v_idP NUMBER(12);


BEGIN

v_idH := '&ID_del_Huesped';
--funcion que verifica que el id del huespes esta en la BD
v_idP := '&ID_del_Prepago';

INSERT INTO prepHues VALUES (v_idP,v_idH);

END;
/



--Requisito N�4

--Requisito N�5
create or replace procedure BuscarHotel(hotel varchar2)
is
    id number;
    nombre varchar2(50);
    Cursor hoteles is Select h.idHotel, h.nomHotel
        from hotel h, ciudad c
        where c.nomCiudad=hotel and c.idCiudad=h.idCiudad;    
begin
open hoteles;
    FETCH Hoteles INTO id, nombre;
    if hoteles%NOTFOUND then
        DBMS_OUTPUT.PUT_LINE('No hay ningun hotel');
    end if;
close hoteles;
    for reg in hoteles loop
        DBMS_output.put_line('Nombre: '|| reg.nomHotel || ', ID: ' || reg.idHotel);
    end loop;    
end BuscarHotel;
/
--Requisito N�6
--Requisito N�7
--Requisito N�8
--Requisito N�9
--Requisito N�10
--Requisito N�11
--Requisito N�12
--Requisito N�13
--Requisito N�14
--Requisito N�15