CREATE TABLE LIBROS (
 TITULO  VARCHAR2(32),
 AUTOR   VARCHAR2(22),
 EDITORIAL VARCHAR2(15),
 PAGINA  NUMBER(3)
 ) ;
/

INSERT INTO LIBROS VALUES ('LA COLMENA', 'CELA, CAMILO JOSÉ', 'PLANETA',240);
INSERT INTO LIBROS VALUES ('LA HISTORIA DE MI HIJO', 'GORDIMER, NADINE', 'TIEM.MODERNOS',327);
INSERT INTO LIBROS VALUES ('LA MIRADA DEL OTRO', 'G.DELGADO, FERNANDO', 'PLANETA',298);
INSERT INTO LIBROS VALUES ('ÚLTIMAS TARDES CON TERESA','MARSE, JUAN', 'CÍRCULO',350);
INSERT INTO LIBROS VALUES ('LA NOVELA DE P. ANSUREZ',
'TORRENTE B., GONZALO', 'PLANETA',162);
COMMIT;

create or replace TYPE libros_typ AS OBJECT (
 TITULO  VARCHAR2(32),
 AUTOR   VARCHAR2(22),
 EDITORIAL VARCHAR2(15),
 PAGINA  NUMBER(3),
 MEMBER PROCEDURE display,
 MEMBER FUNCTION getTitulo RETURN VARCHAR2,
 MEMBER PROCEDURE setTitulo (titulo VARCHAR2),
 MEMBER FUNCTION getAutor RETURN VARCHAR2,
 MEMBER PROCEDURE setAutor (autor VARCHAR2),
 MEMBER FUNCTION getEditorial RETURN VARCHAR2,
 MEMBER PROCEDURE setEditorial (editorial VARCHAR2),
 MEMBER FUNCTION getPagina RETURN NUMBER,
 MEMBER PROCEDURE setPagina (pagina NUMBER)
 ) ;
/
CREATE OR REPLACE TYPE BODY libros_typ AS
    MEMBER PROCEDURE display IS
    BEGIN 
          dbms_output.put_line('Titulo : ' || getTitulo);
          dbms_output.put_line('Autor : ' || getAutor);
          dbms_output.put_line('Editorial : ' || getEditorial);
    END display;
    MEMBER FUNCTION getTitulo RETURN VARCHAR2 IS
        BEGIN
        RETURN titulo;
    END;
    MEMBER PROCEDURE setTitulo(titulo VARCHAR2) IS
    BEGIN
        self.titulo := titulo;
    END setTitulo;
    MEMBER FUNCTION getAutor RETURN VARCHAR2 IS
        BEGIN
        RETURN autor;
    END;
    MEMBER PROCEDURE setAutor(autor VARCHAR2) IS
    BEGIN
        self.autor := autor;
    END setAutor;
    MEMBER FUNCTION getEditorial RETURN VARCHAR2 IS
        BEGIN
        RETURN editorial;
    END;
    MEMBER PROCEDURE setEditorial(editorial VARCHAR2) IS
    BEGIN
        self.editorial := editorial;
    END setEditorial;   
    MEMBER FUNCTION getPagina RETURN NUMBER IS
        BEGIN
        RETURN pagina;
    END;
    MEMBER PROCEDURE setPagina(pagina NUMBER) IS
    BEGIN
        self.pagina := pagina;
    END setPagina;      
END;
/

DECLARE
    libro LIBROS_TYP;
BEGIN
    libro := libros_typ('OTRO LIBRO', 'APELLIDO, NOMBRE', 'EDITALIBROS',1);
    libro.display;
END;