class UsersController < ApplicationController
  def show
    @player = params[:id].to_i

    # Get this player's board
    @player_one = Board.find_by_user_id(1)
    @player_one_array = @player_one.to_a(@player == 2)

    # Get the other player's board, flipped
    @player_two = Board.find_by_user_id(2)
    @player_two_array = @player_two.to_a(@player == 1)
  end
end
