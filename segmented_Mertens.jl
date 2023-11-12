using Distributions, IterTools, Primes

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

function dict_of_cond_intervals()
    num_of_primes = 5
    len = (2^2)*(3^2)*5*7*11*13

    combi = product([0x00, 0x01], [0x00, 0x01], [0x00, 0x01], [0x00, 0x01], [0x00, 0x01], [0x00, 0x01])

    maindict = Dict{NTuple{6, UInt8}, Vector{UInt8}}()

    for f in combi
        m = fill(UInt8(0), len)
        for j in 1:num_of_primes
            if f[j] != 0x00
                for n in prime(j):prime(j):len
                    m[n] += 0x01
                end
            end
            for n in prime(j)^2:prime(j)^2:len
                m[n] = m[n] | 0x80
            end
        end
        maindict[f] = m
    end
    return maindict
end

function segmentedrademacher(x0, del, data, condDict)
    condF = data[1:5]
    builder = condDict[condF]
end
