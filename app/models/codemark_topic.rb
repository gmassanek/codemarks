class CodemarkTopic < ActiveRecord::Base

  belongs_to :codemark_record
  belongs_to :topic

end
