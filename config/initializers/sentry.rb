Sentry.init do |config|
  # config.dsn = Rails.application.credentials.dig(:sentry_dsn)
  config.dsn = "https://880c61cc3623436ebb61ad391cee4547@o4505363632881664.ingest.sentry.io/4505363635175424"
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
  config.enabled_environments = %w[production]
end
