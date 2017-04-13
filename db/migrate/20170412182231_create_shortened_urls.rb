class CreateShortenedUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :shortened_urls do |t|
      t.string :short_url, null: false
      t.text :long_url, null: false
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
