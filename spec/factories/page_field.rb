FactoryGirl.define do
  factory :page_field, class: 'Rhinoart::PageContent' do
    page{ FactoryGirl.build(:page) }
    name{ FFaker::Lorem.words.join('_') }
    value{ FFaker::Lorem.word }
  end
end