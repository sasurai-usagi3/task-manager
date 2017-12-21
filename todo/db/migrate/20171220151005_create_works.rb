class CreateWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :works do |t|
      t.references :project, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.integer :amount, null: false, default: 0

      t.timestamps
    end
  end
end
