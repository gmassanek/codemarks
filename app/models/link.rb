class Link < ActiveRecord::Base
  validates_presence_of :url, :site_content, :host, :title
end
#scope :for, lambda { |codemarks| joins(:codemarks).where(['codemarks.id in (?)', codemarks]) }
