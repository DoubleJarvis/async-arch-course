class Task < ApplicationRecord
  belongs_to :account

  STATUSES = %w[started finished]

  enum status: STATUSES, _default: "started"

  def reassign
    update(account: Account.employee.random)
  end

  def event_data
    as_json(only: %i[status description cost reward]).merge(account_public_id: account.public_id)
  end
end
