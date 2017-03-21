module Rhinoart
  module PagesHelper

    def page_tree(parent = nil)
      @page_tree ||= {}
      @page_tree[parent] ||= if parent.blank?
         # Page.where("parent_id IS NULL and active = ?", true).order(:position)
         Page.roots
       else
         Page.where(parent_id: parent.id)
       end
    end

  end
end