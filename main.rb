# frozen_string_literal: false

# creates new boards
class Board
  attr_reader :all_colors, :code, :win
  attr_accessor :current_guess

  def initialize
    @all_colors = %w[red yellow green blue brown purple]
    @current_guess = nil
    @code = nil
    @win = false
  end

  def make_code
    random_code = []
    while random_code.length < 4
      random_code << all_colors.sample
      random_code.uniq!
    end
    @code = random_code
    random_code
  end

  def take_guess
    puts "Available colors: #{@all_colors}"
    puts "Type any four colors seperated by a comma\nhit Enter when done"
    guess = gets.chomp.downcase.split(',')
    @current_guess = guess.map(&:strip)
  end

  def create_keys
    initial_match = @code.select do |item|
      @current_guess.include?(item)
    end
    exact_match = []
    for i in 0...4
      exact_match << i if @current_guess.slice(i, 1) == @code.slice(i, 1)
    end

    black_keys = exact_match.length
    white_keys = initial_match.length - black_keys

    @win = true if black_keys == 4

    { white_keys: white_keys, black_keys: black_keys }
  end
end

# creates computer class that breaks codes
class Computer
  attr_reader :code, :win

  def initialize
    @initial_guess = [1, 1, 2, 2]
    @set = [1, 2, 3, 4, 5, 6].repeated_permutation(4).to_a
    @ref = %w[red blue green yellow orange purple]
    @code = []
    @win = false
  end

  def take_input
    puts "Choose your secret color code from this list: \n#{@ref}"
    puts "Type four colors separated by a comma\nhit Enter when done"
    gets.chomp.downcase.split(',').map(&:strip)
  end

  def secret_code
    take_input.each do |item|
      @code << @ref.index(item) + 1
    end
  end

  def get_hint(code, guess)
    initial_match = code.select do |item|
      guess.include?(item)
    end
    exact_match = []
    for i in 0...4
      exact_match << i if guess.slice(i, 1) == code.slice(i, 1)
    end

    black_keys = exact_match.length
    white_keys = initial_match.length - black_keys

    { white_keys: white_keys, black_keys: black_keys }
  end

  def display_guess
    color = []
    4.times do |i|
      color << @ref[@initial_guess[i] - 1]
    end
    puts "Computer's guess: #{color}"
  end

  def make_guess
    @initial_guess ||= @set.sample
    initial_hint = get_hint(@code, @initial_guess)
    @win = true if initial_hint[:black_keys] == 4
    @set.delete_if do |combo|
      current_hint = get_hint(combo, @initial_guess)
      initial_hint != current_hint
    end
    display_guess
    @initial_guess = nil
  end
end

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
game = Game.new
game.begin
