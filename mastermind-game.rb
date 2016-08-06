require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'mastermind'

enable :sessions

$varieties = 6
$turns = 12
COLORS = ["red", "blue", "green", "yellow", "purple", "orange"];

Game = Struct.new(:solution, :turn, :guesses)
Turn = Struct.new(:guess, :black_pegs, :white_pegs)

get '/' do
	if params["new-game"] == "true"
		session['game'] = Game.new(Mastermind.create_random_code, 1, [])
		session['game_over'] = false
	else
		session['game'] ||= Game.new(Mastermind.create_random_code, 1, [])
		session['game_over'] ||= false
	end

	guess = params["guess"]
	if Mastermind.valid_input(guess)
		black_pegs, white_pegs = Mastermind.rate_guess(session[:game].solution, guess)
		if black_pegs == 4 || session['game'].turn >= $turns
			session['game_over'] = true 
		end
		session[:game].guesses << Turn.new(guess, black_pegs, white_pegs)
		session[:game].turn += 1
	end

	erb :index, locals: {game: session[:game], game_over: session[:game_over], colors: COLORS}
end