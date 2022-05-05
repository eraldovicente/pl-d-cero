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