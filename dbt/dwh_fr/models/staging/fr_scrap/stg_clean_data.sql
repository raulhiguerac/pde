with stratum AS(  
    SELECT 
        t1.id,
        locations.estrato
    FROM {{ref('stg_scraper_data')}} t1,
    UNNEST(t1.near_locations) locations
)

,aggregated AS (
    SELECT 
        id,
        estrato,
        COUNT(*) conteo
    FROM stratum
    GROUP BY id,estrato
)

,coincidencia AS (
    SELECT 
        id,
        estrato,
        conteo,
        DENSE_RANK() OVER (PARTITION BY id ORDER BY conteo DESC,estrato DESC) rango
    FROM aggregated
    QUALIFY rango=1
)

SELECT 
    t1.id,
    t1.area_m2,
    t1.cuartos,
    {{ fill_stratum('t1.estrato','t2.estrato') }} estrato,
    t1.tipo,
    {{ fill_parkings('t1.parqueaderos') }} as parqueaderos,
    {{ fill_with_zeros('t1.tipo_propiedad','t1.banios') }} banios,
    {{ fill_with_zeros('t1.tipo_propiedad','t1.piso') }} piso,
    t1.precio,
    t1.precio_m2,
    t1.precio_admin,
    t1.vendedor,
    t1.tipo_vendedor,
    t1.tipo_propiedad,
    t1.barrio,
    t1.ciudad,
    t1.lat,
    t1.lon,
    t1.direccion,
    t1.id_propiedad,
    t1.creado,
    t1.publicado,
    t1.actualizado,
    t1.antiguedad,
    t1.descripcion,
    t1.url,
FROM {{ref('stg_unique_values')}} t1
LEFT JOIN coincidencia t2
USING(id)



