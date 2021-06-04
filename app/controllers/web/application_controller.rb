# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include FlashConcern
  include TitleConcern
  include EventConcern

  before_action do
    # TODO: завести определение локали на базе ip
    # results = Geocoder.search(request.remote_ip)

    locale = (current_user.locale || session[:locale] ||
              request.subdomains.first || :ru).to_sym

    if locale == :ru && request.subdomains.empty?
      redirect_to url_for(params.merge(subdomain: locale, only_path: false).permit!)
    end

    if locale == :en && request.subdomains.any?
      redirect_to url_for(params.merge(subdomain: nil, only_path: false).permit!)
    end

    I18n.locale = locale
  end

  before_action do
    gon.current_user = {
      id: current_user.id,
      email: current_user.email,
      created_at: current_user.created_at,
      is_guest: current_user.guest?
    }

    gon.locale = I18n.locale
    gon.events = EventsMapping.events
  end
end
