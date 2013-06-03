 	def Secret_Messages(jumbled_key, jumbled_message)
 		key = key_breaker(jumbled_key)
 		key_shift = key_converter(jumbled_key)
 		puts key_shift
 		decoded_message = message_breaker(key_shift, jumbled_message)
 		return decoded_message
 	end


	@dictionary = []

	def intialize
		File.open(English_Dictionary.txt).each_line do |line|
			word = line.partition(" ")[0]
			@dictionary << word
		end
	end

	def english_word?(args)
		return @dictionary.include?()
	end

	def key_breaker

	end

	def key_converter(key)
		key_shift = []
		key.upcase.codepoints.each do |letter|
			key_shift << letter - 65
		end
		return key_shift
	end

	def bytes_to_letters(args)
		args.pack("c*")
	end

	def char_shift(begin_char, end_char, current_char, shift)
		new_char = current_char - shift
		new_char =+ (end_char - begin_char + 1) if new_char > begin_char
		return new_char
	end


	def message_breaker(key_shift, message)
		counter = 0
		decoded_bytes = []
		message.each_byte do |byte|
			counter = counter % key_shift.length
			shift = key_shift.index(counter)		
			if (byte >= 65 && byte <= 90)
				new_letter = char_shift(65, 90, byte, shift)
				decoded_bytes << new_letter
				counter =+ 1
			elsif (byte >= 97 && byte <= 122)
				new_letter = char_shift(97, 122, byte, shift)
				decoded_bytes << new_letter
				counter =+ 1			
			else
				decoded_bytes << byte
			end
		end
		decoded_message = bytes_to_letters(decoded_bytes)
		return decoded_message
	end

puts bytes_to_letters([65, 97, 90, 122])

