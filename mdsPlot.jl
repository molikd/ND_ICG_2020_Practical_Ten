#! usr/bin/env julia

#load packages
using ArgParse, StringDistances, DataFrames, CSV, MultivariateStats, Clustering, Plots
using CSV

#set up command line arguments
s = ArgParseSettings()
@add_arg_table! s begin
"--Input"
	required = true
	help = "specify single file with multiple sequences"
"--Substring"
	arg_type = Int
	default = 3
	help = "length of substrings being compared per sequence, default is 3"
"--matx_out"
	required = true
	help = "filename for distance matrix csv"
"--clusters"
	arg_type = Int
	default = 2
	help = "number of clusters"
"--mds_out" 
	required = true
	help = "filename to save plot png"
end

parsed_args = parse_args(ARGS, s)

Input = parsed_args["Input"]
Substring = parsed_args["Substring"]
matx_out = parsed_args["matx_out"]
clusters = parsed_args["clusters"]
mds_out = parsed_args["mds_out"]
#load input file
df = CSV.read(Input, header = false)
#create 1xn matrix
M = convert(Matrix, df)
#count number of rows
n = length(M)
#make matrix nxn
DM = zeros(n,n)
#pairwise comparison of each string using Overlap coeffient
for i in 1:n
	for j in 1:n
		OverlapCoeff = StringDistances.evaluate(Overlap(Substring), M[i], M[j])
		global DM[i,j] = OverlapCoeff
	end
end
#convert back to dataframe
DM_df = DataFrame(DM)
#create output csv
CSV.write(matx_out, DM_df)


#Plot results of MDS with hclust
mds = MultivariateStats.transform(fit(MDS, DM, maxoutdim=2, distances=true))
#cluster with kmeans, user defined k
res = kmeans(mds, clusters)
#plot mds, clustered by kmeans
scatter(mds[1,:], mds[2,:], marker_z = res.assignments,
			color = :lightrainbow, legend = false)
png(mds_out)
