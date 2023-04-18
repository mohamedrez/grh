Capybara.register_driver :remote_selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--window-size=1400,1400")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://#{ENV["SELENIUM_HOST"]}:4444/wd/hub",
    options: options,
  )
end

Capybara.register_driver :remote_selenium_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")
  options.add_argument("--window-size=1400,1400")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://#{ENV["SELENIUM_HOST"]}:4444/wd/hub",
    options: options,
  )
end

Capybara.register_driver :local_selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--window-size=1400,1400")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.register_driver :local_selenium_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")
  options.add_argument("--window-size=1400,1400")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

selenium_app_host = ENV.fetch("SELENIUM_APP_HOST") do
  Socket.ip_address_list
        .find(&:ipv4_private?)
        .ip_address
end

Capybara.configure do |config|
  config.server = :puma, { Silent: true }
  config.server_host = '0.0.0.0'
  config.server_port = 4000
  config.app_host = "http://#{selenium_app_host}:#{config.server_port}"
end


RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    # `Capybara.app_host` is reset in the RSpec before_setup callback defined
    # in `ActionDispatch::SystemTesting::TestHelpers::SetupAndTeardown`, which
    # is annoying as hell, but not easy to "fix". Just set it manually every
    # test run.
    Capybara.app_host = "http://#{selenium_app_host}:#{Capybara.server_port}"

    # Allow Capybara and WebDrivers to access network if necessary
    driver = if example.metadata[:js]
        locality = ENV["SELENIUM_HOST"].present? ? :remote : :local
        headless = "_headless" if ENV["DISABLE_HEADLESS"].blank?
        puts "#{locality}_selenium#{headless}".to_sym
        "#{locality}_selenium#{headless}".to_sym
      else
        :rack_test
      end

    driven_by driver
  end
end
