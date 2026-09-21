---
description: Genera un test de 10 preguntas tipo test (3 opciones cada una, dificultad media) sobre el concepto o tarea recién tratada, lo guarda en ~/banco-tests/temas/<tema>.json, y le indica al usuario cómo ejecutar el script quiz.R para hacerlo — el script (no Claude) pregunta, corrige y registra el resultado.
---

# Generar un test corto

Objetivo: dejar 10 preguntas de opción múltiple sobre el tema recién tratado, para que el propio usuario se examine con un script y quede constancia escrita en el banco de temas y preguntas.

## Pasos

1. Identifica el tema concreto tratado en la conversación reciente (por ejemplo: "git: deshacer el último commit", "pandas: filtrar filas por condición", "python: programación básica", "r: tidyverse"). Si no está claro, pregunta a la persona qué tema quiere que entre en el test. Conviértelo a `kebab-case` para el nombre de archivo (ej. `git-basico`, `pandas-filtrado`).

2. Formula 10 preguntas de opción múltiple con exactamente 3 opciones cada una y una sola correcta. Para que el test no sea ni muy fácil ni muy difícil:
   - Mezcla preguntas conceptuales ("¿por qué...?", "¿qué pasaría si...?") con preguntas prácticas ("¿qué harías para...?").
   - Evita preguntas triviales de memorizar sintaxis exacta, y evita también trampas rebuscadas que dependan de un detalle nunca mencionado.
   - Las dos opciones incorrectas (distractores) deben ser plausibles —errores reales que alguien aprendiendo el tema podría cometer, no disparates obvios.
   - No hace falta preocuparse por variar en qué posición (1ª, 2ª o 3ª) va la opción correcta al escribir el JSON: el script baraja el orden de las opciones cada vez que se hace el test, así que la posición en el archivo es irrelevante para el sesgo.
   - `correcta` es el índice de la opción correcta empezando en **1**, para que el archivo se lea igual que un vector en R.
   - **La pregunta debe evaluar el concepto general, no un detalle de este ejercicio concreto.** Pregúntate: "¿esta pregunta tendría la misma respuesta si me la hicieran dentro de un mes, sobre otro código cualquiera que use este mismo concepto?". Si la respuesta solo se puede deducir mirando esta sesión en particular (un nombre de variable que elegimos al azar, el orden concreto de argumentos de esta llamada concreta), no vale — reformúlala en términos generales. Ejemplo real de una pregunta mala que se coló: *"En `lapply(datos$preguntas, function(p) {...})`, ¿qué representa `p` en cada iteración?"* — esto depende de que la función se llamó `p`, un detalle arbitrario de esta sesión, no de entender `lapply`. La versión buena, que sí es transferible: *"Al llamar a `lapply(x, function(elemento) {...})`, ¿qué recibe la función en cada una de las veces que `lapply` la ejecuta?"* (un elemento distinto de `x` cada vez) — esa sí se puede responder pase lo que pase se llame como se llame la variable.

3. Cada pregunta lleva un `id` único: `<tema>-<fecha>-<número de 2 dígitos>`,por ejemplo `git-basico-2026-09-18-01`.

4. Guarda las preguntas en `~/banco-tests/temas/<tema>.json` con este formato (crea la carpeta `temas/` si todavía no existe):

   ```json
   {
     "tema": "<tema>",
     "preguntas": [
       {
         "id": "<tema>-<fecha>-01",
         "fecha": "<fecha>",
         "pregunta": "¿...?",
         "opciones": ["...", "...", "..."],
         "correcta": 1
       }
     ]
   }
   ```

   Si el archivo ya existe (el tema se ha tratado antes), carga el JSON, añade las 10 preguntas nuevas a la lista `preguntas` existente (no sobrescribas las anteriores) y guarda el conjunto resultante.

5. Dile a la persona que ejecute el test ella misma en su terminal:

   ```bash
   Rscript "${CLAUDE_PLUGIN_ROOT}/scripts/quiz.R" test ~/banco-tests/temas/<tema>.json
   ```

   El script pregunta una a una, corrige al momento, muestra la nota final, y guarda automáticamente el intento (preguntas hechas y respuestas dadas) en `~/banco-tests/resultados.jsonl` — no hace falta que la IA anote nada
   de eso a mano.

6. Si en un mensaje posterior la persona menciona que ya hizo el test, puedes leer `~/banco-tests/resultados.jsonl` (la última línea con ese tema) para comentar cómo le fue y qué conviene repasar, en vez de preguntárselo de nuevo.
