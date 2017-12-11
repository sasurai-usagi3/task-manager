class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.references :creator, null: false, foreign_key: {to_table: :users}
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
