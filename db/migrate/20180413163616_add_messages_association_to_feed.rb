class AddMessagesAssociationToFeed < ActiveRecord::Migration[5.1]
  def self.up
      add_column :messages, :feed_id, :integer
      add_index 'messages', ['feed_id'], :name => 'index_feed_id' 
  end

  def self.down
      remove_column :messages, :feed_id
  end

end
