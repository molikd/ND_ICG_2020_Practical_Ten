#!/bin/bash
#$ -M bcoggins@nd.edu
#$ -m abe
#$ -pe smp 8
#$ -N BIOS60132_Practical_Ten

module load julia
julia mdsPlot.jl --Input sequences.txt --matx_out OverlapDist.csv --mds_out mds.png
