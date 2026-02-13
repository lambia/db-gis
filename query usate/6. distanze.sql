-- 2a. Distanza
ST_Distance(a, b) → distanza esatta (costosa).
ST_DWithin(a, b, d) → vero/falso, usa indice, più efficiente.

-- Oggetti entro 500 m da un punto
SELECT *
FROM luoghi
WHERE ST_DWithin(
    posizione,
    ST_SetSRID(ST_MakePoint(1500000, 5000000), 3003),
    500
);

--2b. Intersezione
--ST_Intersects(a, b) → verifica topologica (indice-friendly).

SELECT a.*
FROM luoghi a, aree b
WHERE ST_Intersects(a.posizione, b.posizione);

--2c. Buffer
--ST_Buffer(posizione, distanza) → crea area attorno a un oggetto.
--Da usare solo se necessario (non indicizzabile).

SELECT ST_Buffer(posizione, 100) FROM luoghi;

--2d. Nearest Neighbor (KNN)
--Ricerca più vicini con GiST.

SELECT *
FROM luoghi
ORDER BY posizione <-> ST_SetSRID(ST_MakePoint(1500000, 5000000), 3003)
LIMIT 5;