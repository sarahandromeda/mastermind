require 'pry-byebug'

module Gameplay
  def self.start_game
    player = Player.new_player
    welcome
    play_game(player, GameBoard.new, generate_code)
  end

  def self.play_game(codebreaker, gameboard, code)
    loop do
      guess = ask_for_input
      result = compare_codes(guess, code)
      gameboard.update_board(guess, result)
      if result == ['MATCH']
        win_round(code, gameboard)
        break
      elsif gameboard.board.length > 12
        lose_round(code, gameboard)
        break
      end
    end
  end

  def self.welcome
    puts <<~HEREDOC

      #{'-' * 30}
      You must help, we have been locked out of our computer
      which contains our life-saving research. Help us break the
      code and regain access!

      A random code of 4 colors will be generated and you will
      need to guess the colors in the correct order to win.
      #{'-' * 30}
      The possible colors are:
      #{GameBoard::COLORS.join(', ')}

      For each guess, enter 4 colors separated by commas.
      Example: red,yellow,blue,red
      #{'-' * 30}
      After each guess, the board will display your most recent
      guess on the bottom. Next to your guess, you may see
      ⚫ and ⚪ symbols. The black circle denotes a correct color
      in the correct position, the white circle denotes a correct
      color in the wrong position. Note: The order of the circles
      may not directly correspond to the order of your guess.

      Try to guess the code in 12 tries! Good luck!
      #{'-' * 30}

    HEREDOC
  end

  def self.generate_code
    Array.new(4) { GameBoard::COLORS.sample }
  end

  def self.ask_for_input
    loop do
      puts 'Enter your four color guess: '
      input = gets.chomp.split(',')
      input.each { |pick| pick.strip! }
      return input unless valid_input?(input) == false
    end
  end

  def self.valid_input?(color_picks)
    color_picks.all? { |color| GameBoard::COLORS.include?(color) } &&
      color_picks.length == 4
  end

  def self.compare_codes(guess, code)
    feedback = []
    picks = guess.clone
    return feedback << 'MATCH' if guess == code

    counts = picks.to_h { |i| [i, 0] }
    exact_match(picks, counts, feedback, code)
    close_match(picks, counts, feedback, code)
    feedback
  end

  def self.exact_match(picks, tally, matches, answer)
    picks.each_index do |i|
      if picks[i] == answer[i]
        matches << '⚫'
        tally[picks[i]] += 1
        picks[i] = 'match'
      end
    end
    tally
  end

  def self.close_match(picks, tally, matches, answer)
    picks.each_index do |i|
      if answer.include?(picks[i]) && tally[picks[i]] < answer.count(picks[i])
        matches << '⚪'
        tally[picks[i]] += 1
      end
    end
  end

  def self.win_round(answer, board)
    puts "Congrats! You won! The answer was:\n#{answer}"
    board.reset_board
  end

  def self.lose_round(answer, board)
    puts "You couldn't crack it this time, the answer was:\n#{answer}"
    board.reset_board
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
    rounds = ask_for_rounds.to_i
    if rounds > 10
      rounds = 10
      puts 'Setting number of rounds to maximum of 10.'
    end
    new(name, rounds)
  end

  def self.ask_for_rounds
    loop do
      puts 'How many rounds would you like to play?' \
      ' Enter an integer between 1 and 10.'
      rounds = gets.chomp
      return rounds unless rounds.to_i.zero?
    end
  end
end

class GameBoard
  COLORS = %w[red orange yellow green blue purple]
  attr_reader :board, :guesses

  def initialize
    @board = []
    @guesses = 0
  end

  def display_board
    puts "\n\nGuess || Result\n#{'=' * 30}"
    board.each do |turn|
      turn['guess'].each do |color|
        print "[#{color}]"
      end
      print ' || { '
      turn['result'].each do |res|
        print res.to_s
      end
      puts " }\n#{'=' * 30}\n\n"
    end
  end

  def update_board(code_guess, guess_feedback)
    guesses += 1
    binding.pry
    new_row = [['guess', code_guess], ['result', guess_feedback]]
    board << new_row.to_h
    display_board
  end

  def reset_board
    board = []
  end

  protected

  attr_writer :board, :guesses
end

puts 'Welcome, would you like to play Mastermind?(y/n)'
Gameplay.start_game unless gets.chomp.downcase == 'n'
