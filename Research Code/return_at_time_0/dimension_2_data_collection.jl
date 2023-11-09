using Distributions
using Combinatorics

function sieve(n)
    S = fill(true, n); S[1] = false
    for p = 2:n
        if S[p]
            for m = p+p:p:n S[m]=false end
        end
    end
    return findall(S)
end

function roots_of_unity(n)
    return map(cispi, range(0, 2, length=n+1))[1:end-1]
end

function rv_and_steps(n)
    return (DiscreteUniform(1, n), roots_of_unity(n))
end

function fp(sample_coin = coin, values = steps)
    return values[rand(sample_coin)]
end

#arr must be ordered for function to return correct index
function index_less_than_z(arr, z)
    if arr[end] <= z
        return length(arr)
    end
    for i in eachindex(arr)
        if arr[i] > z
            return i - 1
        end
    end
    return 0
end

function fp_data(n, set_of_primes = primes)
    largest_p = index_less_than_z(set_of_primes, n)
    return [fp() for i in 1:largest_p] 
end

function array_maker(n, set_of_primes = primes)
    S = fill(ComplexF64(1, 0), n)
    upper_bound = sqrt(n)
    for i in eachindex(set_of_primes)
        if set_of_primes[i] > upper_bound break end
        for pos in set_of_primes[i]^2 : set_of_primes[i]^2 : n
            S[pos] = ComplexF64(0,0)
        end
    end
    return S
end

function dim2_rademacher(data_arr, working_arr, prime_set = primes)
    for i in eachindex(data_arr)
        if data_arr[i] == ComplexF64(1, 0) continue end
        for pos in prime_set[i]:prime_set[i]:length(working_arr)
            working_arr[pos] *= data_arr[i]
        end
    end
end

function abs!(arr)
    for i in eachindex(arr)
        if arr[i] == ComplexF64(1, 0) continue end
        arr[i] = abs(arr[i])
    end
end

function return_to_val_at_time_t(t, val, num_of_samples, threshold = 1/1000, prime_set = primes, step_set = steps)
    largest_p = index_less_than_z(prime_set, t)
    
    #Checks that the sample space is smaller than the number of samples
    if log(length(step_set), num_of_samples) >= largest_p
        count = 0
        main_arr = array_maker(t)
        for p_data in Combinations(step_set, largest_p)
            abs!(main_arr)
            dim2_rademacher(p_data, main_arr)
            if abs(sum(view(main_arr, 2:t)) - val) <= threshold  count += 1 end
        end
        return count/(length(step_set)^largest_p)
    end

    #Case when the sample space is too large to completely compute.
    count = 0
    main_arr = array_maker(t)
    for sample in 1:num_of_samples
        abs!(main_arr)
        dim2_rademacher(fp_data(t), main_arr)
        if sum(view(main_arr, 2:t)) == val count += 1 end
    end
    return count/num_of_samples
end

function squarefree_number(a, prime_set = primes)
    for p in prime_set
        if p^2 > a break end
        if a % p^2 == 0 return false end
    end
    return true
end

function range_return_calcuation(a, b, val, num_of_samples, data_list)
    for num in a:b
        if !squarefree_number(num) continue end
        if data_list[end][2] != 0.0
            append!(data_list, [(num, 0.0)])
        else
            append!(data_list, [(num, return_to_val_at_time_t(num, val, num_of_samples))])
        end
    end
end

function complete_return_to_val_at_time_t(t, threshold, prime_set = primes, step_set = steps)
    largest_p = index_less_than_z(prime_set, t)
    count = 0
    main_arr = array_maker(t)
    for p_data in Combinations(step_set, largest_p)
        abs!(main_arr)
        dim2_rademacher(p_data, main_arr)
        if abs(sum(view(main_arr, 2:t))) < threshold count += 1 end
    end
    return count/(length(step_set)^largest_p)
end

function complete_range_return_calcuation(a, b, val, data_list)
    for num in a:b
        if !squarefree_number(num) continue end
        if data_list[end][2] != 0.0
            append!(data_list, [(num, 0.0)])
        else
            append!(data_list, [(num, complete_return_to_val_at_time_t(num, val))])
        end
    end
end

function complete_data_return_to_val_at_time_t(t, prime_set = primes, step_set = steps)
    largest_p = index_less_than_z(prime_set, t)
    main_arr = array_maker(t)
    val_arr = []
    for p_data in Combinations(step_set, largest_p)
        abs!(main_arr)
        dim2_rademacher(p_data, main_arr)
        append!(val_arr, [sum(view(main_arr, 2:t))])
    end
    return val_arr
end

function star_complete_range_return_calcuation(a, b, val, data_list)
    for num in a:b
        if !squarefree_number(num) continue end
        if data_list[end][2] != 0.0
            append!(data_list, [(num, 0.0)])
        else
            append!(data_list, [(num, complete_return_to_val_at_time_t(num, val))])
        end
    end
end

function powers_calcuation(arr)
    return [-log(entry[1], entry[2]) for entry in arr]
end



#Builds Cartesian powers of vectors
#Found here: https://discourse.julialang.org/t/cleanest-way-to-generate-all-combinations-of-n-arrays/20127/6
import Base.iterate, Base.length
struct Combinations{T}
    itr::Vector{T}
    count::Int64
    itrsize::Int64
    function Combinations(itr::Vector{T},count::Int) where T
        new{T}(itr,Int64(count),length(itr))
    end
end

function iterate(c::Combinations,state::Int64=0)
    if state>=length(c)
        return nothing
    end
    indices=digits(state,base=c.itrsize,pad=c.count)
    [c.itr[i] for i in (indices .+1)],state+1
end

function length(c::Combinations)
    length(c.itr) ^ c.count
end
