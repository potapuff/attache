class CreateAnswers < ActiveRecord::Migration
  def change

    create_table :answers do |t|
      t.integer :item_id
      t.string :session_id
      t.integer :number
      t.text :text

      t.timestamps null: false
    end
  end
end
