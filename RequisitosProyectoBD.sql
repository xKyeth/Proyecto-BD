--Requisito Nº1
--Requisito Nº2
--Requisito Nº3
--Requisito Nº4
create or replace procedure BurcarHotel(hotel varchar2)
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
end BurcarHotel;
/
--Requisito Nº5
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