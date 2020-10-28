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
using Plots
plotly()

#Retrieve inputs
inputSeqs=ARGS[1]
inputLength=parse(Int, ARGS[2])
outputDist=ARGS[3]
inputDims=parse(Int, ARGS[4])
inputClusters=parse(Int, ARGS[5])
outputPlot=ARGS[6]

#Read input sequences and convert to a matrix
seqsCSV=CSV.read(inputSeqs, DataFrame, header=false)
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
println("Clustering MDS results...")
inputFuzziness=inputClusters+1
classicMDS=MultivariateStats.transform(fit(MDS, distMat, maxoutdim=inputDims, distances=true))
result=fuzzy_cmeans(classicMDS, inputClusters, inputFuzziness)
#result=kmeans(classicMDS, inputClusters)
#Generate scatter plot
println("Generating plot and writing to PNG...")
Plots.scatter(classicMDS[1,:], classicMDS[2,:], marker_z=result.weights,color=:lightrainbow, legend=false)
Plots.png(outputPlot)
