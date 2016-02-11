#' Write an object to a file
#'
#' A wrapper for \code{write.table} that saves an object by name to a tab
#' delimited (.tsv) file with options to specify directory and include the
#' current date in the file name.
#'
#' @param object a data.frame, matrix, or vector to write out
#' @param dir a character string specifying the directory (folder) in which save
#'   the object, defaults to current working directory.
#' @param date logical, if \code{TRUE} appends the object name with todays date
#' @return Returns nothing. Saves "object_date.tsv" or "object.tsv" to current
#'   directory.
#' @importFrom utils write.table
#' @export
#' @examples
#' write_object(iris2)
#'
write_object <- function(object, dir = NULL, date = TRUE) {
  if(date) date <- Sys.Date()
  object <- deparse(substitute(object))
  if(!is.null(dir)) {
    file.name <- paste0(dir, "/", object, "_", date, ".tsv")
    if(file.name %in% list.files(dir)) {
      stop(paste0("File '", file.name, "' already exists"))
    }
  } else {
    file.name <- paste0(object, "_", date, ".tsv")
    if(file.name %in% list.files()) {
      stop(paste0("File '", file.name, "' already exists"))
    }
  }
  write.table(object,
              file = file.name,
              sep = "\t")
}
