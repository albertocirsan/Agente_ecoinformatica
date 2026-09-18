# Banco de tests

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

```bash
Rscript banco-tests/scripts/quiz.R test banco-tests/temas/<tema>.json   # un tema
Rscript banco-tests/scripts/quiz.R examen                                # mezcla varios temas
```

Depende de dos paquetes de R: [`jsonlite`](https://cran.r-project.org/package=jsonlite) para leer/escribir JSON, y [`here`](https://cran.r-project.org/package=here) para que las rutas funcionen sin importar desde qué carpeta se ejecute el script. Instálalos una vez con `install.packages(c("jsonlite", "here"))`. El proyecto lleva un archivo `.here` vacío en la raíz para anclar dónde está el proyecto" de forma inequívoca.
