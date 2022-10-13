class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.uuid :public_id, default: "gen_random_uuid()", null: false
      
      t.integer :cost
      t.integer :reward
      t.string :description
      t.string :status
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
