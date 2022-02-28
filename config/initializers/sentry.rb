Sentry.init do |config|
  config.excluded_exceptions += ['Pundit::NotAuthorizedError', 'SocketError']

  config.before_send = lambda do |event, hint|
    if hint[:exception].is_a?(Redis::CommandError) && hint[:exception].message == "LOADING Redis is loading the dataset in memory"
      nil
    else
      event
    end
  end

  if Rails.application.secrets.sentry_turned_on.present?
    config.dsn = Rails.application.secrets.sentry_dsn
  end

  config.breadcrumbs_logger = [:active_support_logger]

  config.traces_sample_rate = 0.1

  if Rails.application.secrets.sentry_environment.present?
    config.environment = Rails.application.secrets.sentry_environment
  end
end
