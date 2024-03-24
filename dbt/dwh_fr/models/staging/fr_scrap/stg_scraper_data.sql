{% set stratums=['1','2','3','4','5','6'] %}

with prueba as(
  SELECT id,ciudad,barrio,estrato,lat,lon, ST_GEOGPOINT(lat, lon) geopoint
  FROM {{ref('stg_unique_values')}}
  WHERE estrato not in (
    {% for stratum in stratums -%}
        "{{stratum}}"{{',' if not loop.last else ''}}
    {%- endfor %}
  )
),

prueba_2 as(
  SELECT *,ST_GEOGPOINT(lat, lon) geopoint
  FROM(
    SELECT id,ciudad,barrio,estrato,lat,lon
    FROM {{ref('stg_unique_values')}}
    WHERE lon between -90 AND 90
    AND estrato in (
      {% for stratum in stratums -%}
          "{{stratum}}"{{',' if not loop.last else ''}}
      {%- endfor %}
    )
  )
)

SELECT 
    a.id,
    ARRAY_AGG( 
        STRUCT(b.id,b.ciudad,b.estrato) 
        ORDER BY ST_DISTANCE(a.geopoint, b.geopoint) LIMIT 10
    ) near_locations
FROM prueba a
CROSS JOIN prueba_2 b
WHERE ST_DWITHIN(a.geopoint, b.geopoint, 500)
AND a.id != b.id
AND a.ciudad = b.ciudad
AND a.barrio = b.barrio
AND b.estrato != 'especificar'
GROUP BY ALL
