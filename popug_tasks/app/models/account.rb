class Account < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[popug_auth]

  ROLES = {
    employee: 'employee',
    admin: 'admin',
    manager: 'manager',
    accountant: 'accountant'
  }
  
  enum role: ROLES

  has_many :tasks

  def administrative_role?
    admin? || manager?
  end
  
  def self.random
    reorder('random()').limit(1).first
  end
end
