class UsersController < ApplicationController
  before_filter :load_boards

  def show
  end

  def play
    # Where was the disc dropped?
    column = params[:column].to_i

    # Drop into the correct column for our board
    board    = @player == 1 ? @player_one : @player_two
    opponent = @player == 1 ? @player_two : @player_one

    # play will return if the play is valid (column might be full)
    @play = board.play!(column, opponent)

    respond_to do |f|
      f.js
    end
  end

  private

  def load_boards
    @player = params[:id].to_i

    # Get this player's board
    @player_one = Board.find_by_user_id(1)
    @player_one_array = @player_one.to_a

    # Get the other player's board, flipped
    @player_two = Board.find_by_user_id(2)
    @player_two_array = @player_two.to_a
  end
end
