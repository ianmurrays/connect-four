class UsersController < ApplicationController
  def show
    @player = params[:id]

    # Generate a 6x7 board with zeroes
    @board = Array.new(6, Array.new(7, 0))
  end
end
