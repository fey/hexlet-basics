# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

OmniAuth.config.test_mode = true
OmniAuth.config.request_validation_phase = OmniAuth::AuthenticityTokenProtection.new(allow_if: ->(_env) { true })

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  parallelize(workers: :number_of_processors)

  fixtures :all

  def setup
    queue_adapter.perform_enqueued_jobs = true
    queue_adapter.perform_enqueued_at_jobs = true
  end
end

# class ActionController::TestCase
#   setup do
#     request.host = "#{I18n.locale}.#{configus.host}"
#   end

#   teardown do
#     request.host = "#{I18n.locale}.#{configus.host}"
#   end
# end

class ActionDispatch::IntegrationTest
  include AuthConcern

  def sign_in_as(name)
    user = users(name)

    post session_url(subdomain: I18n.locale), params: { sign_in: { email: user.email, password: 'password' } }
    user
  end
end
