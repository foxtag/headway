class CreateHeadwayQuery < ActiveRecord::Migration
  def change
    create_table :headway_queries, id: :uuid do |t|
      t.uuid :request_id,  null: false

      t.text    :sql,      null: false
      t.integer :count,    null: false
      t.float   :duration, null: false

      t.text :trace, array: true, default: []
      t.text :binds, array: true, default: []

      t.text :explain

      t.timestamps null: false

      t.index :request_id
    end
  end
end
