function string_as_integer_list(string)
    return [Int(char) for char in string]
end

function random_population_of_length(population_size, length, min_char, max_char)
    return [random_specimen_of_length(length, min_char, max_char) for i = 1:population_size]
end

function random_specimen_of_length(length, min_char, max_char)
    return [rand(min_char:max_char) for i = 1:length]
end

function fitness(specimen,target)
    for i = 1:length(specimen)
        distance = specimen[i] - target[i]
    end
end

function iterate_population(population, target, min_char, max_char)
    for specimen in population
        println(fitness(specimen,target))
    end
end

function main(target, population_size, min_char, max_char)
    target = string_as_integer_list(target)

    target_length = length(target)
    random_population =
        random_population_of_length(population_size, target_length, min_char, max_char)

    iterate_population(random_population, target, min_char, max_char)
end

min_char, max_char = 32, 122
population_size = 50
target = "Hello World!"
main(target, population_size, min_char, max_char)
