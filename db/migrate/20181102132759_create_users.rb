class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :identifier
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :username

      t.timestamps
    end

    add_index :users, :identifier, unique: true
  end
end
