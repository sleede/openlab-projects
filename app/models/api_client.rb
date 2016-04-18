class ApiClient < ApplicationRecord
  has_many :calls_count_tracings, dependent: :destroy

  has_secure_token :api_id
  has_secure_token :api_secret

  validates :name, :origin, presence: true

  def increment_calls_count
    update_column(:calls_count, calls_count+1)
  end
end
