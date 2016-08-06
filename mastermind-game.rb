require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'mastermind'

$varieties = 6
$turns = 12
COLORS = ["red", "blue", "green", "yellow", "purple", "orange"];
@@game_over = false

Game = Struct.new(:solution, :turn, :guesses)
Turn = Struct.new(:guess, :black_pegs, :white_pegs)

get '/' do
	if params["new-game"] == "true"
		@@game = Game.new(Mastermind.create_random_code, 1, [])
		@@game_over = false
	else
		@@game ||= Game.new(Mastermind.create_random_code, 1, [])
	end
	
	guess = params["guess"]
	if Mastermind.valid_input(guess)
		black_pegs, white_pegs = Mastermind.rate_guess(@@game.solution, guess)
		if black_pegs == 4 || @@game.turn >= $turns
			@@game_over = true 
		end
		@@game.guesses << Turn.new(guess, black_pegs, white_pegs)
		@@game.turn += 1
	end

	erb :index, locals: {game: @@game, game_over: @@game_over, colors: COLORS}
end