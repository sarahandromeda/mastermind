module Display
  def self.breaker_welcome_message
    puts <<~HEREDOC

      #{'-' * 30}
      A random code of 4 colors will be generated and you will
      need to guess the colors in the correct order to win.
      #{'-' * 30}
      The possible colors are:
      #{Game::COLORS.join(', ')}

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

  def self.maker_welcome_message
    puts <<~HEREDOC
      #{'-' * 30}
      You will need to come up with a four color code in attempt
      to stump the computer. The computer will need to guess the 
      correct colors in the correct order to win. 
      #{'-' * 30}
      The possible colors are:
      #{Game::COLORS.join(', ')}

      For each new code, enter 4 colors separated by commas.
      Example: red,yellow,blue,red
      #{'-' * 30}
      See if you can stump the computer! It has 12 tries each round!
      Good luck!
      #{'-' * 30}
    HEREDOC
  end

  def display_board(board)
    puts "\n\nGuess || Result\n#{'=' * 30}"
    board.each do |turn|
      turn[:guess].each do |color|
        print "[#{color}]"
      end
      print ' || { '
      turn[:result].each do |res|
        print res.to_s
      end
      puts " }\n#{'=' * 30}\n\n"
    end
  end

  def correct_guess_message
    puts 'You cracked the code!'
  end

  def out_of_turns_message
    puts 'Sorry, you are out of guesses.'
  end

  def game_won_message
    puts 'YOU WON THIS ROUND!'
  end

  def game_lost_message
    puts 'You lost this time, better luck next time.'
  end

  def game_over_message
    puts 'Game Over. Do you want to play again? (y/n)'
  end

  def last_guess_warning
    puts 'Last guess!'
  end

  def last_round_warning
    puts 'This is your last round, good luck!'
  end
end