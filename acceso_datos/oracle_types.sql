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
	TYPE errorObjeto IS RECORD (
		textoError VARCHAR2(500)
	);
	error errorObjeto;
    CURSOR dniPersonal (v_centro NUMBER) IS select dni from personal where COD_CENTRO = v_centro;
    v_dato dniPersonal%ROWTYPE;
	
    v_validacion CHAR(100);
    e_dni_invalido EXCEPTION;
	v_check_tabla int := 0;
	v_inserta_error CHAR(2);
	v_query_centro varchar2(500);
	v_query_centro_resultado varchar2(100);
BEGIN
    OPEN dniPersonal(10);
    FETCH dniPersonal into v_dato;
	
	SELECT COUNT(*) INTO v_check_tabla FROM user_tables WHERE table_name = 'ERRORES';
	IF v_check_tabla <= 0 THEN		
		EXECUTE IMMEDIATE 'create table errores (descripcion varchar2(500) not null, fecha date not null)';
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
				v_query_centro := 'select nombre from centros where COD_CENTRO = 10';
				EXECUTE IMMEDIATE v_query_centro into v_query_centro_resultado;
				error.textoError := 'Error en DNI --> ' || v_validacion || ' para el centro ' || v_query_centro_resultado;
				INSERT INTO errores (descripcion, fecha) VALUES ('Error en DNI --> ' || v_validacion || ' para el centro ' || v_query_centro_resultado, SYSDATE);			
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