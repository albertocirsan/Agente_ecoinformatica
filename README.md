# Agente de ecoinformática

Tenemos que decidir para qué y para qué no queremos utilizar la inteligencia artificial, y de qué manera. Un uso imprudente puede distanciarnos y separarnos del trabajo que producimos, así como dificultar nuestro aprendizaje y, dicho rápido, volvernos más tontos. La idea de esto es personalizar la inteligencia artificial para que su uso (centrado en programación, en nuestro caso) nos sirva para aprender, y mantengamos el máximo control de lo producido. Aun así, por supuesto, no hace ninguna magia, y quedará en la mano de cada unx decidir en qué caso y de qué manera lo utiliza.

Un plugin de [Claude Code](https://code.claude.com) que convierte al asistente en un profesor de programación alineado con los valores del [grupo de Ecoinformática de la AEET](https://ecoinfaeet.github.io/): ciencia abierta y reproducible, código simple, y aprendizaje activo por encima de soluciones hechas.

## Qué hace

- **Modo profesor por defecto**: ante una petición de "hazme X", en vez de implementarlo directamente, explica la teoría y guía paso a paso para que lo hagas tú. Escribe "OMITIR PROFESOR" cuando quieras que lo implemente sin el paso a paso.
- **Código simple**: prioriza funciones cortas y legibles, comentarios solo donde aportan, y sugerencias de mejora siempre explicadas.
- **Ciencia abierta**: recuerda buenas prácticas de reproducibilidad (README, licencia, dependencias versionadas) y de git/GitHub cuando viene a cuento.
- **Tests de repaso**: tras explicar un concepto, ofrece un test corto de 10 preguntas de opción múltiple, preguntas pensadas por Claude pero hecho y corregido por un script.
- **Exámenes mezclados**: cuando hay banco suficiente, propone un examen general que mezcla preguntas de varios temas ya guardados.

## Requisitos

- [Claude Code](https://code.claude.com).
- [R](https://cran.r-project.org/) con el paquete [`jsonlite`](https://cran.r-project.org/package=jsonlite), para los tests: `install.packages("jsonlite")`.
- `Rscript` accesible desde la terminal (en Windows no lo está por defecto: hay que añadir R al PATH).

## Instalación

Desde cualquier carpeta, dentro de Claude Code:

```
/plugin marketplace add albertocirsan/Agente_ecoinformatica
/plugin install ecoinformatica-tutor@acs-tools
```

No hace falta clonar nada: el primer comando registra este repositorio como catálogo y el segundo descarga el plugin.

Por defecto se instala **a nivel de usuario**, así que queda activo en todos tus proyectos. Si prefieres activarlo solo en uno, el menú `/plugin` permite elegir el ámbito. Yo lo tengo a nivel de usuario, pero es una elección personal.

## Probarlo

1. El estilo **Ecoinformática** se aplica automáticamente.
2. Pide algo como "hazme una función que lea un CSV": debería guiarte en vez de escribirla.
3. Tras una explicación, puedes pedir un test con `/ecoinformatica-tutor:nuevo-test`, o dejar que te lo ofrezca.
4. Cuando tengas banco suficiente, prueba `/ecoinformatica-tutor:examen`.

## Dónde se guardan tus tests

En `~/banco-tests/`, fuera del plugin y fuera de tus proyectos: son tus datos, en texto plano, y sobreviven a cualquier actualización o desinstalación. Puedes leerlos, editarlos o borrarlos a mano. El formato está documentado en [`docs/banco-tests.md`](docs/banco-tests.md).

## Desactivarlo o quitarlo

```
/plugin disable ecoinformatica-tutor@acs-tools
/plugin uninstall ecoinformatica-tutor@acs-tools
```

Desactivarlo lo deja instalado pero sin efecto. Ninguna de las dos cosas toca `~/banco-tests/`.

## Estructura del repositorio

```
Agente_ecoinformatica/
├── .claude-plugin/
│   ├── plugin.json                  manifiesto del plugin
│   └── marketplace.json             catálogo, para poder instalarlo
├── output-styles/
│   └── ecoinformatica.md            la personalidad "profesor" (pieza central)
├── skills/
│   ├── nuevo-test/SKILL.md          genera y guarda un test corto
│   └── examen/SKILL.md              mezcla preguntas de varios temas
├── scripts/quiz.R                   pregunta, corrige y registra los tests
├── docs/banco-tests.md              formato del banco de preguntas
├── CLAUDE.md                        contexto para trabajar en este repo
└── LICENSE
```

## Desarrollo

Para trastear con el plugin sin publicar cada prueba, clona el repositorio y añádelo como catálogo local:

```
/plugin marketplace add /ruta/a/Agente_ecoinformatica
/plugin install ecoinformatica-tutor@acs-tools
```

Al instalar, Claude Code copia el plugin a su carpeta de caché, así que los cambios que hagas en el repositorio no se aplican solos: hace falta `/plugin marketplace update acs-tools` y `/plugin update ecoinformatica-tutor@acs-tools`. Dentro de una sesión abierta, los cambios en un `SKILL.md` se recogen al momento, pero los de `output-styles/` necesitan `/reload-plugins` o reiniciar.

## Licencia

GNU General Public License v3 — ver [`LICENSE`](LICENSE). Úsalo, modifícalo y compártelo. Pero sin privatizarlo.
