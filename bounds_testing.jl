using Primes, Combinatorics

function logceil(b, n)
    return ceil(Int128, log(b, n))
end

function minimizerconstant(x, b)
    plist = primes(Int(floor(sqrt(x))))
    maxx = 0
    for n in combinations(plist)
        if maxx < - sum([logceil(b, Int128(p)) | 1 for p in n]) + logceil(b, prod([Int128(k) for k in n])) 
            maxx = - sum([logceil(b, Int128(p)) | 1 for p in n]) + logceil(b, prod([Int128(k) for k in n]))
        end
    end
    return maxx
end

