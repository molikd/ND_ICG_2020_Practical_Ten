#!/bin/bash
#$ -M msievert@nd.edu
#$ -m abe
#$ -pe smp 8
#$ -N pac10

module load julia

julia ./mds.jl --Input sequences.txt --Number 3 --Mdsplot mdsplot.csv

