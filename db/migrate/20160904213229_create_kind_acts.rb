class CreateKindActs < ActiveRecord::Migration[5.0]
  def change
    create_table :kind_acts do |t|
      t.text :act
      t.integer :daily_report_id
      t.integer :recipient_id
      t.integer :giver_id

      t.timestamps
    end
  end
end
