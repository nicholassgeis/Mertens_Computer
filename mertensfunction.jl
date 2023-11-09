function prime_sieve(n::Int64)
    S = fill(true,n); S[1] = false
    for p = 2:n
        if S[p]
            for m = p^2:p:n S[m]=false end
        end
    end
    return findall(S)
end

function less_than_a(lst, a)
    for i in eachindex(lst)
        if lst[i] > a return i-1 end
    end
end

function thetastep(n)
    if n <= 0 return Int8(0) else return Int8(2) end
end

function mertensfunction(x, list_of_primes)
    lenl = less_than_a(list_of_primes, floor(Int, sqrt(x)))

    final_array = fill(Int8(0), x)
    m = fill(0x80, x)
    l = [floor(Int8, log2(list_of_primes[j])) | Int8(1) for j in 1:lenl]
    for j in 1:lenl
        for n in list_of_primes[j]:list_of_primes[j]:x
            m[n] += l[j]
        end
        for n in list_of_primes[j]^2:list_of_primes[j]^2:x
            m[n] = 0x00
        end
    end
    for n = 1:x
        if parse(Int8,bitstring(m[n])[1]) == Int8(0) 
           final_array[n] = Int8(0)
        elseif parse(Int8, bitstring(m[n])[2:8]) >= (floor(Int8, log2(n)) - 5 - thetastep(n - 2^20))
           final_array[n] = 1 - 2*parse(Int8, bitstring(m[n])[8]) 
        else 
            final_array[n] = 2*parse(Int8, bitstring(m[n])[8]) - 1  
        end
    end
    return final_array
end