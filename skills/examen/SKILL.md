---
description: Comprueba si hay banco suficiente (al menos 3 temas con 10 preguntas cada uno, unas 30 en total) en ~/banco-tests/ y, si lo hay, indica al usuario cómo ejecutar quiz.R en modo examen — el script mezcla automáticamente preguntas de varios temas, corrige y registra el resultado.
---

# Examen general mezclado

Objetivo: Práctica intercalada — mezclar preguntas de varios temas ya guardados, en vez de repasar uno solo. Toda la mecánica (elegir qué preguntas mezclar, preguntar, corregir, guardar) la hace el script `quiz.R`, no Claude, para
que la corrección y el registro sean siempre consistentes.

## Pasos

1. Lee los ficheros `~/banco-tests/temas/*.json` (cada uno es un tema) y cuenta cuántas preguntas tiene cada uno.

2. Si hay menos de 3 temas con preguntas, o el total de preguntas no llega a unas 30, dile a la persona qué le falta (por ejemplo: "de momento tienes 2 temas con test, git-basico y pandas-filtrado — genera al menos uno más con `nuevo-test` antes del examen") en vez de lanzar el examen igualmente.

3. Si hay banco suficiente, dile que ejecute:

   ```bash
   Rscript "${CLAUDE_PLUGIN_ROOT}/scripts/quiz.R" examen
   ```

   El script elige unas 10 preguntas repartidas entre varios temas distintos al azar, las mezcla, las hace una a una con corrección inmediata, y al terminar guarda el resultado en `~/banco-tests/resultados.jsonl` y actualiza `~/banco-tests/ultimo-examen.md` con la fecha y los temas incluidos — no hace falta que Claude actualice
   nada de eso a mano.

4. Si en un mensaje posterior la persona menciona que ya hizo el examen, puedes leer la última línea de tipo `"examen"` en `~/banco-tests/resultados.jsonl` para comentar qué temas fueron bien y cuáles conviene repasar más.
