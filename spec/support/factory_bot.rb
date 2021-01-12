# This file will lint your factories before the test suite is run.
# DatabaseCleaner will restore the state of the database after we’ve linted our factories.
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryBot.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end