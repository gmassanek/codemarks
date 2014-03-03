require 'spec_helper'

describe CodemarkMarkdownRenderer do
  before do
    @markdown = Global.markdown
  end

  it 'does default rendering' do
    @markdown.render('paragraph').should == "<p>paragraph</p>\n"
  end

  describe 'embedding codemarks' do
    it 'recognizes raw codemarks/show links and embeds them' do
      link = Fabricate(:link)
      codemark = Fabricate(:codemark, :title => 'Foobar', :resource => link)
      @markdown.render("paragraph referencing http://codemarks.com/codemarks/#{codemark.id}").should ==
        "<p>paragraph referencing <a href=\"/codemarks/#{codemark.id}\" class=\"embedded_cm\">Foobar</a></p>\n"
    end

    describe 'links' do
      it 'link externally' do
        link = Fabricate(:link)
        codemark = Fabricate(:codemark, :title => 'Foobar', :resource => link)
        @markdown.render("paragraph referencing [CM#{codemark.id}]").should ==
          "<p>paragraph referencing <a href=\"/codemarks/#{codemark.id}\" class=\"embedded_cm\">Foobar</a></p>\n"
      end

      it 'lets you override embeded CM titles' do
        link = Fabricate(:link)
        codemark = Fabricate(:codemark, :title => 'Foobar', :resource => link)
        @markdown.render("paragraph referencing [CM#{codemark.id} Title Override 2]").should ==
          "<p>paragraph referencing <a href=\"/codemarks/#{codemark.id}\" class=\"embedded_cm\">Title Override 2</a></p>\n"
      end
    end

    describe 'texts' do
      before do
        @textmark = Text.create!(:text => 'Woohoo')
        @codemark = Fabricate(:codemark, :title => 'Foobar', :resource => @textmark)
      end

      it 'link locally' do
        @markdown.render("paragraph referencing [CM#{@codemark.id}]").should ==
          "<p>paragraph referencing <a href=\"/codemarks/#{@codemark.id}\" class=\"embedded_cm\">Foobar</a></p>\n"
      end

      it 'lets you override embeded CM titles' do
        @markdown.render("paragraph referencing [CM#{@codemark.id} Title Override 2]").should ==
          "<p>paragraph referencing <a href=\"/codemarks/#{@codemark.id}\" class=\"embedded_cm\">Title Override 2</a></p>\n"
      end
    end

    describe 'ImageFiles' do
      before do
        @image = ImageFile.new(:attachment => Rails.root.join("spec/fixtures/images/test.png").open)
        VCR.use_cassette 'paperclip', :match_requests_on => [:method, :host] do
          @image.save
        end
        @codemark = Fabricate(:codemark, :title => 'Foobar', :resource => @image)
      end

      it 'turns images into image tags' do
        @markdown.render("paragraph referencing [CM#{@codemark.id}]").should ==
          "<p>paragraph referencing <img alt=\"Test\" src=\"#{@image.attachment.url}\" /></p>\n"
      end

      it 'lets you set width' do
        @markdown.render("paragraph referencing [CM#{@codemark.id} 300]").should ==
          "<p>paragraph referencing <img alt=\"Test\" src=\"#{@image.attachment.url}\" width=\"300\" /></p>\n"
      end

      it 'lets you set width and height' do
        @markdown.render("paragraph referencing [CM#{@codemark.id} 300,500]").should ==
          "<p>paragraph referencing <img alt=\"Test\" height=\"500\" src=\"#{@image.attachment.url}\" width=\"300\" /></p>\n"
      end

      it 'lets you set just height (hacky)' do
        @markdown.render("paragraph referencing [CM#{@codemark.id} ,500]").should ==
          "<p>paragraph referencing <img alt=\"Test\" height=\"500\" src=\"#{@image.attachment.url}\" /></p>\n"
      end
    end
  end
end
