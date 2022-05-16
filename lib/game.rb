require './lib/logic.rb'
require './lib/messages.rb'
require './lib/new_game.rb'
require 'pry-byebug'


class Game
  include Gameplay
  include Display
  include GameLogic
  COLORS = %w[red orange yellow green blue purple]
  attr_accessor :turns, :rounds, :board, :curr_guess

  def initialize(rounds, answer = Array.new(4) { COLORS.sample })
    @answer = answer
    @turns = 0
    @rounds = rounds
    @board = []
  end

  def start
    loop do
      play_round
      break if self.rounds <= 0

      reset_round
    end
    end_game
  end

  def play_round
    self.rounds -= 1
    last_round_warning if self.rounds == 0
    loop do
      @curr_guess = play_turn
      update_board
      break if end_round
    end
  end

  def reset_round
    self.answer = Array.new(4) { COLORS.sample }
    self.turns = 0
    self.board = []
  end

  def end_round
    if self.turns == 12
      out_of_turns_message
      puts "The answer was #{self.answer}."
      self.board = []
      true
    elsif self.curr_guess == self.answer
      correct_guess_message
      self.board = []
      true
    end
  end

  def end_game
    game_over_message
    NewGame.new_game if gets.chomp.downcase == 'y'
  end

  def play_turn
    self.turns += 1
    last_guess_warning if self.turns == 12
  end

  def update_board
    results = compare(self.curr_guess, self.answer)
    self.board << { guess: self.curr_guess, result: results}
    display_board(self.board)
  end

  protected
  attr_accessor :answer
end

class CodeBreaker < Game
  def self.new_game
    new(Gameplay.ask_for_rounds)
  end

  def play_turn
    super
    ask_for_input
  end
end

class CodeMaker < Game
  include ComputerLogic
  attr_accessor :possible_answers
  def self.new_game
    rounds = Gameplay.ask_for_rounds
    answer = Gameplay.ask_for_code
    new(rounds, answer)
  end

  def play_round
    @possible_answers = generate_possible_answers
    super
  end

  def play_turn
    super
    computer_guess
  end

  def computer_guess
    if self.turns == 1
      %w[red red orange orange]
    else
      determine_guess
    end
  end 

  def determine_guess
    last_guess, last_feedback = self.board[-1][:guess], self.board[-1][:result]
    self.possible_answers = self.possible_answers.keep_if do |code|
      compare(code, last_guess) == last_feedback
    end
    sleep 1.5
    self.possible_answers.sample
  end

  def reset_round
    super
    self.answer = Gameplay.ask_for_code
  end


end