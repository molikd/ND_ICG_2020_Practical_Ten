#!/bin/bash
#$ -M sweaver4@nd.edu
#$ -m abe
#$ -N BIOS60132_Practical_Ten

#for use in the CRC, uncomment
#module load julia


#input is a text file of sequences (one per line), output is csv file of the distance matrix
#word_len is the wordlength in the Jaccard distance calculation
#Each row and column in the matrix corresponds to one of the sequences in the input file

julia juliascript.jl --input "sequences.txt" \
	--output "mds_cluster_plot_sdw" \
	--word_len 3 \
	--n_clusters 4