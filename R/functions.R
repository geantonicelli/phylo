#' function to automatically retrieve sequences from a databank based on
#' accession numbers
#'
#' this is a function to retrieve sequences of DNA, RNA or protein from
#' databases structured under ACNUC and located on the web, the retrieval is
#' limited to accession numbers as selection criteria, remote access to ACNUC
#' databases works by opening a socket connection on a port (for example on port
#' number 5558 at pbil.univ-lyon1.fr) and by communicating on this socket
#' following the protocol described
#' \href{http://doua.prabi.fr/databases/acnuc/remote_acnuc.html}{here}
#'
#'
#' @param seqnames a character vector specifying the accession numbers of the
#'   sequences to be retrieved
#' @param acnucdb a character string specifying the name of the ACNUC database
#'   to be searched. Use \code{'\link[seqinr]{choosebank}'} without arguments to
#'   see a list of available databases
#'
#' @return this function returns a named list with the sequences matching the
#'   sequence names of class SeqAcnucWeb retrieved by
#'   \code{'\link[seqinr]{query}'} based on the provided accession numbers the
#'   name of each list item is composed of the accession number and the length
#'   of the sequence
#'
#' @author gerardo esteban antonicelli
#'
#' @seealso \code{'\link{print_alignment}'} \code{'\link{clean_alignment}'}
#'   \code{'\link{load_alignment}'} \code{'\link{make_tree}'}
#'   \code{'\link{max_parsimony}'}
#'
#' @aliases \alias{retrieve_seqs}
#'
#' @examples
#' seqs <- retrieve_seqs(c('P06747', 'P0C569', 'O56773', 'Q5VKP1'), 'swissprot')
#' \dontrun{viruses_annot <- read.csv(system.file('extdata',
#'                                                'CoV_genomes_annot.csv',
#'                                                package='firstPackage'))}
#' \dontrun{accessions <- viruses_annot$accession}
#' \dontrun{seqs <- retrieve_seqs(accessions, 'genbank')}
#' \dontrun{str(seqs)}
#'
#' @importFrom seqinr choosebank query getSequence closebank
#'
#' @export
retrieve_seqs <- function(seqnames, acnucdb){
                          myseqs <- list()
                          choosebank(acnucdb)
                          for(i in 1:length(seqnames)){
                              seqname <- seqnames[i]
                              print(paste('retrieving sequence', seqname, '...'))
                              query <- paste('AC=', seqname, sep='')
                              query2 <- query('query2', `query`)
                              seq <- getSequence(query2$req[[1]])
                              myseqs[[i]] <- seq
                              name <- paste(seqname, 'length', length(seq), sep=' ')
                              names(myseqs)[[i]] <- name
                              }
                          closebank()
                          return(myseqs)
                          }

#' function to print an ordered sequences alignment in chunks of defined size
#'
#' this is a function that takes an alignment in phylip format made by an
#' alignment software like clustal omega and print it to the console in an
#' ordered display of defined sequence width the function calculates the number
#' of letters printed so far and print this number together with the name of
#' each sequence at the end of each chunk
#'
#' @param alignment object of type alignment (seqinr package) with the aligned
#'   sequences to be display. A file in format phylip is generated by an
#'   alignment software from a .fasta file containing the sequences and loaded
#'   to the R environment
#' @param chunksize integer specifying the number of sequence letters to be
#'   printed in each chunk of display
#'
#' @return this function print the sequence alignment to the console in an
#'   ordered fashion
#'
#' @author gerardo esteban antonicelli
#'
#' @seealso \code{'\link{retrieve_seqs}'} \code{'\link{clean_alignment}'}
#'   \code{'\link{load_alignment}'} \code{'\link{make_tree}'}
#'   \code{'\link{max_parsimony}'}
#'
#' @aliases \alias{print_alignment}
#'
#' @examples
#' data(phylipProt)
#' print_alignment(phylipProt, 80)
#'
#' @importFrom seqinr read.alignment
#' @importFrom Biostrings countPattern
#'
#' @export
print_alignment <- function(alignment, chunksize=60){
                            numseqs <- alignment$nb
                            alignmentlen <- nchar(alignment$seq[[1]])
                            starts <- seq(1, alignmentlen, by=chunksize)
                            n <- length(starts)
                            aln <- vector()
                            lettersprinted <- vector()
                            for(j in 1:numseqs){
                                aln[j] <- alignment$seq[[j]]
                                lettersprinted[j] <- 0
                                }
                            for(i in 1:n){
                                for(j in 1:numseqs){
                                    alnj <- aln[j]
                                    chunkseqjaln <- substring(alnj, starts[i], starts[i]+chunksize-1)
                                    chunkseqjaln <- toupper(chunkseqjaln)
                                    gapsj <- countPattern('-', chunkseqjaln)
                                    lettersprinted[j] <- lettersprinted[j]+chunksize-gapsj
                                    print(paste(chunkseqjaln, lettersprinted[j], alignment$nam[j]), quote=FALSE)
                                    }
                                print(paste(''), quote=FALSE)
                                }
                            }

#' function to discard very poorly conserved regions from a sequences alignment
#' before building a phylogenetic tree
#'
#' very poorly conserved regions are likely to be regions that are either not
#' homologous between the sequences being considered (and so do not add any
#' phylogenetic signal), or are homologous but are so diverged that they are
#' very difficult to align accurately (and so may add noise to the phylogenetic
#' analysis, and decrease the accuracy of the inferred tree) this function takes
#' an alignment in phylip format made by an alignment software like clustal
#' omega and clean the alignment based on a defined percentage of non-gap
#' positions and a defined percentage of sequence identity between all sequences
#' considered for phylogenetic analysis
#'
#' @param alignment object of type alignment in phylip format with the aligned
#'   sequences to be checked for similarity and cleaned. A file in format phylip
#'   is generated by an alignment software from a .fasta file containing the
#'   sequences and loaded to the R environment
#' @param minpcnongap integer for the desired minimal percentage of non-gap
#'   positions between alignments for each position being analysed
#' @param minpcid integer for the desired minimal percentage of sequence
#'   identity between alignments for each position being analysed
#'
#' @return this function returns a sequences alignment in phylip format
#'
#' @author gerardo esteban antonicelli
#'
#' @seealso \code{'\link{retrieve_seqs}'} \code{'\link{print_alignment}'}
#'   \code{'\link{load_alignment}'} \code{'\link{make_tree}'}
#'   \code{'\link{max_parsimony}'}
#'
#' @aliases \alias{clean_alignment}
#'
#' @examples
#' data(phylipProt)
#' cleaned_phylipProt <- clean_alignment(phylipProt, 30, 30)
#' print_alignment(cleaned_phylipProt)
#'
#' @export
clean_alignment <- function(alignment, minpcnongap, minpcid){
                            newalignment <- alignment
                            numseqs <- alignment$nb
                            alignmentlen <- nchar(alignment$seq[[1]])
                            for(j in 1:numseqs){
                                newalignment$seq[[j]] <- ''
                                }
                            for(i in 1:alignmentlen){
                                nongap <- 0
                                for(j in 1:numseqs){
                                    seqj <- alignment$seq[[j]]
                                    letterij <- substr(seqj, i, i)
                                    if(letterij != '-'){
                                       nongap <- nongap + 1
                                       }
                                    }
                                pcnongap <- (nongap*100)/numseqs
                                if(pcnongap >= minpcnongap){
                                   numpairs <- 0.01
                                   numid <- 0
                                   for(j in 1:(numseqs-1)){
                                       seqj <- alignment$seq[[j]]
                                       letterij <- substr(seqj, i, i)
                                       for(k in (j+1):numseqs){
                                           seqk <- alignment$seq[[k]]
                                           letterkj <- substr(seqk, i, i)
                                           if(letterij != '-' && letterkj != '-'){
                                              numpairs <- numpairs + 1
                                              if(letterij==letterkj){
                                                 numid <- numid + 1
                                                 }
                                              }
                                           }
                                       }
                                   pcid <- (numid*100)/(numpairs)
                                   if(pcid >= minpcid){
                                      for(j in 1:numseqs){
                                          seqj <- alignment$seq[[j]]
                                          letterij <- substr(seqj, i, i)
                                          newalignmentj <- newalignment$seq[[j]]
                                          newalignmentj <- paste(newalignmentj, letterij, sep='')
                                          newalignment$seq[[j]] <- newalignmentj
                                          }
                                     }
                                   }
                                }
                            return(newalignment)
                            }

#' function to load a file containing a sequences alignment generated by an
#' alignment software
#'
#' this function is wrapper around the functions
#' \code{'\link[seqinr]{read.alignment}'},
#' \code{'\link[adegenet]{fasta2DNAbin}'} and \code{'\link[ape]{as.DNAbin}'}.
#' The goal of this function is to load different types of sequences alignments,
#' i.e. protein, DNA, RNA, in different formats, i.e. fasta, phylip, mase,
#' clustal or msf and to convert it in the best suitable object class for
#' generating a distance matrix either with the 'seqnir' or the 'ape' package
#'
#' @param file a character string specifying the path to the file containing a
#'   sequences alignment to be loaded to the global environment
#' @param format a character string specifying the format of the file, i.e.
#'   fasta, phylip, mase, clustal or msf (no default)
#' @param type a character string specifying type of sequences, i.e. protein,
#'   DNA, RNA (default: protein)
#'
#' @return if the input type is DNA or RNA this function returns an object of
#'   class DNAbin, if the input type is protein or unspecified (default) this
#'   function returns an object of class alignment (seqinr package)
#'
#' @author gerardo esteban antonicelli
#'
#' @seealso \code{'\link{retrieve_seqs}'} \code{'\link{print_alignment}'}
#'   \code{'\link{clean_alignment}'} \code{'\link{make_tree}'}
#'   \code{'\link{max_parsimony}'}
#'
#' @aliases \alias{load_alignment}
#'
#' @examples
#' fastaRNA_load <- load_alignment(system.file('extdata',
#'                                             'spike_align.fasta',
#'                                             package='firstPackage'),
#'                                  'fasta', 'RNA')
#' phylipRNA_load  <- load_alignment(system.file('extdata',
#'                                               'spike_align.phy',
#'                                               package='firstPackage'),
#'                                  'phylip', 'RNA')
#' phylipProt_load <- load_alignment(system.file('extdata',
#'                                               'spike_prot_align.phy',
#'                                               package='firstPackage'),
#'                                  'phylip', 'protein')
#' clustalRNA_load <- load_alignment(system.file('extdata',
#'                                               'spike_align.aln',
#'                                               package='firstPackage'),
#'                                  'clustal')
#' msfRNA_load <- load_alignment(system.file('extdata',
#'                                           'orf1ab_align.msf',
#'                                           package='firstPackage'),
#'                                  'msf', 'RNA')
#' maseProtein_load <- load_alignment(system.file('extdata',
#'                                                'prot.mase',
#'                                                package='firstPackage'),
#'                                  'mase')
#' data(fastaRNA); stopifnot(identical(fastaRNA, fastaRNA_load))
#' data(phylipRNA); stopifnot(identical(phylipRNA, phylipRNA_load))
#' data(clustalRNA); stopifnot(identical(clustalRNA, clustalRNA_load))
#' data(msfRNA); stopifnot(identical(msfRNA, msfRNA_load))
#' data(maseProtein); stopifnot(identical(maseProtein, maseProtein_load))
#'
#' @importFrom seqinr read.alignment
#' @importFrom adegenet fasta2DNAbin
#' @importFrom ape as.DNAbin
#'
#' @export
load_alignment <- function(file, format, type='protein'){
                           if(type=='protein'){
                              alignment <- read.alignment(file, format)
                              }
                           else if(type=='DNA' || type=='RNA'){
                                   if(format=='fasta' || format=='fa'){
                                      alignment <- fasta2DNAbin(file)
                                      }
                                   else{align <- read.alignment(file, format)
                                        alignment <- as.DNAbin(align)
                                        }
                                   }
                           return(alignment)
                           }

#' function to calculate a distance-based phylogenetic tree with bootstrapping validation
#'
#' this function is a wrapper around the functions
#'   \code{'\link[seqinr]{dist.alignment}'}, \code{'\link[ape]{dist.dna}'},
#'   \code{'\link[ape]{nj}'}, \code{'\link[ape]{bionj}'},
#'   \code{'\link[ape]{fastme.bal}'}, \code{'\link[ape]{fastme.ols}'},
#'   \code{'\link[ape]{boot.phylo}'} and \code{'\link[ape]{plot.phylo}'}. it takes
#'   a sequences alignment in format 'alignment' of 'DNAbin' matrix and perform all
#'   transformations and steps to calculate a phylogenetic distance matrix based
#'   on similarity or identity in the case of proteins or based in evolutionary
#'   models in the case of DNA or RNA, to perform a distance-based phylogenetic
#'   clustering, to validate the resulting phylogeny by a bootstrapping method and
#'   to draft plot the results for exploratory visualization in order to adjust
#'   and compare the calculations
#'
#' @param alignment an object of class alignment or DNAbin containing a DNA, RNA
#'   or protein sequences alignment
#' @param type a character string without '' specifying the type of sequences,
#'   i.e. DNA, RNA or protein (without default value)
#' @param model a character string without '' specifying the model to be used
#'   for the calculation of the distances matrix, i.e. raw, N, TS, TV, JC69,
#'   K80, F81, K81, F84, BH87, T92, TN93 (default), GG95, logdet, paralin,
#'   indel, or indelblock
#' @param clustering a character string without '' specifying the clustering
#'   algorithm to be used to build the phylogenetic tree, i.e classic
#'   neighbor-joining (nj), improved neighbor-joining (bionj) (default), NJ or
#'   bio-NJ from a distance matrix with possibly missing values (njs, bionjs),
#'   balanced minimum evolution principle (fastme.bal), ordinary least-squares
#'   minimum evolution principle (fastme.ols)
#' @param outgroup a character string without '' specifying a taxon to be taken
#'   as root for building the tree. The default value is NULL leading to an
#'   unrooted tree
#' @param plot a character string without '' specifying the type of phylogenetic
#'   plot to be drawn for visualization of the phylogenetic calculations, i.e.
#'   phylogram, cladogram, fan, unrooted (default), radial or any unambiguous
#'   abbreviation of these
#'
#' @return the function returns an object of class phylo of the 'ape' package
#'   and a draft plot to visualize the phylogenetic calculations. More advanced
#'   and elaborated plots can be drawn in later steps based on the tree data of
#'   the phylo class object
#'
#' @author gerardo esteban antonicelli
#'
#' @seealso \code{'\link{retrieve_seqs}'} \code{'\link{print_alignment}'}
#'   \code{'\link{clean_alignment}'} \code{'\link{load_alignment}'}
#'   \code{'\link{max_parsimony}'}
#'
#' @aliases \alias{make_tree}
#'
#' @examples
#' data(phylipProt)
#' data(phylipRNA)
#' data(clustalRNA)
#' phylipProtTree <- make_tree(phylipProt, type=protein, model=K80, outgroup=YP_0010399)
#' phylipRNATree <- make_tree(phylipRNA, type=RNA, plot=clado)
#' clustalRNATree <- make_tree(clustalRNA, type=RNA)
#'
#' @importFrom seqinr dist.alignment as.matrix.alignment
#' @importFrom ape as.alignment as.DNAbin dist.dna nj bionj njs bionjs fastme.bal
#'   fastme.ols makeLabel ladderize root boot.phylo plot.phylo nodelabels
#'
#' @export
make_tree <- function(alignment, type, model=TN93, clustering=bionj, outgroup=NULL, plot=u){
                      seqtype <- deparse(substitute(type))
                      distmodel <- deparse(substitute(model))
                      out <- deparse(substitute(outgroup))
                      plottype <- deparse(substitute(plot))
                      makemytree <- function(alignmat){
                                             if(seqtype=='protein'){
                                                alignment <- as.alignment(alignmat)
                                                mydist <- dist.alignment(alignment)
                                                }
                                             else if(seqtype=='DNA'|| seqtype=='RNA'){
                                                     if(class(alignmat)[[1]]=='DNAbin'){DNAbin <- alignmat}
                                                     else{alignment <- as.alignment(alignmat)
                                                          DNAbin <- as.DNAbin(alignment)
                                                          }
                                                     mydist <- dist.dna(DNAbin, model=distmodel)
                                                     }
                                             mytree <- eval(substitute(clustering(mydist)))
                                             mytree <- makeLabel(mytree, space='')
                                             mytree <- ladderize(mytree)
                                             if(out=='NULL'){my_tree <- mytree}
                                             else{my_tree <- root(mytree, outgroup=out, r=TRUE)}
                                             return(my_tree)
                                             }
                      if(class(alignment)=='DNAbin'){mymat <- alignment}
                      else{mymat  <- as.matrix.alignment(alignment)}
                      mytree <- makemytree(mymat)
                      myboot <- boot.phylo(mytree, mymat, makemytree)
                      plot.phylo(mytree, type=plottype)
                      nodelabels(myboot, cex=0.7)
                      mytree$node.label <- myboot
                      return(mytree)
                      }

#' function to calculate a maximum pasimony phylogenetic tree
#'
#' this function is a wrapper around the functions
#'   \code{'\link[seqinr]{dist.alignment}'}, \code{'\link[ape]{dist.dna}'},
#'   \code{'\link[ape]{nj}'}, \code{'\link[ape]{bionj}'},
#'   \code{'\link[ape]{fastme.bal}'}, \code{'\link[ape]{fastme.ols}'} and
#'   \code{'\link[phangorn]{optim.parsimony}'}. it takes a sequences alignment in
#'   format 'alignment' of 'DNAbin' matrix and perform all transformations and
#'   steps to calculate a phylogenetic distance matrix based on similarity or
#'   identity in the case of proteins or based in evolutionary models in the case
#'   of DNA or RNA, to perform a phylogenetic clustering and to optimise the
#'   phylogeny by a maximum parsimony algorithm
#'
#' @param alignment an object of class alignment or DNAbin containing a DNA, RNA
#'   or protein sequences alignment
#' @param type a character string without '' specifying the type of sequences,
#'   i.e. DNA, RNA or protein (without default value)
#' @param clustering a character string without '' specifying the clustering
#'   algorithm to be used to build the phylogenetic tree, i.e classic
#'   neighbor-joining (nj), improved neighbor-joining (bionj) (default), NJ or
#'   bio-NJ from a distance matrix with possibly missing values (njs, bionjs),
#'   balanced minimum evolution principle (fastme.bal), ordinary least-squares
#'   minimum evolution principle (fastme.ols)
#' @param outgroup a character string without '' specifying a taxon to be taken
#'   as root for building the tree. The default value is NULL leading to an
#'   unrooted tree
#'
#' @return the function returns an object of class 'phylo' of the 'ape' package.
#'   Advanced and elaborated plots can be drawn in later steps based on the tree
#'   data of the phylo class object
#'
#' @author gerardo esteban antonicelli
#'
#' @seealso \code{'\link{retrieve_seqs}'} \code{'\link{print_alignment}'}
#'   \code{'\link{clean_alignment}'} \code{'\link{load_alignment}'}
#'   \code{'\link{make_tree}'}
#'
#' @aliases \alias{max_parsimony}
#'
#' @examples
#' data(fastaRNA)
#' data(phylipRNA)
#' data(phylipProt)
#' clustalRNA <- load_alignment(system.file('extdata',
#'                                          'spike_align.aln',
#'                                          package='firstPackage'),
#'                              'clustal')
#' fastaRNAtree <- max_parsimony(alignment=fastaRNA, type=RNA,
#'                               clustering=fastme.ols)
#' phylipRNAtree <- max_parsimony(phylipRNA, RNA, fastme.bal)
#' phylipProtTree <- max_parsimony(phylipProt, protein, outgroup=YP_0010399)
#' clustalRNAtree <- max_parsimony(clustalRNA, type=RNA, clustering=bionj)
#' \dontrun{plot.phylo(phylipRNAtree, type='u')}
#'
#' @importFrom seqinr dist.alignment
#' @importFrom ape as.DNAbin dist.dna nj bionj njs bionjs fastme.bal fastme.ols
#'   makeLabel ladderize root
#' @importFrom phangorn as.phyDat optim.parsimony
#'
#' @export
max_parsimony <- function(alignment, type, clustering=bionj, outgroup=NULL){
                          seqtype <- deparse(substitute(type))
                          out <- deparse(substitute(outgroup))
                          if(seqtype=='protein'){
                             phyDat <- as.phyDat(alignment, type='AA')
                             mydist <- dist.alignment(alignment)
                             }
                          else if(seqtype=='DNA'|| seqtype=='RNA'){
                                  if(class(alignment)[[1]]=='DNAbin'){DNAbin <- alignment}
                                  else{DNAbin <- as.DNAbin(alignment)}
                                  phyDat <- as.phyDat(DNAbin)
                                  mydist <- dist.dna(DNAbin, model='raw')
                                  }
                          mytree <- eval(substitute(clustering(mydist)))
                          optimtree <- optim.parsimony(mytree, phyDat, method='sankoff')
                          optimtree <- makeLabel(optimtree, space='')
                          optimtree <- ladderize(optimtree)
                          if(out=='NULL'){my_tree <- optimtree}
                          else{my_tree <- root(optimtree, outgroup=out, r=TRUE)}
                          return(my_tree)
                          }

#' function to calculate a maximum likelihood phylogenetic tree
#'
#' this function is a wrapper around the functions
#' \code{'\link[seqinr]{dist.alignment}'}, \code{'\link[ape]{dist.dna}'},
#' \code{'\link[ape]{nj}'}, \code{'\link[ape]{bionj}'},
#' \code{'\link[ape]{fastme.bal}'}, \code{'\link[ape]{fastme.ols}'},
#' \code{'\link[phangorn]{pml}'} and \code{'\link[phangorn]{optim.pml}'}. it takes a sequences alignment in
#' format 'alignment' of 'DNAbin' matrix and perform all transformations and steps
#' to calculate a phylogenetic distance matrix based on similarity or identity
#' in the case of proteins or based in evolutionary models in the case of DNA or
#' RNA, to perform a likelihood-based phylogenetic clustering and to optimise the phylogeny by a
#' maximum likelihood algorithm
#'
#' @param alignment an object of class alignment or DNAbin containing a DNA, RNA
#'   or protein sequences alignment
#' @param type a character string without '' specifying the type of sequences,
#'   i.e. DNA, RNA or protein (without default value)
#' @param model a character string without '' specifying the model to be used
#'   for the calculation of the distances matrix, i.e. raw, N, TS, TV, JC69,
#'   K80, F81, K81, F84, BH87, T92, TN93 (default), GG95, logdet, paralin,
#'   indel, or indelblock
#' @param clustering a character string without '' specifying the clustering
#'   algorithm to be used to build the phylogenetic tree, i.e classic
#'   neighbor-joining (nj), improved neighbor-joining (bionj) (default), NJ or
#'   bio-NJ from a distance matrix with possibly missing values (njs, bionjs),
#'   balanced minimum evolution principle (fastme.bal), ordinary least-squares
#'   minimum evolution principle (fastme.ols)
#' @param pml.model a character string without '' specifying the model to be
#'   used for the calculation and optimisation of the maximum likelihood, for
#'   nucleotide sequences they are 23, i.e. JC, F81, K80, HKY, TrNe, TrN, TPM1,
#'   K81, TPM1u, TPM2, TPM2u, TPM3, TPM3u, TIM1e, TIM1, TIM2e, TIM2, TIM3e,
#'   TIM3, TVMe, TVM, SYM, GTR, whereas for protein sequences there are 17
#'   algorithms available, i.e. WAG, JTT, LG, Dayhoff, cpREV, mtmam, mtArt,
#'   MtZoa, mtREV24, VT, RtREV, HIVw, HIVb, FLU, Blosum62, Dayhoff_DCMut,
#'   JTT_DCMut. The default model corresponds to the model F81 for nucleotides
#'   and it is set up with the parameters 'optBf=TRUE' and 'optQ=FALSE' in the
#'   function 'optim.pml()' of the phangorn package inside the function
#'   'max_likelihood()'. It is possible to run all the models at once for a
#'   given type of sequence with the value 'all' without ''
#' @param outgroup a character string without '' specifying a taxon to be taken
#'   as root for building the tree. The default value is NULL leading to an
#'   unrooted tree
#' @param clean logical (default=TRUE) indicating if the input sequences should
#'   be cleaned of any gap position or undefined nucleotide or aminoacid residue
#'   to improve philogenetic prediction, set to FALSE if you want to clean the
#'   sequences more gently and flexibly with 'clean_alignment' before
#'   calculations or if you want to use the raw sequences alignment
#'
#' @return the function returns an object of class 'pml' of the 'phangorn'
#'   package. Advanced and elaborated plots can be drawn in later steps based on
#'   the tree data of the pml class object
#'
#' @author gerardo esteban antonicelli
#'
#' @seealso \code{'\link{retrieve_seqs}'} \code{'\link{print_alignment}'}
#'   \code{'\link{clean_alignment}'} \code{'\link{load_alignment}'}
#'   \code{'\link{make_tree}'} \code{'\link{max_parsimony}'}
#'
#' @aliases \alias{max_likelihood}
#'
#' @examples
#' data(fastaRNA)
#' data(phylipProt)
#' mytree <- max_likelihood(fastaRNA, type=RNA, clustering=fastme.bal,
#'                         pml.model=GTR, clean=FALSE)
#' \dontrun{mytree <- max_likelihood(phylipProt, type=protein, pml.model=Blosum62,
#'                         outgroup=YP_0010399)}
#' \dontrun{plot.phylo(mytree, type='u')}
#'
#' @importFrom seqinr dist.alignment as.matrix.alignment
#' @importFrom ape as.alignment as.DNAbin dist.dna nj bionj fastme.bal
#'   fastme.ols root
#' @importFrom phangorn as.phyDat pml optim.pml
#'
#' @export
max_likelihood <- function(alignment, type, model=TN93, clustering=bionj, pml.model=NULL, outgroup=NULL, clean=TRUE){
                           seqtype <- deparse(substitute(type))
                           distmodel <- deparse(substitute(model))
                           pmlmodel <- deparse(substitute(pml.model))
                           if(pmlmodel=='NULL'){pmlmodel <- NULL}
                           out <- deparse(substitute(outgroup))
                           if(seqtype=='protein'){
                              matrix <- toupper(as.matrix.alignment(alignment))
                              if(clean==TRUE){
                                 na.posi <- which(apply(matrix, 2, function(e) any(!e %in% c('G', 'A', 'L', 'M', 'F',
                                                                                             'W', 'K', 'Q', 'E', 'S',
                                                                                             'P', 'V', 'I', 'C', 'Y',
                                                                                             'H', 'R', 'N', 'D', 'T'))))
                                 cleaned <- matrix[ , -na.posi]
                                 }
                              else{cleaned <- matrix
                                  }
                              phyDat <- as.phyDat(cleaned, type='AA')
                              mydist <- dist.alignment(as.alignment(cleaned))
                              }
                           else if(seqtype=='DNA'|| seqtype=='RNA'){
                                   if(class(alignment)[[1]]=='DNAbin'){DNAbin <- alignment}
                                   else{DNAbin <- as.DNAbin(alignment)}
                                   if(clean==TRUE){
                                      na.posi <- which(apply(as.character(DNAbin), 2, function(e) any(!e %in% c('a', 't', 'g', 'c'))))
                                      DNAbinclean <- DNAbin[ , -na.posi]
                                      }
                                   else{DNAbinclean <- DNAbin}
                                   phyDat <- as.phyDat(DNAbinclean)
                                   mydist <- dist.dna(DNAbinclean, model=distmodel)
                                   }
                           mytree <- eval(substitute(clustering(mydist)))
                           if(!is.null(pmlmodel) && pmlmodel=='all'){
                              my_tree <- list()
                              if(seqtype=='protein'){
                                 models <- c('WAG', 'JTT', 'LG', 'Dayhoff', 'cpREV',
                                             'mtmam', 'mtArt', 'MtZoa', 'mtREV24', 'VT',
                                             'RtREV', 'HIVw', 'HIVb', 'FLU', 'Blosum62',
                                             'Dayhoff_DCMut', 'JTT_DCMut')
                                 for(i in 1:length(models)){
                                     fitted <- pml(mytree, phyDat, k=4, model=models[[i]])
                                     optim <- optim.pml(fitted, optNni=TRUE, optGamma=TRUE, model=models[[i]])
                                     my_tree[[i]] <- optim
                                     names(my_tree)[[i]] <- models[[i]]
                                     }
                                 }
                              else if(seqtype=='DNA'|| seqtype=='RNA'){
                                      models <- c('JC', 'F81', 'K80', 'HKY', 'TrNe',
                                                  'TrN', 'TPM1', 'K81', 'TPM1u', 'TPM2',
                                                  'TPM2u', 'TPM3', 'TPM3u', 'TIM1e', 'TIM1',
                                                  'TIM2e', 'TIM2', 'TIM3e', 'TIM3', 'TVMe',
                                                  'TVM', 'SYM', 'GTR')
                                      for(i in 1:length(models)){
                                          fitted <- pml(mytree, phyDat, k=4, model=models[[i]])
                                          optim <- optim.pml(fitted, optNni=TRUE, optBf=TRUE, optQ=TRUE, optGamma=TRUE, model=models[[i]])
                                          my_tree[[i]] <- optim
                                          names(my_tree)[[i]] <- models[[i]]
                                          }
                                      }
                              }
                           else{fittedtree <- pml(mytree, phyDat, k=4, model=pmlmodel)
                                if(out=='NULL'){my_tree <- optim.pml(fittedtree, optNni=TRUE, optBf=TRUE, optGamma=TRUE, model=pmlmodel)
                                   }
                                else{fittedtree$tree <- root(fittedtree$tree, outgroup=out, r=TRUE)
                                     my_tree <- optim.pml(fittedtree, optNni=TRUE, optBf=TRUE, optGamma=TRUE, optRooted=TRUE, model=pmlmodel)
                                     }
                                }
                           return(my_tree)
                           }
