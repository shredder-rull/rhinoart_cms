module Rhinoart
  module Helpers
    extend ActiveSupport::Autoload

    eager_autoload do

      autoload :ApplicationHelper
      autoload :PagesHelper

    end

  end
end