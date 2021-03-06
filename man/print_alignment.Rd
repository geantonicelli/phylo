% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{print_alignment}
\alias{print_alignment}
\alias{\alias{print_alignment}}
\title{function to print an ordered sequences alignment in chunks of defined size}
\usage{
print_alignment(alignment, chunksize = 60)
}
\arguments{
\item{alignment}{object of type alignment (seqinr package) with the aligned
sequences to be display. A file in format phylip is generated by an
alignment software from a .fasta file containing the sequences and loaded
to the R environment}

\item{chunksize}{integer specifying the number of sequence letters to be
printed in each chunk of display}
}
\value{
this function print the sequence alignment to the console in an
ordered fashion
}
\description{
this is a function that takes an alignment in phylip format made by an
alignment software like clustal omega and print it to the console in an
ordered display of defined sequence width the function calculates the number
of letters printed so far and print this number together with the name of
each sequence at the end of each chunk
}
\examples{
data(phylipProt)
print_alignment(phylipProt, 80)

}
\seealso{
\code{'\link{retrieve_seqs}'} \code{'\link{clean_alignment}'}
\code{'\link{load_alignment}'} \code{'\link{make_tree}'}
\code{'\link{max_parsimony}'}
}
\author{
gerardo esteban antonicelli
}
