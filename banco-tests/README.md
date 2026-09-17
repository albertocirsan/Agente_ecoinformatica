# Banco de tests

Aquí se acumulan las preguntas generadas por la skill `nuevo-test`, un
fichero Markdown por tema. Es texto plano a propósito: se puede leer, editar
o borrar preguntas a mano sin depender de ninguna herramienta.

## Formato

Cada tema es un fichero `<tema-en-kebab-case>.md`. Dentro, un bloque por
sesión de test:

```markdown
## [YYYY-MM-DD] <tema>

**P:** <pregunta>
**R:** <respuesta correcta, breve>

**P:** <pregunta>
**R:** <respuesta correcta, breve>
```

El fichero `ultimo-examen.md` (si existe) guarda solo la fecha del último
examen general hecho con la skill `examen`, para saber cuánto banco nuevo se
ha acumulado desde entonces. No es un tema de repaso, se ignora al elegir
preguntas.
