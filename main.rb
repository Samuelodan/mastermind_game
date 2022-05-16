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
end
