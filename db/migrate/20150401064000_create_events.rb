class CreateEvents < ActiveRecord::Migration
  def change
    create_table(:events) do |t|
      t.string :uid
      t.integer :pair
      t.date :date
      t.string :name_aud
      t.string :name_group
      t.string :abbr_disc
      t.string :name_stud
      t.string :reason
      t.string :stud_type_id
      t.integer :tutor_id
      t.string :info

      t.timestamps null: false
    end
  end
end
