--Requisito Nº1
--Requisito Nº2
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
--Requisito Nº3

CREATE OR REPLACE FUNCTION comprHuesped (idHues NUMBER) RETURN BOOLEAN IS

CURSOR curs IS
    SELECT idhuesped FROM huesped;
registro curs%ROWTYPE;

BEGIN

OPEN curs;

    FETCH curs INTO registro;

    IF idHues IN (registro.idhuesped) THEN
        DBMS_OUTPUT.PUT_LINE('El huesped existe en la base de datos');
        return true;
    ELSE
        DBMS_OUTPUT.PUT_LINE('El huesped no existe en la base de datos');
        return false;
    END IF;
    
CLOSE curs;
END;
/
    

CREATE OR REPLACE FUNCTION comprPrepago (idPrep NUMBER) RETURN BOOLEAN IS

CURSOR curs IS
    SELECT idprepago FROM prepago;
    
registro curs%ROWTYPE;

BEGIN

OPEN curs;

    FETCH curs INTO registro;

    IF idPrep IN (registro.idprepago) THEN
        DBMS_OUTPUT.PUT_LINE('El prepago existe en la base de datos');
        return true;
    ELSE
        DBMS_OUTPUT.PUT_LINE('El prepago no existe en la base de datos');
        return false;
    END IF;
    
CLOSE curs;
END;
/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE RellenarPrepHuesped(v_idH NUMBER, v_idP NUMBER) IS
BEGIN



IF(comprhuesped(v_idH)) THEN
            DBMS_OUTPUT.PUT_LINE('primer if');

    IF(comprPrepago(v_idP)) THEN
            DBMS_OUTPUT.PUT_LINE('segundo if');

        INSERT INTO prepHues VALUES (v_idP,v_idH);
    END IF;
END IF;
END;
/


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

--Requisito Nº5
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
--Requisito Nº6
--Requisito Nº7
--Requisito Nº8
--Requisito Nº9
--Requisito Nº10
--Requisito Nº11
--Requisito Nº12
--Requisito Nº13
--Requisito Nº14
--Requisito Nº15