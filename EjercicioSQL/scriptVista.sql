--a continuación se crea la vista
CREATE OR REPLACE VIEW V_REPORTE_LIBROS AS
SELECT
    libro_id,
    titulo,
    autor,
    total_copias,
    disponibles AS copias_disponibles
FROM
    LIBROS;

-- aqui se verifica la ejecución de la vista
select * from V_REPORTE_LIBROS;