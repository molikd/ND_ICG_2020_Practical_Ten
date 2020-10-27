#! usr/bin/env julia

#Script to generate distance matrix for
# input sequences and length
#Usage: julia ./plotDistanceMatrix.jl sequencesFile length outputTable outPlot
#Usage Ex: julia ./plotDistanceMatrix.jl sequences.txt 3 sequenceDistances.csv sequencePlot.png

#Add packages
#import Pkg
#Pkg.add("StringDistances")
#Pkg.add("DataFrames")
#Pkg.add("CSV")
#Pkg.add("MultivariateStats")
#Pkg.add("Clustering")
#Pkg.add("StatsPlots")
#Pkg.add("Plots")

#Ensure GR run-time is up-to-date, if necessary
#ENV["GRDIR"] = ""
#Pkg.build("GR")

#Load packages
println("Importing packages...")
using StringDistances
using DataFrames
using CSV
using MultivariateStats
using Clustering
using StatsPlots
using Plots

#Retrieve inputs
inputSeqs=ARGS[1]
inputLength=parse(Int, ARGS[2])
outputDist=ARGS[3]
inputClusters=ARGS[4]
outputPlot=ARGS[5]

#Read input sequences and convert to a matrix
seqsCSV=CSV.read(inputSeqs, header=false)
seqsMat=convert(Matrix, seqsCSV)

#Determine number of sequences
numSeqs=length(seqsMat)

#Initialize distance matrix
distMat=zeros(numSeqs,numSeqs)

#Loop over input sequences and compare each with all sequences
println("Calculating sequence distances...")
for i in 1:numSeqs
	for j in 1:numSeqs
		#Determine distance
		dist=StringDistances.evaluate(Overlap(inputLength), seqsMat[i], seqsMat[j])
		#Update distance matrix
		global distMat[i,j]=dist
	end
end

#Convert to dataframe and wite to csv
println("Writting matrix to CSV...")
distDF=DataFrame(distMat)
CSV.write(outputDist, distDF)

#Plot results of MDS with hierarchical clustering
println("Generating MDS plot...")
classicMDS=classical_mds(distMat, 4)
result=fuzzy_cmeans(classicMDS, inputClusters, 2)
#Generate scatter plot
scatter(numSeqs, numSeqs, marker_z=result.centers,color=:lightrainbow, legend=false)
plot(result)
png(outputPlot)
