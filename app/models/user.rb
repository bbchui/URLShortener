class User < ActiveRecord::Base
  validates :email, :presence => true, :uniqueness => true

  has_many :submitted_urls,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :ShortenedUrl

  has_many :visits,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :Visit

  has_many :visited_urls,
  Proc.new { distinct },
  through: :visits,
  source: :visit_url


  def generate_short_url(long)
    short = ShortenedUrl.random_code
    ShortenedUrl.create!(short_url: short, long_url: long, user_id: self.id)
  end




end
