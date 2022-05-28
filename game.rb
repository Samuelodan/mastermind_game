# frozen_string_literal: false

require './computer'
require './board'

# this controls the flow of the game
class Game
  attr_reader :board, :computer

  def initialize
    @board = Board.new
    @computer = Computer.new
  end

  def greet_breaker
    puts "\t\nAlright, you're the code breaker for this round\n
You have 12 chances to guess what the hidden color sequence is\n
Good luck!"
    board.make_code
    game_run
  end

  def greet
    puts "\t\nHello there! Welcome to the Mastermind game\n
I believe you know the rules already\n
You can choose to be the code breaker or be the code maker\n
Good luck!"
    puts "\n\nenter 'b' to continue as code breaker\nor 'm' to be code maker"
    case gets.chomp.downcase
    when 'b' then greet_breaker
    when 'm' then computer_run
    else puts 'You can come back to the game later by clicking run'
    end
  end

  def anounce_result(status)
    case status
    when 'breaker' then puts "Hidden code: #{board.code}\nCongrats! You broke the code"
    when 'maker'
      puts "You win!!\nThe Computer could'nt guess your code\nYou are the ultimate Code Maker"
    when 'computer'
      puts "You lost!\nThe Computer cracked your code.
Don't worry though, you can always play again by clicking 'run'"
    when 'gameover' then puts "You ran out of moves!!
Don't worry though, you can always play again by clicking 'run'"
    end
  end

  def computer_run
    computer.secret_code
    12.downto(1) do |i|
      puts "#{i} attempts left"
      computer.make_guess
      if computer.win
        anounce_result('computer')
        return
      end
    end
    anounce_result('maker')
  end

  def game_run
    12.downto(1) do |i|
      puts "#{i} attempts left"
      board.take_guess
      p board.create_keys
      if board.win
        anounce_result('breaker')
        return
      end
      puts "\n\nUSE THE WHITE AND BLACK KEYS ABOVE TO MAKE YOUR NEXT GUESS\n"
    end
    anounce_result('gameover')
  end

  def begin
    greet
  end
end