	class Secret_Messages

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

	def crack_keyword(coded_keyword)
		potentials = []
		(0..25).each do |shift_val|

		end 
	end

	def shift

	# cicpher is the paragraph(string) that we are decoding
	# cipher_array = cipher.chars
	# cipher_array.each do |char|
	# 	if /[a-zA-z]/.include?(char)
	# 		# code to shift
	# 	else
	# 		next
	# 	end
end