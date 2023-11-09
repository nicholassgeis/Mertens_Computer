using Combinatorics
using Distributions
coin = Bernoulli(0.5)

#Necessary functions

function sieve(n::Int64)
    S = fill(true,n); S[1] = false
    for p = 2:n
        if S[p]
            for m = p+p:p:n S[m]=false end
        end
    end
    return findall(S)
end

function contained_in_ordered_list(ordered_arr, numm)
    i = 1
    while i <= length(ordered_arr)
        if ordered_arr[i] > numm
            return false
        end
        if ordered_arr[i] == numm
            return true
        end
        i += 1
    end
    return false
end

function divisible_by_set(n, subset_of_primes)
    for p in subset_of_primes
         if n % p == 0
             return true
         end
     end
     return false
 end

function primes_less_than_z(z)
    i = 1
    while primes[i] <= z
        i += 1 
    end
    return primes[1:i-1]
end

function all_combination_products_less_than_z(z)
    return sort(append!([1], [prod(entry) for entry in combinations(primes_less_than_z(z)) if prod(entry) <= X]))
end

function end_points_for_intervals(arr_of_nums, z)
    return sort(append!([z], [Int64(floor(X/entry)) for entry in arr_of_nums]))
end

function intervals_from_arrays(arr_of_nums, arr_of_endpoints)
    arr_of_intervals = [[entry for entry in arr_of_nums if arr_of_endpoints[1] < entry <= arr_of_endpoints[2]]]
    for i in 2:length(arr_of_endpoints)-1
        append!(arr_of_intervals, [[entry for entry in arr_of_nums if arr_of_endpoints[i] < entry <= arr_of_endpoints[i+1]]])
    end
    return arr_of_intervals   
end

function not_divisible_by_prime_list(n, list_of_primes)
    for p in list_of_primes
        if n % p == 0
           return false 
        end
    end
    return true
end

function first_p_in_range(a, b, p)
    modulus = a % p
    if modulus == 0 && (a + p <= b)
        return a + p
    end
    position = (p - modulus)
    if a + position > b
        return 0
    else
        return a + position
    end
end

function indices_for_nonzero_entries_in_array(arr)
    i = 1
    while arr[i] == 0
        i += 1 
        if i > length(arr) break end
    end
    if i > length(arr) return "all 0 array" end
    index_arr = [i]
    if i == length(arr) return index_arr end
    for j in i+1:length(arr)
        if arr[j] != 0 append!(index_arr, j) end 
    end
    return index_arr
end

function dictionary_of_relevant_intervals_for_primes(set_of_endpoints = end_points, set_of_primes = primes)
    main_dict = Dict();
    for p in set_of_primes
   	main_dict[p] =  [first_p_in_range(set_of_endpoints[i], set_of_endpoints[i+1], p):p:set_of_endpoints[i+1] for i in 1:length(set_of_endpoints)-1 ]
    end
    return main_dict
end

function list_of_numbers_not_divisible_by_primes_less_than_z(z)
    p_lst = primes_less_than_z(z)
    return [i for i in 1:X if not_divisible_by_prime_list(i, p_lst)]
end

function values_for_M1(arr)
    M1 = 0
    for i in conditional_on_small_primes
       M1 += arr[i] 
    end
    values = [M1]
    for j in 0:length(conditional_on_small_primes) - 2
        append!(values, [values[length(values)] - arr[conditional_on_small_primes[length(conditional_on_small_primes) - j]]])
    end
    return values
end

#Wintner function constructor related functions

function array_maker(n = X, list_of_primes = primes)
    S = fill(Int8(1),n);
    sq_primes = [p^2 for p in list_of_primes if p^2 <= n]
    for sq_p in sq_primes
        for sq_pos in sq_p:sq_p:n
            S[sq_pos] = 0
        end
    end
    return S 
end

function wintner_data_on_primes(sample_coin = coin, set_of_primes = primes)
    return [p for p in primes if rand(coin)]
end

#Naive builder

function wintner_function(subset_of_primes::Vector{Int64}, arr = abs.(main_arr), n = X)
    for p in subset_of_primes
        for position = p:p:n
            arr[position] *= (Int8(-1))
        end      
    end
    return arr    
end

#Halasz sieve computer

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

function relevant_primes_from_subset(subset_of_primes,
                                     cut_off = z)
    i = 1
    while subset_of_primes[i] <= cut_off
        i += 1
    end
    return subset_of_primes[i:length(subset_of_primes)]
end

function set_up_sum_star_terms(subset_of_primes,
                               arr,
                               arr_of_nonzero_indices,
                               list_of_sieve_primes = list_of_small_primes,
                               n = X,
                               dictionary_of_intervals = dictionary_of_prime_intervals)
    for p in subset_of_primes
        for index in arr_of_nonzero_indices
            for pos in dictionary_of_intervals[p][index]
		if pos == 0 continue end
                arr[pos] *= Int8(-1)
           end
        end
    end
    return arr
end

function sum_of_value_array_by_position_array(arr_of_values, arr_of_positions)
    partial_sum = 0
    for entry in arr_of_positions
        partial_sum += arr_of_values[entry] 
    end
    return partial_sum
end

function final_summation_loop(arr_of_scalars,
                              arr_of_values,
                              arr_of_intervals = relevant_intervals,
                              n = number_of_intervals)
    total_sum = arr_of_scalars[1] 
    for i in 1:n
        if arr_of_scalars[i]==0
            continue
        end 
        total_sum += sum_of_value_array_by_position_array(arr_of_values, arr_of_intervals[i])*arr_of_scalars[i]  
    end
    return total_sum
end

function sieve_computation(subset_of_primes, 
                           arr = abs.(main_arr), 
                           list_of_sieve_primes = list_of_small_primes,
                           conditioned_numbers = conditional_on_small_primes,
                           set_of_intervals = relevant_intervals,
                           dictionary_of_intervals = dictionary_of_prime_intervals,
                           n = X)
    #Set up M_1(x) part of the identity
    arr = set_up_M1_terms(subset_of_primes, arr)
    
    #Compute M_1(x) values
    M1_values = values_for_M1(arr)
    non_zero_M1_values = indices_for_nonzero_entries_in_array(M1_values)
    
    #Computes the relevant values for rest of array (in the intervals where M1(x_k) are non-zero)
    arr = set_up_sum_star_terms(subset_of_primes, arr, non_zero_M1_values)
 
    #Numerical computes the Mertens's value up to X using Halasz identity
    return final_summation_loop(M1_values, arr) 
end

println("Please enter to which power of 10 you want to computer up to:")
power = readline()
X = 10^parse(Int64, power);
sieve(15);
primes = sieve(X);
main_arr = array_maker();

println("Please enter the largest prime that you want to sieve up to:")
zed = readline();
z = parse(Int64, zed);
list_of_small_primes = primes_less_than_z(z);
conditional_on_small_primes = all_combination_products_less_than_z(z);
end_points = end_points_for_intervals(conditional_on_small_primes, z);
dictionary_of_prime_intervals = dictionary_of_relevant_intervals_for_primes();
relevant_intervals = intervals_from_arrays(list_of_numbers_not_divisible_by_primes_less_than_z(z), end_points)
number_of_intervals = length(relevant_intervals)
asdfdsaqweragasdf = true