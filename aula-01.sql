-------------------
-- BLOCO ANÔNIMO --
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
            p := ' NO ES UN NÚMERO PRIMO';
            GOTO print_now;
        END IF;
    END LOOP;

    p := ' ES UN NÚMERO PRIMO';
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
-- INTRODUCCIÓN A LAS EXCEPCIONES --
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
-- ÁMBITO DE LAS EXCEPCIONES --
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
    REGN NUMBER;
    REGT VARCHAR2(200);
BEGIN
    REGN:=101;
    REGT:='ASIA';
    IF REGN > 100 THEN
        -- EL CODIGO DEBE ESTAR ENTRE -20000 Y -20999
        RAISE_APPLICATION_ERROR(-20001,'LA ID NO PUEDE SER MAYOR DE 100');
    ELSE
        INSERT INTO REGIONS VALUES (REGN,REGT);
        COMMIT;
    END IF;
END;
/