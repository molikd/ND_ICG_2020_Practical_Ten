#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -N BIOS60132_Practical_Ten

#Load julia module
module load julia

#Run julia script to plot generated distance matrix
julia ./plotDistanceMatrix.jl sequences.txt 3 sequenceDistances.csv sequencePlot.png
