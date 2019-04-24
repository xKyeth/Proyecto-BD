--Requisito Nº1

/*Nombre componente: Enrique Albors Perilli
Autor: Enrique Albors Perilli	Fecha:10/04/2019
Descripción:  Este procedimiento , buscará  habitaciones según tipo y nº camas ,mostrar habitaciones disponibles por hotel, se podrá elegir un hotel para mostrar datos de este y las habitaciones.*/



create or replace procedure buscaHabitacion(cod char , cod2 number)is

    cursor Y (cod char , cod2 number) IS

        select  h.nomhotel as codigo_hotel , ha.cantcamas as numero_camas  
        from hotel h , habitacion ha 
        where  h.IDHOTEL = ha.IDHOTEL and ha.cantcamas=cod and h.IDHOTEL=cod2 ;

    registro Y%rowtype;

begin
open Y (cod ,cod2);

    if (Y%notfound)then
            DBMS_OUTPUT.PUT_LINE('no existe los datos que usted pide');
        else 
         loop
            fetch Y into registro;
                exit when Y%notfound;
                DBMS_OUTPUT.PUT_LINE(registro.codigo_hotel ||' tiene  '|| registro.numero_camas);
         end loop;
    end if;
close Y;
end;
/

exec buscaHabitacion ( '1' ,'11111' );

--Requisito Nº2
/*Nombre componente: comprHabitacion
Autor: Pedro Cortes	Fecha: 22/04/19
Descripción: Funcion que comprueba las reservas y devuelve si una habitaciÃ³n se debe ocupar*/

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
Descripción: Procedimiento que pasando una habitaciÃ³n y si debe ocuparse(0/1), ocupa o desocupa la habitaciÃ³n*/

Create or replace procedure ocuparHab(numHab number, idHot number, ocupar number)
is
begin
    Update usoHab set ocupada=ocupar where idHotel=idHot and numHabitacion=numHab;
end ocuparHab;
/
/*Nombre componente: ocuparHabitaciones
Autor: Pedro Cortes	Fecha: 22/04/19
Descripción: Procedimiento que recorre todas las habitaciones y utiliza el procedimiento y la funciÃ³n anterior para comprobar y ocupar las 
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

    
/*Funcion que recibe por parametro el ID de prepago y verifica que existe en la base de datos.Si existe devuelve true, en caso de que no
devolvera un false.*/

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


/*Procedimiento que recibe por parametro los ID de huesped y prepago,llama a las dos funciones que verifican que exite el idHuesped y el idPrepago.
Si existe el idHuesped se procede a verificar el idPrepago, si los dos existen se insertan los datos*/

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

/*Codigo a ejecutar. Pide el id del Huesped y del Prepago a introducir manualmente, verifica que cada uno de ellos exista en la base de datos.
Si existen se introduciran en la base de datos,en el caso de que no existan saldra del proceso.*/

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


 /*Nombre componente: Enrique Albors Perilli
Autor: Enrique Albors Perilli	Fecha: 11/04/2019
Descripción: Este procedimiento permitira´ que se cree un usuario automáticamente pasando un email y su passw
ademas para controlar que la longitud de la contraseña no excede a lo que que queremos , se controlará la longitud de 
la contraseña con una función*/

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

 exec creaUsuario2 ('3' , '3444558');
 select usremail  , usrpwd from usuario ;

--funcion validacion contra
create or replace function validaContra (contra varchar2)
return boolean is
    begin 
        if (LENGTH(contra)>6)then
            DBMS_OUTPUT.PUT_LINE('la longitud de su contraseña debe ser menor');RETURN false;
        else 
             DBMS_OUTPUT.PUT_LINE('la longitud de su  contraseña es correcta');return true;
        end if;
end validaContra;
/


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

/*Procedimiento al que se le pasa un ID Huesped por parametro, se verifica que exista el ID pasado, si es asi, se imprimira una ficha
con todos los datos del Huesped.*/
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


/*Codigo a ejecutar. Pide que se introduzca manualmente el ID del Huesped y se carga el procedimiento fichahuesped*/
DECLARE

v_idH NUMBER;

BEGIN

v_idH:='&IDHuesped';
fichahuesped(v_idH);

END;
/


--Requisito Nº7

/*Nombre componente: Enrique Albors Perilli
Autor: Enrique Albors Perilli	Fecha: 17/04/2019
Descripcion : Este procedimiento devolverá todos los datos relevantes de un hotel a raiz del codigo del hotel.
*/


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

--Requisito Nº8
Create or replace procedure pagosPais(idHues number, pais varchar2)
is

begin
end pagosPais;
/
--Requisito Nº9



--Requisito Nº10

/*Nombre componente: Enrique Albors Perilli
Autor: Enrique Albors Perilli	Fecha: 11/04/2019
Descripcion : Procedimiento que a raiz de un codigo de pago , informará si el metodo de pago es aceptado o no .
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
        DBMS_OUTPUT.PUT_LINE('ID prepago: '|| reg.idprepago || ', cantidad: ' || reg.totalpag);
    end loop;
end pagosAnuales;
/
--Requisito Nº12

CREATE OR REPLACE FUNCTION aplicarDescuento (idCup VARCHAR2, precio NUMBER) RETURN NUMBER IS

v_precioConDesc NUMBER;

CURSOR curs IS
    SELECT descuento FROM cupon WHERE idCupon = idCup;

registro curs%ROWTYPE;

BEGIN

OPEN CURS;

    FETCH curs INTO registro;
    
    IF curs%notfound THEN
        DBMS_OUTPUT.PUT_LINE('El cupon introducido no existe');
    ELSE 
    v_precioConDesc := precio/registro.descuento;        
    
    DBMS_OUTPUT.PUT_LINE('El precio original es : ' || precio || ' al que se le ha aplicado un descuento de : ' || registro.descuento || 
    ' del cupón : ' || idCup || ' ,el precio con el descuento aplicado es : ' || ROUND(v_preciocondesc,2));
    
    END IF;
    
    RETURN ROUND(v_preciocondesc,2);

CLOSE CURS;
END;
/


--Requisito Nº13
--Requisito Nº14
Create or replace procedure imprReserva(idR number)
is
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
    DBMS_OUTPUT.PUT_LINE('  Nº Habitacion : ' || registro.numHabitacion);
    DBMS_OUTPUT.PUT_LINE('  Nº Huespedes : ' || registro.canthuesp);
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
--Requisito Nº15