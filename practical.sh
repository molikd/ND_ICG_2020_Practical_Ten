#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -N BIOS60132_Practical_Ten

#Load julia module
module load julia

#Set inputs
inputSeqs="sequences.txt"
inputLength=3
outputDist="sequenceDistances.csv"
inputDims=2
inputClusters=4
outputPlot="sequencePlot.png"

#Run julia script to plot generated distance matrix
julia ./plotDistanceMatrix.jl $inputSeqs $inputLength $outputDist $inputDims $inputClusters $outputPlot
