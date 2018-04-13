class AddFiltersToFeed < ActiveRecord::Migration[5.1]
  def change
    add_column :feeds, :senders, :text
    add_column :feeds, :subjects, :text
    add_column :feeds, :bodies, :text
    add_column :feeds, :body_pre_filter, :string
  end
end
