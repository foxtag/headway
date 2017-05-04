class Headway
  class PersistQueryJob
    include SuckerPunch::Job

    def perform(attributes)
      ActiveRecord::Base.connection_pool.with_connection do
        Query.create!(attributes)
      end
    end

  end
end
