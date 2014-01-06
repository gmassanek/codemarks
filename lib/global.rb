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

  def self.track(*args)
    return unless Rails.env == 'production'
    Analytics.track(*args)
  end

  def initialize
    @markdown = Redcarpet::Markdown.new(CodemarkMarkdownRenderer.new(:escape_html => true),
                                        :autolink => true,
                                        :space_after_headers => true,
                                        :hard_wrap => true,
                                        :fenced_code_blocks => true,
                                        :no_intra_emphasis => true,
                                        :superscript => true)
  end
end
