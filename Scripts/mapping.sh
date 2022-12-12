#!/bin/bash

# First use seqtk to convert all the merged reads into fasta on a loop.
# Use samples.txt like we did for cutadapt

# Load the modules
module load gcc/11.2.0
module load seqtk/1.3-olt7cls

mkdir /scratch/aubbxs/noel_files/EVSMITH/workflow/mapped

for sample in $(cat samples.txt)
do

    echo "On sample: $sample"
    seqtk seq -a /home/aubbxs/noel_shared/merged/${sample}*.fastq > /home/aubbxs/noel_shared/merged/${sample}.fasta

#    # have to replace the beginning of the fasta headers with the file name for mapping. Otherwise we get one sample with all the read counts, which is not what we want.
#    # We use awk to append the filename at the beginning of each fasta sequence after the >, then we pipe it to sed to replace the underscore with a period.

    awk '/>/{sub(">","&"FILENAME":");sub(/\.fasta/,x)}1' /home/aubbxs/noel_shared/merged/${sample}.fasta > /home/aubbxs/noel_shared/merged/${sample}_new.fasta

done

# have to create one file containing all the reads from the demultiplexed reads
cat /scratch/aubbxs/noel_files/EVSMITH/workflow/merged/*_new.fasta > /scratch/aubbxs/noel_files/EVSMITH/workflow/merged/merged_new1.fasta
#
awk '{gsub("/home/aubbxs/noel_shared/merged/",""); print}' merged_new1.fasta | sed '/^>/s/_/\ /g' > merged_new2.fasta
#
# align the demultiplexed reads back to the now clustered OTUs or ZOTUs (ESV)
module load vsearch
vsearch -usearch_global /home/aubbxs/noel_shared/merged/merged_new2.fasta -db /home/aubbxs/noel_shared/otus.fasta -strand plus -id 0.97 -otutabout /home/aubbxs/noel_shared/otu_table_16s.txt
