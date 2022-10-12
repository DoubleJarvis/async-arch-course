# frozen_string_literal: true

class DeviseCreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :email,     null: false
      t.string :role,      null: false
      t.uuid   :public_id, null: false
      t.string :provider,  null: false
      
      t.timestamps null: false
    end

    add_index :accounts, :email, unique: true
  end
end
