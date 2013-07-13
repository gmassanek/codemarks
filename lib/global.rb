require 'singleton'

class Global
  include Singleton
  attr_accessor :markdown

  def self.markdown
    instance.markdown
  end

  def self.render_markdown(text)
    markdown.render(text)
  end

  def initialize
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:escape_html => true),
                                        :autolink => true,
                                        :space_after_headers => true,
                                        :hard_wrap => true,
                                        :fenced_code_blocks => true,
                                        :no_intra_emphasis => true,
                                        :superscript => true)
  end
end
