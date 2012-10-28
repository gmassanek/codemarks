class TextRecord < ActiveRecord::Base
  has_many :codemark_records, :as => :resource
end
