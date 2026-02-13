CREATE OR REPLACE VIEW luoghi_arricchiti AS
SELECT 
    id,
    nome,
    posizione,
    
    -- Coordinate come testo
    ST_AsText(posizione) AS posizione_testo,
    
    -- Coordinate in lat/lon (SRID 4326)
    ST_Transform(posizione, 4326) AS posizione_latlon,
    
    -- Distanza da Torino (coordinate centro approssimativo 1500000, 5100000 in 3003)
    ST_Distance(
        posizione,
        ST_SetSRID(ST_MakePoint(1500000, 5100000), 3003)
    ) AS distanza_da_torino_m
FROM luoghi;


-- query
SELECT nome, posizione_testo, 
       ST_X(posizione_latlon) AS lon, 
       ST_Y(posizione_latlon) AS lat,
       distanza_da_torino_m
FROM luoghi_arricchiti
ORDER BY distanza_da_torino_m
LIMIT 10;