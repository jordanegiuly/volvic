class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :screen_name
      t.text :content

      t.timestamps
    end
  end
end
