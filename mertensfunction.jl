using Primes

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

function logfloor(n)
    return ceil(Int8, log(4, n))
end

function oddeven(n)
    if n == 1 return -1 else return 1 end
end


#No Segment
function mertensfunction(x)
    list_of_primes = primes(floor(Int, sqrt(x)))

    final_array = fill(Int8(0), x)
    m = fill(UInt8(0), x)
    
    for j in eachindex(list_of_primes)
        for n in list_of_primes[j]:list_of_primes[j]:x
            m[n] += logfloor(list_of_primes[j])
            final_array[n] += Int8(1)
        end
        for n in list_of_primes[j]^2:list_of_primes[j]^2:x
            m[n] = m[n] | 0x80
        end
    end
    for n = 1:x
        if parse(Int8,bitstring(m[n])[1]) == Int8(1) 
           final_array[n] = Int8(0)
        elseif Int8(m[n]) < logfloor(n)
            final_array[n] = - 1 + 2*(parse(Int8, bitstring(final_array[n])[8]))
        else
            final_array[n] =  1 - 2*(parse(Int8, bitstring(final_array[n])[8]))
        end
    end
    return final_array
end

#Segmented 
function partialMertens(x, del)
    plist = primesmask(floor(Int, sqrt(x + del)))

    m = fill(UInt8(0), del+1)
    final_array = fill(Int8(0), del+1)

    for p in eachindex(plist)
        if plist[p] == true
            for n = (p*ceil(Int, x/p)):p:(x + del)
                m[n - x+ 1] += logfloor(p)
                final_array[n - x+ 1] += Int8(1)
            end
            for n = ((p^2)*ceil(Int, x/(p^2))):p^2:(x + del)
                m[n - x + 1] = m[n - x + 1] | 0x80
            end
        end
    end
    for j in eachindex(final_array)
        if parse(Int8,bitstring(m[j])[1]) == Int8(1) 
            final_array[j] = Int8(0)
         elseif Int8(m[j]) < logfloor(j)
             final_array[j] = - 1 + 2*(parse(Int8, bitstring(final_array[j])[8]))
         else
             final_array[j] =  1 - 2*(parse(Int8, bitstring(final_array[j])[8]))
         end
    end
    return final_array
end

function builderMertens(x)
    total = 0
    for i =1:Int(sqrt(x))
        total += sum(partialMertens((i-1)*Int(sqrt(x)) + 1, Int(sqrt(x)) - 1))
    end
    return total
end

builderMertens(10^4)
