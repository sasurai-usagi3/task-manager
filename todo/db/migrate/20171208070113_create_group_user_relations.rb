class CreateGroupUserRelations < ActiveRecord::Migration[5.1]
  def change
    create_table :group_user_relations do |t|
      t.references :group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :authority, null: false, default: 0

      t.timestamps
    end
  end
end
