--Requisito N�1
--Requisito N�2
--Requisito N�3
CREATE OR REPLACE PROCEDURE RellenarPrepHuesped IS
DECLARE

v_idH VARCHAR2(20);
v_idP VARCHAR2(20);


BEGIN

v_idH := '&ID_del_Huesped';
v_idP := '&ID_del_Prepago';

END;
/



--Requisito N�4
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
--Requisito N�5
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