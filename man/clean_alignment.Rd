% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{clean_alignment}
\alias{clean_alignment}
\alias{\alias{clean_alignment}}
\title{function to discard very poorly conserved regions from a sequences alignment
before building a phylogenetic tree}
\usage{
clean_alignment(alignment, minpcnongap, minpcid)
}
\arguments{
\item{alignment}{object of type alignment in phylip format with the aligned
sequences to be checked for similarity and cleaned. A file in format phylip
is generated by an alignment software from a .fasta file containing the
sequences and loaded to the R environment}

\item{minpcnongap}{integer for the desired minimal percentage of non-gap
positions between alignments for each position being analysed}

\item{minpcid}{integer for the desired minimal percentage of sequence
identity between alignments for each position being analysed}
}
\value{
this function returns a sequences alignment in phylip format
}
\description{
very poorly conserved regions are likely to be regions that are either not
homologous between the sequences being considered (and so do not add any
phylogenetic signal), or are homologous but are so diverged that they are
very difficult to align accurately (and so may add noise to the phylogenetic
analysis, and decrease the accuracy of the inferred tree) this function takes
an alignment in phylip format made by an alignment software like clustal
omega and clean the alignment based on a defined percentage of non-gap
positions and a defined percentage of sequence identity between all sequences
considered for phylogenetic analysis
}
\examples{
data(phylipProt)
cleaned_phylipProt <- clean_alignment(phylipProt, 30, 30)
print_alignment(cleaned_phylipProt)

}
\seealso{
\code{'\link{retrieve_seqs}'} \code{'\link{print_alignment}'}
\code{'\link{load_alignment}'} \code{'\link{make_tree}'}
\code{'\link{max_parsimony}'}
}
\author{
gerardo esteban antonicelli
}
