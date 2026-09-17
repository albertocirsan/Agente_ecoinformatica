---
description: Genera un examen general mezclando preguntas de varios ficheros de banco-tests/, para repasar de forma espaciada varios temas a la vez, y actualiza la fecha del último examen.
---

# Examen general mezclado

Objetivo: repaso espaciado — mezclar preguntas de temas distintos ya
guardados, en vez de repasar un solo tema seguido.

## Pasos

1. Lee todos los ficheros `.md` dentro de `banco-tests/` (ignora
   `README.md` y `ultimo-examen.md`). Cada uno corresponde a un tema y
   contiene bloques `**P:** ... **R:** ...`.

2. Si hay menos de 2 temas con preguntas, avisa a la persona de que aún no
   hay banco suficiente para un examen mezclado y sugiere usar la skill
   `nuevo-test` primero.

3. Si hay banco suficiente, elige entre 6 y 10 preguntas repartidas entre al
   menos 2-3 temas distintos (no todas del mismo fichero). Prioriza mezclar
   temas que no hayan salido juntos recientemente si se puede saber por las
   fechas de `ultimo-examen.md`.

4. Presenta las preguntas una a una, en orden mezclado (no agrupadas por
   tema), esperando respuesta antes de la siguiente.

5. Da feedback tras cada respuesta igual que en un test individual: breve,
   explicando la respuesta correcta si falla, sin machacar por el fallo.

6. Al terminar, resume qué temas fueron bien y cuáles conviene repasar más
   (basándote en los fallos de este examen, no guardes ese detalle en
   ficheros, es solo feedback en la conversación).

7. Actualiza (o crea) `banco-tests/ultimo-examen.md` con este contenido,
   sobrescribiendo la fecha anterior:

   ```markdown
   Último examen general: YYYY-MM-DD
   Temas incluidos: <tema1>, <tema2>, ...
   ```
