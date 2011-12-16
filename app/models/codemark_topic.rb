class CodemarkTopic < ActiveRecord::Base

  belongs_to :codemark, :class_name => 'LinkSave'
  belongs_to :topic

end
