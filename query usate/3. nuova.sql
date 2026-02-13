# Creazione tabella nuova
-- Abilitare PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

-- Creazione tabelle
CREATE TABLE luoghi (
    id SERIAL PRIMARY KEY,
    nome TEXT,
    posizione GEOMETRY(POINT, 3003)
);

CREATE TABLE aree (
    id SERIAL PRIMARY KEY,
    nome TEXT,
    posizione GEOMETRY(POLYGON, 3003)
);

-- Creazione indice
CREATE INDEX idx_luoghi_posizione ON luoghi USING GIST(posizione);
ANALYZE luoghi;

-- Verifica uso indice
EXPLAIN ANALYZE
SELECT *
FROM luoghi
WHERE ST_DWithin(
	posizione,
	ST_SetSRID(ST_MakePoint(1500000,5000000),3003),
	500
);
