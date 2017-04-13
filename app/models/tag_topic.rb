class TagTopic < ApplicationRecord
  validates :tags, presence: true, uniqueness: true

  has_many :taggings,
    primary_key: :id,
    foreign_key: :tag_id,
    class_name: :Tagging

  has_many :urls,
  Proc.new { distinct },
  through: :taggings,
  source: :tagged_url

  def popular_links
    result = []
    self.urls.each do |url|
      result << [url.short_url, url.num_clicks]
    end
    result.sort{|x,y| y[1] <=> x[1]}
  end
end
