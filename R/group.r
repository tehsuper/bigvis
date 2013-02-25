module <- Module("Binned")

#' Create a grouped variable.
#'
#' @details
#' This function produces an R reference class that wraps around a C++ function.
#' Generally, you should just treat this as an opaque object with reference
#' semantics, and you shouldn't call the methods on it - pass it to
#' \code{\link{summarise_1d}} and friends.
#'
#' @param x numeric or integer vector
#' @param width bin width
#' @param origin if not specified, guessed by \code{\link{find_origin}}
#' @param name name of original variable. This will be guess from the input to
#'   \code{group} if not supplied. Used in the output of
#'   \code{\link{summarise_1d}} etc.
#' @export
#' @examples
#' x <- runif(1e6)
#' g <- grouped(x, 0.01)
grouped <- function(x, width, origin = NULL, name = NULL) {
  if (is.null(name)) {
    name <- deparse(substitute(x))
  }

  if (!is.ranged(x)) {
    attr(x, "range") <- frange(x)
    class(x) <- "ranged"
  }
  origin <- origin %||% find_origin(x, width)

  module$BinnedVector$new(x, name, width, origin)
}

setMethod("show", "Rcpp_BinnedVector", function(object) {
  cat("Grouped [", object$size(), "]. ",
    "Width: ", object$width(), " Origin: ", object$origin(), "\n", sep = "")
})

is.grouped <- function(x) {
  is(x, "Rcpp_BinnedVector")
}
