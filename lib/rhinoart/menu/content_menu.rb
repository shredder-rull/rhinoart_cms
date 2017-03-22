module Rhinoart
  module Menu
    class ContentMenu < Rhinoart::Menu::Base

      def item_class
        @item_class ||= Class.new(Rhinoart::Menu::Item) do
          attr_accessor :notification
        end
      end

      add_item({
          icon: 'fa-tasks',
          link: proc{ rhinoart.new_page_path },
          label: :_NEW_PAGE,
          allowed: proc{ can?(:manage, :content) },
          notification: ->{ Rhinoart::Page.count }
        })

      add_item({
          icon: 'fa-book',
          link: proc{ rhinoart.new_page_path(type: Rhinoart::Page::TYPE::BLOG) },
          label: :_NEW_BLOG_POST,
          allowed: proc{ can?(:manage, :content) },
          notification: ->{ Rhinoart::Page.where(type: Rhinoart::Page::TYPE::BLOG).count }
      })

      add_item({
          icon: 'fa-group',
          link: proc{ rhinoart.users_path },
          label: :_USERS,
          allowed: proc{ can?(:manage, :users) },
          notification: ->{ Rhinoart.user_class.count }
        })

      add_item({
          icon: 'fa-cogs',
          link: proc{ rhinoart.settings_path },
          label: :_SETTINGS,
          allowed: proc{ can?(:manage, :all) },
          notification: ->{ Rhinoart::Setting.count }
      })

    end
  end
end