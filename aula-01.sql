-------------------
-- BLOCO ANÔNIMO --
-------------------
SET SERVEROUTPUT ON

DECLARE
    name     VARCHAR2(100);
    lastname VARCHAR2(100);
BEGIN
    name := 'JOHN';
    lastname := 'CONNORS';
    dbms_output.put_line(name);
    dbms_output.put_line(lastname);
    dbms_output.put_line(name || ' ' || lastname);
END;