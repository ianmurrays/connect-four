class AddTurnToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :turn, :boolean
  end
end
