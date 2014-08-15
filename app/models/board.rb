# Boards are represented by bitboards like this
# (modified algorithm to detect winners of NxN tic-tac-toe
# used here)
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
    self.bitboard = 0
    self.save
  end

  # Special method to get zero-padded bitboard
  def self.binary_string(number)
    sprintf("%.#{COLS * (ROWS + 1)}b", number)
  end

  # To ease showing this in the views
  # convert the bitboard representation to an array
  def self.to_a(bitboard, flipped = false)
    # Create empty board array
    board = Array.new(ROWS)
    board = board.map { |r| Array.new(COLS, 0) }

    bitboard = self.binary_string(bitboard)

    # Fill with data from bitboard
    bitboard.length.times do |position|
      row = position % (ROWS + 1)
      col = position / COLS
      col = flipped ? (COLS - col - 1) : col

      # We don't care about the top row
      next if row == 6

      board[ROWS-row-1][col] = bitboard[position].to_i
    end

    return board
  end

  def to_a(flipped = false)
    self.class.to_a(bitboard, flipped)
  end

  # Return false if the play is invalid or an array of
  # [row,col] that was filled.
  def play!(column, opponent_board)
    # Is the column full?
    # Let's grab both boards, bitwise or them and transpose so we can
    # easily sum the column.
    full_board = opponent_board.bitboard | self.bitboard
    full_board = self.class.to_a(full_board)
    full_board = full_board.transpose

    count = full_board[column].inject { |sum, val| sum + val }
    return false if count == ROWS

    # Okay, not full, drop it into the uppermost empty space
    # Again, use the full board, grab the row (which would be the col)
    # and get the index of the leftmost zero of the reversed row.
    row = full_board[column].reverse.index(0)

    new_bitboard = self.class.binary_string(self.bitboard)
    new_bitboard[(column * COLS) + row] = "1"
    self.update_attribute :bitboard, new_bitboard.to_i(2)

    return [ROWS - row - 1, column]
  end

  def check_win
    board = self.bitboard

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
