struct specimen
    genotype::Array
    fitness::Int64
end

function string_as_integer_list(string)
    return [Int(char) for char in string]
end

function random_population_of_length(population_size, length, min_char, max_char)
    return [random_specimen_of_length(length, min_char, max_char) for i = 1:population_size]
end

function random_specimen_of_length(length, min_char, max_char)
    return [rand(min_char:max_char) for i = 1:length]
end

function fitness(specimen, target)
    score = 0
    for i = 1:length(specimen)
        score += abs(specimen[i] - target[i])^2
    end
    return score
end

function iterate_population(population, target, min_char, max_char)
    for specimen in population
        score = fitness(specimen, target)
    end
end

function main(target, population_size, min_char, max_char)
    target = string_as_integer_list(target)
    s = specimen(target,fitness(target,target))
    println(s.genotype, "-",s.fitness)
    random_population =
        random_population_of_length(population_size, length(target), min_char, max_char)
    iterate_population(random_population, target, min_char, max_char)
end

min_char, max_char = 32, 122
population_size = 50
target = "Hello World!"
main(target, population_size, min_char, max_char)
