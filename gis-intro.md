# Installazione
sudo apt install postgis postgresql-15-postgis-3

# Creazione database e abilitazione estensione
CREATE DATABASE nomedb
\c nomedb
CREATE EXTENSION postgis;
SELECT PostGIS_Version();

# Creazione tabella con geometry
CREATE TABLE luoghi (
    id SERIAL PRIMARY KEY,
    nome TEXT,
    geom GEOMETRY(Point, 4326)
);

# Aggiunta campo geometry
ALTER TABLE posts
ADD COLUMN position geometry(Point, 4326);

# Conversione da geometry a geography
ALTER TABLE posts
ALTER COLUMN position
TYPE geography(Point, 4326)
USING position::geography;

# Inserimento geometria
INSERT INTO luoghi (nome, geom)
VALUES (
    'Torino',
    ST_SetSRID(
        ST_GeomFromText('POINT(7.6869 45.0703)'),
        4326
    )
);

o in forma compatta

ST_GeomFromText('POINT(7.6869 45.0703)', 4326)

# Update geometria
UPDATE posts
SET position = ST_SetSRID(ST_MakePoint(7.6869, 45.0703), 4326)
WHERE id = 1;

# Update geografia
UPDATE posts
SET position = ST_SetSRID(ST_MakePoint(12.4964, 41.9028), 4326)::geography
WHERE id = 2;

oppure

UPDATE posts
SET position = ST_GeogFromText('SRID=4326;POINT(12.4964 41.9028)')
WHERE id = 2;

# Lettura geometria
SELECT
    id,
    nome,
    ST_AsText(geom)
FROM luoghi;

# Verifica SRID
SELECT ST_SRID(geom) FROM luoghi;

# Seeding su coordinata arbitraria
UPDATE posts
SET position = ST_SetSRID(ST_MakePoint(10.0000, 45.0000), 4326);

per geography aggiungere ::geography alla fine 

# Seeding a distribuzione semplice su mondo intero
Longitudine con invervallo [-180, +180] ampiezza 360°.
Latitudine con invervallo [-90, +90] ampiezza 180°.

UPDATE posts
SET position = ST_SetSRID(
  ST_MakePoint(
    -180 + random() * 360,   -- lon
    -90  + random() * 180    -- lat
  ),
  4326
);

per geography aggiungere ::geography alla fine 

# Creazione indice GiST
CREATE INDEX idx_posts_position_geog
ON posts
USING GIST(position)

# Lettura dati
SELECT id, ST_AsText(position) AS coords
FROM posts
WHERE position IS NOT NULL;

# Verifica se IN bounding box (geometry)
SELECT id, ST_AsText(position) AS coords
FROM posts
WHERE position && ST_MakeEnvelope(7.5, 45.0, 7.8, 45.1, 4326);

# Verifica se IN bounding box (geography)
SELECT id, ST_AsText(position) AS coords
FROM posts
WHERE ST_DWithin(
    position, 
    ST_SetSRID(ST_MakePoint(7.6869, 45.0703), 4326)::geography,
    5000  -- 5 km
);

