require './lib/new_game.rb'

puts 'Welcome, would you like to play Mastermind?(y/n)'
NewGame.new_game if gets.chomp.downcase == 'y'