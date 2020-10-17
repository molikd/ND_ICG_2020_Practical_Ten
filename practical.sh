#!/bin/bash
#$ -M sweaver4@nd.edu
#$ -m abe
#$ -N BIOS60132_Practical_Ten

#for use in the CRC, uncomment
#module load julia


#input is a text file of sequences, output is a png of the clustered (with kmeans) mds evaluaiton of distance matrix.
#specify number of clusters with "n_clusters", specify word length in distance calculation with "word_len"

julia juliascript.jl --input "sequences.txt" \
	--output "mds_cluster_plot_sdw" \
	--word_len 3 \
	--n_clusters 4
