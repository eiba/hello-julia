struct Specimen
    genotype::Array
    fitness::Int
end

function string_to_integer_list(string::String)
    return [Int(char) for char in string]
end

function integer_list_to_string(integer_list::Array)
    string = ""
    for int in integer_list
        string *= Char(int)
    end
    return string
end

function random_population_of_length(
    population_size::Int,
    target::Array,
    min_char::Int,
    max_char::Int,
)
    return [random_specimen_of_length(target, min_char, max_char) for i = 1:population_size]
end

function random_specimen_of_length(target::Array, min_char::Int, max_cha::Int)
    genotype = [rand(min_char:max_char) for i = 1:length(target)]
    return Specimen(genotype, fitness(genotype, target))
end

function display_specimen(specimen::Specimen, iteration::Int)
    display("$(integer_list_to_string(specimen.genotype)) - {Score: $(specimen.fitness), Iteration: $iteration}")
end

function swap_index_contents!(array::Array, index1::Int, index2::Int)
    index1_contents = array[index1]
    array[index1] = array[index2]
    array[index2] = index1_contents
end

function remove(array::Array, index::Int)
    return [
        array[1:index-1]
        array[index+1:length(array)]
    ]
end

function rank_sum(ranks::Int)
    return Int(ranks * (ranks + 1) / 2)
end

function fitness(genotype::Array, target::Array)
    fitness = 0
    for i = 1:length(genotype)
        fitness += abs(genotype[i] - target[i])^2
    end
    return fitness
end

function mutate!(genotype::Array,min_char::Int, max_char::Int)
    genotype[rand(1:length(genotype))] = rand(min_char:max_char)
end

function crossover(genotype1::Array, genotype2::Array)
    split_point = rand(1:length(genotype1)-1)
    return [genotype1[1:split_point]; genotype2[split_point+1:length(genotype2)]]
end

function select(combined_population::Array, population_size::Int)
    combined_population = sort!(combined_population, by = specimen -> specimen.fitness)
    selected_population = []
    best_selected_fitness, best_selected_index = typemax(Int), 0

    while length(selected_population) < population_size
        selection_sum = rank_sum(length(combined_population))
        cumulative_probability = 0
        for rank = 1:length(combined_population)
            individual = combined_population[rank]
            selection_probability = (length(combined_population) - rank + 1) / selection_sum
            cumulative_probability += selection_probability
            if cumulative_probability > rand()
                push!(selected_population, individual)

                if individual.fitness < best_selected_fitness
                    best_selected_fitness, best_selected_index =
                        individual.fitness, length(selected_population)
                end
                combined_population = remove(combined_population, rank)
                break
            end
        end
    end
    swap_index_contents!(selected_population, 1, best_selected_index)
    return selected_population
end

function iterate_population(population::Array, target::Array, min_char::Int, max_char::Int)
    new_specimen = []
    for individual in population
        random_partner = population[rand(1:length(population))]
        new_genotype = crossover(individual.genotype, random_partner.genotype)
        if rand() < 0.1 mutate!(new_genotype,min_char,max_char) end
        push!(new_specimen, Specimen(new_genotype, fitness(new_genotype, target)))
    end
    return select([population; new_specimen], length(population))
end

function main(
    target::String,
    population_size::Int,
    iterations::Int,
    min_char::Int,
    max_char::Int,
)
    target = string_to_integer_list(target)
    population = random_population_of_length(population_size, target, min_char, max_char)
    display_specimen(population[1], 0)

    for i = 1:iterations
        population[1].fitness == 0 ? break :
        population = iterate_population(population, target, min_char, max_char)
        display_specimen(population[1], i)
    end
end

min_char, max_char = 32, 122
population_size, iterations = 10000, 100
target = "Hello Julia!"
main(target, population_size, iterations, min_char, max_char)
