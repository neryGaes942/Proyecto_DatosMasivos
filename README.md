# Proyecto Final — Procesamiento de Datos Masivos en la Nube
## Food.com: Recipes and Reviews

**Curso:** Datos Masivos — Ingeniería Informática, ULACIT
**Grupo 2**

## Descripción del proyecto

Este proyecto implementa una arquitectura de procesamiento de datos masivos en Google Cloud Platform (GCP), utilizando el dataset público **"Food.com - Recipes and Reviews"** de Kaggle. El objetivo es analizar patrones de recetas, ingredientes, valoraciones y reseñas de usuarios para comprender preferencias gastronómicas y generar información útil para sistemas de recomendación.

## Dataset

- **Nombre:** Food.com - Recipes and Reviews
- **Fuente:** [Kaggle](https://www.kaggle.com/datasets/irkaal/foodcom-recipes-and-reviews)
- **Tamaño:** recipe.csv (704.21 MB), reviews.csv (496.1 MB)
- **Contenido:** 522,517 recetas en 312 categorías, y 1,401,982 reseñas de 271,907 usuarios.

## Preguntas analíticas

1. ¿Qué categorías de recetas tienen mayor demanda?
2. ¿Las recetas con más reseñas tienden a tener mejor calificación, o son las menos revisadas las mejor valoradas?
3. ¿Qué categorías de recetas generan más actividad de la comunidad?

## Arquitectura

## Cómo reproducir el proyecto

1. Crear un proyecto en Google Cloud Platform y habilitar Cloud Storage y BigQuery.
2. Descargar el dataset desde Kaggle y subirlo a un bucket de Cloud Storage (carpeta `raw/`).
3. Crear un dataset en BigQuery y cargar los CSV como tablas (`raw_recipes`, `raw_reviews`).
4. Ejecutar las consultas de limpieza y análisis en [`sql/consultas_bigquery.sql`](sql/consultas_bigquery.sql).
5. Abrir el notebook [`notebook/analisis_foodcom.ipynb`](notebook/analisis_foodcom.ipynb) en Google Colab, autenticarse con la cuenta de GCP, y ejecutar las celdas para generar las visualizaciones.

## Equipo

- Angélica Gutiérrez Gómez
- Dilanni Solís Mejía
- Fiorella Tapia Alfaro
- Ian Herrera Álvarez
- Montserrat María Moreno Vega
- Nery David Galvez Escobado
