class Resource < ActiveRecord::Base
  include ActiveHstore

  has_many :topics, :through => :codemarks
  has_many :codemarks
  has_many :clicks
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id

  acts_as_commentable

  def orphan?
    author_id.blank?
  end

  def update_author(author_id = nil)
    update_attributes(:author_id => author_id) if orphan?
  end

  def suggested_topics
    []
  end
end
