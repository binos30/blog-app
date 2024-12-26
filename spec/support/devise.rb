# frozen_string_literal: true

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :helper
  config.include Devise::Test::ControllerHelpers, type: :view
end
