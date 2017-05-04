class Headway
  class PersistQueryEvents

    TRACKED_COMMANDS = %w[SELECT]
    TRACKED_COMMANDS_REGEXP = /\A#{TRACKED_COMMANDS.join('|')}/i

    TRACKED_PATHS = %w[app lib]
    TRACKED_PATHS_REGEXP ||= %r{^(#{TRACKED_PATHS.join('|')})\/}

    def self.call(events)
      queries = {}

      events.each do |request_id, _, started, finished, _, payload, trace|
        sql = payload[:sql].dup
        next unless track?(sql)

        cleaned_trace = clean_trace(trace)
        next if cleaned_trace.empty?

        sql = clean_sql(sql)
        duration = 1000.0 * (finished - started) # milliseconds
        sql_key = Digest::MD5.hexdigest(sql.downcase)

        binds = payload[:binds].map { |column, value|
          column = column.name if column.respond_to?(:name)
          [column, value]
        }

        if queries.key?(sql_key)
          queries[sql_key][:count]    += 1
          queries[sql_key][:duration] += duration
          queries[sql_key][:trace]    << cleaned_trace.first
          queries[sql_key]
        else
          queries[sql_key] = {
            request_id: request_id,
            sql:        sql,
            count:      1,
            duration:   duration,
            trace:      [cleaned_trace.first],
            binds:      binds
          }
        end
      end

      queries.values.each do |query|
        PersistQueryJob.perform_async(query)
      end
    end

    private

    def self.track?(sql)
      TRACKED_COMMANDS_REGEXP =~ sql
    end

    def self.clean_trace(trace)
      return trace unless defined?(::Rails)

      if Rails.backtrace_cleaner.instance_variable_get(:@root) == '/'
        Rails.backtrace_cleaner.instance_variable_set :@root, Rails.root.to_s
      end

      Rails.backtrace_cleaner.remove_silencers!

      if TRACKED_PATHS.respond_to?(:join)
        Rails.backtrace_cleaner.add_silencer do |line|
          line !~ TRACKED_PATHS_REGEXP
        end
      end

      Rails.backtrace_cleaner.clean(trace)
    end

    def self.clean_sql(query)
      query.squish!
      #query.gsub!(/(\s(=|>|<|>=|<=|<>|!=)\s)('[^']+'|[\$\+\-\w\.]+)/, '\1xxx')
      #query.gsub!(/(\sIN\s)\([^\(\)]+\)/i, '\1(xxx)')
      #query.gsub!(/(\sBETWEEN\s)('[^']+'|[\+\-\w\.]+)(\sAND\s)('[^']+'|[\+\-\w\.]+)/i, '\1xxx\3xxx')
      #query.gsub!(/(\sVALUES\s)\(.+\)/i, '\1(xxx)')
      #query.gsub!(/(\s(LIKE|ILIKE|SIMILAR TO|NOT SIMILAR TO)\s)('[^']+')/i, '\1xxx')
      #query.gsub!(/(\s(LIMIT|OFFSET)\s)(\d+)/i, '\1xxx')
      query
    end

  end
end
