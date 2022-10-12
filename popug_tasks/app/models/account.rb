class Account < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[popug_auth]
end
