class PresentComments
  def self.present(comments)
    new(comments).present_all
  end

  def initialize(comments = nil)
    @comments = comments
  end

  def present_all
    @comments.map { |c| present(c) }
  end

  def present(comment)
    {
      :id => comment.id,
      :body => comment.body,
      :html_body => Global.render_markdown(comment.body),
      :parent_id => comment.parent_id,
      :created_at => comment.created_at,
      :updated_at => comment.updated_at,
      :lft => comment.lft,
      :rgt => comment.rgt,
      :num_children => comment.num_children,
      :user => PresentUsers.present(comment.user)
    }
  end
end
