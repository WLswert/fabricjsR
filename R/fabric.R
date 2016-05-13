#' Fabric.js In R
#'
#' Unleash the amazing power of \href{http://fabricjs.com}{fabric.js}
#'   in R just to see all that we can do.
#'
#' @import htmlwidgets
#'
#' @export
fabric <- function(message="fabric", width = NULL, height = NULL) {

  # forward options using x
  x = list(
    message = message
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'fabric',
    x,
    width = width,
    height = height,
    package = 'fabricjsR'
  )
}

