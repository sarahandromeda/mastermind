require './lib/messages.rb'
require './lib/game.rb'
require 'pry-byebug'

module GameLogic
  def compare(guess, answer)
    feedback = []
    picks = guess.clone
    return feedback << 'MATCH' if guess == answer

    counts = picks.to_h { |i| [i, 0] }
    exact_match(picks, counts, feedback, answer)
    close_match(picks, counts, feedback, answer)
    return feedback
  end

  def exact_match(picks, counts, feedback, answer)
    #returns [match symbols]
    picks.each_index do |i|
      if picks[i] == answer[i]
        feedback << '⚫'
        counts[picks[i]] += 1
        picks[i] = 'match'
      end
    end
    feedback
  end

  def close_match(picks, counts, feedback, answer)
    # returns [match symbols]
    picks.each_index do |i|
      if answer.include?(picks[i]) && counts[picks[i]] < answer.count(picks[i])
        feedback << '⚪'
        counts[picks[i]] += 1
      end
    end
    feedback
  end
end

module ComputerLogic
  #computer_guess algo returns guess
  def generate_possible_answers
    list = []
    Game::COLORS.each do |first| 
      Game::COLORS.each do |second| 
        Game::COLORS.each do |third|
          Game::COLORS.each do |fourth|
            list << [first,second,third,fourth]
          end
        end
      end
    end
    list
  end

end

module Gameplay
  def self.ask_for_rounds
    puts 'How many rounds would you like to play? Enter an integer between 1-10.'
    chosen_rounds = gets.chomp.to_i
    ask_for_rounds unless chosen_rounds.between?(1,10)
    chosen_rounds
  end

  def ask_for_input
    puts 'Enter your 4 color guess separated by commas.'
    guess = gets.chomp.split(',')
    ask_for_input unless verify_input(guess) == true
    guess
  end

  def verify_input(guess)
    guess.all? { |color| Game::COLORS.include?(color) }
  end

  def self.ask_for_code
    puts 'Enter a 4 color code separated by commas for the computer to crack.'
    chosen_code = gets.chomp.split(',')
    ask_for_code unless verify_code(chosen_code) == true
    chosen_code
  end

  def self.verify_code(code_array)
    code_array.all? { |choice| Game::COLORS.include?(choice) }
  end
end
