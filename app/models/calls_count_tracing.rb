class CallsCountTracing < ApplicationRecord
  belongs_to :api_client
  validates :api_client, :at, :calls_count, presence: true
end
