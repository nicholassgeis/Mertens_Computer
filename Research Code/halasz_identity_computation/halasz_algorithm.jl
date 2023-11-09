function halasz_computation(index_set, arr = main_array, end_data = endpoint_data)
    #Computes the M1_values for computations
    conditioned_M1 = conditional_values(index_set)
    useful_index_set = set_of_useful_indices(findall(iszero, conditioned_M1))

    #Sets up main_arr with correct values
    arr = main_array_multiplication!(index_set, useful_index_set)

    #Computes the final summation
    return final_summation(conditioned_M1, arr)
end

function final_summation(multiplier_arr, value_arr, end_data = endpoint_data)
    final_sum = multiplier_arr[1]
    for entry in end_data
        if multiplier_arr[entry[1]] == 0 continue end
        final_sum += ((multiplier_arr[entry[1]])*sum(view(value_arr, entry[2]:entry[3])))
    end
    return final_sum
end
