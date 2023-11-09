function big_small_array(n, cutoff, prime_set = primes)
    S = fill(true, n)
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

function position_dict_for_stuff(n, cutoff, prime_set = primes)
    dict = Dict{Int32, Vector{Int32}}()
    bool_array = big_small_array(n, cutoff)
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


