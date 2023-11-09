using Distributions
using Combinatorics
coin = Bernoulli(0.5)

function array_maker(n, prime_set = primes)
    S = fill(Int8(1),n)
    for p in prime_set
        for sq_pos in p^2:p^2:n
            S[sq_pos] = 0
        end
    end
    return S
end

function rademacher_data(sample_coin = coin, prime_set = primes)
    return findall(rand(sample_coin, length(prime_set)))
end

function rademacher_function(index_set, n, arr, prime_set = primes)
    for i in index_set
        for pos = prime_set[i]:prime_set[i]:n
            arr[pos] *= (Int8(-1))
        end      
    end
    return arr    
end

#Creates a list of primes up to an integer n.
function sieve(n::Int64)
    S = fill(true,n); S[1] = false
    for p = 2:n
        if S[p]
            for m = p+p:p:n S[m]=false end
        end
    end
    return findall(S)
end

function index_less_than_z(arr, z)
    index = 1
    while arr[index] <= z
        index += 1
        if index > length(arr) break end
    end
    if index > length(arr) return 0 else return index-1 end
end

function all_combinations(largest_index)
    return append!([[]], [entry for entry in combinations(1:largest_index)])
end

function return_percentage_to_a(t, a, prime_list = primes)
    largest_i = index_less_than_z(prime_list, t)
    sample_space = all_combinations(largest_i)

    main_arr = array_maker(t)

    count = 0
    for func in sample_space
        if sum(rademacher_function(func, t, abs.(main_arr))) == a count += 1 end
    end
    return count/length(sample_space)
end

function return_percentage_to_a2(t, a, prime_list = primes)
    largest_i = index_less_than_z(prime_list, t)
    main_arr = array_maker(t)

    count = 0
    number_of_funcs = 1
    for func in combinations(1:largest_i)
        if sum(rademacher_function(func, t, abs.(main_arr))) == a count += 1 end
        number_of_funcs += 1
    end
    return count/number_of_funcs
end

function is_squarefree(n, prime_set = primes)
    for p in prime_set
        if p^2 > n break end
        if n % p^2 == 0 return false end
    end
    return true
end

function percentage_range_calc(a, b, data_arr) 
    for i in a:b
        if is_squarefree(i)
            append!(data_arr, [(i, return_percentage_to_a2(i, 0))])
        end
    end
    return data_arr
end

function percentage_range_calc2(a, b, data_arr) 
    for i in a:b
        if !(is_squarefree(i)) 
            append!(data_arr, [(i, data_arr[i-2][2])])
        else
            append!(data_arr, [(i, return_percentage_to_a2(i, 0))])
        end
    end
    return data_arr
end

function sample_percentage_at_a(t, a, num_of_samples, arr, sample_coin = coin, prime_list = primes)
    largest_i = index_less_than_z(prime_list, t)
    count = 0

    if largest_i <= log2(num_of_samples)
        for func in combinations(1:largest_i)
            if sum(rademacher_function(func, t, abs.(arr))) == a count += 1 end
        end
        return count/2^largest_i
    else
        for sample in 1:num_of_samples
            if sum(rademacher_function(findall(rand(sample_coin, largest_i)), t, abs.(arr))) == a count += 1 end
        end
        return count/num_of_samples
    end
end

function sampled_range_calc(a, b, num_of_samples, data_arr)
    for i in a:b
        if !(is_squarefree(i)) continue end

        if data_arr[end][2] == 0
            main_arr = array_maker(i)
            append!(data_arr, [(i, sample_percentage_at_a(i, 0, num_of_samples, main_arr))])
        else
            append!(data_arr, [(i, 0.0)])
        end
    end
    return data_arr
end
