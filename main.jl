min_char, max_char = 32, 122


function string_as_integer_list(string)
	return [Int(char) for char in string]
end

println(string_as_integer_list("Hello World!"))
