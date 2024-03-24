SELECT *
FROM {{ source('fr_scrap', 'revisar') }}
GROUP BY ALL