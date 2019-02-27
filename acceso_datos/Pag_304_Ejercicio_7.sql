CREATE OR REPLACE PROCEDURE EJERCICIO_7
IS
    CURSOR empleados IS select emp_no, oficio, salario from emple;
    CURSOR media_oficio IS select oficio, ROUND(avg(salario), 2) as media from emple group by oficio;
    v_empleados empleados%ROWTYPE;
    v_medias media_oficio%ROWTYPE;
    v_diferencia NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('INICIO');
    DBMS_OUTPUT.PUT_LINE('Subir salario a los que cobran menos de la media en su oficio');
    OPEN empleados;
    FETCH empleados into v_empleados;    
    WHILE (empleados%FOUND) LOOP
        BEGIN
            OPEN media_oficio;
            FETCH media_oficio into v_medias;
            WHILE (media_oficio%FOUND) LOOP
                IF (v_empleados.oficio = v_medias.oficio) THEN
                    IF (v_empleados.salario < v_medias.media) THEN
                        v_diferencia := v_medias.media - v_empleados.salario;
                        DBMS_OUTPUT.PUT_LINE('Actualizando salario al empleado : ' || v_empleados.emp_no || ' con oficio : ' || v_empleados.oficio);
                        DBMS_OUTPUT.PUT_LINE('Nuevo salario será : ' || v_empleados.salario || ' + ' || ROUND(v_diferencia/2, 2));
                        EXIT;
                    END IF;
                END IF;
                FETCH media_oficio into v_medias;
            END LOOP; 
            CLOSE media_oficio;
        END;
        FETCH empleados into v_empleados;
    END LOOP;
    CLOSE empleados;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('FIN');
END;