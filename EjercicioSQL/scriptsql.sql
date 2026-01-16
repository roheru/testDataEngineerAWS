--creación de scripts
CREATE TABLE LIBROS (
    libro_id NUMBER PRIMARY KEY,
    titulo VARCHAR2(100),
    autor VARCHAR2(100),
    disponibles NUMBER,
    total_copias NUMBER
);

CREATE TABLE PRESTAMOS (
    prestamo_id NUMBER PRIMARY KEY,
    libro_id NUMBER,
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    nombre_usuario VARCHAR2(100),
    estado VARCHAR2(20), -- 'ACTIVO', 'DEVUELTO'
    FOREIGN KEY (libro_id) REFERENCES LIBROS(libro_id)
);

--debido a que se necesita la creación de una secuencia en el momento de insertar el prestámo
--debemos crearlo en SQL Oracle

CREATE SEQUENCE PRESTAMOS_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- a continuación se crea el store procedure que realiza el préstamo

CREATE OR REPLACE PROCEDURE SP_PRESTAR_LIBRO(
    p_libro_id       IN  NUMBER,
    p_nombre_usuario IN  VARCHAR2,
    p_mensaje        OUT VARCHAR2
)
IS
    v_disponibles NUMBER;
BEGIN
    -- Verificar existencia y copias disponibles
    SELECT disponibles
    INTO v_disponibles
    FROM LIBROS
    WHERE libro_id = p_libro_id;

    IF v_disponibles > 0 THEN
        -- Insertar préstamo
        INSERT INTO PRESTAMOS(prestamo_id, libro_id, fecha_prestamo, fecha_devolucion, nombre_usuario, estado)
        VALUES (
            PRESTAMOS_SEQ.NEXTVAL,
            p_libro_id,
            SYSDATE,
            NULL,
            p_nombre_usuario,
            'ACTIVO'
        );

        -- Reducir disponibles
        UPDATE LIBROS
        SET disponibles = disponibles - 1
        WHERE libro_id = p_libro_id;

        p_mensaje := 'Préstamo realizado con éxito';
    ELSE
        p_mensaje := 'No hay copias disponibles';
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_mensaje := 'El libro no existe';
    WHEN OTHERS THEN
        p_mensaje := 'Error al realizar el préstamo: ' || SQLERRM;
END SP_PRESTAR_LIBRO;
/

-- a continuación se ejecuta el store procedure solicitado

DECLARE
    v_msg VARCHAR2(100);
BEGIN
    SP_PRESTAR_LIBRO(1, 'Juan Perez', v_msg);
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/