# Boards are represented by bitboards like this
#
#   0  0  0  0  0  0  0  TOP (where discs are thrown)
#   5 12 19 26 33 40 47
#   4 11 18 25 32 39 46
#   3 10 17 24 31 38 45
#   2  9 16 23 30 37 44
#   1  8 15 22 29 36 43
#   0  7 14 21 28 35 42  BOTTOM
#
class Board < ActiveRecord::Base
  ROWS = 6
  COLS = 7

  def reset_board!
    self.bitboard = "0" * ((ROWS + 1) * COLS)
    self.save
  end

  # To ease showing this in the views
  # convert the bitboard representation to an array
  def to_a(flipped = false)
    # Create empty board array
    board = Array.new(ROWS)
    board = board.map { |r| Array.new(COLS, 0) }

    # Fill with data from bitboard
    self.bitboard.length.times do |position|
      row = position % (ROWS + 1)
      col = position / COLS
      col = flipped ? (COLS - col - 1) : col

      # We don't care about the top row
      next if row == 6

      board[ROWS-row-1][col] = self.bitboard[position].to_i
    end

    return board
  end

  def check_win
    # Get the real number to do binary ops to it
    board = self.bitboard.to_i(2)

    y = board & (board >> 6)
    return true if y & (y >> 2 * 6) != 0 # check \ diagonal

    y = board & (board >> 7)
    return true if y & (y >> 2 * 7) != 0 # check horizontal

    y = board & (board >> 8)
    return true if y & (y >> 2 * 8) != 0 # check / diagonal

    y = board & (board >> 1)
    return true if y & (y >> 2) != 0 # check vertical

    return false
  end
end
