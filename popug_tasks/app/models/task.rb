class Task < ApplicationRecord
  belongs_to :account

  STATUSES = %w[started finished]

  enum status: STATUSES, _default: "started"

  def reassign
    update(account: Account.employee.random)
  end
end
