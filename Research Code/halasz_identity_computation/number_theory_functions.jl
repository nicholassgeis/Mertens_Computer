#Sieve of Eratosthenes
function prime_sieve(n::Int64)
    S = fill(true,n); S[1] = false
    for p = 2:n
        if S[p]
            for m = p^2:p:n S[m]=false end
        end
    end
    return findall(S)
end
