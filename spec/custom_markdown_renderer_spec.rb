require 'spec_helper'

describe CodemarkMarkdownRenderer do
  before do
    @markdown = Global.markdown
  end

  it 'does default rendering' do
    @markdown.render('paragraph').should == "<p>paragraph</p>\n"
  end

  it 'embeds links to external CM Links' do
    link = Fabricate(:link)
    codemark = Fabricate(:codemark, :title => 'Foobar', :resource => link)
    @markdown.render("paragraph referencing [CM#{codemark.id}]").should == "<p>paragraph referencing <a href='#{link.url}' class='embedded_cm' target='_blank'>Foobar</a></p>\n"
  end

  it 'embeds links to CM Textmarks' do
    textmark = Text.create!(:text => 'Woohoo')
    codemark = Fabricate(:codemark, :title => 'Foobar', :resource => textmark)
    @markdown.render("paragraph referencing [CM#{codemark.id}]").should == "<p>paragraph referencing <a href='/codemarks/#{codemark.id}' class='embedded_cm' target='_blank'>Foobar</a></p>\n"
  end

  it 'lets you override title' do
    textmark = Text.create!(:text => 'Woohoo')
    codemark = Fabricate(:codemark, :title => 'Foobar', :resource => textmark)
    @markdown.render("paragraph referencing [CM#{codemark.id} Title Override 2]").should == "<p>paragraph referencing <a href='/codemarks/#{codemark.id}' class='embedded_cm' target='_blank'>Title Override 2</a></p>\n"
  end
end
