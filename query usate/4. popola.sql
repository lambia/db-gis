-- Punti casuali
INSERT INTO luoghi (nome, posizione)
SELECT 'Luogo ' || i,
       ST_SetSRID(ST_MakePoint(
           random() * (1600000 - 1200000) + 1200000,  -- X
           random() * (5200000 - 4600000) + 4600000   -- Y
       ), 3003)
FROM generate_series(1, 100) AS s(i);

-- Aree casuali (quadrati di ~10 km)
INSERT INTO aree (nome, posizione)
SELECT 'Area ' || i,
       ST_SetSRID(
           ST_MakePolygon(
               ST_MakeLine(ARRAY[
                   ST_MakePoint(x, y),
                   ST_MakePoint(x + 10000, y),
                   ST_MakePoint(x + 10000, y + 10000),
                   ST_MakePoint(x, y + 10000),
                   ST_MakePoint(x, y)
               ])
           ), 3003)
FROM generate_series(1, 100) AS s(i),
     LATERAL (
         SELECT random() * (1600000 - 1200000) + 1200000 AS x,
                random() * (5200000 - 4600000) + 4600000 AS y
     ) AS coords;
