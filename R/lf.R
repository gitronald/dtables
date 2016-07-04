
#' list.files 2.0
#'
#' The output of `list.files`, but easier to read.
#'
#' @param path string, path to list files from
#' @param recursive logical, list files within folders
#'
#' @return a one column data.frame named after the working directory that
#'   contains a recursive file list of that directory's contents as rows
#' @export
#'
#' @examples
#' lf()
#'
lf = function(path = ".", recursive = TRUE){

  folderName = getwd()
  folderName = strsplit(folderName, "/")
  folderName = folderName[[1]][lengths(folderName)]

  folderDetail = as.data.frame(list.files(path = path, recursive = recursive))
  folderDetail = setNames(folderDetail, folderName)

  return(folderDetail)
}
