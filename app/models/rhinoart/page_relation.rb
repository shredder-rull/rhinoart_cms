module Rhinoart
  class PageRelation < Rhinoart::ApplicationRecord

    belongs_to :page
    belongs_to :relation, polymorphic: true

    acts_as_list :scope => [:page_id]

  end
end