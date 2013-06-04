
class Message

	def initialize
		puts "Please enter the name of the text file to be decoded."
		file = gets.chomp
		cipher = File.new(file)
		@jumbled_key = cipher.gets.chomp
		@jumbled_message = cipher.read
		puts "Please enter the name of the dictonary file you wish to use."
		@dictionary = gets.chomp

		puts "Please enter the desired name of the output file."
		@output = gets.chomp
		IO.write(@output, self.break)
	end

	def break
		decoded_message = Decoder.new(@jumbled_key, @jumbled_message, @dictionary).Secret_Messages
	end
end

class Dictionary

	attr_reader :dictionary

	def initialize(dictionary_file)
		@dictionary = []
		File.new(dictionary_file).each_line do |line|
			if line.include?(" ")
				word = line.partition(" ")[0]
				@dictionary << word
			else
				word = line.chomp
				@dictionary << word
			end		
		end
	end
end

class Decoder

	def initialize(jumbled_key,jumbled_message, dictionary)
		@jumbled_key = jumbled_key
		@jumbled_message = jumbled_message
		@dictionary = Dictionary.new(dictionary).dictionary
	end

	def Secret_Messages
		key = key_breaker(@jumbled_key)
		key_shift = key_converter(key)
		decoded_message = message_breaker(key_shift, @jumbled_message)
		return decoded_message
	end

	def key_breaker(jumbled_key)

		rough_potentials = []
		('A'..'Z').each do |shift_letter|
			decoded_keyword = ""
			jumbled_key.each_char do |letter|
				new_position = char_shift(65, 90, letter.ord, shift_letter.ord - 65)
				decoded_keyword << new_position.chr
			end
			rough_potentials << decoded_keyword
		end

		fine_potentials = []
		rough_potentials.each do |potential_keyword|
			if @dictionary.include?(potential_keyword.upcase)
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
		new_char = current_char + shift
		if shift > 0
			new_char -= range if new_char > end_char
		end
		if shift < 0
			new_char += range if new_char < begin_char
		end
		return new_char
	end


	def message_breaker(key_shift, message)
		counter = 0
		decoded_bytes = []
		message.bytes do |byte|
			counter = counter % key_shift.length
			shift = key_shift[counter]		
			if (byte >= 65 && byte <= 90)
				new_letter = char_shift(65, 90, byte, -shift)
				decoded_bytes << new_letter
				counter += 1
			elsif (byte >= 97 && byte <= 122)
				new_letter = char_shift(97, 122, byte, -shift)
				decoded_bytes << new_letter
				counter =+ 1			
			else
				decoded_bytes << byte
			end
		end
		decoded_message = bytes_to_letters(decoded_bytes).join
		return decoded_message
	end
end


Message.new
