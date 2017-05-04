class CreateHeadwayRequest < ActiveRecord::Migration
  def change
    create_table :headway_requests, id: :uuid do |t|
      t.string :controller,    null: false
      t.string :action,        null: false
      t.string :format,        null: false
      t.string :method,        null: false
      t.string :path,          null: false
      t.json   :params

      t.timestamps null: false
    end
  end
end
