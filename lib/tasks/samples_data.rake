namespace :rhinoart do

  desc "Fill database with samples date"
  task samples: :environment do
    ActiveRecord::Base.transaction do
      #Index Page
      page = Rhinoart::Page.new(name: "Home page", slug: "index")
      page.contents.build(name: 'main_content', content: '<p>Rhinoart CMS</p>')
      page.fields.build(name: 'title', type: 'string', value: 'Home page')
      page.fields.build(name: 'h1', type: 'string', value: 'Home page' )
      page.fields.build(name: 'description', type: 'meta', value: 'This is a home page')
      page.fields.build(name: 'keywords', type: 'meta', value: 'home, page')
      page.save!

      #Blog Page
      page = Rhinoart::Page.new(name: "Blog", slug: "blog", type: Rhinoart::Page::TYPE::BLOG )
      page.contents.build(name: 'main_content', content: '<p>Rhinoart CMS</p>')
      page.fields.build(name: 'title', type: 'string', value: 'Blog')
      page.fields.build(name: 'description', type: 'meta', value: 'Blog')
      page.fields.build(name: 'keywords', type: 'meta', value: 'blog')
      page.save!


      #Settings
      Rhinoart::Setting.create!(name: 'site_name', value: 'RhinoArt (change_me)', descr: 'Site name. Shown on title')
      Rhinoart::Setting.create!(name: 'head_tags', descr: 'Common site tags, verification code, etc')
      Rhinoart::Setting.create!(name: 'analytics_code', descr: 'Code for Google Analytics, etc')

      Rhinoart::Role.backend_roles.each do |role|
        Rhinoart.user_class.reflect_on_association(:roles).klass.find_or_create_by(name: role)
      end

      #User
      user = Rhinoart.user_class.new(
        first_name: 'Super',
        last_name: 'User',
        email: 'admin@test.com',
        password: 'admin123',
        password_confirmation: 'admin123'
      )
      user.approved = 1 if user.has_attribute? :approved
      user.add_role Rhinoart::Role::SUPER_USER
      user.save
    end
  end

end