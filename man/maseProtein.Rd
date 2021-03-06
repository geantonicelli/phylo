% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{maseProtein}
\alias{maseProtein}
\title{an example of alignment in mase format of related protein sequences from different taxa}
\format{
a list of class alignment with 4 elements
\describe{\item{nb}{number of sequences compared}
\item{nam}{taxon origen of sequence}
\item{seq}{a list of protein sequences}
\item{com}{NA}}
}
\source{
the Universal Protein Resource \href{https://www.uniprot.org/}{UniProt} database
}
\usage{
maseProtein
}
\description{
an example of alignment in mase format of related protein sequences from different taxa
}
\details{
\enumerate{
\item maseProtein_load <- load_alignment(system.file('extdata', 'prot.mase',
package='firstPackage'), 'mase')
\item data(maseProtein); stopifnot(identical(maseProtein, maseProtein_load))
}
}
\keyword{datasets}
