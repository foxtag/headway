class Headway
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    layout "headway/application"

    http_basic_authenticate_with name: ENV.fetch("SIDEKIQ_USERNAME"),
                                 password: ENV.fetch("SIDEKIQ_PASSWORD")
  end
end
