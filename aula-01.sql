-------------------
-- BLOCO AN?NIMO --
-------------------

SET SERVEROUTPUT ON

DECLARE
    b1 BOOLEAN;
BEGIN
    b1 := true;
    b1 := false;
    b1 := NULL;
END;

---------------
-- Bucle FOR --
---------------
set SERVEROUTPUT ON

DECLARE
    i VARCHAR2(100) := 'AAAAAA';
BEGIN
    FOR i IN REVERSE 5..15 LOOP     -- PLS_INTEGER
        dbms_output.put_line(i);
        EXIT WHEN i = 10;
    END LOOP;

    dbms_output.put_line(i);
END;

-----------------
-- BUCLE WHILE --
-----------------

DECLARE
    done BOOLEAN := false;
    x    NUMBER := 0;
BEGIN
    WHILE x < 10 LOOP
        dbms_output.put_line(x);
        x := x + 1;
        EXIT WHEN x = 5;
    END LOOP;

    WHILE done LOOP
        dbms_output.put_line('NO IMPRIMAS ESTO.');
        done := true;
    END LOOP;
    WHILE NOT done LOOP
        dbms_output.put_line('HE PASADO POR AQUI');
        done := true;
    END LOOP;

END;
/

------------------
-- COMANDO GOTO --
------------------

DECLARE
    p VARCHAR2(30);
    n PLS_INTEGER := 5;
BEGIN
    FOR j IN 2..round(sqrt(n)) LOOP
        IF n MOD j = 0 THEN
            p := ' NO ES UN N?MERO PRIMO';
            GOTO print_now;
        END IF;
    END LOOP;

    p := ' ES UN N?MERO PRIMO';
    << print_now >> dbms_output.put_line(to_char(n)
                                         || p);
END;
/

------------------------------
-- SELECTS DENTRO DE PL/SQL --
------------------------------

DECLARE
    salario NUMBER;
    nombre  employees.first_name%TYPE;
BEGIN
    SELECT
        salary,
        first_name
    INTO
        salario,
        nombre
    FROM
        employees
    WHERE
        employee_id = 100;

    dbms_output.put_line(salario);
    dbms_output.put_line(nombre);
END;

--------------
-- %ROWTYPE --
--------------

DECLARE
    salario  NUMBER;
    nombre   employees.first_name%TYPE;
    empleado employees%rowtype;
BEGIN
    SELECT -- SOLO PUEDE DEVOLVER UNA FILA
        *
    INTO empleado
    FROM
        employees
    WHERE
        employee_id = 100;

    dbms_output.put_line(empleado.salary * 100);
    dbms_output.put_line(empleado.first_name);
END;

-------------
-- INSERTS --
-------------

DECLARE
    col1 test.c1%TYPE;
BEGIN
    col1 := 10;
    INSERT INTO test (
        c1,
        c2
    ) VALUES (
        col1,
        'LILIAN'
    );

    COMMIT;
END;

-------------
-- UPDATES --
-------------

DECLARE
    t test.c1%TYPE;
BEGIN
    t := 10;
    UPDATE test
    SET
        c2 = 'PIKACHU'
    WHERE
        c1 = t;

    COMMIT;
END;

------------
-- DELETE --
------------

DECLARE
    t test.c1%TYPE;
BEGIN
    t := 10;
    DELETE FROM test
    WHERE
        c1 = t;

    COMMIT;
END;

------------------------------------
-- INTRODUCCI?N A LAS EXCEPCIONES --
------------------------------------



DECLARE
    empl employees%rowtype;
BEGIN
    SELECT
        *
    INTO empl
    FROM
        employees
    WHERE
        employee_id = 100;

    dbms_output.put_line(empl.first_name);
END;

-- TIPOS DE EXCEPCIONES:
-- ORACLE
-- USUARIO

---------------------------------
-- SINTAXIS DE LAS EXCEPCIONES --
---------------------------------
-- EJEMPLO --
-------------
DECLARE
    empl employees%rowtype;
BEGIN
    SELECT
        *
    INTO empl
    FROM
        employees
    WHERE
        employee_id = 100;

    dbms_output.put_line(empl.first_name);
EXCEPTION
    WHEN ex1 THEN
        NULL;
    WHEN ex2 THEN
        NULL;
    WHEN OTHERS THEN
        NULL;
END;

------------------------------
-- EXCEPCIONES PREDEFINIDAS --
------------------------------

-------------
DECLARE
    empl employees%rowtype;
BEGIN
    SELECT
        *
    INTO empl
    FROM
        employees
    WHERE
        employee_id = 10000;

    dbms_output.put_line(empl.first_name);
EXCEPTION

-- NO_DATA_FOUND ORA-01403
-- TOO_MANY_ROWS ORA-01422
-- ZERO_DIVIDE
-- DUP_VAL_ON_INDEX

    WHEN no_data_found THEN
        dbms_output.put_line('ERROR, EMPLEADO INEXISTENTE');
    WHEN too_many_rows THEN
        dbms_output.put_line('ERROR, DEMASIADOS EMPLEADOS');
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR ');
END;

---------------------------------
-- EXCEPCIONES NO PREDEFINIDAS --
---------------------------------

DECLARE
    mi_excep EXCEPTION;
    PRAGMA exception_init ( mi_excep, -937 );
    v1 NUMBER;
    v2 NUMBER;
BEGIN
    SELECT
        employee_id,
        SUM(salary)
    INTO
        v1,
        v2
    FROM
        employees;

    dbms_output.put_line(v1);
EXCEPTION
    WHEN mi_excep THEN
        dbms_output.put_line('FUNCION DE GRUPO INCORRECTA');
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR INDEFINIDO');
END;

-----------------------
-- SQLCODE Y SQLERRM --
-----------------------

DECLARE
    empl    employees%rowtype;
    code    NUMBER;
    message VARCHAR2(100);
BEGIN
    SELECT
        *
    INTO empl
    FROM
        employees;

    dbms_output.put_line(empl.salary);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
        code := sqlcode;
        message := sqlerrm;
        INSERT INTO errors VALUES (
            code,
            message
        );

END;

-----------------------------------
-- CONTROLAR SQL CON EXCEPCIONES --
-----------------------------------

DECLARE
    reg         regions%rowtype;
    reg_control regions.region_id%TYPE;
BEGIN
    reg.region_id := 100;
    reg.region_name := 'AFRICA';
    SELECT
        region_id
    INTO reg_control
    FROM
        regions
    WHERE
        region_id = reg.region_id;

    dbms_output.put_line('LA REGION YA EXISTE');
EXCEPTION
    WHEN no_data_found THEN
        INSERT INTO regions VALUES (
            reg.region_id,
            reg.region_name
        );

        COMMIT;
END;

--------------------------------
-- Excepciones personalizadas --
-- por el desarollador        --
--------------------------------

DECLARE
    reg_max EXCEPTION;
    regn NUMBER;
    regt VARCHAR2(200);
BEGIN
    regn := 101;
    regt := 'ASIA';
    IF regn > 100 THEN
        RAISE reg_max;
    ELSE
        INSERT INTO regions VALUES (
            regn,
            regt
        );

    END IF;

EXCEPTION
    WHEN reg_max THEN
        dbms_output.put_line('LA REGION NO PUEDE SER MAYOR DE 100.');
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR INDEFINIDO');
END;
/

-------------------------------
-- ?MBITO DE LAS EXCEPCIONES --
-------------------------------


DECLARE
    regn NUMBER;
    regt VARCHAR2(200);
BEGIN
    regn := 101;
    regt := 'ASIA';
    DECLARE BEGIN
        IF regn > 100 THEN
            RAISE reg_max;
        ELSE
            INSERT INTO regions VALUES (
                regn,
                regt
            );

        END IF;
    EXCEPTION
        WHEN reg_max THEN
            dbms_output.put_line('LA REGION NO PUEDE SER MAYOR DE 100.');
    END;

EXCEPTION
   /* WHEN reg_max THEN
        dbms_output.put_line('LA REGION NO PUEDE SER MAYOR DE 100.');*/
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR INDEFINIDO');
END;
/

-------------------------------------
-- COMANDO RAISE_APPLICATION_ERROR --
-------------------------------------

DECLARE
    regn NUMBER;
    regt VARCHAR2(200);
BEGIN
    regn := 101;
    regt := 'ASIA';
    IF regn > 100 THEN
        -- EL CODIGO DEBE ESTAR ENTRE -20000 Y -20999
        raise_application_error(
                               -20001,
                               'LA ID NO PUEDE SER MAYOR DE 100'
        );
    ELSE
        INSERT INTO regions VALUES (
            regn,
            regt
        );

        COMMIT;
    END IF;

END;
/

--------------------
-- PL/SQL RECORDS --
--------------------

DECLARE
    TYPE empleado IS RECORD (
        nombre  VARCHAR2(100),
        salario NUMBER,
        fecha   employees.hire_date%TYPE,
        datos   employees%rowtypes
    );
    emple1 empleado;
BEGIN
    SELECT
        *
    INTO emple1.datos
    FROM
        employees
    WHERE
        employee_id = 100;

    emple1.nombre := emple1.datos.first_name
                     || ' '
                     || emple1.datos.last_name;

    emple1.salario := emple1.datos.salary * 0.80;
    emple1.fecha := emple1.datos.hire_date;
    dbms_output.put_line(emple1.nombre);
    dbms_output.put_line(emple1.salario);
    dbms_output.put_line(emple1.fecha);
    dbms_output.put_line(emple1.datos.first_name);
END;

-----------------------------------------
--INSERTS Y UPDATES CON PL/SQL RECORDS --
-----------------------------------------

CREATE TABLE regiones
    AS
        SELECT
            *
        FROM
            regions
        WHERE
            region_id = 0;

DECLARE
    reg1 regions%rowtype;
BEGIN
    SELECT
        *
    INTO reg1
    FROM
        regions
    WHERE
        region_id = 1;
    
    -- INSERT
    INSERT INTO regiones VALUES reg1;

END;
/

DECLARE
    reg1 regions%rowtype;
BEGIN
    reg1.region_id := 1;
    reg1.region_name := 'AUSTRALIA';
    --UPDATE
    UPDATE regiones
    SET
        row = reg1
    WHERE
        region_id = 1;

END;

-------------------------------------
-- TRABAJAR CON ARRAYS ASOCIATIVOS --
-------------------------------------

DECLARE
    TYPE departamentos IS
        TABLE OF departments.department_name%TYPE INDEX BY PLS_INTEGER;
    TYPE empleados IS
        TABLE OF employees%rowtype INDEX BY PLS_INTEGER;
    depts  departamentos;
    emples empleados;
BEGIN
    -- TIPO NAME
    depts(1) := 'INFORMATICA';
    depts(2) := 'RRHH';
    dbms_output.put_line(depts(1));
    dbms_output.put_line(depts(2));
    dbms_output.put_line(depts.last);
    dbms_output.put_line(depts.first);
    IF depts.exits(3) THEN
        dbms_output.put_line(depts(3));
    ELSE
        dbms_output.put_line('ESE VALOR NO EXISTE');
    END IF;
    
    -- TIPO COMPUESTO
    SELECT
        *
    INTO
        emples
    (1)
    FROM
        employees
    WHERE
        employee_id = 100;

    SELECT
        *
    INTO
        emples
    (2)
    FROM
        employees
    WHERE
        employee_id = 101;

    dbms_output.put_line(emples(1).first_name);
    dbms_output.put_line(emples(2).first_name);
END;
/

--------------------------------------------
-- SELECT M?TIPLES CON ARRAYS ASOCIATIVOS --
--------------------------------------------

DECLARE
    TYPE departamentos IS
        TABLE OF departments%rowtype INDEX BY PLS_INTEGER;
    depts departamentos;
BEGIN
    FOR i IN 1..10 LOOP
        SELECT
            *
        INTO
            depts
        (i)
        FROM
            departments
        WHERE
            department_id = i * 10;

    END LOOP;

    FOR i IN depts.first..depts.last LOOP
        dbms_output.put_line(depts(i).department_name);
    END LOOP;

END;
/

--------------------------
-- ATRIBUTOS IMPL?CITOS --
--------------------------

/*SQL%ISOPEN --OPEN
SQL%FOUND
SQL%NOTFOUND
SQL%ROWCOUNT*/
SET SERVEROUTPUT ON

DECLARE
    x NUMBER;
BEGIN
    UPDATE test
    SET
        c2 = 'P'
    WHERE
        c1 = 11;

    dbms_output.put_line(SQL%rowcount);
    IF SQL%found THEN
        dbms_output.put_line('ENCONTRADO');
    END IF;
    IF SQL%notfound THEN
        dbms_output.put_line('NO ENCONTRADO');
    END IF;
    SELECT
        c1
    INTO x
    FROM
        test
    WHERE
        c1 = 1000;

    IF SQL%notfound THEN
        dbms_output.put_line('FILA NO EXISTE');
    END IF;
END;

---------------------
-- CREAR UN CURSOR --
---------------------

DECLARE
    CURSOR c1 IS
    SELECT
        *
    FROM
        regions;

    v1 regions%rowtype;
BEGIN
    OPEN c1;
    FETCH c1 INTO v1;
    dbms_output.put_line(v1.region_name);
    FETCH c1 INTO v1;
    dbms_output.put_line(v1.region_name);
    CLOSE c1;
END;
/

------------------------------
-- ATRIBUTOS (RECORDATORIO) --
------------------------------

/*
C1%NOTFOUND
C1%FOUND
C1%ISOPEN
C1%ROWCOUNT
*/

------------------------------------------
-- RECORRER UN CURSOR CON EL BUCLE LOOP --
------------------------------------------

DECLARE
    CURSOR c1 IS
    SELECT
        *
    FROM
        regions;

    v1 regions%rowtype;
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO v1;
        EXIT WHEN c1%notfound;
        dbms_output.put_line(v1.region_name);
    END LOOP;

    CLOSE c1;
END;

-----------------------------------------
-- RECORRER UN CURSOR CON EL BUCLE FOR --
-----------------------------------------

DECLARE
    CURSOR c1 IS
    SELECT
        *
    FROM
        regions;

    v1 regions%rowtype;
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO v1;
        EXIT WHEN c1%notfound;
        dbms_output.put_line(v1.region_name);
    END LOOP;

    CLOSE c1;
    
    ---------------
    -- BUCLE FOR --
    ---------------

    FOR i IN c1 LOOP
        dbms_output.put_line(i.region_name);
    END LOOP;
END;

------------------------------
-- BUCLE FOR CON SUBQUERIES --
------------------------------

BEGIN
    FOR i IN (
        SELECT
            *
        FROM
            regions
    ) LOOP
        dbms_output.put_line(i.region_name);
    END LOOP;
END;

-----------------------------
-- cursores con par?metros --
-----------------------------

DECLARE
    CURSOR c1 (
        sal NUMBER
    ) IS
    SELECT
        *
    FROM
        employees
    WHERE
        salary > sal;

    empl employees%rowtype;
BEGIN
    OPEN c1(8000);
    LOOP
        FETCH c1 INTO empl;
        EXIT WHEN c1%notfound;
        dbms_output.put_line(empl.first_name
                             || ' '
                             || empl.salary);
    END LOOP;

    dbms_output.put_line('HE ENCONTRADO '
                         || c1%rowcount
                         || ' EMPLEADOS');
    CLOSE c1;
END;

--------------------------------------------
-- UPDATES Y DELETES CON WHERE CURRENT OF --
--------------------------------------------

DECLARE
    empl employees%rowtype;
    CURSOR cur IS
    SELECT
        *
    FROM
        employees
    FOR UPDATE;

BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO empl;
        EXIT WHEN cur%notfound;
        IF empl.commission_pct IS NOT NULL THEN
            UPDATE employees
            SET
                salary = salary * 1.10
            WHERE
                CURRENT OF cur;

        ELSE
            UPDATE employees
            SET
                salary = salary * 1.15
            WHERE
                CURRENT OF cur;

        END IF;

    END LOOP;

    CLOSE cur;
END;