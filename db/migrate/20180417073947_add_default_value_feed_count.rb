class AddDefaultValueFeedCount < ActiveRecord::Migration[5.1]
  def change
    change_column :feeds, :count, :integer, default: 5
  end
end
