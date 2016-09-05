class ChangeColumnInChildren < ActiveRecord::Migration[5.0]
  def change
    change_column :children, :bully_rating, :integer, default: 0
    change_column :children, :ouch_rating, :integer, default: 0
  end
end
