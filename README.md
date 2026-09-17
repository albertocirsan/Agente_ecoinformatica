# ecoinformatica-tutor

Un plugin de [Claude Code](https://code.claude.com) que convierte al
asistente en un tutor de programación alineado con los valores del
[grupo de Ecoinformática de la AEET](https://www.aeet.org/es/gtecoinformatica):
ciencia abierta y reproducible, código simple, y aprendizaje activo por
encima de soluciones hechas.

## Qué hace

- **Modo profesor por defecto**: ante una petición de "hazme X", en vez de
  implementarlo directamente, explica la teoría y guía paso a paso para que
  lo hagas tú. Puedes pedir explícitamente "hazlo tú" cuando quieras que
  Claude lo implemente sin el paso a paso.
- **Código simple**: prioriza funciones cortas y legibles, comentarios solo
  donde aportan, y sugerencias de mejora siempre explicadas.
- **Ciencia abierta**: recuerda buenas prácticas de reproducibilidad
  (README, licencia, dependencias versionadas) y de git/GitHub cuando viene
  a cuento.
- **Tests de repaso**: tras explicar un concepto, ofrece un test corto de
  3-5 preguntas y lo guarda en `banco-tests/`.
- **Exámenes mezclados**: de vez en cuando, propone un examen general que
  mezcla preguntas de varios temas ya guardados.

## Probarlo en local

Sin necesidad de publicarlo en ningún sitio:

```bash
cd Claude_ecoinformatica
claude --plugin-dir .
```

Dentro de Claude Code:

1. Activa el estilo: `/output-style` → elige **Ecoinformática**.
2. Prueba a pedir algo como "hazme una función que lea un CSV" — debería
   guiarte en vez de escribirla directamente.
3. Prueba también a decir "impleméntalo tú directamente" para ver el otro
   camino.
4. Tras una explicación, puedes invocar el test manualmente con
   `/ecoinformatica-tutor:nuevo-test`, o dejar que Claude lo ofrezca solo.
5. Cuando haya banco suficiente, prueba `/ecoinformatica-tutor:examen`.

Si cambias algo en los archivos del plugin mientras Claude Code está
abierto, usa `/reload-plugins` para que recoja los cambios.

## Estructura

```
.claude-plugin/plugin.json     manifest del plugin
output-styles/ecoinformatica.md  la personalidad "profesor" (pieza central)
skills/nuevo-test/             genera y guarda un test corto
skills/examen/                 mezcla preguntas de varios tests
banco-tests/                   banco de preguntas acumulado, en Markdown
CLAUDE.md                      contexto de proyecto / versión copiable al CLAUDE.md global
```

## Instalarlo desde GitHub (para otras personas)

Una vez publicado este repositorio, cualquiera puede probarlo igual que en
local clonándolo y usando `claude --plugin-dir ruta/al/repo`, o añadiéndolo
como marketplace de plugins si se publica un `marketplace.json` (no incluido
en esta versión inicial).

## Licencia

MIT — ver `LICENSE`. Coherente con el espíritu de ciencia abierta: úsalo,
modifícalo y compártelo.
