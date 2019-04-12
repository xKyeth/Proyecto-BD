--Requisito Nº1
--Requisito Nº2
/*Funcion que comprueba las reservas y devuelve si una habitación se debe ocupar*/
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
/*Procedimiento que pasando una habitación y si debe ocuparse(0/1), ocupa o desocupa la habitación*/
Create or replace procedure ocuparHab(numHab number, idHot number, ocupar number)
is
begin
    Update usoHab set ocupada=ocupar where idHotel=idHot and numHabitacion=numHab;
end ocuparHab;
/
/*Procedimiento que recorre todas las habitaciones y utiliza el procedimiento y la función anterior para comprobar y ocupar las 
habitaciones*/
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
--Requisito Nº3
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



--Requisito Nº4

--Requisito Nº5
/*Procedimiento que pasado un nombre de ciudad comprueba si existen hoteles en dicha ciudad*/
create or replace procedure BuscarHotel(ciudad varchar2)
is
    id number;
    nombre varchar2(20);
    --Con el cursor ya filtro solo los hoteles de la ciudad introducida
    Cursor hoteles is Select h.idHotel, h.nomHotel
        from hotel h, ciudad c
        where UPPER(c.nomCiudad)=UPPER(ciudad) and c.idCiudad=h.idCiudad;    
begin
--Aqui compruebo si existen o no registro para esa consulta
open hoteles;
    FETCH Hoteles INTO id, nombre;
    if hoteles%NOTFOUND then
        DBMS_OUTPUT.PUT_LINE('No hay ningun hotel');
    end if;
close hoteles;
    --Aqui muestro los registros de los del cursor, sino hubiese ninguno daría igual, ya que no se mostraría niguno y
    --y se activa el if anterior
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
Create or replace procedure pagosAnuales(idHues number, ano number)
is
    Cursor Total is Select (h.nomhuesped || ' ' || h.apepaterno || ' ' || h.apematerno ) as Nombre, h.idhuesped, To_Char(NVL(SUM(pr.total), '0'), '999g999g990d99l' ) as totalpag
        from huesped h, prepago pr, prephues ph
        where h.idhuesped=idHues and h.idhuesped=ph.idhuesped
        and ph.idprepago=pr.idprepago and To_char(pr.fchprepago, 'yyyy')=ano
        group by (h.nomhuesped || ' ' || h.apepaterno || ' ' || h.apematerno ), h.idhuesped;
    Cursor Pagos is Select (h.nomhuesped || ' ' || h.apepaterno || ' ' || h.apematerno ) as Nombre, h.idhuesped, pr.idprepago, To_Char(NVL(pr.total, '0'), '999g999g990d99l') as totalpag
        from huesped h, prepago pr, prephues ph
        where h.idhuesped=idHues and h.idhuesped=ph.idhuesped
        and ph.idprepago=pr.idprepago and To_char(pr.fchprepago, 'yyyy')=ano;
begin
    for reg in Total loop
        DBMS_OUTPUT.PUT_LINE('Nombre: '||reg.Nombre||', Total pagado: '|| reg.totalpag);
    end loop;
    for reg in Pagos loop
        DBMS_OUTPUT.PUT_LINE('Nombre: '||reg.Nombre||', ID prepago: '|| reg.idprepago || ', pagado: ' || reg.totalpag);
    end loop;
end pagosAnuales;
/
--Requisito Nº12
--Requisito Nº13
--Requisito Nº14
--Requisito Nº15