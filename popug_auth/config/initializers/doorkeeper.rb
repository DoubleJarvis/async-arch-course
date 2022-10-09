
Doorkeeper.configure do
  orm :active_record

  resource_owner_authenticator do
    Account.find_by(id: session['warden.user.account.key'].first.first) || redirect_to(new_account_session_path)
  end

  admin_authenticator do
    redirect_to sign_in_url unless current_account

    head :forbidden unless current_account.admin?
  end

  grant_flows %w[authorization_code client_credentials]

  skip_authorization do
    true
  end
end
