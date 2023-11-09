include("number_theory_functions.jl")
include("M1_computer.jl")
include("remaining_terms_computer.jl")
include("endpoint_calculations.jl")
include("halasz_algorithm.jl")

#For testing purposes
include("naive_steinhaus_function.jl")

#Precomputation of functions so they are compiled before larger computation
X = 10^2
z = 2
primes = prime_sieve(X)
M1_array = M1_array_maker()
M1_position_dict = M1_array_positions_dict()
endpoint_data = interval_data()
main_array = main_array_maker()
main_position_dict = main_position_dictionary_maker()
naive_main_arr = array_maker()

#Input functions
println("Please enter to which power of 10 you want to compute up to:")
power = readline()
X = 10^parse(Int64, power)
primes = prime_sieve(X)

println("Please enter the number of primes that you want to sieve by:")
zed = readline()
z = parse(Int64, zed)

#Precomputed data for M1(x) computations
M1_array = M1_array_maker()
M1_position_dict = M1_array_positions_dict()

#Precomputed data for final endpoint calculation
endpoint_data = interval_data()

#Precomputed data for remaining computations
main_array = main_array_maker()
main_position_dict = main_position_dictionary_maker()

#Precomputations for naive calculation
naive_main_arr = array_maker()
