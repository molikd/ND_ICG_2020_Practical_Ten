#! usr/bin/env julia 
import Pkg 
Pkg.add("MultivariateStats")
using CSV 
using DataFrames
using MultivariateStats 
Pkg.add("ArgParse")
using ArgParse

function parse_commandline()


s = ArgParseSettings()
@add_arg_table s begin
        "--opt1"
                help = "input file"
	"--opt2" 
		help = "output file name"

end

return parse_args(s)
end

files = parse_commandline()

A = CSV.read("sequences.txt")

B = convert(Matrix,A)
E = convert(AbstractArray{Int64,2},B)
println(size(E))


C = classical_mds(E)
D = kmeans(C,2)

scatter(D[1,:], D[2,:], marker_z=B.assignments,
        color=:lightrainbow, legend=false)

png("output.png")
