require "request_store"
require "sucker_punch"

require "headway/engine"
require "headway/persist_request_events"
require "headway/persist_query_events"

class Headway
  def self.table_name_prefix
    "headway_"
  end

  def self.instrument_request
    RequestStore.store[:headway_instrument_request] = true
  end

  def self.instrument_request?
    RequestStore.store[:headway_instrument_request] && request_id
  end

  def self.set_request_id
    RequestStore.store[:headway_request_id] = SecureRandom.uuid
  end

  def self.request_id
    RequestStore.store[:headway_request_id]
  end

  def self.query_events
    RequestStore.store[:headway_query_events] ||= []
  end

  def self.request_events
    RequestStore.store[:headway_request_events] ||= []
  end

  def self.persist_events
    PersistRequestEvents.call(request_events)
    PersistQueryEvents.call(query_events)
  end
end
