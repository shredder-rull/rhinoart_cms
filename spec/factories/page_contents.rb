FactoryGirl.define do

  factory :page_content, class: 'Rhinoart::PageContent' do
    page{ FactoryGirl.build(:page) }
    name{ FFaker::Lorem.words.join('_') }
    content{ FFaker::HTMLIpsum.body }
  end

end