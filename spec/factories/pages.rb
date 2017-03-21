FactoryGirl.define do

  factory :page, class: 'Rhinoart::Page' do
    name{ FFaker::Book.title }
    content{ FFaker::HTMLIpsum.body }
  end

end