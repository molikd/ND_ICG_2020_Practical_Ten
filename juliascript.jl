#! usr/bin/env julia

#lines 37 through 72 are modified from my practical 4 script

println("loading packages...")
using StringDistances
using CSV
using DataFrames
using MultivariateStats
using Plots
using Clustering
using ArgParse


println("parsing arguments...")
#Parse arguments
s = ArgParseSettings()
@add_arg_table! s begin
	"--input"
		help = "an input text file of sequences to compare"
		required = true
	"--word_len"
		help = "length of work in Jaccard calculation"
		arg_type = Int
		default = 3
	"--output"
		help = "name for png file of plot"
		required = true
	"--n_clusters"
		help = "number of clusters"
		arg_type = Int
		default = 2
end

parsed_args = parse_args(ARGS, s)


#set arguments as variables
input_file = parsed_args["input"]
output_file = parsed_args["output"]
word_length = parsed_args["word_len"]
n_clust = parsed_args["n_clusters"]


#import data text file
println("reading in text file...")
df = CSV.read(input_file)
matx = convert(Matrix, df)

#get the number of sequences 
n = length(matx)

#create a distance matrix of zeros to be filled
dist_matx = zeros(n,n)


#loop through each sequence and compare it to each other sequence, store results in matrix
println("creating distance matrix...")
for i in 1:n
	for j in 1:n
		Jac_dist = compare(matx[i], matx[j], Jaccard(word_length))
		global dist_matx[i,j] = Jac_dist
	end
end

#turn into distance matrix (as opposed to similarities matrix)
for i in 1:n
	for j in 1:n
		value = 1-dist_matx[i,j]
		dist_matx[i,j] = value
	end
end


#run mds on the distance matrix with 2 dimensions
println("running mds...")
mds = classical_mds(dist_matx, 2)


#kmeans cluster
println("clustering with kmeans...")
results = kmeans(mds, n_clust)

#plot with plot
println("plotting...")
scatter(mds[1,:], mds[2,:], marker_z = results.assignments,
			color = :lightrainbow, legend = false)

png(output_file)

println(string("plot saved as ", output_file, ".png"))
