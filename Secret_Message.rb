def Secret_Messages(jumbled_key, jumbled_message)
	key = key_breaker(jumbled_key)
	key_shift = key_converter(key)
	decoded_message = message_breaker(key_shift, jumbled_message)
	return decoded_message
end

def english_word?(word, dictionary)
	return dictionary.include?(word.upcase)
end


def key_breaker(jumbled_key)
	dictionary = []
	File.new("English_Dictionary.txt").each_line do |line|

		if line.include?(" ")
			word = line.partition(" ")[0]
			dictionary << word
		else
			word = line.chomp
			dictionary << word
		end		
	end

	rough_potentials = []
	('A'..'Z').each do |shift_letter|
		decoded_keyword = ""
		jumbled_key.each_char do |letter|
			new_position = (letter.ord - shift_letter.ord) + 65
			if new_position < 65
				new_position += 26
			end
			decoded_keyword << new_position.chr
		end
		rough_potentials << decoded_keyword
	end

	fine_potentials = []
	rough_potentials.each do |potential_keyword|
		if english_word?(potential_keyword, dictionary)
			fine_potentials << potential_keyword
		end
	end
	return fine_potentials
end

def key_converter(key)
	key_shift = []
	key.join.upcase.codepoints.each do |letter|
		key_shift << letter - 65
	end
	return key_shift
end

def bytes_to_letters(args)
	chars = []
	args.each do |byte|
		chars << byte.chr
	end
	return chars
end

def char_shift(begin_char, end_char, current_char, shift)
	range = end_char - begin_char + 1
	new_char = current_char - shift
	new_char += range if new_char < begin_char
	return new_char
end


def message_breaker(key_shift, message)
	counter = 0
	decoded_bytes = []
	message.bytes do |byte|
		counter = counter % key_shift.length
		shift = key_shift[counter]		
		if (byte >= 65 && byte <= 90)
			new_letter = char_shift(65, 90, byte, shift)
			decoded_bytes << new_letter
			counter += 1
		elsif (byte >= 97 && byte <= 122)
			new_letter = char_shift(97, 122, byte, shift)
			decoded_bytes << new_letter
			counter =+ 1			
		else
			decoded_bytes << byte
		end
	end
	decoded_message = bytes_to_letters(decoded_bytes).join
	return decoded_message
end

##########Main code section###############

puts "Please enter the name of the text file to be decoded."
file = gets.chomp
cipher = File.new(file)
jumbled_key = cipher.gets.chomp	
cipher.gets
jumbled_message = cipher.read

IO.write("output.txt", Secret_Messages(jumbled_key, jumbled_message))
