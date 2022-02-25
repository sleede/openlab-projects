class ApiClientTraceCallsCountJob < ActiveJob::Base
  def perform
    ApiClient.find_each do |api_client|
      CallsCountTracing.create!(api_client: api_client, calls_count: api_client.calls_count, at: DateTime.now.in_time_zone)
    end
  end
end
