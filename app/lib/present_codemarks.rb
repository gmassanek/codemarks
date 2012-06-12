class PresentCodemarks
  def self.for(codemarks)
    codemarks.map {|codemark|  present(codemark) }
  end

  def self.present(codemark)
    {
      :id => codemark.id,
      :title => codemark.title,
      :topics => codemark.topics
    }
  end
end
