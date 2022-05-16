# frozen_string_literal: false

# creates new boards
class Board
  attr_reader :all_colors
  attr_accessor :current_guess

  def initialize
    @all_colors = %w[red yellow green blue brown purple]
    @current_guess = nil
  end
  
end