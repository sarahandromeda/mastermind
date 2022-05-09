require './lib/game.rb'
require './lib/messages.rb'

module NewGame
  def self.new_game
    game = game_type
    if game == 0
      Display.breaker_welcome_message
      breaker = CodeBreaker.new_game
      breaker.start
    else 
      Display.maker_welcome_message
      maker = CodeMaker.new_game
      maker.start
    end
  end

  def self.game_type
    puts 'Enter a 0 or 1 to play as Code Breaker(0) or Code Maker(1).'
    choice = gets.chomp
    game_type if choice.length > 1 || choice.scan(/[1,0]/).empty?
    choice.to_i
  end
end