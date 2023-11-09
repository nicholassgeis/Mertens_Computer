function prime_sieve_with_factors(n::Int64)
    S = fill([true, []], n)
    S[1] = [false, [1]]
    for p = 2:n
        if S[p][1]
            S[p] = [true, [p]]
            for m = p^2:p:n     
                S[m] = [false, vcat(S[m][2], [p])]
            end
        end
    end
    return return S
end

function prime_sieve(n::Int64)
    S = fill(true,n); S[1] = false
    for p = 2:n
        if S[p]
            for m = p^2:p:n S[m]=false end
        end
    end
    return findall(S)
end

using Distributions
coin = Bernoulli(0.5)

function array_maker(n = X, prime_set = primes)
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

function rademacher_function(index_set, prime_set = primes, arr = abs.(naive_main_arr), n = X)
    for i in index_set
        for pos = prime_set[i]:prime_set[i]:n
            arr[pos] *= (Int8(-1))
        end      
    end
    return arr    
end


