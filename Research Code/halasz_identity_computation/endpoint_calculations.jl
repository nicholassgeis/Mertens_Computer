using Combinatorics

#Computes the list of all possible squarefree products of primes
#less than an integer z.
function all_combination_products_less_than_z(cutoff = z, n = X, prime_set = primes)
    return sort(append!([1], [prod(entry) for entry in combinations(view(prime_set, 1:cutoff)) if 0 < prod(entry) <= n]))
end

function end_points_for_intervals(cutoff = z, n = X)
    return sort(append!([cutoff], [Int64(floor(n/entry)) for entry in all_combination_products_less_than_z(cutoff, n)]))
end

#Compute the position of the endpoints in the nonzero array (main_array) and also find
#which M1(x) value corresponds to each interval (as some intervals have zero elements in them).
function interval_data(cutoff = z)
    bool_array = utility_array(cutoff)
    small_array = findall(bool_array)
    set_of_endpoints = end_points_for_intervals(cutoff)
    data = Vector{Int32}[]

    for index in 2:length(set_of_endpoints)
        if set_of_endpoints[index] <= cutoff continue end
        if set_of_endpoints[index] > set_of_endpoints[index - 1]

            first_true = find_first_true(bool_array, [set_of_endpoints[index-1], set_of_endpoints[index]])
            last_true = find_last_true(bool_array, [set_of_endpoints[index-1], set_of_endpoints[index]])

            if first_true == 0
                continue
            else
                append!(data, [[Int32(index)-1, Int32(searchsortedfirst(small_array, first_true)), Int32(searchsortedfirst(small_array, last_true))]])
            end
        end
    end
    return data
end

function find_first_true(arr, interval)
    hold = 0
    for pos in interval[1]+1:interval[2]
        if arr[pos] 
            hold = pos
            break
        end      
    end
    return hold
end

function find_last_true(arr, interval)
    hold = 0
    for i in 0:(interval[2] - interval[1] - 1)
        if arr[interval[2]-i]
            hold = interval[2]-i
            break
        end
    end
    return hold
end
