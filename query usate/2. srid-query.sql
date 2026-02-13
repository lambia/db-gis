
-- Query!
SELECT ST_SRID(posizione), ST_IsGeographic(posizione) FROM luoghi LIMIT 1;

SELECT id, ST_SRID(posizione) AS srid
FROM luoghi
WHERE ST_SRID(posizione) <> 3003;

Si possono alterare i campi con transform ma perde indice. Se capita spesso:

--Materializzare colonna 
ALTER TABLE dati ADD COLUMN posizione3003 geometry(Point, 3003);
UPDATE dati SET posizione3003 = ST_Transform(posizione, 3003);
CREATE INDEX ON dati USING GIST (posizione3003);
-- eliminare la vecchia o tenerlo aggiornato o fare in vista

--Convertire i dati permanente
ALTER TABLE dati
ALTER COLUMN posizione TYPE geometry(Point, 3003)
USING ST_Transform(posizione, 3003);

--Lavori su geography con indice castato
CREATE INDEX idx_dati_geog ON dati
USING GIST(posizione::geography);

SELECT *
FROM dati
WHERE ST_DWithin(
    posizione::geography,
    ST_SetSRID(ST_MakePoint(7.682, 45.070), 4326)::geography,
    500
);
