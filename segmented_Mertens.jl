function arrayloop(A, i, x)
    new_A = Vector{Int8}(undef, x)
    k = 0
    for j in eachindex(new_A)
        if (i + (j-1) - (k*length(A))) > length(A) 
            k += 1 
        end
        new_A[j] = A[i + (j-1) - (k*length(A))]
    end
    return new_A
end

function logfun(n)
    return ceil(Int8, log(4, Int8(n))) | 1
end

function dict_of_cond_intervals(x)
    num_of_primes = 5

    combi = product([0x00, 0x01], [0x00, 0x01], [0x00, 0x01], [0x00, 0x01], [0x00, 0x01])

    maindict = Dict{Tuple{UInt8, UInt8}, Vector{UInt8}}()

    for f in combi
        m = fill(UInt8(0), x)
        for j in 1:num_of_primes
            for n in prime[j]:prime[j]:x
                m[n] += 
                final_array[n] += Int8(1)
            end
            for n in list_of_primes[j]^2:list_of_primes[j]^2:x
                m[n] = m[n] | 0x80
            end
        end
    end
end
