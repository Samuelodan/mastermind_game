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
    initial_match = @current_guess.select do |item|
      @code.include?(item)
    end
    exact_match = @current_guess.select do |item|
      @current_guess.index(item) == @code.index(item)
    end

    black_keys = exact_match.length
    white_keys = initial_match.length - black_keys

    @win = true if black_keys == 4

    { white_keys: white_keys, black_keys: black_keys }
  end
end

# creates computer class that breaks codes
class Computer
  attr_reader :code

  def initialize
    @initial_guess = [1, 1, 2, 2]
    @set = [1, 2, 3, 4, 5, 6].repeated_permutation(4).to_a
    @ref = %w[red blue green yellow orange purple]
    @code = []
  end

  def take_input
    puts "Choose your secret color code from this list: \n#{@ref}"
    puts "Type four colors separated by a comma\nhit Enter when done"
    code = gets.chomp.downcase.split(',') # i might combine...
    code = code.map(&:strip) # ...these two lines later for this class and the Board class.
  end

  def secret_code
    take_input.each do |item|
      @code << @ref.index(item) + 1
    end
  end

  def get_hint(code, guess)
    initial_match = guess.select do |item|
      code.include?(item)
    end
    exact_match = guess.select do |item|
      guess.index(item) == code.index(item)
    end

    black_keys = exact_match.length
    white_keys = initial_match.length - black_keys

    @win = true if black_keys == 4

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
    @initial_guess ||= @set[0]
    initial_hint = get_hint(@code, @initial_guess)
    set.delete_if do |combo|
      current_hint = get_hint(@initial_guess, combo)
      current_hint != initial_hint
    end
    @initial_guess = nil
  end
end

# this controls the flow of the game
class Game
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def greet
    puts "\t\nHello there! Welcome to the Mastermind game\n
I believe you know the rules already\n
You have 12 chances to guess what the hidden color sequence is\n
Good luck!"
    puts "\n\nenter 'y' to continue"
    con = gets.chomp.downcase
    case con
    when 'y' then game_run
    else puts 'You can come back to the game later by clicking run'
    end
  end

  def anounce_win
    puts "Hidden code: #{board.code}"
    puts 'Congrats! You broke the code.'
  end

  def game_run
    i = 12
    while i.positive?
      puts "#{i} attempts left"
      board.take_guess
      p board.create_keys
      if board.win
        anounce_win
        break
      end
      puts "\n\nUSE THE WHITE AND BLACK KEYS ABOVE TO MAKE YOUR NEXT GUESS\n"
      i -= 1
    end
    puts 'Gameover! You can play again by clicking "run"'
  end

  def begin
    board.make_code
    greet
  end
end

# game = Game.new
# game.begin
