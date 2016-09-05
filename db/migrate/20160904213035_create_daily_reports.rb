class CreateDailyReports < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_reports do |t|
      t.date :date
      t.integer :poopy_diapers
      t.integer :wet_diapers
      t.text :bullying_report
      t.text :ouch_report
      t.integer :child_id
      t.boolean :bullying_incident
      t.boolean :ouch_incident

      t.timestamps
    end
  end
end
