class CreateChildren < ActiveRecord::Migration[5.0]
  def change
    create_table :children do |t|
      t.string :last_name
      t.string :first_name
      t.date :birthdate
      t.integer :diapers_inventory
      t.integer :bully_rating
      t.integer :ouch_rating

      t.timestamps
    end
  end
end
