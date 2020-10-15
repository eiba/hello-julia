struct specimen
    genotype::Array
    fitness::Int64
end

function string_to_integer_list(string)
    return [Int(char) for char in string]
end

function integer_list_to_string(integer_list)
    string = ""
    for int in integer_list
        string *= Char(int)
    end
    return string
end

function random_population_of_length(population_size, target, min_char, max_char)
    return [random_specimen_of_length(target, min_char, max_char) for i = 1:population_size]
end

function random_specimen_of_length(target, min_char, max_char)
    genotype = [rand(min_char:max_char) for i = 1:length(target)]
    return specimen(genotype, fitness(genotype, target))
end

function fitness(genotype, target)
    fitness = 0
    for i = 1:length(genotype)
        fitness += abs(genotype[i] - target[i])^2
    end
    return fitness
end

function crossover(specimen1, specimen2)
    return
end

function iterate_population(population, target, min_char, max_char)
    for specimen in population
        println(integer_list_to_string(specimen.genotype))
    end
end

function main(target, population_size, min_char, max_char)
    target = string_to_integer_list(target)
    random_population =
        random_population_of_length(population_size, target, min_char, max_char)

    iterate_population(random_population, target, min_char, max_char)
end

min_char, max_char = 32, 122
population_size = 50
target = "Hello World!"
main(target, population_size, min_char, max_char)
