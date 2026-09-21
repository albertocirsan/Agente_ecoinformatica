#!/usr/bin/env Rscript
# Mini aplicación de test/examen para el banco de preguntas de ~/banco-tests/.
#
# Uso:
#   Rscript quiz.R test <ruta_al_tema.json>
#   Rscript quiz.R examen
#
# Formato esperado de cada <tema>.json:
#   {"tema": "...", "preguntas": [
#     {"id": "...", "pregunta": "...", "opciones": ["...", "...", "..."], "correcta": 1/2/3}
#   ]}
#
# Guarda cada intento (preguntas hechas y respuestas dadas) en resultados.jsonl,
# y tras un examen actualiza ultimo-examen.md con la fecha y los temas incluidos.

LETRAS <- c("A", "B", "C")
BANCO <- path.expand("~/banco-tests")

cargar_tema <- function(ruta) {
  datos <- jsonlite::fromJSON(ruta, simplifyVector = FALSE)
  preguntas <- lapply(datos$preguntas, function(p) {
    p$opciones <- unlist(p$opciones) # de lista de 3 elementos a vector de texto
    p
  })
  list(tema = datos$tema, preguntas = preguntas)
}

preparar_preguntas <- function(preguntas) {
  # Baraja el orden de las preguntas y, dentro de cada una, el de sus opciones,
  # para que la respuesta correcta no quede siempre en la misma posición.
  preguntas <- preguntas[sample(length(preguntas))]
  lapply(preguntas, function(p) {
    orden <- sample(length(p$opciones)) # p.ej. c(3, 1, 2)
    # opciones_barajadas[k] = p$opciones[orden[k]], así que la nueva posición
    # de la correcta es donde "orden" apunta al índice que era correcto:
    correcta_nueva <- which(orden == p$correcta)
    list(
      id = p$id,
      pregunta = p$pregunta,
      opciones = p$opciones[orden],
      correcta = correcta_nueva
    )
  })
}

preguntar <- function(pregunta, entrada, numero, total) {
  cat("\nPregunta ", numero, "/", total, "\n", pregunta$pregunta, "\n", sep = "")
  for (i in seq_along(pregunta$opciones)) {
    cat("  ", LETRAS[i], ") ", pregunta$opciones[i], "\n", sep = "")
  }
  repeat {
    cat("Tu respuesta (A/B/C): ")
    # Leemos de la conexión "entrada" (abierta una sola vez en main())
    respuesta <- toupper(trimws(readLines(entrada, n = 1)))
    if (respuesta %in% LETRAS) break
    cat("Responde con A, B o C.\n")
  }
  indice <- match(respuesta, LETRAS)
  acierto <- indice == pregunta$correcta
  if (acierto) {
    cat("Correcto.\n")
  } else {
    cat("Incorrecto. La respuesta correcta era ", LETRAS[pregunta$correcta], ") ",
      pregunta$opciones[pregunta$correcta], "\n",
      sep = ""
    )
  }
  list(indice = indice, acierto = acierto)
}

ejecutar_quiz <- function(preguntas) {
  entrada <- file("stdin", "r")
  on.exit(close(entrada)) # se cierra sola al salir de la función, pase lo que pase
  respuestas <- list()
  aciertos <- 0
  total <- length(preguntas)
  # seq_along(preguntas) en vez de "for (pregunta in preguntas)": necesitamos
  # el número de posición (1, 2, 3...) para mostrarlo, no solo la pregunta.
  for (i in seq_along(preguntas)) {
    pregunta <- preguntas[[i]]
    resultado <- preguntar(pregunta, entrada, i, total)
    respuestas[[length(respuestas) + 1]] <- list(
      id = pregunta$id,
      respuesta = LETRAS[resultado$indice],
      acierto = resultado$acierto
    )
    aciertos <- aciertos + resultado$acierto # TRUE cuenta como 1
  }
  cat("\nResultado: ", aciertos, "/", total, "\n", sep = "")
  list(respuestas = respuestas, aciertos = aciertos)
}

guardar_resultado <- function(tipo, temas, respuestas, aciertos, total) {
  registro <- list(
    tipo = tipo,
    temas = temas,
    fecha = as.character(Sys.Date()),
    respuestas = respuestas,
    nota = aciertos,
    total = total
  )
  # auto_unbox = TRUE: sin esto, jsonlite convierte cada valor suelto
  # (p.ej. "nota": 8) en un array de un elemento ("nota": [8]).
  linea <- jsonlite::toJSON(registro, auto_unbox = TRUE)
  cat(linea, "\n", sep = "", file = file.path(BANCO, "resultados.jsonl"), append = TRUE)
}

modo_test <- function(ruta) {
  datos <- cargar_tema(ruta)
  preparadas <- preparar_preguntas(datos$preguntas)
  resultado <- ejecutar_quiz(preparadas)
  guardar_resultado("test", list(datos$tema), resultado$respuestas, resultado$aciertos, length(preparadas))
}

modo_examen <- function() {
  ficheros <- list.files(file.path(BANCO, "temas"), pattern = "\\.json$", full.names = TRUE)
  bancos <- lapply(ficheros, cargar_tema)
  bancos <- Filter(function(b) length(b$preguntas) > 0, bancos)

  if (length(bancos) < 2) {
    cat("Todavía no hay banco suficiente (hacen falta al menos 2 temas con preguntas).\n")
    cat("Genera algún test más con la skill nuevo-test antes de hacer un examen.\n")
    return(invisible())
  }

  mezcla <- list()
  i <- 1
  while (length(mezcla) < 10 && any(sapply(bancos, function(b) length(b$preguntas)) > 0)) {
    j <- (i - 1) %% length(bancos) + 1 # índice cíclico 1..length(bancos)
    banco <- bancos[[j]]
    if (length(banco$preguntas) > 0) {
      idx <- sample(length(banco$preguntas), 1)
      elegida <- banco$preguntas[[idx]]
      elegida$tema <- banco$tema
      mezcla[[length(mezcla) + 1]] <- elegida
      # En R, modificar "banco" (una copia local) no cambia bancos[[j]]
      banco$preguntas[[idx]] <- NULL
      bancos[[j]] <- banco
    }
    i <- i + 1
  }

  temas_incluidos <- sort(unique(sapply(mezcla, function(p) p$tema)))
  preparadas <- preparar_preguntas(mezcla)
  resultado <- ejecutar_quiz(preparadas)
  guardar_resultado("examen", as.list(temas_incluidos), resultado$respuestas, resultado$aciertos, length(preparadas))

  writeLines(
    c(
      paste0("Último examen general: ", Sys.Date()),
      paste0("Temas incluidos: ", paste(temas_incluidos, collapse = ", "))
    ),
    file.path(BANCO, "ultimo-examen.md")
  )
}

main <- function() {
  dir.create(file.path(BANCO, "temas"), recursive = TRUE, showWarnings = FALSE)
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) < 1 || !(args[1] %in% c("test", "examen"))) {
    cat("Uso:\n  Rscript quiz.R test <ruta_al_tema.json>\n  Rscript quiz.R examen\n")
    quit(status = 1)
  }
  if (args[1] == "test") {
    if (length(args) != 2) {
      cat("Uso: Rscript quiz.R test <ruta_al_tema.json>\n")
      quit(status = 1)
    }
    modo_test(args[2])
  } else {
    modo_examen()
  }
}

main()
