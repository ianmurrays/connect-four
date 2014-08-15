class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :user_id
      t.bigint :bitboard

      t.timestamps
    end
  end
end
