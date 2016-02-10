class GamesController < ActionController::API
	before_action :load_game, only: [:show, :update, :destroy]
	def index #get games/
		@games = Game.all
		render json: @games.as_json.map { 
			|obj|
			obj.delete("p2_coordinates")
			obj	
		}
	end

	def show #get games/:id
		render json: {game: @game, moves: @game.turns, remaining_p1_coordinates: remaining_p1_coordinates, remaining_p2_coordinates: remaining_p2_coordinates, all_coordinates: all_coordinates, p1_selected: p1_selected, p2_selected: p2_selected, p1_remaining_ships: p1_remaining_ships, p2_remaining_ships: p2_remaining_ships.size, p1_empty_spots: p1_empty_spots.sort, p1_hits: p1_hits, p1_misses: p1_misses, p2_hits: p2_hits, p2_misses: p2_misses   } if @game
	end

	def create #post games/
		@game = Game.new(game_params)
		if @game.save
			render json: @game
		else
			render text: "problem with Saving game", :status => 501
		end
	end

	def update #get games/:id
		player = params['player']
		move = params['move']
		if @game.turns.create(player: player, move: move)
			render json: {game: @game, moves: @game.turns, remaining_p1_coordinates: remaining_p1_coordinates, remaining_p2_coordinates: remaining_p2_coordinates, all_coordinates: all_coordinates, p1_selected: p1_selected, p2_selected: p2_selected, p1_remaining_ships: p1_remaining_ships, p2_remaining_ships: p2_remaining_ships.size, p1_empty_spots: p1_empty_spots.sort, p1_hits: p1_hits, p1_misses: p1_misses, p2_hits: p2_hits, p2_misses: p2_misses } if @game
		else
			"problem with Saving Game"
		end
	end

	def destroy
		render json: Game.all if @game.destroy
	end

	private
	def game_params
		params.permit(:p1_coordinates, :p2_coordinates, :status, :p1_name, :current_turn)

	end

	def all_coordinates
		("A".."E").to_a.map { |letter| (1..5).to_a.map{|i| "#{letter}#{i}"}}.flatten
	end

	def p1_selected

		@game.turns.to_a.select{|turn| turn.player == "p1"}.map { |turn| turn.move}

	end

	def p2_selected
		@game.turns.to_a.select{|turn| turn.player == "p2"}.map { |turn| turn.move}
	end

	def remaining_p1_coordinates
		all_coordinates - p1_selected
	end

	def remaining_p2_coordinates
		all_coordinates - p2_selected	
	end

	def p1_remaining_ships
		puts "#{@game.p1_coordinates.split(",") - p2_selected}"
		@game.p1_coordinates.split(",") - p2_selected
	end

	def p2_remaining_ships
		@game.p2_coordinates.split(",") - p1_selected

	end

	def p1_empty_spots
		all_coordinates - p1_selected - @game.p1_coordinates.split(",")
	end

	def p2_empty_spots
		all_coordinates - p2_selected - @game.p2_coordinates.split(",")
	end

	def p1_hits
		p1_selected.select {|coordinate| @game.p2_coordinates.split(",").include? coordinate}
	end

	def p1_misses
		p1_selected.select {|coordinate| !(@game.p2_coordinates.split(",").include? coordinate)}
	end

	def p2_hits p2_hits: p2_hits, p2_misses: p2_misses
		p2_selected.select {|coordinate| @game.p1_coordinates.split(",").include? coordinate}
	end

	def p2_misses
		p2_selected.select {|coordinate| !(@game.p1_coordinates.split(",").include? coordinate)}
	end

	def load_game
		@game = Game.find(params[:id])
	rescue ActiveRecord::RecordNotFound
		@game = false
		render text: "Record ID '#{params[:id]}' Not found"
	end
end
