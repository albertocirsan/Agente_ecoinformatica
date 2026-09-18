# Agente de ecoinformática

Tenemos que decidir para qué y para qué no queremos utilizar la inteligencia artificial, y de qué manera. Un uso imprudente, puede distanciarnos y separarnos del trabajo que producimos, así como dificultar nuestro aprendizaje y dicho rápido, volvernos más tontos. La idea de esto es personalizar la inteligencia artificial para que su uso (centrado en programación en nuestro caso), nos sirva para aprender, y mantengamos el 100% del control de lo producido. Aun así, por supuesto, no hace ninguna magia, y quedará en la mano de cada unx decidir en que caso y de que manera lo utiliza. 

Un plugin de [Claude Code](https://code.claude.com) que convierte al asistente en un tutor de programación alineado con los valores del [grupo de Ecoinformática de la AEET](https://ecoinfaeet.github.io/):
ciencia abierta y reproducible, código simple, y aprendizaje activo por encima de soluciones hechas.

## Qué hace

- **Modo profesor por defecto**: ante una petición de "hazme X", en vez de implementarlo directamente, explica la teoría y guía paso a paso para que lo hagas tú. Puedes pedir explícitamente mediante "OMITIR PROFESOR" cuando quieras que Claude lo implemente sin el paso a paso.
- **Código simple**: prioriza funciones cortas y legibles, comentarios solo donde aportan, y sugerencias de mejora siempre explicadas.
- **Ciencia abierta**: recuerda buenas prácticas de reproducibilidad (README, licencia, dependencias versionadas) y de git/GitHub cuando viene a cuento.
- **Tests de repaso**: tras explicar un concepto, ofrece un test corto de 10 preguntas de opción múltiple, hecho y corregido por un script determinista (no por Claude a ojo), y lo guarda en `banco-tests/`.
- **Exámenes mezclados**: cuando hay banco suficiente, propone un examen general que mezcla preguntas de varios temas ya guardados.

## Activarlo

El plugin vive en `.claude/skills/ecoinformatica-tutor/` — Claude Code lo detecta y lo carga **solo**, sin instalar nada ni pasar flags, en cuanto abres una sesión con la carpeta raíz de este repositorio como directorio de
trabajo:

```bash
cd (ruta a)/Claude_ecoinformatica
claude
```

La primera vez te pedirá confirmar que confías en esta carpeta.

Una vez cargado:

1. El estilo **Ecoinformática** se aplica automáticamente.
2. Prueba a pedir algo como "hazme una función que lea un CSV" — debería guiarte en vez de escribirla directamente.
3. Tras una explicación, puedes invocar el test manualmente con `/ecoinformatica-tutor:nuevo-test`, o dejar que Claude lo ofrezca solo.
4. Cuando haya banco suficiente, prueba `/ecoinformatica-tutor:examen`. De todos modos, claude también lo ofrecerá solo.

Si cambias algo en `output-styles/` mientras Claude Code está abierto, hace falta `/reload-plugins` o reiniciar la sesión para que lo recoja — los cambios en un `SKILL.md` sí se aplican al momento.

### Para que se cargue en todos tus proyectos, no solo en este

`.claude/skills/` a nivel de **proyecto** solo se carga si trabajas dentro de ese proyecto. Si además quieres que estén disponibles en cualquier carpeta, personalmente, existe el mismo mecanismo a nivel de usuario: `~/.claude/skills/`. Copiar (o enlazar) esta misma carpeta ahí lo activa siempre, sin aviso de confianza (al ser tu propia configuración personal, no la de un repositorio ajeno).

## Estructura

```
.claude/skills/ecoinformatica-tutor/
├── .claude-plugin/plugin.json     manifest del plugin
├── output-styles/ecoinformatica.md  la personalidad "profesor" (pieza central)
└── skills/
    ├── nuevo-test/                genera y guarda un test corto
    └── examen/                    mezcla preguntas de varios tests
banco-tests/                       banco de preguntas y script del quiz (ver su README)
CLAUDE.md                          contexto de proyecto / versión copiable al CLAUDE.md global
```

## Instalarlo desde GitHub

Al clonar este repositorio y ejecutar `claude` desde su raíz, el plugin se carga solo (tras el aviso de confianza de la primera vez) — no hace falta ningún paso de instalación aparte.

## Licencia

GNU General Public License — ver `LICENSE`. Úsalo, modifícalo y compártelo. Pero sin privatizarlo
