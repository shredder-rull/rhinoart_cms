module Rhinoart
  module User
    module Localable
      extend ActiveSupport::Concern


      included do

        unless method_defined?(:locales)
          def locales
            []
          end
        end

        def locales=(value)
          self[:locales] = value.select(&:present?) if has_attribute?(:locales)
        end

      end
    end
  end
end
