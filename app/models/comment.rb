class Comment < ActiveRecord::Base
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  validates :body, :presence => true
  validates :user, :presence => true

  # NOTE: install the acts_as_votable plugin if you want user to vote on the quality of comments.
  #acts_as_votable

  belongs_to :commentable, :polymorphic => true

  belongs_to :user

  def self.build_from(obj, user_id, comment)
    new({
      :commentable => obj,
      :body        => comment,
      :user_id     => user_id
    })
  end

  def has_children?
    self.children.any?
  end

  def num_children
    (self.rgt - self.lft - 1) / 2
  end

  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }
end
