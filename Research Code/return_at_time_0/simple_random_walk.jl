using Distributions
using Combinatorics
coin = Bernoulli(0.5)

function translation(bool)
    if bool return 1 else return -1 end
end

function random_walk(len, sample_coin = coin)
    S = findall(rand(sample_coin, len))
    return 2*length(S) - len
end

function sample_at_val(len, val, num_of_samples)
    count = 0
    if len <= log2(num_of_samples)
        for func in combinations(1:len)
            if 2*length(func) - len == val count += 1 end
        end
        return count/2^len
    else
        for sample in 1:num_of_samples
            if  random_walk(len) == val count += 1 end
        end
        return count/num_of_samples
    end
end

function sampled_range_from_a_to_b(a, b, num_of_samples, data_arr)
    for i in a:b
        if data_arr[end][2] == 0
            append!(data_arr, [(i, sample_at_val(i, 0, num_of_samples))])
        else
            append!(data_arr, [(i, 0.0)])
        end
    end
    return data_arr
end
