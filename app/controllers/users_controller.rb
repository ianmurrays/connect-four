class UsersController < ApplicationController
  def show
    @player = params[:id]

    # Get this player's board
    @board = Board.find_by_user_id(@player)
    @board_array = @board.to_a
  end
end
