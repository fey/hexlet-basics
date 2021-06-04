# frozen_string_literal: true

require 'test_helper'

class Web::Account::ProfilesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :full
    sign_in_as(:full)
  end

  test 'edit' do
    get edit_account_profile_url(subdomain: I18n.locale)

    assert_response :success
  end

  test 'update' do
    new_name = 'new first name'

    patch account_profile_url(@user, subdomain: I18n.locale), params: {
      user_profile_form: {
        first_name: new_name
      }
    }

    @user.reload

    assert { @user.first_name = new_name }
  end

  test 'destroy' do
    delete account_profile_url

    assert_response :redirect

    @user.reload

    assert { @user.removed? }
    assert { !signed_in? }
  end
end
