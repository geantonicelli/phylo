#' alignment of RNA sequences for the spike protein of some sarbecoviruses
#'   closely related to SARSCoV2
#'
#' @description
#' 14 different sequences of some sarbecoviruses closely related to SARSCoV2
#'   were retrieved from public databases and compared using CLUSTAL omega (1.2.4)
#'   alignment software with the output in clustal format (see examples section for
#'   the complete protocol for retrieving, saving and processing the data)
#'
#' @source
#'   the \href{https://www.ncbi.nlm.nih.gov/genbank/}{genbank} database of
#'   the National Center for Biotechnology Information or the Universal Protein
#'   Resource \href{https://www.uniprot.org/}{UniProt} database
#'
#' @format a list of class alignment with 4 elements
#' \describe{\item{nb}{number of sequences compared}
#'           \item{nam}{sequence name (accession number)}
#'           \item{seq}{a list of RNA sequences}
#'           \item{com}{NA}}
#'
#' @details
#' 1) spikeRNA_annot <- read.csv(system.file('extdata', 'spike_annot.csv',
#'                               package='firstPackage'))
#' 2) accessions <- spikeRNA_annot$accession
#' 3) download manually each sequence from 'genbank' and save as spike.fasta and
#'    perform an alignment with clustal omega with following commands
#'    (it needs to be installed locally or use a web interface)
#' 4) clustalo --threads=4 -v --outfmt=clustal -t RNA -i
#'    ./data/sequences/spike.fasta -o ./data/sequences/spike_align.aln
#' 5) clustalRNA_load <- load_alignment(system.file('extdata', 'spike_align.aln',
#'                                      package='firstPackage'), 'clustal')
#'
'clustalRNA'

#' alignment of RNA sequences for the spike protein of some sarbecoviruses
#'   closely related to SARSCoV2 in fasta format
#'
#' @description
#' 14 different sequences of some sarbecoviruses closely related to SARSCoV2
#'   were retrieved from public databases and compared using CLUSTAL omega (1.2.4)
#'   alignment software with the output in fasta format (see details for
#'   the complete protocol for retrieving, saving and processing the data)
#'
#' @source
#'   the \href{https://www.ncbi.nlm.nih.gov/genbank/}{genbank} database of
#'   the National Center for Biotechnology Information or the Universal Protein
#'   Resource \href{https://www.uniprot.org/}{UniProt} database
#'
#' @format a matrix of class DNAbin
#'  \describe{\item{attribute (dimnames)}{sequence name (accession number)}}
#'
#' @details
#' 1) spikeRNA_annot <- read.csv(system.file('extdata', 'spike_annot.csv',
#'                               package='firstPackage'))
#' 2) accessions <- spikeRNA_annot$accession
#' 3) download manually each sequence from 'genbank' and save as spike.fasta and
#'    perform an alignment with clustal omega with following commands
#'    (it needs to be installed locally or use a web interface)
#' 4) clustalo --threads=4 -v --outfmt=fasta -t RNA -i
#'    ./data/sequences/spike.fasta -o ./data/sequences/spike_align.fasta
#' 5) fastaRNA_load <- load_alignment(system.file('extdata', 'spike_align.fasta',
#'                                      package='firstPackage'), 'fasta')
#'
'fastaRNA'

#' an example of alignment in mase format of related protein sequences from different taxa
#'
#' @source
#' the Universal Protein Resource \href{https://www.uniprot.org/}{UniProt} database
#'
#' @format a list of class alignment with 4 elements
#' \describe{\item{nb}{number of sequences compared}
#'           \item{nam}{taxon origen of sequence}
#'           \item{seq}{a list of protein sequences}
#'           \item{com}{NA}}
#'
#' @details
#' 1) maseProtein_load <- load_alignment(system.file('extdata', 'prot.mase',
#'                                      package='firstPackage'), 'mase')
#' 2) data(maseProtein); stopifnot(identical(maseProtein, maseProtein_load))
#'
'maseProtein'

#' alignment of RNA sequences for the replicase of some sarbecoviruses
#'   closely related to SARSCoV2 in msf format
#'
#' @description
#' 14 different sequences of some sarbecoviruses closely related to SARSCoV2
#'   were retrieved from public databases and compared using CLUSTAL omega (1.2.4)
#'   alignment software with the output in msf format (see details for
#'   the complete protocol for retrieving, saving and processing the data)
#'
#' @source
#'   the \href{https://www.ncbi.nlm.nih.gov/genbank/}{genbank} database of
#'   the National Center for Biotechnology Information or the Universal Protein
#'   Resource \href{https://www.uniprot.org/}{UniProt} database
#'
#' @format a matrix of class DNAbin
#'  \describe{\item{attribute (dimnames)}{sequence name (accession number)}}
#'
#' @details
#' 1) orf1abRNA_annot <- read.csv(system.file('extdata', 'orf1ab_annot.csv',
#'                               package='firstPackage'))
#' 2) accessions <- orf1abRNA_annot$accession
#' 3) download manually each sequence from 'genbank' and save as orf1ab.fasta and
#'    perform an alignment with clustal omega with following commands
#'    (it needs to be installed locally or use a web interface)
#' 4) clustalo --threads=4 -v --outfmt=msf -t RNA -i
#'    ./data/sequences/orf1ab.fasta -o ./data/sequences/orf1ab_align.msf
#' 5) msfRNA_load <- load_alignment(system.file('extdata', 'orf1ab_align.msf',
#'                                  package='firstPackage'), 'msf', 'RNA')
#'
'msfRNA'

#' alignment of protein sequences of the spike protein of some sarbecoviruses
#'   closely related to SARSCoV2
#'
#' @description
#' 14 different sequences of some sarbecoviruses closely related to SARSCoV2
#'   were retrieved from public databases and compared using CLUSTAL omega (1.2.4)
#'   alignment software with the output in phylip format (see examples section for
#'   the complete protocol for retrieving, saving and processing the data)
#'
#' @source
#'   the \href{https://www.ncbi.nlm.nih.gov/genbank/}{genbank} database of
#'   the National Center for Biotechnology Information or the Universal Protein
#'   Resource \href{https://www.uniprot.org/}{UniProt} database
#'
#' @format a list of class alignment with 4 elements
#' \describe{\item{nb}{number of sequences compared}
#'           \item{nam}{sequence name (accession number)}
#'           \item{seq}{a list of protein sequences}
#'           \item{com}{NA}}
#'
#' @details
#' 1) spikeProt_annot <- read.csv(system.file('extdata', 'spike_prot_annot.csv',
#'                               package='firstPackage'))
#' 2) accessions <- spikeProt_annot$accession
#' 3) download manually each sequence from 'UniProt' and save as spike_prot.fasta and
#'    perform an alignment with clustal omega with following commands
#'    (it needs to be installed locally or use a web interface)
#' 4) clustalo --threads=4 -v --outfmt=phy -t Protein -i
#'    ./data/sequences/spike_prot.fasta -o ./data/sequences/spike_prot_align.phy
#' 5) phylipProt_load <- load_alignment(system.file('extdata', 'spike_prot_align.phy',
#'                                      package='firstPackage'), 'phylip', 'protein')
#'
'phylipProt'

#' alignment of RNA sequences for the spike protein of some sarbecoviruses
#'   closely related to SARSCoV2 in phylip format
#'
#' @description
#' 14 different sequences of some sarbecoviruses closely related to SARSCoV2
#'   were retrieved from public databases and compared using CLUSTAL omega (1.2.4)
#'   alignment software with the output in phylip format (see details for
#'   the complete protocol for retrieving, saving and processing the data)
#'
#' @source
#'   the \href{https://www.ncbi.nlm.nih.gov/genbank/}{genbank} database of
#'   the National Center for Biotechnology Information or the Universal Protein
#'   Resource \href{https://www.uniprot.org/}{UniProt} database
#'
#' @format a matrix of class DNAbin
#'  \describe{\item{attribute (dimnames)}{sequence name (accession number)}}
#'
#' @details
#' 1) spikeRNA_annot <- read.csv(system.file('extdata', 'spike_annot.csv',
#'                               package='firstPackage'))
#' 2) accessions <- spikeRNA_annot$accession
#' 3) download manually each sequence from 'genbank' and save as spike.fasta and
#'    perform an alignment with clustal omega with following commands
#'    (it needs to be installed locally or use a web interface)
#' 4) clustalo --threads=4 -v --outfmt=phy -t RNA -i
#'    ./data/sequences/spike.fasta -o ./data/sequences/spike_align.phy
#' 5) phylipRNA_load <- load_alignment(system.file('extdata', 'spike_align.phy',
#'                                      package='firstPackage'), 'fasta')
#'
'phylipRNA'
