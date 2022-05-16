# frozen_string_literal: false

# creates new boards
class Board
  attr_reader :all_colors, :code
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

  def game_run
    i = 12
    while i.positive?
      board.make_code
      board.take_guess
      p board.create_keys
      puts "\n\n"
    end
  end

  def begin
    greet
  end
end

g = Game.new
g.begin
