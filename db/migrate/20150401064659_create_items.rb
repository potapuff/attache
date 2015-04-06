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

    execute "DROP TYPE IF EXISTS item_types;"
    execute "CREATE TYPE item_types AS ENUM ('#{Item::SUB_TYPES.values.join("','")}');"
    execute "ALTER TABLE items DROP type;"
    execute "ALTER TABLE items ADD type item_types;"

  end
end
