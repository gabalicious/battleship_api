class CreateGames < ActiveRecord::Migration
	def change
		create_table :games do |t|
			t.string :p1_name
			t.string :p1_coordinates
			t.string :p2_coordinates
			t.string :status
			t.integer :current_turn
			t.timestamps null: false
		end
	end
end
