class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :user_id
      t.integer :bitboard, limit: 8

      t.timestamps
    end
  end
end
