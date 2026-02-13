-- Per scrivere la query che crea quadrati casuali ho seguito questi passaggi.
        
-- 1. Genero 100 numeri casuali x e y
SELECT 
	i,
	random() * (1600000 - 1200000) + 1200000 AS x,
	random() * (5200000 - 4600000) + 4600000 AS y
FROM generate_series(1, 100) AS s(i)

-- 2. uso i numeri casuali per generare i 4 vertici
SELECT 
	ST_AsText( ST_SetSRID(ST_MakePoint(x, y), 3003)) AS a,
	ST_AsText( ST_SetSRID(ST_MakePoint(x + 10000, y), 3003)) AS b,
	ST_AsText( ST_SetSRID(ST_MakePoint(x + 10000, y + 10000), 3003)) AS c,
	ST_AsText( ST_SetSRID(ST_MakePoint(x, y + 10000), 3003)) AS d
FROM (
	SELECT 
		i,
		random() * (1600000 - 1200000) + 1200000 AS x,
		random() * (5200000 - 4600000) + 4600000 AS y
	FROM generate_series(1, 100) AS s(i)
) AS casuali

-- 3. uso 4 punti per generare il poligono + aggiungo un campo "area N"
SELECT 
    'area ' || i AS nome,
    ST_SetSRID(
        ST_MakePolygon(
            ST_MakeLine(ARRAY[
                ST_MakePoint(x, y),
                ST_MakePoint(x + 10000, y),
                ST_MakePoint(x + 10000, y + 10000),
                ST_MakePoint(x, y + 10000),
                ST_MakePoint(x, y)  -- chiusura del poligono
            ])
        ), 3003
    ) AS posizione
FROM (
    SELECT 
        i,
        random() * (1600000 - 1200000) + 1200000 AS x,
        random() * (5200000 - 4600000) + 4600000 AS y
    FROM generate_series(1, 100) AS s(i)
) AS casuali;

-- 4. infine uso la select nell'insert into
