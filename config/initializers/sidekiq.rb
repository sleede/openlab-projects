redis_url = "redis://#{Rails.application.secrets.redis_host}:6379"

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end

schedule_file = "config/schedule.yml"

if File.exists?(schedule_file)
  rendered_schedule_file = ERB.new(File.read(schedule_file)).result
  Sidekiq::Cron::Job.load_from_hash YAML.load(rendered_schedule_file)
end
