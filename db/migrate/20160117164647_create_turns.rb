class CreateTurns < ActiveRecord::Migration
	def change
		create_table :turns do |t|
			t.integer :game_id
			t.string :move
			t.string :player
			t.timestamps null: false
		end
	end
end
