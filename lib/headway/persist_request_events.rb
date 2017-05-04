class Headway
  class PersistRequestEvents

    def self.call(events)
      events.each do |request_id, _, started, finished, _, payload|
        PersistRequestJob.perform_async(
          id:         request_id,
          controller: payload[:controller],
          action:     payload[:action],
          format:     payload[:format],
          method:     payload[:method],
          path:       payload[:path],
          params:     payload[:params],
          started_at: started
        )
      end
    end

  end
end
