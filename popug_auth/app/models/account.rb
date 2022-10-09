class Account < ApplicationRecord
  devise :database_authenticatable, :registerable
end
