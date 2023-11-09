#This boolean array contains the information where for index i is false if every prime that divides i is <= cutoff
#or if i is not squarefree. Otherwise, index i is marked true.
function utility_array(cutoff = z, n = X, prime_set = primes)
    S = fill(true, n)
    for i in 1:cutoff
        S[i] = false
    end
    for p in prime_set
        for pos in p^2:p^2:n
            S[pos] = false
        end
    end
    for i in 1:cutoff
        for pos in prime_set[i]:prime_set[i]:n
            S[pos] = false
        end
    end
    return S
end

function main_array_maker(cutoff = z)
    return fill(Int8(1), length(findall(utility_array(cutoff))))
end

function main_position_dictionary_maker(cutoff = z, n = X, prime_set = primes, end_data = endpoint_data)
    dict = Dict{Int32, Vector{Vector{Int32}}}()
    bool_array = utility_array(cutoff)
    small_array = findall(bool_array)
    for i in cutoff+1:length(prime_set)
        places = Int32[]
        for j in prime_set[i]:prime_set[i]:n
            if bool_array[j] append!(places, [Int32(searchsortedfirst(small_array, j))]) end
        end
        dict[Int32(i)] = array_breaker(places, [entry[3] for entry in end_data])
    end
    return dict
end

function working_main_position_dictionary_maker(cutoff = z, n = X, prime_set = primes, end_data = endpoint_data)
    dict = Dict{Int32, Vector{Int32}}()
    bool_array = utility_array(cutoff)
    small_array = findall(bool_array)
    for i in cutoff+1:length(prime_set)
        places = Int32[]
        for j in prime_set[i]:prime_set[i]:n
            if bool_array[j] append!(places, [Int32(searchsortedfirst(small_array, j))]) end
        end
        dict[Int32(i)] = places
    end
    return dict
end

function array_breaker(sorted_array, break_points)
    new_array = []
    place = 1
    for point in break_points
        temp_array = []
        if place > length(sorted_array)
            append!(new_array, [[]])
            continue
        end
        while (sorted_array[place] <= point)
            append!(temp_array, [sorted_array[place]])
            place += 1
            if place > length(sorted_array) break end
        end
        append!(new_array, [temp_array])
    end
    return new_array
end

function main_array_multiplication!(index_set, useful_indices, cutoff = z, arr = abs.(main_array), pos_dict = main_position_dict)
    for i in index_set
        if i <= cutoff continue end
        for j in useful_indices
            for pos in pos_dict[i][j]
                arr[pos] *= Int8(-1)
            end
        end
    end
    return arr
end

function set_of_useful_indices(zero_indices, end_data = endpoint_data)
    return [j for j in eachindex(end_data) if !(end_data[j][1] in zero_indices)]
end

function working_main_array_multiplication!(index_set, cutoff = z, arr = abs.(main_array), pos_dict = main_position_dict)
    for i in index_set
        if i <= cutoff continue end
        for pos in pos_dict[i]
            arr[pos] *= Int8(-1)
        end
    end
    return arr
end
