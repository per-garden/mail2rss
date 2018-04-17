class RemoveFeedBodyPreFilter < ActiveRecord::Migration[5.1]
  def change
    remove_column :feeds, :body_pre_filter
  end
end
