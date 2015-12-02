class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.text :content, null: false
      t.text :hastags, null: true
      t.text :links, null: true
      t.text :mentions, null: true

      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
