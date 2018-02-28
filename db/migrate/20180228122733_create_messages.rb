class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :from
      t.string :to
      t.string :subject
      t.string :body

      t.timestamps
    end
  end
end
