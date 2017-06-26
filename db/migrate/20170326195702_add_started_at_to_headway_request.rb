class AddStartedAtToHeadwayRequest < ActiveRecord::Migration[4.2]
  def change
    change_table :headway_requests do |t|
      t.datetime :started_at
    end
  end
end
