class User < ActiveRecord::Base

  extend FriendlyId
  friendly_id :nickname, :use => :slugged

  has_many :authentications, :dependent => :destroy
  has_many :codemark_records, :dependent => :destroy
  has_many :links, :through => :codemark_records
  has_many :topics, :through => :codemark_records
  has_many :clicks

  has_many :nuggets, :class_name => 'LinkRecord', :foreign_key => :author_id

  after_save :take_nickname_from_authentication

  validates_uniqueness_of :nickname

  def self.find_by_email email
    id = User.select('users.id')
      .joins('LEFT JOIN authentications on users.id = authentications.user_id')
      .where(['users.email = ? OR authentications.email = ?', email, email])
      .group('users.id')
      .limit(1)
      .first
    User.find_by_id(id)
  end

  def self.find_by_authentication(provider, nickname)
    User.find(:first,
              :joins => :authentications,
              :conditions => {:authentications => {:provider => provider, :nickname => nickname}}
             )
  end

  def take_nickname_from_authentication
    if self.nickname.nil?
      nickname = authentications.first.nickname
      self.nickname = nickname
      self.save!
    end
  end

  def authentication_by_provider(provider)
    authentications.find { |a| a.provider.to_s == provider.to_s }
  end

  def missing_authentications
    current_providers = authentications.collect(&:provider)
    missing = Authentication.providers.reject! do |provider|
      current_providers.include?(provider.to_s)
    end
    missing
  end

  def codemark_for link
    codemarks.for(link).first
  end

  def get attr
    val = self.send attr
    if val
      return val
    else
      auth_vals = authentications.collect { |auth| auth.send attr }
      return auth_vals.compact.first
    end
  end

  def favorite_topics
    favorite_topic_counts = topics.group('topics.id').select('topics.id, count(*)').order('count desc').first(15)
    return unless favorite_topic_counts.present?

    favorites = {}
    topics = Topic.find(favorite_topic_counts.map(&:id))
    Array(favorite_topic_counts).each do |topic_count|
      topic = topics.find { |t| t.id == topic_count.id }
      favorites[topic] = topic_count.count.to_i
    end
    favorites
  end
end
