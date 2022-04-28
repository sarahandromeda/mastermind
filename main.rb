module Gameplay
  def self.start_game
    welcome
    play_game(Player.new_player, GameBoard.new, generate_code)
  end

  def play_game(codebreaker, gameboard, code)
    until compare_codes == true or gameboard.guesses == 12
      guess = get_input
      gameboard.update_board(guess)
      gameboard.display_board
    end
    compare_codes == true ? win_round : lose_round
  end

  def self.welcome
    puts "\nYou must help, we have been locked out of our computer\n" +
    "which contains our life-saving research. Help us break the\n" +
    "code and regain access!\n" +
    "A random code of 4 colors will be generated and you will\n" +
    "need to guess the colors in the correct order to win.\n\n" +
    "For each guess, enter 4 colors separated by commas.\n" +
    "Example: red,yellow,blue,red\n\n" +
    "After each guess, the board will display your most recent\n" +
    "guess on the bottom. Next to your guess, you may see\n" +
    "⚫ and ⚪ symbols. The black circle denotes a correct color\n" +
    "in the correct position, the white circle denotes a correct\n" +
    "color in the wrong position. Note: The order of the circles\n" +
    "may not directly correspond to your guess.\n\n" +
    "Try to guess the code in 12 tries! Good luck!\n\n"
  end

  def self.generate_code
    Array.new(4) { |i| i = GameBoard::COLORS.sample }
  end

  def self.get_input
  end

  def self.verify_input
  end

  def self.compare_codes
  end

  def self.win_round
  end

  def self.lose_round
  end

  def self.end_game
  end
end

class Player
  def initialize(name, rounds)
    @name = name
    @rounds = rounds
  end

  def self.new_player
    puts 'Please enter your name:'
    name = gets.chomp 
    puts 'How many rounds would you like to play? Enter an integer up to 10.'
    rounds = gets.chomp.to_i
    if rounds > 10
      rounds = 10
      puts 'Setting number of rounds to maximum of 10.'
    end
    new(name,rounds)
  end
end

class GameBoard
  COLORS = ['red','orange','yellow','green','blue','purple']
  attr_reader :board

  def initialize
    @board = [ {guess:['','','',''] , result:['','','','']} ]
    @guesses = 0
  end

  def display_board
    puts "Guess || Result\n" + '='*30
    self.board.each do | turn |
      turn[:guess].each do | color |
        print "[#{color}]"
      end
      print ' || { '
      turn[:result].each do | res |
        print "#{res}"
      end
      puts " }\n" + '='*30
    end
  end

  protected
  
  attr_writer :board, :guesses

  def update_board
  end

  def reset_board
  end
end

puts "Welcome, would you like to play Mastermind?(y/n)"
Gameplay.start_game unless gets.chomp.downcase == 'n'

