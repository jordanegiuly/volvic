class CreateDiffbotApis < ActiveRecord::Migration
  def change
    create_table :diffbot_apis do |t|
      t.text :url
      t.text :response

      t.timestamps
    end
  end
end
