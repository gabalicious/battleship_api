# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Game.destroy_all
  games = Game.create([{ p1_coordinates: 'A1,A2,A3,A4,A5,B1,B2,B3,B4,B5'}])
# p1_name
# p1_coordinates
# p2_coordinates
# status
# current_turn