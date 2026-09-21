# Banco de tests

Se crea una carpeta "~/banco-tests" en la que se guardaran las preguntas y los resultados. Esta carpeta ha de crearse fuera del repositorio para que no se borren los datos ante futuras actualizaciones. 

En esta carpeta, dentro de /temas se acumulan las preguntas de opción múltiple generadas por la skill `nuevo-test`, un fichero JSON por tema. Es texto plano: se puede leer, editar o borrar preguntas a mano sin depender de ninguna herramienta.

La mecánica de hacer el test/examen (preguntar, corregir, guardar el resultado) la ejecuta el script `scripts/quiz.R`.

## Formato de un tema: `temas/<tema-en-kebab-case>.json`

```json
{
  "tema": "git-basico",
  "preguntas": [
    {
      "id": "git-basico-2026-09-18-01",
      "fecha": "2026-09-18",
      "pregunta": "¿Qué hace `git fetch`?",
      "opciones": [
        "Descarga los cambios remotos sin fusionarlos con tu rama",
        "Fusiona automáticamente los cambios remotos en tu rama",
        "Elimina la rama remota"
      ],
      "correcta": 1
    }
  ]
}
```

`correcta` es el índice (empezando en **1**) de la opción correcta dentro de `opciones`. La posición en el archivo no importa: `quiz.R` baraja el orden de las opciones cada vez que presenta la pregunta.

## `resultados.jsonl`

Un registro por línea (formato [JSON Lines](https://jsonlines.org/)) de cada test o examen realizado, escrito automáticamente por `quiz.R`:

```json
{"tipo": "test", "temas": ["git-basico"], "fecha": "2026-09-18", "respuestas": [{"id": "git-basico-2026-09-18-01", "respuesta": "A", "acierto": true}], "nota": 8, "total": 10}
```

## `ultimo-examen.md`

Solo la fecha y los temas del último examen general, para saber cuánto banco nuevo se ha acumulado desde entonces. Lo escribe `quiz.R` al terminar un examen.

## `scripts/quiz.R`

(La ruta a la carpeta del plugin la da la skill)

```bash
Rscript <carpeta-del-plugin>/scripts/quiz.R test ~/banco-tests/temas/<tema>.json   # un tema
Rscript <carpeta-del-plugin>/scripts/quiz.R examen                                # mezcla varios temas
```

Depende de un paquete de R: [`jsonlite`](https://cran.r-project.org/package=jsonlite) para leer/escribir JSON. Instálalo una vez con `install.packages("jsonlite")`.
