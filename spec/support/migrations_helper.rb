RSpec.configure do |config|
  config.before(:all) do
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Base.logger.silence do
      ActiveRecord::Migrator.up('spec/dummy/db/migrate')
      ActiveRecord::Migrator.up('db/migrate')
    end
  end
end