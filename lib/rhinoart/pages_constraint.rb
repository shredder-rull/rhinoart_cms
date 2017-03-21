module Rhinoart
  class PagesConstraint

    def self.matches?(request)
      return false if request.params[:url] == 'index'
      if ( page = Rhinoart::Page.ready.find_by(slug: request.params[:url]) )
        request.params[:id] = page.id
        return true
      end
      false
    end

  end
end