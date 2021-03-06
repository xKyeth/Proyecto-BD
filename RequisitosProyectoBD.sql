--Requisito N�1

/*Nombre componente: buscaHabitacion
Autor: Enrique Albors Perilli	Fecha:10/04/2019
Descripci�n:  Este procedimiento , buscar�  habitaciones seg�n tipo y n� camas ,mostrar habitaciones disponibles por hotel, se podr� elegir un hotel para mostrar datos de este y las habitaciones.*/



create or replace procedure buscaHabitacion(cod char , cod2 number)is

    cursor Y (cod char , cod2 number) IS

        select  h.nomhotel as codigo_hotel , ha.cantcamas as numero_camas  
        from hotel h , habitacion ha 
        where  h.IDHOTEL = ha.IDHOTEL and ha.cantcamas=cod and h.IDHOTEL=cod2 ;

    registro Y%rowtype;

begin
open Y (cod ,cod2);

    fetch Y into registro;
    if (Y%notfound)then
                

            DBMS_OUTPUT.PUT_LINE('no existe los datos que usted pide');
        else 
         
                DBMS_OUTPUT.PUT_LINE(registro.codigo_hotel ||' tiene los datos que usted desea ');
        end if;
close Y;
end;
/

exec buscaHabitacion ( '3' ,'14325' );

--Requisito N�2
/*Nombre componente: comprHabitacion
Autor: Pedro Cortes	Fecha: 22/04/19
Descripci�n: Funcion que comprueba las reservas y devuelve si una habitación se debe ocupar*/

CREATE OR REPLACE FUNCTION comprHabitacion(numHab number, idHot number)
return boolean is
    --Este cursor saca la reserva junto a la fecha de la estancia
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
/*Nombre componente: ocuparHab
Autor: Pedro Cortes	Fecha: 22/04/19
Descripci�n: Procedimiento que pasando una habitación y si debe ocuparse(0/1), ocupa o desocupa la habitación*/

Create or replace procedure ocuparHab(numHab number, idHot number, ocupar number)
is
begin
    Update usoHab set ocupada=ocupar where idHotel=idHot and numHabitacion=numHab;
end ocuparHab;
/
/*Nombre componente: ocuparHabitaciones
Autor: Pedro Cortes	Fecha: 22/04/19
Descripci�n: Procedimiento que recorre todas las habitaciones y utiliza el procedimiento y la función anterior para comprobar y ocupar las 
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

--Requisito N�3

/*Nombre componente: comprPrepago
Autor: Imanol Garcia Fecha: 25/04/19
Descripci�n: Funcion que recibe por parametro el ID de prepago y verifica que existe en la base de datos.Si existe devuelve true, en caso de que no
devolvera un false */


CREATE OR REPLACE FUNCTION comprPrepago (idPrep NUMBER) RETURN BOOLEAN IS

CURSOR curs IS
    SELECT idprepago FROM prepago WHERE idprepago=idPrep;
    
registro curs%ROWTYPE;

BEGIN

OPEN curs;

    FETCH curs INTO registro;
    
    IF idPrep IN (registro.idprepago) THEN
        DBMS_OUTPUT.PUT_LINE('El prepago existe en la base de datos.');
        return true;
    ELSE
        DBMS_OUTPUT.PUT_LINE('El prepago no existe en la base de datos.');
        return false;
    END IF;
       
CLOSE curs;
END;
/


/*Nombre componente: RellenarPrepHuesped
Autor: Imanol Garcia Fecha: 25/04/19
Descripci�n: Procedimiento que recibe por parametro los ID de huesped y prepago,llama a las dos funciones que verifican que exite el idHuesped y el idPrepago.
Si existe el idHuesped se procede a verificar el idPrepago, si los dos existen se insertan los datos */


CREATE OR REPLACE PROCEDURE RellenarPrepHuesped(v_idH NUMBER, v_idP NUMBER) IS
BEGIN

IF(comprhuesped(v_idH)) THEN

    IF(comprPrepago(v_idP)) THEN
    
        INSERT INTO prepHues VALUES (v_idP,v_idH);       
        DBMS_OUTPUT.PUT_LINE('Se ha introducido correctamente el huesped con ID : '||v_idh||' y el prepago con ID : '||v_idp||'.');
        
    END IF;
    
END IF;
END;
/


--Requisito N�4


 /*Nombre componente: creaUsuario2
 Autor: Enrique Albors Perilli	Fecha: 11/04/2019
Descripci�n: Este procedimiento permitira� que se cree un usuario autom�ticamente pasando un email y su passw
 , ademas se pedir�  una longitud minima de contrase�a*/
 
 --funcion validacion contra
create or replace function validaContra (contra varchar2)
return boolean is
begin 
 if (LENGTH(contra)>6)then
    DBMS_OUTPUT.PUT_LINE('la longitud de su contrase�a debe ser menor');RETURN false;
    else 
    DBMS_OUTPUT.PUT_LINE('la longitud de su  contrase�a es correcta');return true;
 end if;
end validaContra;
/



create or replace procedure creaUsuario2 (usuario char , passwd char) is
 
    cursor Y (usuario char , passwd char) is 
    
        select usremail  , usrpwd from usuario ; 
       
        registro Y%rowtype;
       
begin
        open Y (usuario , passwd);
            fetch Y into registro;
                if (validaContra(passwd)=true)then
                 INSERT INTO usuario VALUES (usuario,passwd);
                end if;    
end;
/

 exec creaUsuario2 ('5' , '34445');
 select usremail  , usrpwd from usuario ;


--Requisito N�5

/*Nombre componente: BuscarHotel
Autor: Pedro Cortes	Fecha: 22/04/19
Descripci�n: Procedimiento que pasado un nombre de ciudad comprueba si existen hoteles en dicha ciudad*/

create or replace procedure BuscarHotel(ciudad varchar2)
is
    id number;
    nombre varchar2(40);
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
    --Aqui muestro los registros de los del cursor, sino hubiese ninguno dar�a igual, ya que no se mostrar�a niguno y
    --y se activa el if anterior
    for reg in hoteles loop
        DBMS_output.put_line('Nombre: '|| reg.nomHotel || ', ID: ' || reg.idHotel);
    end loop;    
end BuscarHotel;
/

--Requisito N�6


/*Nombre componente: FichaHuesped
Autor: Imanol Garcia Fecha: 25/04/19
Descripci�n: Procedimiento al que se le pasa un ID Huesped por parametro, se verifica que exista el ID pasado, si es asi, se imprimira una ficha
con todos los datos del Huesped. */


CREATE OR REPLACE PROCEDURE FichaHuesped (idH NUMBER) IS
CURSOR curs IS
    SELECT * FROM HUESPED WHERE idHuesped=idH;

registro curs%rowtype;
BEGIN
OPEN CURS;

    LOOP
    
    FETCH curs INTO registro;
    
    EXIT WHEN curs%notfound;

    IF (comprhuesped(idH))THEN
    DBMS_OUTPUT.PUT_LINE('Imprimiendo ficha del cliente');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('***********************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('INFORMACION DEL CLIENTE');
    DBMS_OUTPUT.PUT_LINE('Codigo del Huespued : '|| registro.idHuesped);
    DBMS_OUTPUT.PUT_LINE('Nombre del Huespued : '|| registro.nomhuesped || ' ,Primer apellido : '||registro.apepaterno || ' ,Segundo apellido : '||registro.apematerno);
    DBMS_OUTPUT.PUT_LINE('El cliente ha traido el tipo de documento : '||registro.tipodocumento||' y el numero del documento es : '||registro.numdocumento);
    DBMS_OUTPUT.PUT_LINE('PARA CONTACTAR CON EL CLIENTE');
    DBMS_OUTPUT.PUT_LINE('Email : '||registro.email ||'   Telefono : '||registro.tel);
    DBMS_OUTPUT.PUT_LINE('***********************************************************************************************');  

    END IF;

    END LOOP;
    
CLOSE CURS;
END;
/



--Requisito N�7

/*Nombre componente: fichaHoteles
Autor: Enrique Albors Perilli	Fecha: 17/04/2019
Descripcion : Este procedimiento devolver� todos los datos relevantes de un hotel a raiz del codigo del hotel.*/


 create or replace procedure fichaHoteles (cod number) is
 
     cursor Y (cod number) is 
     select h.nomhotel as nombre , c.nomciudad as ciudad , p.nompais as pais from hotel h , ciudad c , pais p where h.idhotel=cod and h.idciudad=c.idciudad and c.idpais = p.idpais  ;   
     registro Y%rowtype;
     
     cursor X (cod number) is
     select count (ha.cantcamas) as numero from habitacion ha , hotel h  where h.idhotel=cod and h.idhotel=ha.idhotel; 
     habita X%rowtype;
     
     cursor simple (cod number) is 
     select count (ha.cantcamas) as numero from habitacion ha , hotel h  where h.idhotel=cod and h.idhotel=ha.idhotel and ha.idtipohab='SNG'; 
     habita1 simple%rowtype;
     
     cursor doble (cod number) is 
     select count (ha.cantcamas) as numero from habitacion ha , hotel h  where h.idhotel=cod and h.idhotel=ha.idhotel and ha.idtipohab='DBL'; 
     habita2 doble%rowtype;
     
     cursor triple (cod number) is 
     select count (ha.cantcamas) as numero from habitacion ha , hotel h  where h.idhotel=cod and h.idhotel=ha.idhotel and ha.idtipohab='BRK'; 
     habita3 triple%rowtype;
     
     cursor lujo (cod number) is 
     select count (ha.cantcamas) as numero from habitacion ha , hotel h  where h.idhotel=cod and h.idhotel=ha.idhotel and ha.idtipohab='LUX'; 
     habita4 lujo%rowtype;
       
begin
    open Y (cod) ;
    fetch Y into registro;
            DBMS_OUTPUT.PUT_LINE('************************************************************');
            DBMS_OUTPUT.PUT_LINE( 'Hotel :  '|| registro.nombre ||'   Pais:'  || registro.pais ||'  Ciudad  :'|| registro.ciudad );
    close Y;

    open X (cod);
    fetch X into habita;
            DBMS_OUTPUT.PUT_LINE( 'la cantidad total de camas de este hotel es  '||habita.numero );
    close X;

    open simple (cod);
        fetch simple into habita1;
            DBMS_OUTPUT.PUT_LINE( 'la cantidad total de camas simples  es  '||habita1.numero );
    close simple;

    open doble (cod);
        fetch doble into habita2;
            DBMS_OUTPUT.PUT_LINE( 'la cantidad total de camas simples  es  '||habita2.numero );
    close doble;

    open triple (cod);
        fetch triple into habita3;
            DBMS_OUTPUT.PUT_LINE( 'la cantidad total de camas simples  es  '||habita3.numero );
    close triple;

    open lujo (cod);
        fetch lujo into habita4;
            DBMS_OUTPUT.PUT_LINE( 'la cantidad total de camas simples  es  '||habita4.numero );
    close lujo;

end;
/

exec fichahoteles ('14325');

--Requisito N�8
/*Nombre componente: reservasPais
Autor: Pedro Cortes	Fecha: 22/04/19
Descripci�n: Procedimiento que pasado un pais devuelve las reservas que hicieron los cliente de este*/

Create or replace procedure reservasPais(pai varchar2)
is
    Cursor clientes is Select h.idHuesped, h.nomHuesped, pr.total, rs.fchreserva, rs.fchdesde, rs.fchhasta, 
        ho.nomhotel, rs.numhabitacion, rg.Descrregimen
        from pais pa, huesped h, prephues ph, prepago pr, usuario us, reserva rs, hotel ho, regimen rg
        where UPPER(pa.nompais)=UPPER(pai) and pa.idpais=h.pais
        and ph.idhuesped=ph.idHuesped and ph.idprepago=pr.idprepago
        and pr.usremail=us.usremail and us.usremail=rs.usremail
        and rs.idhotel=ho.idhotel and rs.idregimen=rg.idregimen;
begin
    for reg in clientes loop
        DBMS_OUTPUT.PUT_LINE('Huesped : ' || reg.nomHuesped);
        DBMS_OUTPUT.PUT_LINE('Fecha Reserva : ' || reg.fchdesde || 'Hasta ' || reg.fchhasta);
        DBMS_OUTPUT.PUT_LINE('Regimen: ' || reg.Descrregimen);
        DBMS_OUTPUT.PUT_LINE('Pago : ' || reg.total);
        DBMS_OUTPUT.PUT_LINE('Hotel : ' || reg.nomhotel);
        DBMS_OUTPUT.PUT_LINE('Habitacion : ' || reg.numhabitacion);
    end loop;
end reservasPais;
/
--Requisito N�9

/*Nombre componente: comprHuesped
Autor:Imanol Garcia Fecha: 25/04/2019
Descripcion : Funcion que recibe el idHuesped por parametro que comprueba si existe en la base de datos, si existe devuelve true si no
devuelve false*/

create or replace FUNCTION comprHuesped (idHues NUMBER) RETURN BOOLEAN IS

CURSOR curs IS
    SELECT idhuesped FROM huesped WHERE idhuesped=idHues; 
registro curs%ROWTYPE;

BEGIN

OPEN curs;

    FETCH curs INTO registro;

    IF idHues IN (registro.idhuesped) THEN
        DBMS_OUTPUT.PUT_LINE('El huesped existe en la base de datos');
        RETURN TRUE;
    ELSE
        DBMS_OUTPUT.PUT_LINE('El huesped no existe en la base de datos');
        RETURN false;
    END IF;

CLOSE curs;
END;
/


--Requisito N�10

/*Nombre componente: pagoCorrecto
Autor: Enrique Albors Perilli	Fecha: 11/04/2019
Descripcion : Procedimiento que a raiz de un codigo de pago , informar� si el metodo de pago es aceptado o no .
*/

create or replace procedure pagoCorrecto (codigo char ) is

Cursor Y (codigo char) is
    select empresa from metodo_de_pago where codigo_metodo=codigo;

registro Y%rowtype;

begin 

    open Y (codigo );
       if (codigo >=7)then
          DBMS_OUTPUT.PUT_LINE('el metodo de pago no existe');
       else
          DBMS_OUTPUT.PUT_LINE('El metodo de pago es correcto');
       end if;
close Y;
end;
/


EXEC PAGOCORRECTO (8);

--Requisito N�11
/*Nombre componente: pagosAnuales
Autor: Pedro Cortes	Fecha: 22/04/19
Descripci�n: Procedimiento en el cual se le pasa un huesped y una a�o y te devuelve los pagos de ese huesped ese a�o y el total*/
Create or replace procedure pagosAnuales(idHues number, ano number)
is
    --Cursor en el cual saco el total de los pagos del cliente ese a�o
    Cursor Total is Select (h.nomhuesped || ' ' || h.apepaterno || ' ' || h.apematerno ) as Nombre, h.idhuesped, To_Char(NVL(SUM(pr.total), '0'), '999g999g990d99l' ) as totalpag
        from huesped h, prepago pr, prephues ph
        where h.idhuesped=idHues and h.idhuesped=ph.idhuesped
        and ph.idprepago=pr.idprepago and To_char(pr.fchprepago, 'yyyy')=ano
        group by (h.nomhuesped || ' ' || h.apepaterno || ' ' || h.apematerno ), h.idhuesped;
    --Cursor en el cual saco los pagos para mostrarlos
    Cursor Pagos is Select (h.nomhuesped || ' ' || h.apepaterno || ' ' || h.apematerno ) as Nombre, h.idhuesped, pr.idprepago, To_Char(NVL(pr.total, '0'), '999g999g990d99l') as totalpag
        from huesped h, prepago pr, prephues ph
        where h.idhuesped=idHues and h.idhuesped=ph.idhuesped
        and ph.idprepago=pr.idprepago and To_char(pr.fchprepago, 'yyyy')=ano;
begin
    for reg in Total loop
        DBMS_OUTPUT.PUT_LINE('Nombre: '||reg.Nombre||', Total pagado: '|| reg.totalpag);
    end loop;
    for reg in Pagos loop
        DBMS_OUTPUT.PUT_LINE('ID prepago: '|| reg.idprepago || ', cantidad: ' || reg.totalpag);
    end loop;
end pagosAnuales;
/
--Requisito N�12

/*Nombre componente: aplicarDescuento
Autor: Imanol Garcia Fecha: 25/04/19
Descripci�n: Recibe por parametro un cupon y un precio, el cupon tiene asignado un porcentaje de descuento que se le aplicara al precio y
devolvera el precio con el descuento correspondiente*/

CREATE OR REPLACE FUNCTION aplicarDescuento (idCup VARCHAR2, precio NUMBER) RETURN NUMBER IS

v_precioConDesc NUMBER;

CURSOR curs IS
    SELECT descuento FROM cupon WHERE idCupon = idCup;

registro curs%ROWTYPE;

BEGIN

OPEN CURS;

    FETCH curs INTO registro;
    
    IF curs%notfound THEN
        DBMS_OUTPUT.PUT_LINE('El cup�n introducido no existe');
    ELSE 
    v_precioConDesc := precio/registro.descuento;        
    
    DBMS_OUTPUT.PUT_LINE('El precio original es : ' || precio || ' al que se le ha aplicado un descuento de : ' || registro.descuento || 
    '% del cup�n : ' || idCup || ' ,el precio con el descuento aplicado es : ' || ROUND(v_preciocondesc,2));
    
    END IF;
    
    RETURN ROUND(v_preciocondesc,2);

CLOSE CURS;
END;
/


--Requisito N�13
/*Nombre componente: esperareserva
Autor: Enrique Albors Perilli	Fecha: 24/04/2019
Descripcion :Este trigger se dispar� cuando se cree una nueva reserva , pasando el usuario que la cree a una tabla
especifico para el
*/

INSERT INTO usuario VALUES ('usr10@gmail.com','pwd8');
INSERT INTO reserva VALUES (11,'usr10@gmail.com',14325,1,1,'MP','31-12-2014','01-02-2015','15-02-2015');



create or replace trigger esperareserva
    after  insert on reserva 
    for each row 
begin

    insert into reservaPorPagar values (:new.usremail);

end;
/




--Requisito N�14

/*Nombre componente: imprReserva
Autor: Pedro Cortes	Fecha: 22/04/19
Descripci�n: Procedimiento el cual nos indica los datos de una reserva mostrando los datos de esta*/

Create or replace procedure imprReserva(idR number)
is
    --Cursor en el cual saco la reserva junto con sus datos
    Cursor reserva is Select r.* ,rg.descrRegimen, h.nomHotel  
        from reserva r, hotel h, regimen rg  
        where r.idreserva=idR
        and rg.idRegimen=r.idRegimen and r.idHotel=h.idHotel; 
    registro reserva%rowtype;
Begin
    open reserva;
    FETCH reserva INTO registro;
    if reserva%FOUND then
    DBMS_OUTPUT.PUT_LINE('Imprimiendo ficha de la reserva');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('***********************************************************************************************');
    DBMS_OUTPUT.PUT_LINE('INFORMACION DE LA RESERVA');
    DBMS_OUTPUT.PUT_LINE('ID de la Reserva : ' || registro.idReserva);
    DBMS_OUTPUT.PUT_LINE('Email del usuario : ' || registro.usremail);
    DBMS_OUTPUT.PUT_LINE('Hotel : ' || registro.nomHotel);
    DBMS_OUTPUT.PUT_LINE('  N� Habitacion : ' || registro.numHabitacion);
    DBMS_OUTPUT.PUT_LINE('  N� Huespedes : ' || registro.canthuesp);
    DBMS_OUTPUT.PUT_LINE('  Tipo de reserva : ' || registro.descrRegimen);
    DBMS_OUTPUT.PUT_LINE('Fecha de la reserva : ' || registro.fchReserva);
    DBMS_OUTPUT.PUT_LINE('  Inicio de la reserva : ' || registro.fchDesde);
    DBMS_OUTPUT.PUT_LINE('  Fin de la reserva : ' || registro.fchHasta);
    DBMS_OUTPUT.PUT_LINE('***********************************************************************************************');    
    else
    DBMS_OUTPUT.PUT_LINE('No existe reserva para el este id');
    end if;
end imprReserva;
/
--Requisito N�15

/*Nombre componente: auditoriatablas
Autor: Imanol Garcia Fecha: 25/04/2019
Descripcion :Este procedimiento inserta el dato pasado por parametro en la tabla auditoria*/


CREATE OR REPLACE PROCEDURE auditoriatablas (gd VARCHAR2) IS

begin

INSERT INTO AUDITORIA VALUES (gd);

END;
/

/*Nombre componente: audHotel
Autor: Pedro Cortes Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla Hotel*/



Create or replace trigger audHotel
    before INSERT OR UPDATE OR DELETE ON Hotel
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
        auditoriatablas((:old_buffer.IdHotel ||' '|| :old_buffer.nomhotel ||' '|| :old_buffer.idciudad ||' '|| 'Deleting Hotel'));
    END IF;
    IF updating THEN
        auditoriatablas((:old_buffer.IdHotel ||' '|| :old_buffer.nomhotel ||' '|| :old_buffer.idciudad ||' '|| 'Inserting Hotel'));
    END IF;
    if inserting THEN
        auditoriatablas((:new_buffer.IdHotel ||' '|| :new_buffer.nomhotel ||' '|| :new_buffer.idciudad ||' '|| 'Updating Hotel'));
    END IF;
end audHotel;
/
/*Nombre componente: audPais
Autor: Pedro Cortes Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla Pais*/


Create or replace trigger audPais
    before INSERT OR UPDATE OR DELETE ON Pais
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
        auditoriatablas((:old_buffer.IdPais ||' '|| :old_buffer.nompais ||' '|| 'Deleting Pais'));
    END IF;
    IF updating THEN
        auditoriatablas((:old_buffer.IdPais ||' '|| :old_buffer.nompais ||' '|| 'Inserting Pais'));
    END IF;
    if inserting THEN
        auditoriatablas((:new_buffer.IdPais ||' '|| :new_buffer.nompais ||' '|| 'Updating Pais'));
    END IF;
end audPais;
/
/*Nombre componente: audUsoHab
Autor: Pedro Cortes Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla UsoHab*/


Create or replace trigger audUsoHAB
    before INSERT OR UPDATE OR DELETE ON UsoHab
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
        auditoriatablas((:old_buffer.IdHotel ||' '|| :old_buffer.NUMHABITACION ||' '|| :old_buffer.fecha ||' '|| :old_buffer.ocupada ||' '|| 'Deleting UsoHab'));
    END IF;
    IF updating THEN
        auditoriatablas((:old_buffer.IdHotel ||' '|| :old_buffer.NUMHABITACION ||' '|| :old_buffer.fecha ||' '|| :old_buffer.ocupada ||' '|| 'Inserting UsoHab'));
    END IF;
    if inserting THEN
        auditoriatablas((:new_buffer.IdHotel ||' '|| :new_buffer.NUMHABITACION ||' '|| :new_buffer.fecha ||' '|| :new_buffer.ocupada ||' '|| 'Updating UsoHab'));
    END IF;
end audHotel;
/
/*Nombre componente: audReserva
Autor: Pedro Cortes Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla Reserva*/


Create or replace trigger audREserva
    before INSERT OR UPDATE OR DELETE ON Reserva
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
        auditoriatablas((:old_buffer.IdReserva ||' '|| :old_buffer.usremail ||' '|| :old_buffer.idHotel ||' '|| :old_buffer.numhabitacion ||' '|| :old_buffer.canthuesp ||' '|| :old_buffer.idregimen ||' '|| :old_buffer.fchreserva ||' '|| :old_buffer.fchdesde ||' '|| :old_buffer.fchhasta ||' '|| 'Deleting Reserva'));
    END IF;
    IF updating THEN
        auditoriatablas((:old_buffer.IdReserva ||' '|| :old_buffer.usremail ||' '|| :old_buffer.idHotel ||' '|| :old_buffer.numhabitacion ||' '|| :old_buffer.canthuesp ||' '|| :old_buffer.idregimen ||' '|| :old_buffer.fchreserva ||' '|| :old_buffer.fchdesde ||' '|| :old_buffer.fchhasta ||' '|| 'Inserting Reserva'));
    END IF;
    if inserting THEN
        auditoriatablas((:new_buffer.IdReserva ||' '|| :new_buffer.usremail ||' '|| :new_buffer.idHotel ||' '|| :new_buffer.numhabitacion ||' '|| :new_buffer.canthuesp ||' '|| :new_buffer.idregimen ||' '|| :new_buffer.fchreserva ||' '|| :new_buffer.fchdesde ||' '|| :new_buffer.fchhasta ||' '|| 'Updating Reserva'));
    END IF;
end audHotel;
/

/*Nombre componente: audCiudad
Autor: Pedro Cortes Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla Ciudad*/


Create or replace trigger audCiudad
    before INSERT OR UPDATE OR DELETE ON Ciudad
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
        auditoriatablas((:old_buffer.IdCiudad ||' '|| :old_buffer.NOMCIUDAD ||' '|| :old_buffer.IDPAIS ||' '|| 'Deleting Ciudad'));
    END IF;
    IF updating THEN
        auditoriatablas((:old_buffer.IdCiudad ||' '|| :old_buffer.NOMCIUDAD ||' '|| :old_buffer.IDPAIS ||' '|| 'Inserting Ciudad'));
    END IF;
    if inserting THEN
        auditoriatablas((:new_buffer.IdCiudad ||' '|| :new_buffer.NOMCIUDAD ||' '|| :new_buffer.IDPAIS ||' '|| 'Updating Ciudad'));
    END IF;
end audCiudad;
/
/*Nombre componente: audCupon
Autor: Enrique Albors Perilli Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla Cupon*/


Create or replace trigger audCupon
    before INSERT OR UPDATE OR DELETE ON Cupon
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
        auditoriatablas((:old_buffer.idcupon ||' '|| :old_buffer.descuento ||' '|| 'Deleting Cupon'));
    END IF;
    IF updating THEN
    auditoriatablas((:old_buffer.idcupon ||' '|| :old_buffer.descuento ||' '|| 'Inserting Cupon'));
    END IF;
    if inserting THEN
    auditoriatablas((:new_buffer.idcupon ||' '|| :new_buffer.descuento ||' '|| 'Updating Cupon'));
    END IF;
end audCiudad;
/
/*Nombre componente: audHuesped
Autor: Enrique Albors Perilli Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla Huesped*/


Create or replace trigger audHuesped
    before INSERT OR UPDATE OR DELETE ON huesped
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
    auditoriatablas((:old_buffer.idhuesped ||' '|| :old_buffer.nomhuesped ||' '||:old_buffer.apepaterno ||' '||:old_buffer.apematerno ||' '||:old_buffer.tipodocumento ||' '||:old_buffer.numdocumento ||' '||:old_buffer.email ||' '||:old_buffer.tel ||' '||:old_buffer.pais ||' '|| 'Deleting huesped'));
    END IF;
    IF updating THEN
    auditoriatablas((:old_buffer.idhuesped ||' '|| :old_buffer.nomhuesped ||' '||:old_buffer.apepaterno ||' '||:old_buffer.apematerno ||' '||:old_buffer.tipodocumento ||' '||:old_buffer.numdocumento ||' '||:old_buffer.email ||' '||:old_buffer.tel ||' '||:old_buffer.pais ||' '|| 'Inserting huesped'));
    END IF;
    if inserting THEN
    auditoriatablas((:new_buffer.idhuesped ||' '|| :new_buffer.nomhuesped ||' '||:new_buffer.apepaterno ||' '||:new_buffer.apematerno ||' '||:new_buffer.tipodocumento ||' '||:new_buffer.numdocumento ||' '||:new_buffer.email ||' '||:new_buffer.tel ||' '||:new_buffer.pais ||' '|| 'Updating huesped'));
    END IF;
end audHuesped;
/

/*Nombre componente: audRegimen
Autor: Enrique Albors Perilli Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla Regimen*/


Create or replace trigger audRegimen
    before INSERT OR UPDATE OR DELETE ON Regimen
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
        auditoriatablas((:old_buffer.idregimen ||' '|| :old_buffer.descrregimen ||' '|| 'Deleting Regimen'));
    END IF;
    IF updating THEN
    auditoriatablas((:old_buffer.idregimen ||' '|| :old_buffer.descrregimen ||' '|| 'Inserting Regimen'));
    END IF;
    if inserting THEN
    auditoriatablas((:new_buffer.idregimen ||' '|| :new_buffer.descrregimen ||' '|| 'Updating Regimen'));
    END IF;
end audRegimen;
/
/*Nombre componente: audReservaPorPagar
Autor: Enrique Albors Perilli Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla ReservaPorPagar*/


Create or replace trigger audReservaporpagar
    before INSERT OR UPDATE OR DELETE ON Reservaporpagar
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
        auditoriatablas((:old_buffer.usremail ||' '||  'Deleting Reservaporpagar'));
    END IF;
    IF updating THEN
    auditoriatablas((:old_buffer.usremail ||' '||  'Inserting Reservaporpagar'));
    END IF;
    if inserting THEN
    auditoriatablas((:new_buffer.usremail ||' '||  'Updating Reservaporpagar'));
    END IF;
end audReservaporpagar;
/
/*Nombre componente: audUsuario
Autor: Enrique Albors Perilli Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla Usuario*/


Create or replace trigger audUsuario
    before INSERT OR UPDATE OR DELETE ON Usuario
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
        auditoriatablas((:old_buffer.usremail ||' '|| :old_buffer.usrpwd ||' '|| 'Deleting Usuario'));
    END IF;
    IF updating THEN
    auditoriatablas((:old_buffer.usremail ||' '|| :old_buffer.usrpwd ||' '|| 'Inserting Usuario'));
    END IF;
    if inserting THEN
    auditoriatablas((:new_buffer.usremail ||' '|| :new_buffer.usrpwd ||' '|| 'Updating Usuario'));
    END IF;
end audUsuario;
/

/*Nombre componente: audHabitacion
Autor: Imanol Garcia Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla Habitacion*/


Create or replace trigger audHabitacion
    before INSERT OR UPDATE OR DELETE ON Habitacion
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
        auditoriatablas((:old_buffer.IdHotel ||' '|| :old_buffer.numhabitacion ||' '|| :old_buffer.idtipohab ||' '|| :old_buffer.cantcamas ||' '|| 'Deleting Habitacion'));
    END IF;
    IF updating THEN
        auditoriatablas((:old_buffer.IdHotel ||' '|| :old_buffer.numhabitacion ||' '|| :old_buffer.idtipohab ||' '|| :old_buffer.cantcamas ||' '|| 'Inserting Habitacion'));
    END IF;
    if inserting THEN
        auditoriatablas((:new_buffer.IdHotel ||' '|| :new_buffer.numhabitacion ||' '|| :new_buffer.idtipohab ||' '|| :new_buffer.cantcamas ||' '|| 'Updating Habitacion'));
    END IF;
end audHabitacion;
/

/*Nombre componente: audMetodoDePago
Autor: Imanol Garcia Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla Metodo_De_Pago*/


Create or replace trigger audMetodoDePago
    before INSERT OR UPDATE OR DELETE ON Metodo_De_Pago
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
        auditoriatablas((:old_buffer.codigo_metodo ||' '|| :old_buffer.empresa ||' '|| 'Deleting Metodo de pago'));
    END IF;
    IF updating THEN
        auditoriatablas((:old_buffer.codigo_metodo ||' '|| :old_buffer.empresa ||' '|| 'Inserting Metodo de pago'));
    END IF;
    if inserting THEN
        auditoriatablas((:new_buffer.codigo_metodo ||' '|| :new_buffer.empresa ||' '|| 'Updating Metodo de pago'));
    END IF;
end audMetodoDePago;
/


/*Nombre componente: audPrepago
Autor: Imanol Garcia Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla Prepago*/


Create or replace trigger audPrepago
    before INSERT OR UPDATE OR DELETE ON Prepago
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
        auditoriatablas((:old_buffer.idprepago ||' '|| :old_buffer.usremail ||' '|| :old_buffer.idhotel ||' '|| :old_buffer.numhabitacion ||' '|| :old_buffer.idregimen ||' '|| :old_buffer.fchprepago ||' '|| :old_buffer.fchdesde ||' '|| :old_buffer.fchhasta ||' '|| :old_buffer.total ||' '|| :old_buffer.codigopago ||' '||  'Deleting Prepago'));
    END IF;
    IF updating THEN
        auditoriatablas((:old_buffer.idprepago ||' '|| :old_buffer.usremail ||' '|| :old_buffer.idhotel ||' '|| :old_buffer.numhabitacion ||' '|| :old_buffer.idregimen ||' '|| :old_buffer.fchprepago ||' '|| :old_buffer.fchdesde ||' '|| :old_buffer.fchhasta ||' '|| :old_buffer.total ||' '|| :old_buffer.codigopago ||' '|| 'Inserting Prepago'));
    END IF;
    if inserting THEN
        auditoriatablas((:new_buffer.idprepago ||' '|| :new_buffer.usremail ||' '|| :new_buffer.idhotel ||' '|| :new_buffer.numhabitacion ||' '|| :new_buffer.idregimen ||' '|| :new_buffer.fchprepago ||' '|| :new_buffer.fchdesde ||' '|| :new_buffer.fchhasta ||' '|| :new_buffer.total ||' '|| :new_buffer.codigopago ||' '||  'Updating Prepago'));
    END IF;
end audPrepago;
/

/*Nombre componente: audTipoHab
Autor: Imanol Garcia Fecha: 25/04/2019
Descripcion :Trigger que salta antes de que se haga un delete, update o insert sobre la tabla TipoHab*/


Create or replace trigger audTipoHab
    before INSERT OR UPDATE OR DELETE ON TipoHab
    REFERENCING OLD AS old_buffer NEW AS new_buffer 
    FOR EACH ROW
begin
    IF DELETING THEN
        auditoriatablas((:old_buffer.idHotel ||' '|| :old_buffer.idTipoHab ||' '|| 'Deleting Tipo Habitacion'));
    END IF;
    IF updating THEN
        auditoriatablas((:old_buffer.idHotel ||' '|| :old_buffer.idTipoHab ||' '|| 'Inserting Tipo Habitacion'));
    END IF;
    if inserting THEN
        auditoriatablas((:new_buffer.idHotel ||' '|| :new_buffer.idTipoHab ||' '|| 'Updating Tipo Habitacion'));
    END IF;
end audTipoHab;
/








