#' file.edit 2.0
#'
#' The usage of `file.edit`, but easier.
#'
#' @param rowNum integer, specify row number from `lf()` to open it's
#'   corresponding file
#'
#' @return nothing, opens the file specified
#' @export
#'
#' @examples
#' fe()
#'
fe = function(rowNum = 1){
  fileNames = as.character(lf()[, 1])
  fileName = fileNames[rowNum]
  file.edit(fileName)
}
