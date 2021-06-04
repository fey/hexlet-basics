# frozen_string_literal: true

class Web::LocalesController < Web::ApplicationController
  def switch
    locale = params[:locale]
    # redirect_path = request.referer || root_path

    unless I18n.available_locales.include?(locale&.to_sym)
      redirect_back fallback_location: redirect_path
      return
    end

    unless current_user.guest?
      current_user.locale = locale
      current_user.save!
    end

    session[:locale] = locale

    sd = locale == 'en' ? nil : locale
    redirect_to root_url(subdomain: sd)
  end
end
