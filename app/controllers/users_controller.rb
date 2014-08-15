class UsersController < ApplicationController
  before_filter :ensure_boards!
  before_filter :load_boards

  def show
    @turn = @player_one.turn ? 1 : 2
  end

  def play
    # Where was the disc dropped?
    column = params[:column].to_i

    # Drop into the correct column for our board
    board    = @player == 1 ? @player_one : @player_two
    opponent = @player == 1 ? @player_two : @player_one

    # play will return if the play is valid (column might be full)
    @play = board.play!(column, opponent)

    # Did we win?
    if board.check_win
      @win = true

      Pusher['moves'].trigger('win', {
        user_id: @player
      })
    end

    respond_to do |f|
      f.js
    end
  end

  def reset
    @player_one.reset_board!
    @player_two.reset_board!

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

  # Do we have the boards created?
  def ensure_boards!
    if Board.count != 2
      Board.destroy_all

      board_1 = Board.create user_id: 1
      board_2 = Board.create user_id: 2

      board_1.reset_board!
      board_2.reset_board!
    end
  end
end
