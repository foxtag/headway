class Headway
  class Engine < ::Rails::Engine
    isolate_namespace Headway

    config.i18n.load_path += Dir[config.root.join("config", "locales", "*.{rb,yml}").to_s]
    config.i18n.default_locale = :en

    # Include Engine migrations in Applicaton migrations.
    initializer "headway", before: :load_config_initializers do |app|
      config.paths["db/migrate"].expanded.each do |expanded_path|
        Rails.application.config.paths["db/migrate"] << expanded_path
      end
    end

    ActiveSupport::Notifications.subscribe "start_processing.action_controller" do |*args|
      Headway.set_request_id
    end

    ActiveSupport::Notifications.subscribe "sql.active_record" do |*args|
      next unless Headway.instrument_request?
      Headway.query_events << [Headway.request_id, *args, caller]
    end

    ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
      next unless Headway.instrument_request?

      Headway.request_events << [Headway.request_id, *args]
      Headway.persist_events
    end

    # Required due to bokmann/font-awesome-rails#130
    require "font-awesome-rails"
  end
end
