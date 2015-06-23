class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.boolean :utility_words
      t.integer :word_count_min
      t.string :query_string
      t.references :user

      t.timestamps null: false
    end
  end
end
