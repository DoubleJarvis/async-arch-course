class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.integer :cost
      t.integer :reward
      t.string :description
      t.string :status
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
