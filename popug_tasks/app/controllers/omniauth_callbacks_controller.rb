class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def popug_auth
    account = Account.find_or_create_by!(public_id: auth_hash.dig("info", "public_id")) do |acc|
      acc.role     = auth_hash.dig("info", "role")
      acc.email    = auth_hash.dig("info", "email")
      acc.provider = auth_hash["provider"]
    end
    set_flash_message(:notice, :success, kind: "PopugAuth") if is_navigational_format?

    sign_in account
    redirect_to root_path
  end
  
  def failure
    Rails.logger.warn("Failed to authenticate with omniauth auth_hash: #{auth_hash}")
    redirect_to root_path
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end
