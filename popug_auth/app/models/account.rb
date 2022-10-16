class Account < ApplicationRecord
  devise :database_authenticatable, :registerable

  ROLES = {
    employee: 'employee',
    admin: 'admin',
    manager: 'manager',
    accountant: 'accountant'
  }
  
  enum role: ROLES

  has_many :access_grants,
    class_name: 'Doorkeeper::AccessGrant',
    foreign_key: :resource_owner_id,
    dependent: :delete_all

  has_many :access_tokens,
    class_name: 'Doorkeeper::AccessToken',
    foreign_key: :resource_owner_id,
    dependent: :delete_all

  after_create do
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'auth_service',
      event_name: 'AccountCreated',
      data: event_data
    }

    result = SchemaRegistry.validate_event(event, 'accounts.created', version: 1)
    if result.success?
      KAFKA_PRODUCER.produce_sync(payload: event.to_json, topic: 'accounts-stream')
    else
      # Sentry.notify("Cannot produce AccountCreated #{result.failure.to_json}")
    end
  end

  def event_data
    # Reload because public_id is not being filled on AR object automatically 
    reload.as_json(only: %i[public_id email role])
  end
end
