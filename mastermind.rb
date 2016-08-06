module Mastermind
	def self.create_random_code
		code = ""
		(0..3).each do |i|
			code += (rand(6) + 1).to_s
		end
		code
	end

	def self.valid_input(input)
		if input
			correct_length = (input.length == 4)
			valid_numbers = true
			(0..3).each do |i|
				begin
					valid_numbers = false unless (0..$varieties-1).include?(input[i].to_i)
				rescue Exception => e
					puts "Not enough valid numbers"
					valid_numbers = false
				end
			end
			correct_length && valid_numbers
		else
			false
		end
	end

	def self.rate_guess(code, guess)
		black_pegs = 0
		white_pegs = 0
		not_correct_guesses = []
		unguessed_codes = []
		(0...guess.length).each do |i|
			if guess[i] == code[i]
				black_pegs += 1 
			else
				not_correct_guesses << guess[i]
				unguessed_codes << code[i]
			end
		end
		unguessed_codes.each do |u|
			if not_correct_guesses.include?(u)
				white_pegs += 1
				not_correct_guesses.delete_at(not_correct_guesses.index(u))
			end
		end
		[black_pegs, white_pegs]
	end
end