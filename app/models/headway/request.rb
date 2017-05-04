class Headway
  class Request < ApplicationRecord
    has_many :queries, dependent: :destroy

    validates_presence_of :controller, :action, :format, :method, :path, :started_at

    scope :order_by_recency, -> { order("started_at DESC NULLS LAST") }

    def count_queries
      queries.sum(:count)
    end

    def total_query_duration
      queries.sum(:duration)
    end
  end
end
