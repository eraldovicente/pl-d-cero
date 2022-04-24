-------------------
-- BLOCO ANÔNIMO --
-------------------

---------------
-- QUESTÃO 1 --
---------------

SET SERVEROUTPUT ON

DECLARE
    nome      VARCHAR2 := 'Eraldo';
    sobrenome VARCHAR2 := 'Vicente';
BEGIN
    dbms_output.put_line(nome);
    dbms_output.put_line(sobrenome);
    dbms_output.put_line(nome
                         || ' '
                         || sobrenome);
END;

---------------
-- QUESTÃO 2 --
---------------

-- 4

---------------
-- QUESTÃO 3 --
---------------

DECLARE
  N1 NUMBER := 1;
  N2 NUMBER := 1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(N1 + N2);
END;

---------------
-- QUESTÃO 4 --
---------------

DECLARE
  N1 NUMBER;
  N2 NUMBER;
  RESULTADO NUMBER;
BEGIN
  N1 := NULL;
  N2 := 1;
  RESULTADO := N1 + N2;
  DBMS_OUTPUT.PUT_LINE('O RESULTADO DA SOMA: ' || RESULTADO);
END;