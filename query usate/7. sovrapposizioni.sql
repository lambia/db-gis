-- Controlla punti COMPLETAMENTE DENTRO il poligono con id=1
SELECT *
FROM luoghi
WHERE ST_Contains(
    (SELECT posizione FROM aree WHERE id = 1),
    posizione
);

-- Punti che TOCCANO il poligono id=1
SELECT *
FROM luoghi
WHERE ST_Intersects(posizione, (SELECT posizione FROM aree WHERE id = 1));


-- Poligoni che intersecano il poligono con id=1
SELECT *
FROM aree
WHERE ST_Intersects(
    posizione,
    (SELECT posizione FROM aree WHERE id = 1)
);

-- calcola geometria = Sovrapposizione geometrica con poligono id=1
SELECT ST_Intersection(posizione, (SELECT posizione FROM aree WHERE id = 1))
FROM aree
WHERE ST_Intersects(posizione, (SELECT posizione FROM aree WHERE id = 1));
