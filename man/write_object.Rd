% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_object.R
\name{write_object}
\alias{write_object}
\title{Write an object to a file}
\usage{
write_object(object, dir = NULL, date = TRUE, overwrite = FALSE,
  row.names = FALSE, col.names = TRUE)
}
\arguments{
\item{object}{a data.frame, matrix, or vector to write out}

\item{dir}{a character string specifying the directory (folder) in which save
the object, defaults to current working directory.}

\item{date}{logical, if \code{TRUE} appends the object name with todays date}

\item{overwrite}{logical, if \code{TRUE} overwrites existing file of same name}

\item{row.names}{logical, if \code{TRUE} adds rownames to output file}

\item{col.names}{logical, if \code{TRUE} adds column names to output file}
}
\value{
Returns nothing. Saves "object_date.tsv" or "object.tsv" to current
  directory.
}
\description{
A wrapper for \code{write.table} that saves an object by name to a tab
delimited (.tsv) file with options to specify directory and include the
current date in the file name.
}
\examples{
write_object(iris2)

}

