class Headway
  class PersistRequestJob
    include SuckerPunch::Job

    def perform(attributes)
      puts 'request perform'
      ActiveRecord::Base.connection_pool.with_connection do
        puts 'creating request'
        Request.create!(attributes)
      end
    end

  end
end
