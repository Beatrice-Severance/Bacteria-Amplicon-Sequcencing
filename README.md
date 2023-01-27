# Bacteria-Amplicon-Sequencing
A pipeline that encompasses the computational steps of 16S amplicon sequencing, starting from demultiplexed reads.
The scripts in this pipeline were originally run on the [Alabama supercomputer](https://www.asc.edu/) and thus might make reproducibility difficult for users who do not utilize this system.
Scripts for this pipeline are grouped in a folder along with the "samples.txt" file. The Alabama HPC utilizes a slurm queue system where jobs are submitted and run. The scripts being located in the same file along with the samples file helps run jobs in the queue more efficiently.

# Merging reads ([merge_reads.sh](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/Scripts/merge_reads.sh))
This is a loop script that will merge forward and reverse reads from a set of samples. The file "samples.txt" includes sample identifiers to run this script. 

# Stripping primers ([stripping_primers.sh](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/Scripts/stripping_primers.sh))
This is a loop script that will remove primers that may be included in the output from the merging reads step. The "samples.txt" file will be used in this step as well.
Linked primers are used because the 300 bp demultiplexed reads likely span the entire amplicon, and it is expected that both primers might be in the forward and reverse reads. The primers used in this code are:
- 515F = GTGCCAGCMGCCGCGGTAA RC-515R = TTACCGCGGCKGCTGGCAC
- 806R = GGACTACHVGGGTWTCTAAT RC-806R = ATTAGAWACCCBDGTAGTCC

# Run Statistics ([stats.sh](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/Scripts/stats.sh))
This is a script that allows users to view some statistics on their dataset. If data is consistent with what users are expecting, the pipeline can be continued.

# Filter ([filtering.sh](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/Scripts/filtering.sh))
This is a script that will filter out bad quality reads from the previous step. Parameters are set at an e-value of 0.5 and a length of 250bp. Parameters can be edited based on user needs.

# Cluster ([clustering.sh](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/Scripts/clustering.sh))
This is a script that can dereplicate, cluster, and remove chimeras. Dereplication and clustering were performed from the original code. Denoising was commented out, but can be run if necessary for user's purpose.
- De-noising step will provide zero-radius OTUs (zOTUs).
- Clustering will provide OTUs based on traditional 97% identity.
- USEARCH is a program that is utilized for the de-noising and clustering steps. For more information on these programs the following links can be used:
- [UPARSE vs. UNOISE](http://www.drive5.com/usearch/manual/faq_uparse_or_unoise.html)
- [otutab command](http://www.drive5.com/usearch/manual/cmd_otutab.html)
- [Sample identifiers in read labels](http://www.drive5.com/usearch/manual/upp_labels_sample.html)
- [Bugs and fixes for USEARCH v11](http://drive5.com/usearch/manual/bugs.html)
- [Technical support](http://drive5.com/usearch/manual/support.html) 

# Mapping ([mapping.sh](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/Scripts/mapping.sh))
This is a script that will create an OTU table that can be used for further downstream analysis. It utilizes the input from the merge reads step and aligns these reads back to the clustered OTUs or zOTUs.

# Taxonomy ([taxonomy.sh](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/Scripts/taxonomy.sh))
This is a script that utilizes the SINTAX algorithm to create a taxonomy for the otus.fasta file created in the clustering step. The SINTAX algorithm is used because it predicts taxonomy for marker genes like 16S.

#
Combined, these steps should provide output files that can be utilized in a phyloseq object in R.

# R Analysis
R analysis begins by creating a phyloseq object. Before beginning, ensure that you have the following files downloaded and in an appropriate directory so that R can utilize them:
- [otu_table_16s.csv](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/phyloseq_input/otu_table_16s.csv)
- [16s_taxonomy.csv](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/phyloseq_input/16s_taxonomy.csv)
- [metadata2021.csv](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/phyloseq_input/metadata2021.csv)
- [otus.fasta](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/phyloseq_input/otus.fasta)

The R markdown file ([Phyloseq_Analysis.Rmd](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/Scripts/Phyloseq_Analysis.Rmd)) will execute the following steps:
- Load Dependencies
- Utilize a colorblind palette
- Load the above files to create a phyloseq object
- Remove mitrochondria, chloroplasts, or taxa not assigned at domain level
- Decontaminate the data
- Provide read distribution for the dataset (including a histogram)
- Rarefaction analysis (including line graphs)
- Alpha diversity analysis, including "richness over time" and "richness over treatment" plots
- Cumulative sum scaling (CSS) Normalization
- Beta diversity analysis, including a principal coordinates analysis (PCoA) plot with Bray-Curtis distances and a detrended correspondence analysis (DCA, to eliminate time as a factor)
- PERMANOVA to test for differences in centroids
