require 'sinatra'
require 'sinatra/reloader' if development?

$varieties = 6
$turns = 12
COLORS = ["red", "blue", "green", "yellow", "purple", "orange"];
@@new_game = true
@@game_over = false

Game = Struct.new(:solution, :turn, :guesses)
Turn = Struct.new(:guess, :black_pegs, :white_pegs)

class Mastermind
	def create_random_code
		code = ""
		(0..3).each do |i|
			code += (rand(6) + 1).to_s
		end
		code
	end

	def valid_input(input)
		correct_length = (input.length == 4)
		valid_numbers = true
		(0..3).each do |i|
			begin
				valid_numbers = false unless (1..$varieties).include?(input[i].to_i)
			rescue Exception => e
				puts "Not enough valid numbers"
				valid_numbers = false
			end
		end
		correct_length && valid_numbers
	end

	def rate_guess(code, guess)
		black_pegs = 0
		white_pegs = 0
		not_correct_guesses = []
		unguessed_codes = []
		guess.each_with_index do |x, i|
			if x == code[i]
				black_pegs += 1 
			else
				not_correct_guesses << x
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

get '/' do
	# If new game - prepare game data
	if @@new_game
		code = Mastermind.create_random_code
		@@game = Game.new(code, 1, [])
		@@new_game = false
	end
	# If continuing game and params supplied (representing new guess) - evaluate guess and add line to prev guesses array
	guess = params["guess"]
	if Mastermind.valid_input(guess)
		black_pegs, white_pegs = Mastermind.rate_guess(@@game.code, guess)
		if black_pegs == 4 || @@game.turn >= $turns
			@@game_over = true 
		end
		@@game.turns << Turn.new(guess, black_pegs, white_pegs)
	end
	# erb execute page - loop through all prev guesses and output, then output a clickable line if not game over
	erb :index, locals: {game: @@game, game_over: @@game_over, colors: COLORS}
end

# class Game
# 	$varieties = 6
# 	$turns = 12
# 	def initialize
# 		codebreaker_game
# 	end

# 	def codebreaker_game	
# 		@master = Master.new
# 		@breaker = CodeValidator.new
# 		@game_over = false
# 		@turn = 1
# 		until @game_over
# 			puts "Turn #{@turn}:"
# 			@guess = @breaker.code
# 			row = Row.new(@guess)
# 			pegs = @master.rate_guess(@guess)
# 			row.set_pegs(pegs[0], pegs[1])
# 			puts row

# 			if pegs == [4, 0]
# 				puts "You win!"
# 				@game_over = true
# 			elsif @turn == $turns
# 				puts "No more turns, game over :("
# 				@master.show_solution
# 				@game_over = true
# 			else
# 				@turn += 1
# 			end
# 		end
# 	end

# 	def master_game
# 		puts "Please provide a 4-digit code using the digits 1 to #{$varieties} for the computer to try to guess."
# 		@master = Master.new(false)
# 		@guesser = Guesser.new
# 		@game_over = false
# 		@turn = 1
# 		until @game_over
# 			puts "Turn #{@turn}:"
# 			if @guess
# 				@guess = @guesser.make_educated_guess(@guess, @peg_string)
# 			else
# 				@guess = @master.create_random_code($varieties)
# 			end
# 			row = Row.new(@guess)
# 			@peg_string = @master.rate_guess_easy(@guess)
# 			row.set_peg_string(@peg_string)
# 			puts row

# 			if @peg_string == 'OOOO'
# 				puts "Computer wins!"
# 				@game_over = true
# 			elsif @turn == $turns
# 				puts "No more turns, you win!"
# 				@game_over = true
# 			else
# 				@turn += 1
# 				sleep 1
# 			end
# 		end
# 	end

# end

# Records and displays current row
# class Row
# 	def initialize(guess)
# 		@guess = guess
# 	end

# 	def set_pegs(black, white)
# 		@black_pegs = black
# 		@white_pegs = white
# 	end

# 	def set_peg_string(peg_string)
# 		@peg_string = peg_string
# 	end

# 	def to_s
# 		if $mode == 'c'
# 			@peg_string = ''
# 			if @black_pegs > 0
# 				(1..@black_pegs).each {@peg_string << 'O'}
# 			end
# 			if @white_pegs > 0
# 				(1..@white_pegs).each {@peg_string << 'o'}
# 			end
# 			@peg_string << '.' until @peg_string.length == 4
# 		end

# 		"#{@guess[0]} #{@guess[1]} #{@guess[2]} #{@guess[3]}  --  #{@peg_string}"
# 	end
# end

# # Knows the solution and rates guesses
# class Master
# 	def initialize(random = true)
# 		if random
# 			@code = create_random_code($varieties)
# 		else
# 			@code = CodeValidator.new.code
# 		end
# 	end

# 	def create_random_code(varieties)
# 		code = []
# 		(0..3).each do |i|
# 			code[i] = rand(varieties) + 1
# 		end
# 		code
# 	end

# 	def rate_guess(guess)
# 		black_pegs = 0
# 		white_pegs = 0
# 		not_correct_guesses = []
# 		unguessed_codes = []
# 		guess.each_with_index do |x, i|
# 			if x == @code[i]
# 				black_pegs += 1 
# 			else
# 				not_correct_guesses << x
# 				unguessed_codes << @code[i]
# 			end
# 		end
# 		unguessed_codes.each do |u|
# 			if not_correct_guesses.include?(u)
# 				white_pegs += 1
# 				not_correct_guesses.delete_at(not_correct_guesses.index(u))
# 			end
# 		end
# 		[black_pegs, white_pegs]
# 	end

# 	def rate_guess_easy(guess)
# 		output = ['.', '.', '.', '.']
# 		not_correct_guesses = []
# 		unguessed_codes = []
# 		guess.each_with_index do |x, i|
# 			if x == @code[i]
# 				output[i] = 'O'
# 			else
# 				not_correct_guesses[i] = x
# 				unguessed_codes << @code[i]
# 			end
# 		end
# 		unguessed_codes.each do |u|
# 			if not_correct_guesses.include?(u)
# 				output[not_correct_guesses.index(u)] = 'o'
# 				not_correct_guesses[not_correct_guesses.index(u)] = ''
# 			end
# 		end
# 		output.join
# 	end

# 	def show_solution
# 		puts "The solution is #{@code}"
# 	end
# end

# class CodeValidator
# 	def code
# 		input = '    '
# 		until valid_input(input)
# 			puts "Please enter a code as 4 digits e.g. 4321:"
# 			input = gets.chomp
# 		end 
# 		[input[0].to_i, input[1].to_i, input[2].to_i, input[3].to_i]
# 	end

# 	def valid_input(input)
# 		correct_length = (input.length == 4)
# 		valid_numbers = true
# 		(0..3).each do |i|
# 			begin
# 				valid_numbers = false unless (1..$varieties).include?(input[i].to_i)
# 			rescue Exception => e
# 				puts "Not enough valid numbers"
# 				valid_numbers = false
# 			end
# 		end

# 		correct_length && valid_numbers
# 	end
# end


