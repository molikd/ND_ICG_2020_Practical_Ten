#!usr/bin/env julia 

import Pkg
Pkg.add("ArgParse")
using ArgParse
using DataFrames
using MultivariateStats
function parse_commandline()


s = ArgParseSettings()
@add_arg_table s begin
        "--opt1"
                help = "input file" 

        "--opt2"
                help = "output file"
end

return parse_args(s)
end

files = parse_commandline()

Pkg.add("StringDistances") 
Pkg.add("CSV")
using StringDistances 
using CSV

df = CSV.read(files["opt1"], header = false)

matrix = convert(Matrix,df)
n = length(matrix)
println(n)
mat = zeros(n,n)

for i = 1:n
	for j = 1:n 
		m = StringDistances.evaluate(Levenshtein(),matrix[i],matrix[j])
		global mat[j,i] = m
	end 
end 
Pkg.add("Plots")
using Plots 

C = classical_mds(mat,2)
Pkg.add("Clustering")
using Clustering
D = kmeans(C,2)

scatter(C[1,:], C[2,:], marker_z=D.assignments,
        color=:lightrainbow, legend=false)

png("output.png") 

