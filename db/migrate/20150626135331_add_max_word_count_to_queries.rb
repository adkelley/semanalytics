class AddMaxWordCountToQueries < ActiveRecord::Migration
  def change
    add_column :queries, :word_count_max, :integer
  end
end
