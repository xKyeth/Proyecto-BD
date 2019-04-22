CREATE TABLE pais (
    idPais number(2) NOT NULL,
    nomPais varchar2(20) NOT NULL,
    CONSTRAINT PK_pais PRIMARY KEY (idPais)
	);
CREATE TABLE ciudad (
    idCiudad  number(5) NOT NULL,
    nomCiudad varchar2(20) NOT NULL,
    idPais number(2) NOT NULL,
    CONSTRAINT PK_ciu PRIMARY KEY (idCiudad),
	CONSTRAINT FK_ciu_idPais FOREIGN KEY (idPais) REFERENCES pais (idPais) 
	);
CREATE TABLE hotel (
    idHotel    number(5) NOT NULL,
    nomHotel   varchar2(30) NOT NULL,
    idCiudad   number(5) NOT NULL,
	CONSTRAINT PK_hot PRIMARY KEY (idHotel),
	CONSTRAINT FK_hot_idCiu FOREIGN KEY (idCiudad) REFERENCES ciudad(idCiudad)
	);
CREATE TABLE tipohab (
	idHotel      number(5) NOT NULL,
   	idTipoHab    CHAR(3) NOT NULL, 
    CONSTRAINT   PK_tipohab PRIMARY KEY (idHotel,idTipoHab)
    );	
CREATE TABLE habitacion (
	idHotel       number(5) NOT NULL,
    numHabitacion number(5) NOT NULL,
	idTipoHab     CHAR(3) NOT NULL,
    cantCamas     number(2) NOT NULL,	
	CONSTRAINT    PK_hab PRIMARY KEY (idHotel, numHabitacion),
	CONSTRAINT    FK_hab_idhot_idtipoHab FOREIGN KEY (idHotel,idTipoHab) REFERENCES tipoHab (idHotel,idTipoHab),
	CONSTRAINT	  FK_hab_idhot_numhab FOREIGN KEY (idHotel) REFERENCES hotel(idHotel) 
	);
CREATE TABLE usohab (
	idHotel       number(5) NOT NULL,
    numHabitacion number(5) NOT NULL,
	fecha         DATE NOT NULL, 	
	ocupada       number,
	CONSTRAINT    PK_usohab PRIMARY KEY (idHotel, numHabitacion, fecha),
    CONSTRAINT	  FK_usohab_hot_numhab FOREIGN KEY (idHotel, numHabitacion) REFERENCES habitacion(idHotel, numHabitacion) 
	);
CREATE TABLE usuario (
	usremail   CHAR(25) NOT NULL,
	usrpwd     CHAR(12) NOT NULL, 
    CONSTRAINT   PK_usuario PRIMARY KEY (usremail)
    );	
CREATE TABLE regimen (
	idRegimen    CHAR(2) NOT NULL,
	descrRegimen CHAR(30) NOT NULL, 
    CONSTRAINT   PK_regimen PRIMARY KEY (idRegimen)
    );	
CREATE TABLE reserva (
    idReserva     number(12,0),
	usremail      CHAR(25),
	idHotel       number(5) NOT NULL,
    numHabitacion number(5) NOT NULL,
    canthuesp     number(1) NOT NULL,
	idRegimen     CHAR(2) NOT NULL,
	fchReserva    DATE NOT NULL,
	fchDesde      DATE NOT NULL,
	fchHasta      DATE NOT NULL,
	CONSTRAINT    PK_res PRIMARY KEY (idReserva),
	CONSTRAINT    FK_res_usremail FOREIGN Key (usremail) REFERENCES usuario (usrEmail),
	CONSTRAINT    FK_res_idhot_numHab FOREIGN KEY (idHotel,numHabitacion) REFERENCES habitacion (idHotel,numHabitacion),
	CONSTRAINT    FK_res_idreg FOREIGN KEY (idRegimen) REFERENCES regimen (idRegimen)
	);
CREATE TABLE huesped (
	idHuesped     number(12) NOT NULL,
    nomHuesped    varchar2(15) NOT NULL,
	apePaterno    varchar2(15) NOT NULL,
	apeMaterno    varchar2(15),
	tipoDocumento CHAR(8) NOT NULL,
	numDocumento  number(15) NOT NULL,
	email         varchar2(30),
	tel           number(15) NOT NULL,
	CONSTRAINT PK_hues PRIMARY KEY (idHuesped)
	);	
CREATE TABLE prepago (
    idPrepago     number(12,0),
	usremail      CHAR(25),
	idHotel       number(5) NOT NULL,
    numHabitacion number(5) NOT NULL,
	idRegimen     CHAR(2) NOT NULL,
	fchPrepago    DATE NOT NULL,
	fchDesde      DATE NOT NULL,
	fchHasta      DATE NOT NULL,
	CONSTRAINT    PK_prep PRIMARY KEY (idPrepago),
	CONSTRAINT    FK_prep_usremail FOREIGN Key (usremail) REFERENCES usuario (usrEmail),
	CONSTRAINT    FK_prep_idhot_numhab FOREIGN KEY (idHotel,numHabitacion) REFERENCES habitacion(idHotel,numHabitacion),
	CONSTRAINT    FK_prep_idreg FOREIGN KEY (idRegimen) REFERENCES regimen (idRegimen)
	);
CREATE TABLE prephues (
    idPrepago     number(12,0) NOT NULL,
	idHuesped     number(12) NOT NULL,
	CONSTRAINT    PK_prephues PRIMARY KEY (idPrepago, idHuesped),
	CONSTRAINT    FK_prephues_idprep FOREIGN KEY (idPrepago) REFERENCES prepago (idPrepago),
	CONSTRAINT    FK_prepago_idhuesped  FOREIGN KEY (idHuesped) REFERENCES huesped (idHuesped)
	);
    
    
    
INSERT INTO pais VALUES (1,'Uruguay');
INSERT INTO pais VALUES (2,'Argentina');
INSERT INTO pais VALUES (3,'Brasil');


INSERT INTO ciudad VALUES (1,'Montevideo',1);
INSERT INTO ciudad VALUES (2,'Punta Del Este',1);
INSERT INTO ciudad VALUES (3,'Rio De Janeiro',3);


INSERT INTO hotel VALUES (11111, 'Hotel Radisson Victoria Plaza',1);
INSERT INTO hotel VALUES (22222, 'Hotel Sheraton Montevideo',1);
INSERT INTO hotel VALUES (33333, 'Hotel Four Points Montevideo',1);
INSERT INTO hotel VALUES (44444, 'Hotel Conrad',2);
INSERT INTO hotel VALUES (55555, 'Atlantico Boutique Hotel',2);
INSERT INTO hotel VALUES (66666, 'Barradas Parque Hotel and Spa',2);
INSERT INTO hotel VALUES (77777, 'Golden Beach Resort and Spa',2);
INSERT INTO hotel VALUES (14325, 'Copacabana Palace Hotel',3);


INSERT INTO tipohab VALUES (14325, 'SNG');
INSERT INTO tipohab VALUES (14325, 'DBL');
INSERT INTO tipohab VALUES (14325, 'LUX');
INSERT INTO tipohab VALUES (14325, 'BRK');
INSERT INTO tipohab VALUES (11111, 'SNG');
INSERT INTO tipohab VALUES (11111, 'DBL');
INSERT INTO tipohab VALUES (11111, 'BRK');
INSERT INTO tipohab VALUES (33333, 'SNG');
INSERT INTO tipohab VALUES (33333, 'DBL');
INSERT INTO tipohab VALUES (33333, 'LUX');
INSERT INTO tipohab VALUES (44444, 'SNG');
INSERT INTO tipohab VALUES (44444, 'DBL');
INSERT INTO tipohab VALUES (55555, 'SNG');



INSERT INTO habitacion VALUES (11111,1,'SNG',1);
INSERT INTO habitacion VALUES (11111,2,'DBL',2);
INSERT INTO habitacion VALUES (11111,3,'DBL',2);
INSERT INTO habitacion VALUES (11111,4,'DBL',2);
INSERT INTO habitacion VALUES (11111,100,'BRK',99);
INSERT INTO habitacion VALUES (11111,200,'BRK',99);
INSERT INTO habitacion VALUES (14325,1,'SNG',1);
INSERT INTO habitacion VALUES (14325,2,'DBL',2);
INSERT INTO habitacion VALUES (14325,3,'DBL',2);
INSERT INTO habitacion VALUES (14325,4,'DBL',2);
INSERT INTO habitacion VALUES (14325,5,'LUX',4);
INSERT INTO habitacion VALUES (14325,1000,'BRK',98);
INSERT INTO habitacion VALUES (14325,2000,'BRK',98);
INSERT INTO habitacion VALUES (33333,1,'SNG',1);
INSERT INTO habitacion VALUES (33333,2,'LUX',4);
INSERT INTO habitacion VALUES (33333,3,'DBL',4);
INSERT INTO habitacion VALUES (33333,4,'DBL',4);
INSERT INTO habitacion VALUES (44444,1,'SNG',1);
INSERT INTO habitacion VALUES (44444,2,'DBL',1);
INSERT INTO habitacion VALUES (55555,1,'SNG',1);





INSERT INTO usohab VALUES (11111,1,'01-10-2017',0);
INSERT INTO usohab VALUES (11111,1,'02-10-2017',0);
INSERT INTO usohab VALUES (11111,1,'03-10-2017',1);
INSERT INTO usohab VALUES (11111,1,'04-10-2017',1);
INSERT INTO usohab VALUES (11111,1,'05-10-2017',0);
INSERT INTO usohab VALUES (11111,1,'06-10-2017',0);
INSERT INTO usohab VALUES (11111,1,'07-10-2017',0);
INSERT INTO usohab VALUES (11111,1,'08-10-2017',0);
INSERT INTO usohab VALUES (11111,2,'01-10-2017',0);
INSERT INTO usohab VALUES (11111,2,'02-10-2017',0);
INSERT INTO usohab VALUES (11111,2,'03-10-2017',1);
INSERT INTO usohab VALUES (11111,2,'04-10-2017',0);
INSERT INTO usohab VALUES (11111,2,'05-10-2017',0);
INSERT INTO usohab VALUES (11111,2,'06-10-2017',0);
INSERT INTO usohab VALUES (11111,2,'07-10-2017',0);
INSERT INTO usohab VALUES (11111,2,'08-10-2017',0);
INSERT INTO usohab VALUES (11111,3,'01-10-2017',0);
INSERT INTO usohab VALUES (11111,3,'02-10-2017',0);
INSERT INTO usohab VALUES (11111,3,'03-10-2017',1);
INSERT INTO usohab VALUES (11111,3,'04-10-2017',0);
INSERT INTO usohab VALUES (11111,3,'05-10-2017',0);
INSERT INTO usohab VALUES (11111,3,'06-10-2017',0);
INSERT INTO usohab VALUES (11111,3,'07-10-2017',0);
INSERT INTO usohab VALUES (11111,3,'08-10-2017',0);
INSERT INTO usohab VALUES (11111,4,'01-10-2017',0);
INSERT INTO usohab VALUES (11111,4,'02-10-2017',0);
INSERT INTO usohab VALUES (11111,4,'03-10-2017',1);
INSERT INTO usohab VALUES (11111,4,'04-10-2017',0);
INSERT INTO usohab VALUES (11111,4,'05-10-2017',0);
INSERT INTO usohab VALUES (11111,4,'06-10-2017',0);
INSERT INTO usohab VALUES (11111,4,'07-10-2017',0);
INSERT INTO usohab VALUES (11111,4,'08-10-2017',0);
INSERT INTO usohab VALUES (11111,100,'01-10-2017',0);
INSERT INTO usohab VALUES (11111,100,'02-10-2017',0);
INSERT INTO usohab VALUES (11111,100,'03-10-2017',1);
INSERT INTO usohab VALUES (11111,100,'04-10-2017',0);
INSERT INTO usohab VALUES (11111,100,'05-10-2017',0);
INSERT INTO usohab VALUES (11111,100,'06-10-2017',0);
INSERT INTO usohab VALUES (11111,100,'07-10-2017',0);
INSERT INTO usohab VALUES (11111,100,'08-10-2017',0);
INSERT INTO usohab VALUES (11111,200,'01-10-2017',0);
INSERT INTO usohab VALUES (11111,200,'02-10-2017',0);
INSERT INTO usohab VALUES (11111,200,'03-10-2017',1);
INSERT INTO usohab VALUES (11111,200,'04-10-2017',0);
INSERT INTO usohab VALUES (11111,200,'05-10-2017',0);
INSERT INTO usohab VALUES (11111,200,'06-10-2017',0);
INSERT INTO usohab VALUES (11111,200,'07-10-2017',0);
INSERT INTO usohab VALUES (11111,200,'08-10-2017',0);
INSERT INTO usohab VALUES (33333,1,'01-10-2017',0);
INSERT INTO usohab VALUES (33333,1,'02-10-2017',0);
INSERT INTO usohab VALUES (33333,1,'03-10-2017',1);
INSERT INTO usohab VALUES (33333,1,'04-10-2017',1);
INSERT INTO usohab VALUES (33333,1,'05-10-2017',0);
INSERT INTO usohab VALUES (33333,1,'06-10-2017',0);
INSERT INTO usohab VALUES (33333,1,'07-10-2017',0);
INSERT INTO usohab VALUES (33333,1,'08-10-2017',0);
INSERT INTO usohab VALUES (33333,2,'01-10-2017',0);
INSERT INTO usohab VALUES (33333,2,'02-10-2017',0);
INSERT INTO usohab VALUES (33333,2,'03-10-2017',1);
INSERT INTO usohab VALUES (33333,2,'04-10-2017',0);
INSERT INTO usohab VALUES (33333,2,'05-10-2017',0);
INSERT INTO usohab VALUES (33333,2,'06-10-2017',0);
INSERT INTO usohab VALUES (33333,2,'07-10-2017',0);
INSERT INTO usohab VALUES (33333,2,'08-10-2017',0);
INSERT INTO usohab VALUES (33333,3,'01-10-2017',0);
INSERT INTO usohab VALUES (33333,3,'02-10-2017',0);
INSERT INTO usohab VALUES (33333,3,'03-10-2017',1);
INSERT INTO usohab VALUES (33333,3,'04-10-2017',0);
INSERT INTO usohab VALUES (33333,3,'05-10-2017',0);
INSERT INTO usohab VALUES (33333,3,'06-10-2017',0);
INSERT INTO usohab VALUES (33333,3,'07-10-2017',0);
INSERT INTO usohab VALUES (33333,3,'08-10-2017',0);
INSERT INTO usohab VALUES (33333,4,'01-10-2017',0);
INSERT INTO usohab VALUES (33333,4,'02-10-2017',0);
INSERT INTO usohab VALUES (33333,4,'03-10-2017',1);
INSERT INTO usohab VALUES (33333,4,'04-10-2017',0);
INSERT INTO usohab VALUES (33333,4,'05-10-2017',0);
INSERT INTO usohab VALUES (33333,4,'06-10-2017',0);
INSERT INTO usohab VALUES (33333,4,'07-10-2017',0);
INSERT INTO usohab VALUES (33333,4,'08-10-2017',0);
INSERT INTO usohab VALUES (14325,1,'01-10-2017',0);
INSERT INTO usohab VALUES (14325,1,'02-10-2017',0);
INSERT INTO usohab VALUES (14325,1,'03-10-2017',1);
INSERT INTO usohab VALUES (14325,1,'04-10-2017',1);
INSERT INTO usohab VALUES (14325,1,'05-10-2017',0);
INSERT INTO usohab VALUES (14325,1,'06-10-2017',0);
INSERT INTO usohab VALUES (14325,1,'07-10-2017',0);
INSERT INTO usohab VALUES (14325,1,'08-10-2017',0);
INSERT INTO usohab VALUES (14325,2,'01-10-2017',0);
INSERT INTO usohab VALUES (14325,2,'02-10-2017',0);
INSERT INTO usohab VALUES (14325,2,'03-10-2017',1);
INSERT INTO usohab VALUES (14325,2,'04-10-2017',0);
INSERT INTO usohab VALUES (14325,2,'05-10-2017',0);
INSERT INTO usohab VALUES (14325,2,'06-10-2017',0);
INSERT INTO usohab VALUES (14325,2,'07-10-2017',0);
INSERT INTO usohab VALUES (14325,2,'08-10-2017',0);
INSERT INTO usohab VALUES (14325,3,'01-10-2017',0);
INSERT INTO usohab VALUES (14325,3,'02-10-2017',0);
INSERT INTO usohab VALUES (14325,3,'03-10-2017',1);
INSERT INTO usohab VALUES (14325,3,'04-10-2017',0);
INSERT INTO usohab VALUES (14325,3,'05-10-2017',0);
INSERT INTO usohab VALUES (14325,3,'06-10-2017',0);
INSERT INTO usohab VALUES (14325,3,'07-10-2017',0);
INSERT INTO usohab VALUES (14325,3,'08-10-2017',0);
INSERT INTO usohab VALUES (14325,4,'01-10-2017',0);
INSERT INTO usohab VALUES (14325,4,'02-10-2017',0);
INSERT INTO usohab VALUES (14325,4,'03-10-2017',1);
INSERT INTO usohab VALUES (14325,4,'04-10-2017',0);
INSERT INTO usohab VALUES (14325,4,'05-10-2017',0);
INSERT INTO usohab VALUES (14325,4,'06-10-2017',0);
INSERT INTO usohab VALUES (14325,4,'07-10-2017',0);
INSERT INTO usohab VALUES (14325,4,'08-10-2017',0);
INSERT INTO usohab VALUES (14325,5,'01-10-2017',0);
INSERT INTO usohab VALUES (14325,5,'02-10-2017',0);
INSERT INTO usohab VALUES (14325,5,'03-10-2017',1);
INSERT INTO usohab VALUES (14325,5,'04-10-2017',0);
INSERT INTO usohab VALUES (14325,5,'05-10-2017',0);
INSERT INTO usohab VALUES (14325,5,'06-10-2017',0);
INSERT INTO usohab VALUES (14325,5,'07-10-2017',0);
INSERT INTO usohab VALUES (14325,5,'08-10-2017',0);
INSERT INTO usohab VALUES (14325,1000,'01-10-2017',0);
INSERT INTO usohab VALUES (14325,1000,'02-10-2017',0);
INSERT INTO usohab VALUES (14325,1000,'03-10-2017',1);
INSERT INTO usohab VALUES (14325,1000,'04-10-2017',0);
INSERT INTO usohab VALUES (14325,1000,'05-10-2017',0);
INSERT INTO usohab VALUES (14325,1000,'06-10-2017',0);
INSERT INTO usohab VALUES (14325,1000,'07-10-2017',0);
INSERT INTO usohab VALUES (14325,1000,'08-10-2017',0);
INSERT INTO usohab VALUES (14325,2000,'01-10-2017',0);
INSERT INTO usohab VALUES (14325,2000,'02-10-2017',0);
INSERT INTO usohab VALUES (14325,2000,'03-10-2017',1);
INSERT INTO usohab VALUES (14325,2000,'04-10-2017',0);
INSERT INTO usohab VALUES (14325,2000,'05-10-2017',0);
INSERT INTO usohab VALUES (14325,2000,'06-10-2017',0);
INSERT INTO usohab VALUES (14325,2000,'07-10-2017',0);
INSERT INTO usohab VALUES (14325,2000,'08-10-2017',0);



INSERT INTO usuario VALUES ('PCuevas@gmail.com','pwdPC');
INSERT INTO usuario VALUES ('usr2@gmail.com','pwd1');
INSERT INTO usuario VALUES ('usr3@gmail.com','pwd3');
INSERT INTO usuario VALUES ('usr4@gmail.com','pwd4');
INSERT INTO usuario VALUES ('usr5@gmail.com','pwd5');
INSERT INTO usuario VALUES ('usr6@gmail.com','pwd6');
INSERT INTO usuario VALUES ('usr7@gmail.com','pwd7');





INSERT INTO regimen VALUES ('SA','Solo Alojamiento');
INSERT INTO regimen VALUES ('AD','Alojamiento y Desayuno');
INSERT INTO regimen VALUES ('MP','Media Pensi?n');
INSERT INTO regimen VALUES ('PC','Pensi?n Completa');
INSERT INTO regimen VALUES ('TI','Todo Inclu?do');



INSERT INTO reserva VALUES (1,'PCuevas@gmail.com',14325,1,1,'MP','31-12-2014','01-02-2015','15-02-2015');
INSERT INTO reserva VALUES (2,'PCuevas@gmail.com',14325,1,1,'MP','31-12-2015','01-02-2016','15-03-2016');
INSERT INTO reserva VALUES (3,'PCuevas@gmail.com',14325,1,1,'MP','31-10-2016','01-02-2017','17-02-2016');
INSERT INTO reserva VALUES (4,'PCuevas@gmail.com',55555,1,1,'MP','31-12-2014','01-01-2015','15-01-2015');
INSERT INTO reserva VALUES (5,'PCuevas@gmail.com',55555,1,1,'MP','31-12-2015','01-01-2016','15-01-2016');
INSERT INTO reserva VALUES (6,'PCuevas@gmail.com',55555,1,1,'MP','31-10-2016','01-01-2017','17-01-2016');
INSERT INTO reserva VALUES (7,'usr7@gmail.com',44444,2,2,'PC','31-12-2014','01-01-2015','15-01-2015');
INSERT INTO reserva VALUES (8,'usr7@gmail.com',44444,2,2,'PC','31-12-2015','01-01-2016','15-01-2016');
INSERT INTO reserva VALUES (9,'usr7@gmail.com',44444,2,2,'PC','31-10-2016','01-01-2017','17-01-2016');




INSERT INTO huesped VALUES (123456789012,'Huesped','Uno','Dos', 1, 12345678, 'UHuesped@hotmail.com',99123456);
INSERT INTO huesped VALUES (234567890123,'Huesped','Dos','Tres', 1, 23456789, 'DHuesped@Gmail.com',99234567);



INSERT INTO prepago VALUES (1,'PCuevas@gmail.com',14325,1,'MP','31-12-2014','01-02-2015','15-02-2015');
INSERT INTO prepago VALUES (2,'PCuevas@gmail.com',14325,1,'MP','31-12-2015','01-02-2016','15-03-2016');
INSERT INTO prepago VALUES (3,'PCuevas@gmail.com',14325,1,'MP','31-10-2016','01-02-2017','17-02-2016');
INSERT INTO prepago VALUES (4,'PCuevas@gmail.com',44444,1,'MP','31-12-2014','01-01-2015','15-01-2015');
INSERT INTO prepago VALUES (5,'PCuevas@gmail.com',44444,1,'MP','31-10-2015','21-11-2016','21-11-2016');
INSERT INTO prepago VALUES (6,'PCuevas@gmail.com',44444,1,'MP','31-10-2016','23-11-2017','23-11-2016');
INSERT INTO prepago VALUES (7,'usr7@gmail.com',44444,1,'PC','31-12-2014','01-01-2015','15-01-2015');
INSERT INTO prepago VALUES (8,'usr7@gmail.com',44444,1,'PC','31-12-2015','01-01-2016','15-01-2016');
INSERT INTO prepago VALUES (9,'usr7@gmail.com',44444,2,'PC','31-10-2016','01-01-2017','17-01-2016');
INSERT INTO prepago VALUES (10,'usr7@gmail.com',44444,1,'MP','31-10-2015','21-11-2016','21-11-2016');
INSERT INTO prepago VALUES (11,'usr7@gmail.com',44444,1,'MP','31-10-2016','23-11-2017','23-11-2016');
INSERT INTO prepago VALUES (12,'usr7@gmail.com',14325,1,'MP','31-10-2015','21-11-2016','21-11-2016');
INSERT INTO prepago VALUES (13,'usr7@gmail.com',14325,1,'MP','31-10-2016','23-11-2016','23-11-2016');


INSERT INTO prephues VALUES (5,123456789012);
INSERT INTO prephues VALUES (6,234567890123);
INSERT INTO prephues VALUES (12,123456789012);
INSERT INTO prephues VALUES (13,234567890123);

commit;



DROP TABLE PREPHUES;
DROP TABLE PREPAGO;
DROP TABLE HUESPED;
DROP TABLE RESERVA;
DROP TABLE REGIMEN;
DROP TABLE USUARIO;
DROP TABLE USOHAB;
DROP TABLE HABITACION;
DROP TABLE TIPOHAB;
DROP TABLE HOTEL;
DROP TABLE ciudad;
DROP TABLE PAIS;

--Alteraciones de Tablas y Campos

Alter table prepago add total number(8,2);
Update prepago set total=1500.00;

INSERT INTO huesped VALUES (1,'Alexis','Flores','Santos', 1, 1112, 'Huesped1@hotmail.com',954123451);
INSERT INTO huesped VALUES (2,'Ian','Bosch','Jimenez', 1, 1213, 'Huesped2@Gmail.com',954123452);
INSERT INTO huesped VALUES (3,'Ivan','Alvarez','Blanco', 1, 1314, 'Huesped3@Gmail.com',954123453);
INSERT INTO huesped VALUES (4,'Joel','Gonzalez','Ruiz', 1, 1415, 'Huesped4@Gmail.com',954123454);
INSERT INTO huesped VALUES (5,'Aitor','Dominguez','Pastor',1, 1516, 'Huesped5@Gmail.com',954123455);
INSERT INTO huesped VALUES (6,'Jimena','Pujol','Nuñez', 1, 1617, 'Huesped6@Gmail.com',954123456);
INSERT INTO huesped VALUES (7,'Mireia','Medina','Arias', 1, 1718, 'Huesped7@Gmail.com',954123457);
INSERT INTO huesped VALUES (8,'Leire','Reyes','Lopez',1, 1819, 'Huesped8@Gmail.com',954123458);

Alter table huesped add 
    pais number(2,0);
Alter table huesped add 
    constraint hus_pai_fk FOREIGN KEY(pais) REFERENCES Pais;
Update huesped set pais=1;

create table metodo_de_pago (
codigo_metodo number(2) constraint met_cod_pk Primary key,
empresa varchar2(1000)
);
alter table prepago add codigoPago number(2);
alter table prepago add constraint prp_cpa_fk foreign key(codigoPago) References metodo_de_pago(codigo_metodo);


insert into metodo_de_pago values (1 ,'paypal' );
insert into metodo_de_pago values (2 ,'transferencia bancaria');
insert into metodo_de_pago values (3 ,'ingreso en cajero ' );
insert into metodo_de_pago values (4 ,'pago en efectivo');
insert into metodo_de_pago values (5 ,'cheque al portador' );
insert into metodo_de_pago values (6 ,'financiado a 2 meses' );

CREATE TABLE cupon (

    idCupon VARCHAR2(10),
    descuento NUMBER(3)

);


INSERT INTO cupon VALUES ('UX3FmJxMVc',15);
INSERT INTO cupon VALUES ('uQB7SHHjxn',25);
INSERT INTO cupon VALUES ('L13Bm39JVd',20);
INSERT INTO cupon VALUES ('k1mjr9CtIM',12);
INSERT INTO cupon VALUES ('sZINDNTv9p',8);
INSERT INTO cupon VALUES ('X3UodVmG96',3);



Commit;  