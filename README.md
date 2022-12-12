# Bacteria-Amplicon-Sequencing
A pipeline that encompasses the computational steps of 16S amplicon sequencing, starting from demultiplexed reads.
The scripts in this pipeline were originally run on the Alabama supercomputer (https://www.asc.edu/) and thus might make reproducability difficult for users who do not utilize this system.
Scripts for this pipeline are grouped in a folder with the "samples.txt" file. The Alabama HPC utilizes a slurm queue system where jobs are submitted and run. The scripts being located in the same file along with the samples file helps run jobs in the queue more efficiently.

# Merging reads (merge_reads.sh)
This is a loop script that will merge forward and reverse reads from a set of samples. The file "samples.txt" includes sample identifiers to run this script. 

# Stripping primers (stripping_primers.sh)
This is a loop script that will remove primers that may be included in the output from the merging reads step. The "samples.txt" file will be used in this step as well.
Linked primers are used because the 300 bp demultiplexed reads likely span the entire amplicon, and it is expected that both primers might be in the forward and reverse reads. The primers used in this code are:
- 515F = GTGCCAGCMGCCGCGGTAA RC-515R = TTACCGCGGCKGCTGGCAC
- 806R = GGACTACHVGGGTWTCTAAT RC-806R = ATTAGAWACCCBDGTAGTCC

# Run Statistics (stats.sh)
This is a script that allows users to view some statistics on their dataset. If data is consistent with what users are expecting, the pipeline can be continued.

# Filter (filtering.sh)
This is a script that will filter out bad quality reads from the previous step. Parameters are set at an e-value of 0.5 and a length of 250bp. Parameters can be edited based on user needs.

# Cluster (clustering.sh)
This is a script that can dereplicate, cluster, and remove chimeras. Dereplication and clustering were performed from the original code. Denoising was commented out, but can be run if necessary for user's purpose.
- De-noising step will provide zero-radius OTUs (zOTUs).
- Clustering will provide OTUs based on traditional 97% identity.
- USEARCH is a program that is utilized for the de-noising and clustering steps. For more information on these programs the following links can be used:
- UPARSE vs. UNOISE: http://www.drive5.com/usearch/manual/faq_uparse_or_unoise.html 
- otutab command: http://www.drive5.com/usearch/manual/cmd_otutab.html 
- Sample identifiers in read labels: http://www.drive5.com/usearch/manual/upp_labels_sample.html 
- Bugs and fixes for USEARCH v11: http://drive5.com/usearch/manual/bugs.html
- Technical support: http://drive5.com/usearch/manual/support.html 

# Mapping (mapping.sh)
This is a script that will create an OTU table that can be used for further downstream analysis. It utilizes the input from the merge reads step and aligns these reads back to the clustered OTUs or zOTUs.

# Taxonomy (taxonomy.sh)
This is a script that utilizes the SINTAX algorithm to create a taxonomy for the otus.fasta file created in the clustering step. The SINTAX algorithm is used because it predicts taxonomy for marker genes like 16S.

#
Combined, these steps should provide output files that can be utilized in a phyloseq object in R.

# R Analysis
R analysis begins by creating a phyloseq object. After loading the dependencies, ensure that you have the following files:
- otu_table_16s.csv
- 16s_taxonomy.csv
- metadata2021.csv
- otus.fasta
