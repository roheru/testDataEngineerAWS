-- Dimensión Clientes
CREATE TABLE DIMENSION_CLIENTES (
    id_cliente NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    edad NUMBER,
    segmento VARCHAR2(50),
    ciudad VARCHAR2(50),
    region VARCHAR2(50)
);

-- Dimensión Productos
CREATE TABLE DIMENSION_PRODUCTOS (
    id_producto NUMBER PRIMARY KEY,
    nombre_producto VARCHAR2(100),
    tipo_producto VARCHAR2(50),
    tasa_interes NUMBER(5,2)
);

-- Dimensión Tiempo
CREATE TABLE DIMENSION_TIEMPO (
    fecha_id NUMBER PRIMARY KEY,
    fecha DATE,
    dia NUMBER,
    mes NUMBER,
    trimestre NUMBER,
    anio NUMBER
);

-- Dimensión Canal
CREATE TABLE DIMENSION_CANAL (
    canal_id NUMBER PRIMARY KEY,
    canal VARCHAR2(50)
);

-- Tabla de Hechos

CREATE TABLE HECHO_TRANSACCIONES (
    id_transaccion NUMBER PRIMARY KEY,
    id_cliente NUMBER,
    id_producto NUMBER,
    fecha_id NUMBER,
    canal_id NUMBER,
    monto NUMBER(15,2),
    tipo_transaccion VARCHAR2(20),
    FOREIGN KEY (id_cliente) REFERENCES DIMENSION_CLIENTES(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES DIMENSION_PRODUCTOS(id_producto),
    FOREIGN KEY (fecha_id) REFERENCES DIMENSION_TIEMPO(fecha_id),
    FOREIGN KEY (canal_id) REFERENCES DIMENSION_CANAL(canal_id)
);
