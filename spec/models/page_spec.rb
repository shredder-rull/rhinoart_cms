require 'rails_helper'

describe Rhinoart::Page do

  describe 'Contents' do

    it 'builds main content by default' do
      page = Rhinoart::Page.new(name: 'Page', content: 'Page Content')
      expect(page.contents.first).to be
    end

    it 'returns main content by default' do
      page = create(:page, content: nil, contents: [build(:page_content, name: 'main_content')] )
      expect(page.content).to eq(page.contents.first.content)
    end

    it 'returns content by name' do
      page = create(:page, contents: [build(:page_content, name: 'some_content')])
      expect(page.content('some_content')).to eq(page.contents.find_by(name: 'some_content').content)
    end

  end

  describe 'Slug' do

    it 'generates slug from name' do
      page = create(:page, name: 'Page Title' )
      expect(page.slug).to eq('page-title')
    end

    it 'generates slug from name and parent slug' do
      page = create(:page, name: 'Page Title' )
      subpage = create(:page, parent: page, name: 'Sub Page Title' )
      expect(subpage.slug).to eq('page-title/sub-page-title')
    end

  end

end