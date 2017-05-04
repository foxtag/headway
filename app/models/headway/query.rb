class Headway
  class Query < ApplicationRecord
    belongs_to :request
    validates_presence_of :request_id, :sql, :count, :duration

    scope :order_by_recency, -> { order(created_at: :desc) }

    def explain!
      db = self.class.connection

      binds = []
      if self.binds.any?
        columns = db.columns("headway_queries")

        binds = self.binds.map { |column_name, value|
          [columns.find { |column| column.name == column_name }, value]
        }
      end

      result = db.exec_query("EXPLAIN ANALYZE #{sql}", nil, binds)
      explain = result.rows.flatten.join("\n")

      update_attribute(:explain, explain)
    end
  end
end
