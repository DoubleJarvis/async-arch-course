# frozen_string_literal: true

class DeviseCreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      ## Database authenticatable (DataModel.User.AuthInfo)
      t.string :email,              null: false, default: "" # посчитаем email за имя попуга для простоты
      t.string :encrypted_password, null: false, default: ""

      t.uuid :public_id, default: "gen_random_uuid()", null: false

      # DataModel.User.Role
      t.string :role, null: false, default: 'employee'
      
      t.timestamps null: false
    end

    add_index :accounts, :email,                unique: true
  end
end
