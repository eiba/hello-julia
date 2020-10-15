min_char, max_char = 32, 122

function string_as_integer_list(string)
	return [Int(char) for char in string]
end

function random_specimen_of_length(length, min_char, max_char)
	return [rand(min_char:max_char) for i = 1:length]
end

function main(target,min_char, max_char)
	target = string_as_integer_list(target)
	target_length = length(target)

	println(random_specimen_of_length(target_length,min_char, max_char))
	println(target,target_length)
end

main("Hello World!",min_char, max_char)
