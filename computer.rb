# frozen_string_literal: false

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
      exact_match << i if guess[i] == code[i]
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