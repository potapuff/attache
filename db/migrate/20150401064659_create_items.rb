class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :event_id
      t.integer :position
      t.string :type
      t.boolean :is_deleted, dafault: false
      t.text :description
      t.json :fields

      t.timestamps null: false
    end
  end
end
