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
    X NUMBER := 0;
BEGIN
    WHILE X < 10 LOOP
        DBMS_OUTPUT.PUT_LINE(X);
        X := X + 1;
        EXIT WHEN X = 5;
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
    P VARCHAR2(30);
    N PLS_INTEGER := 5;
BEGIN
    FOR J IN 2..ROUND(SQRT(N)) LOOP
        IF N MOD J = 0 THEN
            P := ' NO ES UN NÚMERO PRIMO';
            GOTO PRINT_NOW;
        END IF;
    END LOOP;
    
    P := ' ES UN NÚMERO PRIMO';
    
    <<PRINT_NOW>>
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(N) || P);
END;
/