class CreateMinituits < ActiveRecord::Migration
  def change
    create_table :minituits do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :minituits, [:user_id, :created_at]
  end
end
