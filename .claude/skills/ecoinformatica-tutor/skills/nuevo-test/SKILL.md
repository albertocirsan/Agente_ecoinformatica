---
description: Genera un test corto (3-5 preguntas) sobre el concepto o tarea que se acaba de tratar, lo hace al usuario una a una con feedback, y guarda las preguntas en banco-tests/ para repasarlas o incluirlas en un examen general más adelante.
---

# Generar un test corto

Objetivo: comprobar y reforzar si la persona ha entendido el concepto o
tarea recién tratada, y dejar constancia escrita para poder repasarlo luego.

## Pasos

1. Identifica el tema concreto tratado en la conversación reciente (por
   ejemplo: "git: deshacer el último commit", "pandas: filtrar filas por
   condición", "funciones: argumentos por defecto"). Si no está claro,
   pregunta a la persona qué tema quiere que entre en el test.

2. Formula entre 3 y 5 preguntas variadas sobre ese tema: mezcla preguntas
   conceptuales ("¿por qué...?") con preguntas prácticas ("¿qué comando
   usarías para...?"). Evita preguntas triviales de memorizar sintaxis sin
   más.

3. Haz las preguntas una a una (no todas de golpe), espera la respuesta de
   la persona antes de pasar a la siguiente.

4. Tras cada respuesta, da feedback breve: si es correcta, confirma y añade
   un matiz si aporta; si es incorrecta o incompleta, explica por qué y cuál
   es la respuesta correcta, sin hacerlo sentir mal por fallar — el fallo es
   parte de aprender.

5. Al terminar, guarda las preguntas y respuestas correctas en un archivo
   `banco-tests/<tema-en-kebab-case>.md` (crea el archivo si no existe,
   añade al final si ya existe) con este formato:

   ```markdown
   ## [YYYY-MM-DD] <tema>

   **P:** <pregunta>
   **R:** <respuesta correcta, breve>

   **P:** <pregunta>
   **R:** <respuesta correcta, breve>
   ```

   Usa la fecha real del sistema. No guardes las respuestas que dio la
   persona, solo la pregunta y la respuesta correcta de referencia — el
   banco es para repasar, no un registro de aciertos/fallos.

6. Confirma a la persona en qué archivo ha quedado guardado el test.
