
class Message

	def initialize
		puts "Please enter the name of the text file to be decoded."
		file = gets.chomp
		cipher = File.new(file)
		@jumbled_key = cipher.gets.chomp
		cipher.gets
		@jumbled_message = cipher.read
		puts "Please enter the name of the dictonary file you wish to use."
		@dictionary = gets.chomp

		puts "Please enter the desired name of the output file."
		@output = gets.chomp
		self.break
	end

	def break
		@decoded_message = Decoder.new(@jumbled_key, @jumbled_message, @dictionary).decode
	end

	def write
		IO.write(@output, @decoded_message)
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
	attr_reader :begin_char
	attr_reader :end_char

	def initialize(jumbled_key,jumbled_message, dictionary)
		@jumbled_key = jumbled_key
		@jumbled_message = jumbled_message
		@dictionary = Dictionary.new(dictionary).dictionary
		# Setting begin_char and end_char for char_shift. Values correspond to
		#"A" and "Z" characters
		@begin_char = 65
		@end_char = 90
	end

	def decode
		key = key_breaker(@jumbled_key)
		decoded_message = message_breaker(key, @jumbled_message)
	end

	def key_breaker(jumbled_key)
		rough_potentials = []
		fine_potentials = []
		key = []

		('A'..'Z').each do |shift_letter|
			decoded_keyword = ""
			jumbled_key.each_char do |letter|
				new_position = char_shift(letter.ord, shift_letter.ord - 65)
				decoded_keyword << new_position.chr
			end
			rough_potentials << decoded_keyword
		end

		rough_potentials.each do |potential_keyword|
			if @dictionary.include?(potential_keyword.upcase)
				fine_potentials << potential_keyword
			end
		end

		fine_potentials.join.upcase.codepoints.each do |letter|
			key << letter - @begin_char
		end

		return key
	end

	def message_breaker(key_shift, message)
		counter = 0
		decoded_bytes = []
		message.bytes do |byte|
			counter = counter % key_shift.length
			shift = key_shift[counter]		
			if (byte >= 65 && byte <= 90)
				new_letter = char_shift(byte, -shift)
				decoded_bytes << new_letter
				counter += 1
			elsif (byte >= 97 && byte <= 122)
				new_letter = char_shift(byte + 32, -shift)
				decoded_bytes << new_letter
				counter =+ 1			
			else
				decoded_bytes << byte
			end
		end
		decoded_message = bytes_to_letters(decoded_bytes).join
		return decoded_message
	end

	def bytes_to_letters(args)
		chars = []
		args.each do |byte|
			chars << byte.chr
		end
		return chars
	end

	def char_shift(current_char, shift)
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
end


#################main#################

answer = Message.new
answer.write