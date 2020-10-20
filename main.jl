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

function crossover(genotype1, genotype2)
    split_point = rand(1:length(genotype1)-1)
    return [genotype1[1:split_point]; genotype2[split_point+1:length(genotype2)]]
end

function rank_sum(ranks)
    return Int(ranks * (ranks + 1) / 2)
end

function swap_indexes(array,i,j)
    tmp = array[i]
    array[i] = array[j]
    array[j] = tmp
end

function select(combined_population, population_size)
    combined_population = sort!(combined_population, by = specimen -> specimen.fitness)
    selected_population = []
    best_selected_fitness = typemax(Int)
    best_selected_index = 0

    while length(selected_population) < population_size
        selection_sum = rank_sum(length(combined_population))
        cumulative_probability = 0
        for rank = 1:length(combined_population)
            individual = combined_population[rank]
            selection_probability = (length(combined_population)-rank+1) / selection_sum
            cumulative_probability += selection_probability
            if cumulative_probability > rand()
                push!(selected_population, individual)

                if  individual.fitness < best_selected_fitness
                    best_selected_fitness = individual.fitness
                    best_selected_index = length(selected_population)
                end

                combined_population = [
                    combined_population[1:rank-1]
                    combined_population[rank+1:length(combined_population)]
                ]
                break
            end
        end
    end
    swap_indexes(selected_population,1,best_selected_index)
    return selected_population
end

function iterate_population(population, target, min_char, max_char)
    new_specimen = []
    for individual in population
        random_partner = population[rand(1:length(population))]
        new_genotype = crossover(individual.genotype, random_partner.genotype)
        push!(new_specimen, specimen(new_genotype, fitness(new_genotype, target)))
    end
    return select([population; new_specimen], length(population))
end

function print_iteration_leader(specimen,iteration)
    println(integer_list_to_string(specimen.genotype), " Score:", specimen.fitness, " Iteration:", iteration,)
end

function main(target, population_size, iterations, min_char, max_char)
    target = string_to_integer_list(target)
    population = random_population_of_length(population_size, target, min_char, max_char)

    for i = 1:iterations
        print_iteration_leader(population[1],i)
        population[1].fitness == 0 ? break :
        population = iterate_population(population, target, min_char, max_char)
    end
end

min_char, max_char = 32, 122
population_size, iterations = 1000, 100
target = "Hello Julia!"
main(target, population_size, iterations, min_char, max_char)

#println(typemax(Int64))
