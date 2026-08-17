-- =====================================================================
-- Proyecto Final - Datos Masivos - Food.com Recipes and Reviews
-- Entrega 2 - Consultas SQL para BigQuery
-- Reemplazar `TU_PROYECTO` por el ID real de tu proyecto en GCP.
-- =====================================================================

-- ---------------------------------------------------------------------
-- PASO 5: LIMPIEZA Y TRANSFORMACIÓN
-- ---------------------------------------------------------------------

-- 5.1 Tabla limpia de recetas
CREATE OR REPLACE TABLE `TU_PROYECTO.foodcom.recipes_clean` AS
SELECT DISTINCT
  RecipeId,
  Name,
  AuthorId,
  AuthorName,
  RecipeCategory,
  SAFE_CAST(AggregatedRating AS FLOAT64) AS AggregatedRating,
  SAFE_CAST(ReviewCount AS INT64)        AS ReviewCount,
  SAFE_CAST(Calories AS FLOAT64)         AS Calories,
  SAFE_CAST(ProteinContent AS FLOAT64)   AS ProteinContent,
  SAFE_CAST(SugarContent AS FLOAT64)     AS SugarContent,
  SAFE_CAST(RecipeServings AS FLOAT64)   AS RecipeServings
FROM `TU_PROYECTO.foodcom.raw_recipes`
WHERE RecipeId IS NOT NULL
  AND RecipeCategory IS NOT NULL
  AND RecipeCategory != '';

-- 5.2 Tabla limpia de reseñas
CREATE OR REPLACE TABLE `TU_PROYECTO.foodcom.reviews_clean` AS
SELECT DISTINCT
  ReviewId,
  RecipeId,
  AuthorId,
  AuthorName,
  SAFE_CAST(Rating AS FLOAT64) AS Rating,
  Review,
  DateSubmitted
FROM `TU_PROYECTO.foodcom.raw_reviews`
WHERE ReviewId IS NOT NULL
  AND RecipeId IS NOT NULL;

-- Filas descartadas en la limpieza (para documentar en el informe)
SELECT
  (SELECT COUNT(*) FROM `TU_PROYECTO.foodcom.raw_recipes`)   AS recetas_originales,
  (SELECT COUNT(*) FROM `TU_PROYECTO.foodcom.recipes_clean`) AS recetas_limpias,
  (SELECT COUNT(*) FROM `TU_PROYECTO.foodcom.raw_reviews`)   AS reviews_originales,
  (SELECT COUNT(*) FROM `TU_PROYECTO.foodcom.reviews_clean`) AS reviews_limpias;


-- ---------------------------------------------------------------------
-- PASO 6: PREGUNTAS ANALÍTICAS
-- ---------------------------------------------------------------------

-- Q1: ¿Qué categorías de recetas tienen mayor demanda?
-- "Demanda" = número de recetas publicadas y volumen total de reseñas recibidas por categoría.
SELECT
  RecipeCategory,
  COUNT(*)                         AS total_recetas,
  SUM(ReviewCount)                 AS total_resenas,
  ROUND(AVG(AggregatedRating), 2)  AS calificacion_promedio
FROM `TU_PROYECTO.foodcom.recipes_clean`
GROUP BY RecipeCategory
ORDER BY total_resenas DESC
LIMIT 15;


-- Q2: ¿Las recetas con más reseñas tienden a tener mejor calificación,
--     o son las menos revisadas las mejor valoradas?
SELECT
  CASE
    WHEN ReviewCount = 0                     THEN '0 reseñas'
    WHEN ReviewCount BETWEEN 1 AND 5         THEN '1-5 reseñas'
    WHEN ReviewCount BETWEEN 6 AND 20        THEN '6-20 reseñas'
    WHEN ReviewCount BETWEEN 21 AND 100      THEN '21-100 reseñas'
    ELSE '100+ reseñas'
  END AS rango_resenas,
  COUNT(*)                          AS num_recetas,
  ROUND(AVG(AggregatedRating), 2)   AS calificacion_promedio
FROM `TU_PROYECTO.foodcom.recipes_clean`
WHERE AggregatedRating IS NOT NULL
GROUP BY rango_resenas
ORDER BY
  CASE rango_resenas
    WHEN '0 reseñas'      THEN 0
    WHEN '1-5 reseñas'    THEN 1
    WHEN '6-20 reseñas'   THEN 2
    WHEN '21-100 reseñas' THEN 3
    ELSE 4
  END;


-- Q3: ¿Qué categorías de recetas generan más actividad de la comunidad?
-- "Actividad de comunidad" = número real de reseñas registradas (tabla reviews_clean)
-- y usuarios únicos que participan, por categoría.
SELECT
  r.RecipeCategory,
  COUNT(rv.ReviewId)              AS total_reviews_reales,
  COUNT(DISTINCT rv.AuthorId)     AS usuarios_unicos
FROM `TU_PROYECTO.foodcom.reviews_clean` rv
JOIN `TU_PROYECTO.foodcom.recipes_clean` r
  ON rv.RecipeId = r.RecipeId
GROUP BY r.RecipeCategory
ORDER BY total_reviews_reales DESC
LIMIT 15;
