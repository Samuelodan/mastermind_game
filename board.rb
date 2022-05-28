# frozen_string_literal: false

# creates new boards
class Board
  attr_reader :all_colors, :code, :win
  attr_accessor :current_guess

  def initialize
    @all_colors = %w[red blue green yellow orange purple]
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
      exact_match << i if @current_guess[i] == @code[i]
    end

    black_keys = exact_match.length
    white_keys = initial_match.length - black_keys

    @win = true if black_keys == 4

    { white_keys: white_keys, black_keys: black_keys }
  end
end
