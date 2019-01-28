CREATE OR REPLACE FUNCTION DNILetra (DNI IN INT)
RETURN CHAR
IS letra CHAR(100);
BEGIN
    IF LENGTH(TO_CHAR(DNI)) = 8 THEN
        letra := substr('TRWAGMYFPDXBNJZSQVHLCKE', MOD(dni,23)+1, 1);
    ELSE
        letra := 'ERROR Longitud es ' || LENGTH(TO_CHAR(DNI)) || ' cuando se espera 8';
    END IF;
	RETURN(letra);
END;
/

DECLARE
    CURSOR dniPersonal (v_centro NUMBER) IS select dni from personal where COD_CENTRO = v_centro;
    v_dato dniPersonal%ROWTYPE;
    v_validacion CHAR(100);
    e_dni_invalido EXCEPTION;
	v_check_tabla int := 0;
	v_inserta_error CHAR(2);
BEGIN
    OPEN dniPersonal(10);
    FETCH dniPersonal into v_dato;
	
	SELECT COUNT(*) INTO v_check_tabla FROM user_tables WHERE table_name = 'ERRORES';
	IF v_check_tabla <= 0 THEN		
		EXECUTE IMMEDIATE 'create table errores (error_id number(10) not null, descripcion varchar2(500) not null, fecha date not null)';
		DBMS_OUTPUT.PUT_LINE('Tabla de errores creada');
	END IF;
	
    WHILE (dniPersonal%FOUND) LOOP
        BEGIN
            v_validacion := DNILetra(v_dato.dni);
            IF LENGTH(v_validacion) > 1 THEN
                RAISE e_dni_invalido;
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_dato.dni || '-' || v_validacion);
        EXCEPTION
            WHEN e_dni_invalido THEN
				INSERT INTO errores (error_id, descripcion, fecha) VALUES (dniPersonal%ROWCOUNT, 'Error en DNI --> ' || v_validacion, TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')));			
        END;
        FETCH dniPersonal into v_dato;
    END LOOP;
    CLOSE dniPersonal;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN  
        DBMS_OUTPUT.PUT_LINE('No hay datos');
END;
/