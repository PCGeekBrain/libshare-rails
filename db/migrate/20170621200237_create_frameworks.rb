class CreateFrameworks < ActiveRecord::Migration
  def change
    create_table :frameworks do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
