module Rhinoart
  class Registry
    extend ActiveSupport::PerThreadRegistry
    attr_accessor :current_user

    def self.clear
      Thread.current[@per_thread_registry_key] = nil
    end

    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env)
      ensure
        Registry.clear
      end
    end

  end
end