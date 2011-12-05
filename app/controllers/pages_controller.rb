class PagesController < ApplicationController

  autocomplete :topic, :title, :full => true, :extra_data => [:slug]

  def about

  end

end
