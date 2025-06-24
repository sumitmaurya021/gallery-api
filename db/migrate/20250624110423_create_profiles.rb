class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :name, null: true
      t.string :address, null: true
      t.string :age, null: true
      t.string :gender, null: true
      t.string :location, null: true
      t.string :number, null: true
      t.string :instagram, null: true
      t.string :facebook, null: true
      t.string :twitter, null: true
      t.string :dob, null: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
