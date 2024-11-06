ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def sign_in_as(user)
    post(sign_in_url, params: { email: user.email, password: "Secret1*3*5*" })
    session = Session.create!(user: user)
    Current.session = session
    user
  end
end

class ActionDispatch::SystemTestCase
  def sign_in_as(user)
    visit sign_in_url

    fill_in "Email", with: user.email
    fill_in "Password", with: "Secret1*3*5*"
    click_button "Sign in"

    assert_current_path root_path

    assert_text user.name

    user
  end
end
