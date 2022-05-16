# frozen_string_literal: false

# creates new boards
class Board
  attr_reader :all_colors, :code
  attr_accessor :current_guess

  def initialize
    @all_colors = %w[red yellow green blue brown purple]
    @current_guess = nil
    @code = nil
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

    { white_keys: white_keys, black_keys: black_keys }
  end
end

# creates player for the game
class Player
  def initialize
    @board = Board.new
  end
end
