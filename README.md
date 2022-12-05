# Bacteria-Amplicon-Sequencing
A pipeline that encompasses the computational steps of 16S amplicon sequencing, starting from demultiplexed reads.

# Merging reads (merge_reads.sh)
This is a loop script that will merge forward and reverse reads from a set of samples. Create a file that includes your sample identifiers to run this script.

# Stripping primers (stripping_primers.sh)
This is a loop script that will remove primers that may be included in the output from the merging reads step. The samples file created will be used here as well.

# Run Statistics (stats.sh)
This is a script that will allow users to view some statistics on their dataset. If data is consistent with what users are expecting, the pipeline can be continued.

# Filter (filtering.sh)
This is a script that will filter out bad quality reads from the previous step. Parameters can be edited to satisfy user needs.

# Cluster (clustering.sh)
This is a script that can dereplicate, cluster, and remove chimeras. Certain steps can be commented out if unnecessary for user's purpose.
- De-noising step will provide zero-radius OTUs (zOTUs).
- Clustering will provide OTUs based on traditional 97% identity.
USEARCH is a program that is utilized for the de-noising nad clustering steps. For more information on these programs the following links can be used:
- UPARSE vs. UNOISE: http://www.drive5.com/usearch/manual/faq_uparse_or_unoise.html 
- otutab command: http://www.drive5.com/usearch/manual/cmd_otutab.html 
- Sample identifiers in read labels: http://www.drive5.com/usearch/manual/upp_labels_sample.html 
- Bugs and fixes for USEARCH v11: http://drive5.com/usearch/manual/bugs.html
- Technical support: http://drive5.com/usearch/manual/support.html 

# Mapping (mapping.sh)
This is a script that will create an OTU table that can be used for further downstream analysis. It utilizes the input from the merge reads step and aligns these reads back to the clustered OTUs or zOTUs.

# Taxonomy (taxonomy.sh)
This is a script that utilizes the SINTAX algorithm to create a taxonomy for the otus.fasta file created in the clustering step.

Combined, these steps should provide output files that can be utilized in a phyloseq object in R.
