module Rhinoart
  module Helpers
	  module PagesHelper

      def rhinoart_meta_tags(page = nil)
        render('rhinoart/shared/meta_tags', page: page || @page);
      end

      def full_title
        [(@title || content_for(:title) || @page.try(:title)),  setting_by_name('site_name', 'Rhino Rails CMS')].compact.join(' | ')
      end

      def page_title(page)
        page.field('h1') || page.title
      end

      def page_items(parent = nil)
        if parent.blank?
          Page.paginate(page: params[:page]).where('parent_id IS NULL').order(:position, :name)
        else
          Page.paginate(page: params[:page]).where('parent_id = ?', parent.id).order(:position, :name) if parent.type == 'page'
        end
      end

      def page_structure_tree(parent = nil)
        if parent.blank?
          Page.where("parent_id IS NULL").order(:position)
        else
          Page.where('parent_id = ?', parent.id).order(:position) if parent.type == 'page'
        end
      end

      def disabled_page?(page)
        return false unless page
        @disabled_pages ||= setting_by_name('disabled_pages', '').split(',')
        @disabled_pages.include? page.id.to_s
      end

      def setting_by_name(name, default = nil)
        Rhinoart::Setting.get(name, default)
      end

    end
	end
end
