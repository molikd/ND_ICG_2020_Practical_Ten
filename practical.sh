#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -N BIOS60132_Practical_Ten

#Load julia module
module load julia/1.4.1

#Set inputs
inputSeqs="sequences.txt"
inputLength=3
outputDist="sequenceDistances.csv"
inputClusters=4
outputPlot="sequencePlot.png"

#Run julia script to plot generated distance matrix
julia ./plotDistanceMatrix.jl $inputSeqs $inputLength $outputDist $inputClusters $outputPlot
