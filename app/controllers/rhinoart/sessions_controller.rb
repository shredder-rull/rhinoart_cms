require_dependency "devise/sessions_controller"

module Rhinoart
  class SessionsController < Devise::SessionsController
    include Rhinoart::Helpers::ApplicationHelper
    include Rhinoart::ApplicationHelper

    helper_method :t

    layout 'rhinoart/blank'

  end
end