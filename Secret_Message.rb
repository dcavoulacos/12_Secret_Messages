def Secret_Messages(jumbled_key, jumbled_message)
	key = key_breaker(jumbled_key)
	key_shift = key_converter(jumbled_key)
	puts key_shift
	decoded_message = message_breaker(key_shift, jumbled_message)
	return decoded_message
end

	def english_word?(word, dictionary)
		return dictionary.include?(args.upcase)
	end


def key_breaker(coded_keyword)
	potentials = []
	(0..25).each do |shift_val|

	end 
end

def key_converter(key)
	key_shift = []
	key.upcase.codepoints.each do |letter|
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
dictionary = []
File.new("English_Dictionary.txt").each_line do |line|
	word = line.partition(" ")[0]
	dictionary << word
end

message = message_breaker([0,1,11,4], "AUEECL LX DBHR")
puts message



