#! usr/bin/env julia

using ArgParse
using StringDistances
using DataFrames
using CSV
using Clustering
using MultivariateStats
using Plots

#set up command line arguments
s = ArgParseSettings()
@add_arg_table! s begin
"--Input"
        required = true
        help = ":("
"--Number"
        arg_type = Int
        default = 3
        help = ":("
"--Mdsplot"
        required = true
        help = ":("
end

parsed_args = parse_args(ARGS, s)

Input = parsed_args["Input"]
Number = parsed_args["Number"]
Mdsplot = parsed_args["Mdsplot"]

df = CSV.read(Input, header = false)

M = convert(Matrix, df)

n = length(M)

#empty matrix
D = zeros(n,n)

# Overlap coeffient measure
for i in 1:n
        for j in 1:n
                OverlapCoeff =  StringDistances.evaluate(Overlap(Number), M[i], M[j])
                global D[i,j] = OverlapCoeff
        end
end


mds = MultivariateStats.transform(fit(MDS, D, maxoutdim=2, distances=true))
#cluster
res = kmeans(mds, 4)
#plot mds
scatter(mds[1,:], mds[2,:], marker_z = res.assignments,
			color = :lightrainbow, legend = false)
png(Mdsplot)


