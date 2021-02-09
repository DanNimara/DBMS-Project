CREATE TABLE cinematograf
        (cinematograf_id number(4) constraint pk_cin primary key, 
         nume varchar2(50) constraint nume_cin not null,
         adresa varchar2(100) not null,
         data_infiintare date default sysdate
        );

CREATE TABLE sala
        (sala_id number(4) constraint pk_sala primary key, 
         capacitate number(3) constraint cap_sala not null,
         tip_proiectie varchar(10) default '2D',
         cinematograf_id number(4) constraint fk_sala references cinematograf(cinematograf_id) ON DELETE CASCADE
        );

CREATE OR REPLACE TYPE tab_imb IS TABLE OF varchar2(20);
/

CREATE TABLE film
        (film_id number(4) constraint pk_film primary key, 
         titlu varchar2(225) constraint titlu_film not null,
         gen tab_imb default tab_imb(),
         durata number(3),
         data_lansarii date default sysdate,
         regizor varchar2(50),
         limba varchar2(3),
         tara varchar2(20),
         clasificare varchar2(9)
        )
NESTED TABLE gen STORE AS tab_imb_gen;

CREATE TABLE difuzeaza
        (film_id number(4) constraint fk_dif_film references film(film_id) ON DELETE CASCADE,
        sala_id number(4) constraint fk_dif_sala references sala(sala_id) ON DELETE CASCADE,
        data_dif date default sysdate,
        primary key(film_id, sala_id, data_dif)
        );

CREATE TABLE spectator
        (spectator_id number(4) constraint pk_spectator primary key, 
         nume varchar2(20) constraint nume_spectator not null,
         prenume varchar2(20),
         numar_telefon char(10) unique,
         sex char(1)
        );

CREATE TABLE bilet
        (bilet_id number(4) constraint pk_bilet primary key,
        randl number(2) not null,
        loc number(3) not null,
        pret number(5,2),
        data_dif date default sysdate,
        tip_reducere varchar2(20),
        film_id number(4) constraint fk_bilet_film references film(film_id) ON DELETE CASCADE,
        sala_id number(4) constraint fk_bilet_sala references sala(sala_id) ON DELETE CASCADE,
        spectator_id number(4) constraint fk_bilet_spectator references spectator(spectator_id) ON DELETE CASCADE
        );

--Atunci cand se introduce o noua difuzare, trebuie sa ne asiguram ca data difuzarii nu preceda data lansarii filmului.

CREATE OR REPLACE TRIGGER difuzare_permisa
BEFORE INSERT OR UPDATE ON difuzeaza
FOR EACH ROW
DECLARE
    lansare film.data_lansarii%TYPE;
BEGIN
    SELECT data_lansarii
    INTO lansare
    FROM film
    WHERE film_id = :NEW.film_id;
    IF :NEW.data_dif<lansare THEN
        RAISE_APPLICATION_ERROR(-20000,'Nu se poate difuza un film inainte de data lansarii acestuia!');
    END IF;
END;
/
--ALTER TRIGGER difuzare_permisa DISABLE;
--ALTER TRIGGER difuzare_permisa ENABLE;

INSERT INTO cinematograf
       VALUES(1, 'Jay and Silent Bob Multiplex', '58 Leonard Avenue, Leonardo', '19-OCT-1994');

INSERT INTO cinematograf
       VALUES(2, 'Hitchcock Multiplex', '517 High Road, Leytonstone, London', '13-AUG-1899');

INSERT INTO cinematograf
       VALUES(3, 'The Supercalifragilistic Cinema Experience', '500 S. Buena Vista St., Burbank, CA', '27-AUG-1964');
     
INSERT INTO cinematograf
       VALUES(4, 'Gisaengchung Cinema', 'Bongdeok-dong, Daegu, South Korea', '19-FEB-2000'); 

INSERT INTO cinematograf
       VALUES(5, 'Inglorious, Fictitious and Unchained Feet Cinema', '1822 Sepulveda Blvd., Manhattan Beach, CA, USA', '09-OCT-1992');       

INSERT INTO cinematograf
       VALUES(6, 'Hitchcock Multiplex', 'Bel Air, Los Angeles, CA, USA', '29-APR-1980');
       
INSERT INTO cinematograf
       VALUES(7, 'Time and Relative Dimensions in Cinema', 'White City, W12 7RJ, London, UK', '23-NOV-1963');

SELECT * FROM cinematograf;

INSERT INTO sala
        VALUES(1, 120, '2D', 1);

INSERT INTO sala
        VALUES(2, 160, '3D', 1);

INSERT INTO sala
        VALUES(3, 200, '3D', 2);

INSERT INTO sala
        VALUES(4, 300, 'IMAX 3D', 2);

INSERT INTO sala
        VALUES(5, 100, '4DX 2D', 5);

INSERT INTO sala
        VALUES(6, 25, 'VIP 2D', 3);
    
INSERT INTO sala
        VALUES(7, 25, 'VIP 3D', 3);

INSERT INTO sala
        VALUES(8, 160, '3D', 4);

INSERT INTO sala
        VALUES(9, 150, '4DX 3D', 1);

INSERT INTO sala
        VALUES(10, 100, 'IMAX 2D', 2);
        
INSERT INTO sala
        VALUES(11, 250, '2D', 6);
    
INSERT INTO sala
        VALUES(12, 110, 'IMAX 2D', 7);
        
INSERT INTO sala
        VALUES(13, 215, '3D', 6);

SELECT * FROM sala;

INSERT INTO film
        VALUES(1, 'Back to the Future', tab_imb('Adventure', 'Comedy', 'Sci-Fi'), 116, '19-JUL-1985', 'Robert Zemeckis', 'EN', 'USA', 'PG-13');

INSERT INTO film
        VALUES(2, 'It''s A Wonderful Life', tab_imb('Drama', 'Family', 'Fantasy'), 131, '20-DEC-1946', 'Frank Capra', 'EN', 'USA', 'PG');

INSERT INTO film
        VALUES(3, 'Gone Girl', tab_imb('Drama', 'Mystery', 'Thriller'), 149, '03-OCT-2014', 'David Fincher', 'EN', 'USA', 'R');

INSERT INTO film
        VALUES(4, 'Psycho', tab_imb('Horror', 'Mystery', 'Thriller'), 109, '08-SEP-1960', 'Alfred Hitchcock', 'EN', 'USA', 'R');

INSERT INTO film
        VALUES(5, 'Baby Driver', tab_imb('Action', 'Crime', 'Music'), 113, '28-JUN-2017', 'Edgar Wright', 'EN', 'USA', 'R');
        
INSERT INTO film
        VALUES(6, 'Knives Out', tab_imb('Comedy', 'Crime', 'Drama'), 130, '27-NOV-2019', 'Rian Johnson', 'EN', 'USA', 'PG-13');
    
INSERT INTO film
        VALUES(7, 'Parasite', tab_imb('Comedy', 'Drama', 'Thriller'), 132, '30-MAY-2019', '	Bong Joon-ho', 'KO', 'South Korea', 'R');
        
INSERT INTO film
        VALUES(8, 'Forrest Gump', tab_imb('Drama', 'Romance', 'Comedy'), 142, '06-JUL-1994', 'Robert Zemeckis', 'EN', 'USA', 'PG-13');

INSERT INTO film
        VALUES(9, 'Metropolis', tab_imb('Drama', 'Sci-Fi', 'Thriller'), 153, '10-JAN-1927', 'Fritz Lang', 'DE', 'Germany', 'PG-13');

INSERT INTO film
        VALUES(10, '12 Angry Men', tab_imb('Crime', 'Drama', 'Courtroom Drama'), 96, '10-APR-1957', 'Sidney Lumet', 'EN', 'USA', 'PG-13');
        
INSERT INTO film
        VALUES(11, 'A Trip to the Moon', tab_imb('Short', 'Adventure', 'Comedy'), 9, '01-SEP-1902', 'Georges M�li�s', 'SIL', 'France', 'G');

INSERT INTO film
        VALUES(12, 'City Lights', tab_imb('Comedy', 'Drama', 'Romance'), 87, '07-MAR-1931', 'Charles Chaplin', 'EN', 'USA', 'G');
        
SELECT * FROM film;

INSERT INTO difuzeaza
        VALUES(1, 2, sysdate-30);

INSERT INTO difuzeaza
        VALUES(2, 1, sysdate-2.3);

INSERT INTO difuzeaza
        VALUES(2, 2, sysdate-5.6);

INSERT INTO difuzeaza
        VALUES(3, 1, sysdate-7);

INSERT INTO difuzeaza
        VALUES(3, 4, sysdate-10.1);

INSERT INTO difuzeaza
        VALUES(4, 5, sysdate-1.2);

INSERT INTO difuzeaza
        VALUES(5, 5, sysdate-15);
        
INSERT INTO difuzeaza
        VALUES(5, 3, sysdate-13.71);

INSERT INTO difuzeaza
        VALUES(1, 3, sysdate-4.3);

INSERT INTO difuzeaza
        VALUES(5, 1, sysdate-0.3);
        
INSERT INTO difuzeaza
        VALUES(3, 2, sysdate-132.3);
--      
INSERT INTO difuzeaza
        VALUES(10, 8, sysdate-451.8);

INSERT INTO difuzeaza
        VALUES(7, 8, sysdate-512.6);
        
INSERT INTO difuzeaza
        VALUES(9, 1, sysdate-645.04);
        
INSERT INTO difuzeaza
        VALUES(2, 10, sysdate-99.7);
        
INSERT INTO difuzeaza
        VALUES(8, 4, sysdate-222.1);
        
INSERT INTO difuzeaza
        VALUES(5, 3, sysdate-1.13);

-- Nu se poate difuza un film inainte de data lansarii acestuia!
--INSERT INTO difuzeaza
--        VALUES(6, 6, sysdate-873.6);
        
INSERT INTO difuzeaza
        VALUES(9, 5, sysdate-451);
        
INSERT INTO difuzeaza
        VALUES(7, 9, sysdate-51);

INSERT INTO difuzeaza
        VALUES(4, 2, sysdate-11);

INSERT INTO difuzeaza
        VALUES(7, 1, sysdate-332.8);
----
INSERT INTO difuzeaza
        VALUES(2, 13, sysdate-123.2);

INSERT INTO difuzeaza
        VALUES(9, 12, sysdate-570);

INSERT INTO difuzeaza
        VALUES(10, 11, sysdate-3.5);
        
INSERT INTO difuzeaza
        VALUES(1, 7, sysdate-100);

SELECT film_id, sala_id, TO_CHAR(data_dif,'DD-MM-YYYY HH:MM:SS') FROM difuzeaza;

INSERT INTO spectator
        VALUES(1, 'Nimara', 'Dan-Gabriel', '0762669402', 'M');

INSERT INTO spectator
        VALUES(2, 'Alexandrescu', 'Paula', '0799168286', 'F');

INSERT INTO spectator
        VALUES(3, 'Barbu', 'Mariana-Lenuta', '0748984069', 'F');

INSERT INTO spectator
        VALUES(4, 'Oprian', 'George-Adrian', '0743441168', 'M');

INSERT INTO spectator
        VALUES(5, 'Pavalasc', 'Irina', '0756161429', 'F');

INSERT INTO spectator
        VALUES(6, 'Negulescu', 'Radu', '0755004495', 'M');

INSERT INTO spectator
        VALUES(7, 'Lapadus', 'Raluca', '0723161118', 'F');

INSERT INTO spectator
        VALUES(8, 'Simion', 'Roberto-Florian', '0720617882', 'M');

INSERT INTO spectator
        VALUES(9, 'Apostoiu', 'Antonio-Ciprian', '0727761387', 'M');

INSERT INTO spectator
        VALUES(10, 'Varga', 'Robert', '0767251023', 'M');

INSERT INTO spectator
        VALUES(11, 'Dima', 'Oana-Teodora', '0720309259', 'F');

INSERT INTO spectator
        VALUES(12, 'Bigan', 'Marian', '0720078066', 'M');

INSERT INTO spectator
        VALUES(13, 'Moanga', 'Natalia', '07XXXXXXXX', 'F');

SELECT * FROM spectator;

INSERT INTO bilet
        VALUES(1, 12, 14, 41, sysdate-1.2, NULL, 4, 5, 1);

INSERT INTO bilet
        VALUES(2, 6, 12, 19.5, sysdate-2.3, 'Pensionar', 2, 1, 12);

INSERT INTO bilet
        VALUES(3, 5, 12, 17.5, sysdate-15, 'Student', 5, 5, 10);

INSERT INTO bilet
        VALUES(4, 14, 10, 41, sysdate-4.3, NULL, 1, 3, 3);

INSERT INTO bilet
        VALUES(5, 8, 9, 16.5, sysdate-2.3, 'Copil', 2, 1, 11);

INSERT INTO bilet
        VALUES(6, 11, 2, 25.5, sysdate-30, NULL, 1, 2, 6);

INSERT INTO bilet
        VALUES(7, 6, 8, 46, sysdate-51, NULL, 7, 9, 8);
--nou
INSERT INTO bilet
        VALUES(8, 16, 8, 23.5, sysdate-7, NULL, 3, 1, 6);
        
INSERT INTO bilet
        VALUES(9, 12, 14, 21.5, sysdate-1.13, 'Pensionar', 5, 3, 4);
        
INSERT INTO bilet
        VALUES(10, 5, 7, 42.5, sysdate-451, 'Avanpremiera', 9, 5, 1);
        
INSERT INTO bilet
        VALUES(11, 3, 10, 66, sysdate-873.6, 'Pensionar', 6, 6, 12);
        
INSERT INTO bilet
        VALUES(12, 10, 4, 20.5, sysdate-99.7, 'Student', 2, 10, 5);
        
INSERT INTO bilet
        VALUES(13, 2, 6, 70, sysdate-100, NULL, 1, 7, 3);
        
INSERT INTO bilet
        VALUES(14, 13, 13, 25.5, sysdate-1.13, NULL, 5, 3, 13);
        
INSERT INTO bilet
        VALUES(15, 10, 8, 41, sysdate-15, NULL, 5, 5, 2);
        
INSERT INTO bilet
        VALUES(16, 9, 11, 18.5, sysdate-99.7, NULL, 2, 10, 11);
        
INSERT INTO bilet
        VALUES(17, 15, 12, 25.5, sysdate-5.6, NULL, 2, 2, 3);
        
INSERT INTO bilet
        VALUES(18, 6, 16, 17.5, sysdate-645.04, 'Student', 9, 1, 3);
        
INSERT INTO bilet
        VALUES(19, 8, 10, 21.5, sysdate-512.6, 'Student', 7, 8, 9);
        
INSERT INTO bilet
        VALUES(20, 10, 18, 29.5, sysdate-222.1, NULL, 8, 4, 13);
        
INSERT INTO bilet
        VALUES(21, 6, 17, 23.5, sysdate-645.04, NULL, 9, 1, 1);
        
INSERT INTO bilet
        VALUES(22, 7, 9, 19.5, sysdate-3.5, 'Pensionar', 10, 11, 12);

INSERT INTO bilet
        VALUES(23, 9, 10, 21.5, sysdate-570, 'Pensionar', 9, 12, 4);

SELECT * FROM bilet;

-- SELECT b.bilet_id, sp.nume, f.titlu, s.tip_proiectie, c.nume
-- FROM bilet b JOIN spectator sp ON (b.spectator_id = sp.spectator_id)
--                 JOIN film f ON (b.film_id = f.film_id)
--                 JOIN sala s ON (b.sala_id = s.sala_id)
--                 JOIN cinematograf c ON (s.cinematograf_id = c.cinematograf_id);


-- 6. Scrieti un subprogram stocat care primeste ca parametru de intrare un an si afiseaza 
-- detalii despre filmele aparute pana in acel an inclusiv printr-un parametru de iesire de tip colectie.


CREATE OR REPLACE PACKAGE p6_pkg IS
TYPE tablou_indexat IS TABLE OF film%ROWTYPE INDEX BY BINARY_INTEGER;
END;
/

CREATE OR REPLACE PROCEDURE 
       p6(an IN VARCHAR2,
        detalii_filme OUT p6_pkg.tablou_indexat) IS 
    dummy NUMBER;
  BEGIN
    SELECT null INTO dummy
    FROM film
    WHERE TO_CHAR(data_lansarii, 'YYYY') <= an AND rownum=1;
    SELECT * BULK COLLECT INTO detalii_filme 
    FROM   film
    WHERE  TO_CHAR(data_lansarii, 'YYYY') <= an;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20000, 'Nu exista filme aparute inainte de anul precizat');
    WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
  END p6;
/

DECLARE
   filme p6_pkg.tablou_indexat;
BEGIN
  p6(2020,filme);
  FOR i IN filme.FIRST..filme.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Filmul '|| filme(i).titlu || ' regizat de ' || filme(i).regizor || ', aparut in anul ' || TO_CHAR(filme(i).data_lansarii, 'YYYY') || ' si avand o durata de ' || filme(i).durata || ' minute');
    END LOOP;
END;
/

-- 7.Afiseaza pentru fiecare film numele cinematografelor care l-au rulat de cele mai multe ori
-- intr-un an dat ca parametru unui subprogram stocat. In cazul in care un anumit film nu a rulat in
-- anul respectiv la niciun cinematograf, se va preciza acest lucru.

CREATE OR REPLACE PROCEDURE 
       p7(an VARCHAR2) IS
    CURSOR c1 IS
     SELECT film_id id1, titlu titlu, (SELECT count(film_id)
                                FROM difuzeaza d
                                WHERE TO_CHAR(data_dif,'YYYY') = an and film_id=f.film_id) nr1
    FROM film f;
     CURSOR c2 IS
        SELECT nume nume, film_id id2, count(film_id) nr2
        FROM cinematograf c JOIN sala s ON (c.cinematograf_id=s.cinematograf_id)
                JOIN difuzeaza d ON (s.sala_id=d.sala_id)
        WHERE TO_CHAR(d.data_dif,'YYYY') = an
        GROUP BY nume, film_id
        ORDER BY 3 DESC;
     nr3 number(4);
  BEGIN
    FOR i in c1 LOOP
        nr3 := 0;
        IF i.nr1=0 THEN
            DBMS_OUTPUT.PUT_LINE('Filmul ' || i.titlu || ' nu a fost difuzat in anul ' || an || ' la niciun cinematograf.');
        ElSE
            DBMS_OUTPUT.PUT('Filmul ' || i.titlu || ' a fost difuzat ');
            FOR j in c2 LOOP
                IF i.id1=j.id2 THEN
                    IF nr3=0 THEN
                        IF j.nr2=1 THEN
                            DBMS_OUTPUT.PUT_LINE('o data la: ');
                        ELSE DBMS_OUTPUT.PUT_LINE('de ' || j.nr2 || ' ori la: ');
                        END IF;
                    END IF;
                    EXIT WHEN nr3!=j.nr2 AND nr3!=0;
                    DBMS_OUTPUT.PUT_LINE('Cinematograful ' || j.nume);
                    nr3 := j.nr2;
                END IF;
            END LOOP;
        END IF;
        DBMS_OUTPUT.NEW_LINE();
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END p7;
/                
                    

BEGIN
  p7(2020);
END;
/

-- 8. Dat fiind numele unui cinematograf, determinati profitul obtinut de acesta in anul 2020
-- tinand cont ca un cinematograf pastreaza 45% din costul biletului.

SELECT * FROM cinematograf;
CREATE OR REPLACE FUNCTION f8 
  (v_nume cinematograf.nume%TYPE DEFAULT 'Jay and Silent Bob Multiplex')    
RETURN NUMBER IS
    profit NUMBER(10,2);
    idul cinematograf.cinematograf_id%TYPE;
  BEGIN
    SELECT c.cinematograf_id INTO idul
    FROM cinematograf c
    WHERE nume=v_nume;
    SELECT SUM(pret-0.55*pret) INTO profit
    FROM cinematograf c JOIN sala s ON (c.cinematograf_id=s.cinematograf_id)
                JOIN bilet b ON (s.sala_id=b.sala_id)
    WHERE nume=v_nume AND TO_CHAR(data_dif,'YYYY')='2020';
    RETURN profit;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20000, 'Cinematograful respectiv nu exista. ');
    WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20001, 'Exista mai multe cinematografe cu numele dat!');
    WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END f8;
/

-- SQL
SELECT f8 FROM DUAL; -- functioneaza
-- --Cinematograful respectiv nu exista
-- SELECT f8('Cinema City') FROM DUAL;

-- -- PL/SQL
-- -- Exista mai multe cinematografe cu numele dat!
-- BEGIN
--  DBMS_OUTPUT.PUT_LINE('Profitul este '|| f8('Hitchcock Multiplex'));
-- END;
-- /

SELECT sp.nume, sp.prenume, b.bilet_id, f.titlu, s.sala_id, c.nume, c.cinematograf_id
FROM spectator sp JOIN bilet b ON (sp.spectator_id=b.spectator_id)
                JOIN film f ON (b.film_id=f.film_id)
                JOIN sala s ON (b.sala_id=s.sala_id)
                JOIN cinematograf c ON (s.cinematograf_id=c.cinematograf_id);

-- 9. Pentru codul unui cinematograf trimis ca parametru unui proceduri afisati numele acestuia,
-- precum si spectatorii si filmele la care au mers acestia.

CREATE OR REPLACE PROCEDURE 
       p9(cod_cinema cinematograf.cinematograf_id%TYPE) IS
    cnume cinematograf.nume%TYPE;
     CURSOR c1 IS
        SELECT nume n, prenume pr, titlu t, cinematograf_id cid2
        FROM spectator sp JOIN bilet b ON (sp.spectator_id=b.spectator_id)
                        JOIN film f ON (b.film_id=f.film_id)
                        JOIN sala s ON (b.sala_id=s.sala_id)
        WHERE cinematograf_id=cod_cinema;
  BEGIN
        SELECT nume
        INTO cnume
        FROM cinematograf c
        WHERE cinematograf_id=cod_cinema;
        DBMS_OUTPUT.PUT_LINE('Cinematograful ' || cnume ||' a avut urmatorii spectatori: ');
        DBMS_OUTPUT.NEW_LINE();
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');
        FOR i in c1 LOOP
            DBMS_OUTPUT.PUT_LINE(i.n || ' ' || i.pr || ' care a vizionat filmul ' || i.t);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');
        DBMS_OUTPUT.NEW_LINE();
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20000, 'Cinematograful cu codul respectiv nu exista.');
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END p9;
/                
                    

BEGIN
  p9(7);
END;
/

---- nu exista cinematograful cu codul respectiv
-- BEGIN
--  p9(12);
-- END;
-- /


-- 10. La cinematografele din sistem filmele pentru weekend-ul urmator ajung duminica. Atunci angajatii le pot insera in baza de
-- date, insa difuzarile nu pot fi programate decat luni, cel tarziu marti in intervalele 8-14, atunci cand volumul de lucru
-- al cinematografelor este mai linistit. Acelasi lucru se intampla si in cazul reprogramarilor unor filme difuzate anterior
-- sau stergerea difuzarilor anterioare.

CREATE OR REPLACE TRIGGER trig_10
BEFORE INSERT OR DELETE OR UPDATE on difuzeaza
BEGIN
    IF (TO_CHAR(SYSDATE,'D') NOT IN (2,3))
        OR (TO_CHAR(SYSDATE,'D') IN (2,3) AND TO_CHAR(SYSDATE,'HH24') NOT BETWEEN 8 and 14) THEN
        IF INSERTING THEN
            RAISE_APPLICATION_ERROR(-20001,'Inserarea unei noi difuzari
            nu se poate face in acest interval!');
        ELSIF DELETING THEN
            RAISE_APPLICATION_ERROR(-20002,'Stergerea unei vechi difuzari
            nu se poate face in acest interval!');
        ELSE
            RAISE_APPLICATION_ERROR(-20003,'Actualizarea unei vechi difuzari
            nu se poate face in acest interval!');
        END IF;
    END IF;
END;
/
ALTER TRIGGER trig_10 DISABLE;
--ALTER TRIGGER trig_10 ENABLE;

--Exemplu
INSERT INTO difuzeaza
    VALUES(1,1,sysdate-150);
    
--11. Trigger-ul LMD la nivel de linie se afla inainte de a incepe inserarea in tabele pentru a ma folosi de el la
-- capacitate maxima.

--12. 

CREATE TABLE actiuni_user
   (nume_baza_de_date VARCHAR2(50),
   user_curent VARCHAR2(30),
   actiune VARCHAR2(20),
   tip_obiect_referit VARCHAR2(30),
   nume_obiect_referit VARCHAR2(30),
   data TIMESTAMP(3));
   
----Definiti un declansator care sa introduca date in acest tabel dupa ce utilizatorul a folosit o comanda LDD.

CREATE OR REPLACE TRIGGER trig_12
AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
   INSERT INTO actiuni_user
   VALUES (SYS.DATABASE_NAME, SYS.LOGIN_USER,
           SYS.SYSEVENT, SYS.DICTIONARY_OBJ_TYPE,
           SYS.DICTIONARY_OBJ_NAME, SYSTIMESTAMP(3));
END;
/

SELECT * from actiuni_user;

--13.

CREATE OR REPLACE PACKAGE pack_ex13
IS  
    TYPE tablou_indexat IS TABLE OF film%ROWTYPE INDEX BY BINARY_INTEGER;
    PROCEDURE p6
        (an IN VARCHAR2,
        detalii_filme OUT pack_ex13.tablou_indexat);
    PROCEDURE p7
       (an VARCHAR2);
    FUNCTION f8 
        (v_nume cinematograf.nume%TYPE DEFAULT 'Jay and Silent Bob Multiplex')    
    RETURN NUMBER;
    PROCEDURE p9
        (cod_cinema cinematograf.cinematograf_id%TYPE);
END pack_ex13;
/

CREATE OR REPLACE PACKAGE BODY pack_ex13
IS
    PROCEDURE p6
        (an IN VARCHAR2,
        detalii_filme OUT pack_ex13.tablou_indexat) IS 
    dummy NUMBER;
      BEGIN
        SELECT null INTO dummy
        FROM film
        WHERE TO_CHAR(data_lansarii, 'YYYY') <= an AND rownum=1;
        SELECT * BULK COLLECT INTO detalii_filme 
        FROM   film
        WHERE  TO_CHAR(data_lansarii, 'YYYY') <= an;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20000, 'Nu exista filme aparute inainte de anul precizat');
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
      END p6;
    PROCEDURE p7
        (an VARCHAR2) IS
    CURSOR c1 IS
     SELECT film_id id1, titlu titlu, (SELECT count(film_id)
                                FROM difuzeaza d
                                WHERE TO_CHAR(data_dif,'YYYY') = an and film_id=f.film_id) nr1
    FROM film f;
     CURSOR c2 IS
        SELECT nume nume, film_id id2, count(film_id) nr2
        FROM cinematograf c JOIN sala s ON (c.cinematograf_id=s.cinematograf_id)
                JOIN difuzeaza d ON (s.sala_id=d.sala_id)
        WHERE TO_CHAR(d.data_dif,'YYYY') = an
        GROUP BY nume, film_id
        ORDER BY 3 DESC;
     nr3 number(4);
      BEGIN
        FOR i in c1 LOOP
            nr3 := 0;
            IF i.nr1=0 THEN
                DBMS_OUTPUT.PUT_LINE('Filmul ' || i.titlu || ' nu a fost difuzat in anul ' || an || ' la niciun cinematograf.');
            ElSE
                DBMS_OUTPUT.PUT('Filmul ' || i.titlu || ' a fost difuzat ');
                FOR j in c2 LOOP
                    IF i.id1=j.id2 THEN
                        IF nr3=0 THEN
                            IF j.nr2=1 THEN
                                DBMS_OUTPUT.PUT_LINE('o data la: ');
                            ELSE DBMS_OUTPUT.PUT_LINE('de ' || j.nr2 || ' ori la: ');
                            END IF;
                        END IF;
                        EXIT WHEN nr3!=j.nr2 AND nr3!=0;
                        DBMS_OUTPUT.PUT_LINE('Cinematograful ' || j.nume);
                        nr3 := j.nr2;
                    END IF;
                END LOOP;
            END IF;
            DBMS_OUTPUT.NEW_LINE();
            DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');
            DBMS_OUTPUT.NEW_LINE();
        END LOOP;
    END p7;
    FUNCTION f8 
      (v_nume cinematograf.nume%TYPE DEFAULT 'Jay and Silent Bob Multiplex')    
    RETURN NUMBER IS
        profit NUMBER(10,2);
        idul cinematograf.cinematograf_id%TYPE;
      BEGIN
        SELECT c.cinematograf_id INTO idul
        FROM cinematograf c
        WHERE nume=v_nume;
        SELECT SUM(pret-0.55*pret) INTO profit
        FROM cinematograf c JOIN sala s ON (c.cinematograf_id=s.cinematograf_id)
                    JOIN bilet b ON (s.sala_id=b.sala_id)
        WHERE nume=v_nume AND TO_CHAR(data_dif,'YYYY')='2020';
        RETURN profit;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20000, 'Cinematograful respectiv nu exista. ');
        WHEN TOO_MANY_ROWS THEN
           RAISE_APPLICATION_ERROR(-20001, 'Exista mai multe cinematografe cu numele dat!');
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
    END f8;
    PROCEDURE p9
        (cod_cinema cinematograf.cinematograf_id%TYPE) IS
        cnume cinematograf.nume%TYPE;
         CURSOR c1 IS
            SELECT nume n, prenume pr, titlu t, cinematograf_id cid2
            FROM spectator sp JOIN bilet b ON (sp.spectator_id=b.spectator_id)
                            JOIN film f ON (b.film_id=f.film_id)
                            JOIN sala s ON (b.sala_id=s.sala_id)
            WHERE cinematograf_id=cod_cinema;
      BEGIN
            SELECT nume
            INTO cnume
            FROM cinematograf c
            WHERE cinematograf_id=cod_cinema;
            DBMS_OUTPUT.PUT_LINE('Cinematograful ' || cnume ||' a avut urmatorii spectatori: ');
            DBMS_OUTPUT.NEW_LINE();
            DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');
            FOR i in c1 LOOP
                DBMS_OUTPUT.PUT_LINE(i.n || ' ' || i.pr || ' care a vizionat filmul ' || i.t);
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');
            DBMS_OUTPUT.NEW_LINE();
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20000, 'Cinematograful cu codul respectiv nu exista.');
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
    END p9;
END pack_ex13;
/

DECLARE
   filme pack_ex13.tablou_indexat;
BEGIN
  pack_ex13.p6(2020,filme);
  FOR i IN filme.FIRST..filme.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Filmul '|| filme(i).titlu || ' regizat de ' || filme(i).regizor || ', aparut in anul ' || TO_CHAR(filme(i).data_lansarii, 'YYYY') || ' si avand o durata de ' || filme(i).durata || ' minute');
    END LOOP;
END;
/

BEGIN
  pack_ex13.p7(2020);
END;
/

SELECT pack_ex13.f8 FROM DUAL;

BEGIN
  pack_ex13.p9(7);
END;
/

--14. Cerinta se afla in pdf.

CREATE SEQUENCE pack_dni
START WITH 100;

CREATE OR REPLACE PACKAGE pack_ex14
IS
    FUNCTION achizitie_bilet_coresp(titlu_film film.titlu%TYPE, data_diff difuzeaza.data_dif%TYPE)
    RETURN NUMBER;
    PROCEDURE actualizare_spectator(idul spectator.spectator_id%TYPE, nm spectator.nume%TYPE, pren spectator.prenume%TYPE,
                                    tel spectator.numar_telefon%TYPE, sex spectator.sex%TYPE);
    PROCEDURE actualizare_bilet(idul bilet.bilet_id%TYPE, rand bilet.randl%TYPE, loc bilet.loc%TYPE, 
                                pret bilet.pret%TYPE, data_dif bilet.data_dif%TYPE, red bilet.tip_reducere%TYPE,
                                id_film film.film_id%TYPE, id_sala sala.sala_id%TYPE, id_spectator spectator.spectator_id%TYPE);
    PROCEDURE istoric_spectator(id_spectator spectator.spectator_id%TYPE, achizitie NUMBER, nm spectator.nume%TYPE,
                        pren spectator.prenume%TYPE, tel spectator.numar_telefon%TYPE, sex spectator.sex%TYPE,
                        id_bilet bilet.bilet_id%TYPE, rand bilet.randl%TYPE, loc bilet.loc%TYPE, 
                        pret bilet.pret%TYPE, data_diff bilet.data_dif%TYPE, red bilet.tip_reducere%TYPE,
                        titlu film.titlu%TYPE);
END pack_ex14;
/

CREATE OR REPLACE PACKAGE BODY pack_ex14
IS
    FUNCTION achizitie_bilet_coresp(titlu_film film.titlu%TYPE, data_diff difuzeaza.data_dif%TYPE)
        RETURN NUMBER 
    IS
        exista NUMBER;
        nr NUMBER;
        idul film.film_id%TYPE;
    BEGIN
        SELECT film_id
        INTO idul
        FROM film
        WHERE upper(titlu)=upper(titlu_film);
        SELECT count(*)
        INTO nr
        FROM difuzeaza
        WHERE film_id=idul and to_char(data_dif,'DD/MM/YYYY')=to_char(data_diff,'DD/MM/YYYY');
        IF nr=0 THEN
            RETURN 0;
        ELSE RETURN 1;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000, 'Filmul cu titlul respectiv nu exista.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
    END achizitie_bilet_coresp;
    PROCEDURE actualizare_spectator(idul spectator.spectator_id%TYPE, nm spectator.nume%TYPE, pren spectator.prenume%TYPE,
                                    tel spectator.numar_telefon%TYPE, sex spectator.sex%TYPE)
    IS
    BEGIN
        INSERT INTO spectator
            VALUES(idul, nm, pren, tel, sex);
    END actualizare_spectator;
    PROCEDURE actualizare_bilet(idul bilet.bilet_id%TYPE, rand bilet.randl%TYPE, loc bilet.loc%TYPE, 
                                pret bilet.pret%TYPE, data_dif bilet.data_dif%TYPE, red bilet.tip_reducere%TYPE,
                                id_film film.film_id%TYPE, id_sala sala.sala_id%TYPE, id_spectator spectator.spectator_id%TYPE)
    IS
    BEGIN
        INSERT INTO bilet
            VALUES(idul, rand, loc, pret, data_dif, red, id_film, id_sala, id_spectator);
    END actualizare_bilet;
PROCEDURE istoric_spectator(id_spectator spectator.spectator_id%TYPE, achizitie NUMBER, nm spectator.nume%TYPE,
                        pren spectator.prenume%TYPE, tel spectator.numar_telefon%TYPE, sex spectator.sex%TYPE,
                        id_bilet bilet.bilet_id%TYPE, rand bilet.randl%TYPE, loc bilet.loc%TYPE, 
                        pret bilet.pret%TYPE, data_diff bilet.data_dif%TYPE, red bilet.tip_reducere%TYPE,
                        titlu film.titlu%TYPE)
    IS
        nr NUMBER;
        find_spec NUMBER;
        id_film difuzeaza.film_id%TYPE;
        id_sala difuzeaza.sala_id%TYPE;
        TYPE record_filme IS RECORD (
            titlu_film film.titlu%TYPE,
            regizor film.regizor%TYPE
        );
        TYPE matrice IS TABLE OF record_filme;
        istoric matrice := matrice();
    BEGIN
        SELECT COUNT(*)
        INTO find_spec
        FROM spectator
        WHERE spectator_id=id_spectator;
        IF find_spec=0 THEN
            pack_ex14.actualizare_spectator(id_spectator, nm, pren, tel, sex);
        END IF;
        IF achizitie=1 THEN
            SELECT pack_ex14.achizitie_bilet_coresp(titlu, data_diff) INTO nr FROM DUAL;
            IF nr=1 THEN
                SELECT film_id, sala_id
                INTO id_film, id_sala
                FROM difuzeaza
                WHERE to_char(data_dif,'DD/MM/YYYY')=to_char(data_diff,'DD/MM/YYYY');
                pack_ex14.actualizare_bilet(id_bilet, rand, loc, pret, data_diff, red, id_film, id_sala, id_spectator);
            ELSE 
                DBMS_OUTPUT.PUT_LINE('Nu exista o difuzare a filmului respectiv la acea data');
            END IF;
        END IF;
        SELECT titlu, regizor BULK COLLECT INTO istoric
        FROM film f JOIN bilet b ON (f.film_id=b.film_id)
        WHERE spectator_id = id_spectator;
        DBMS_OUTPUT.PUT_LINE('Istoricul filmelor vizionate de '||nm||' '||pren);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------');
        DBMS_OUTPUT.NEW_LINE;
        IF istoric.count=0 THEN
            DBMS_OUTPUT.PUT_LINE('Spectatorul nu a vizionat niciun film');
        ELSE
            FOR i in istoric.FIRST..istoric.LAST LOOP
                DBMS_OUTPUT.PUT_LINE(istoric(i).titlu_film ||' '||' regizat de '||istoric(i).regizor);
            END LOOP;
        END IF;
    END istoric_spectator;
END pack_ex14;
/

DECLARE
    nr NUMBER;
BEGIN
    pack_ex14.istoric_spectator(21, 0, 'Bertalan', 'Victor', '0722855111', 'M', pack_dni.NEXTVAL,
                    10, 12, 19.5, TO_DATE('19/11/2020','DD/MM/YYYY'), NULL, 'Parasite');
END;
/

SELECT * FROM spectator;
SELECT * FROM bilet;
--SELECT b.spectator_id, nume, prenume, titlu, to_char(data_dif,'DD/MM/YYYY')
--FROM spectator s JOIN bilet b on (s.spectator_id=b.spectator_id)
--                JOIN film f on (b.film_id=f.film_id);

DROP TABLE actiuni_user;
DROP PACKAGE pack_ex14;
DROP PACKAGE pack_ex13;
DROP TRIGGER trig_11_prim;
DROP TRIGGER trig_10;
DROP PROCEDURE p9;
DROP FUNCTION f8;
DROP procedure p7;
DROP procedure p6;
DROP package p6_pkg;
DROP TRIGGER difuzare_permisa;
DROP TABLE difuzeaza;
DROP TABLE bilet;
DROP TABLE sala;
DROP TABLE film;
DROP TABLE spectator;
DROP TABLE cinematograf;