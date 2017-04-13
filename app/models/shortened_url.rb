require 'byebug'
class ShortenedUrl < ApplicationRecord
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, :user_id, presence: true
  validate :no_spamming
  validate :non_premium_max

  belongs_to :submitter,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :User

  has_many :visits,
  primary_key: :id,
  foreign_key: :url_id,
  class_name: :Visit

  has_many :visitors,
  Proc.new { distinct },
  through: :visits,
  source: :visitor

  has_many :taggings,
  primary_key: :id,
  foreign_key: :url_id,
  class_name: :Tagging

  has_many :tags,
  through: :taggings,
  source: :tag


  def self.random_code
    random_string = SecureRandom.urlsafe_base64
    until ShortenedUrl.exists?(random_string) == false
      random_string = SecureRandom.urlsafe_base64
    end
    random_string
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    self.visitors.where("visits.created_at > ?", 10.minutes.ago)
  end

  def no_spamming
    submitter = self.submitter.submitted_urls
    submitter_count = submitter.where("shortened_urls.created_at > ?", 2.minute.ago).count

    if submitter_count > 5
      errors[:submitter_count] << "NO SPAMMING"
    end
  end

  def non_premium_max
    submitter_count = self.submitter.submitted_urls.count
    if submitter_count > 5 && !self.submitter.premium
      errors[:submitter_count] << "gotta spit the dough babe"
    end
  end

  def self.prune(n)
    url_arr = ShortenedUrl.all.where("shortened_urls.created_at < ?", 100.minutes.ago)
    visit_count = url_arr.map {|url| [url, url.visits.where("visits.created_at > ?", n.minutes.ago).count]}
    pruners = visit_count.select {|url| url[0] if url[1] == 0}
    pruners.each {|url| ShortenedUrl.destroy(url[0].id)}

    ShortenedUrl.all.count
  end

end
