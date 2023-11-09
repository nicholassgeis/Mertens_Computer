using Combinatorics

function M1_array_maker(cutoff = z, n = X, prime_set = primes)
    len = length(append!([1], [prod(entry) for entry in combinations(view(prime_set, 1:cutoff)) if 0 < prod(entry) <= n]))
    return fill(Int8(1), len)
end

function M1_array_positions_dict(cutoff = z, n = X, prime_set = primes)
    dict = Dict{Int8, Vector{Int32}}()
    set_of_nums = sort(append!([1], [prod(entry) for entry in combinations(view(prime_set, 1:cutoff)) if 0 < prod(entry) <= n]))
    for i in 1:cutoff
        places = Int32[]
        for j in eachindex(set_of_nums)
            if set_of_nums[j] % prime_set[i] == 0 append!(places, [Int32(j)]) end
        end
        dict[Int8(i)] = places
    end
    return dict
end

function conditional_values(index_set, cutoff = z, arr = abs.(M1_array), pos_dict = M1_position_dict)
    for i in index_set
        if i > cutoff break end
        for j in pos_dict[i] arr[j] *= Int8(-1) end
    end
    values = [sum(arr)]
    for j in 0:length(arr)-2
        append!(values, [values[length(values)] - arr[length(arr)-j]])
    end
    return values
end

function set_up_M1_terms(subset_of_primes,
                         arr,
                         list_of_sieve_primes = list_of_small_primes,
                         conditioned_numbers = conditional_on_small_primes)
    for p in list_of_sieve_primes
        if !(contained_in_ordered_list(subset_of_primes, p))
            continue
        end
        for i in p:p:conditioned_numbers[length(conditioned_numbers)]
            arr[i] *= Int8(-1)
        end
    end
    return arr
end
