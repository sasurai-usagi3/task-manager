class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.references :creator, null: false, foreign_key: {to_table: :users}
      t.string :name, null: false
      t.string :description

      t.timestamps
    end
  end
end
