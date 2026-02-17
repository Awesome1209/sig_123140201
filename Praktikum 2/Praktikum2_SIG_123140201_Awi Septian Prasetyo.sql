SELECT 
    id,
    nama,
    ST_AsText(geom),
    ST_AsGeoJSON(geom),
    ST_IsValid(geom)
FROM jalan;
