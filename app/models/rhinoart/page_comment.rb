# == Schema Information
#
# Table name: rhinoart_page_comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  page_id    :integer
#  parent_id  :integer
#  comment    :text             not null
#  approved   :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

module Rhinoart
	class PageComment < Rhinoart::ApplicationRecord

		paginates_per 20

		include ActionView::Helpers
		before_validation :clear_html

		belongs_to :page, :inverse_of => :page_comment, touch: true, counter_cache: :comments_count
		accepts_nested_attributes_for :page

		belongs_to :user
		accepts_nested_attributes_for :user #, :allow_destroy => true

		has_many :children, foreign_key: :parent_id, class_name: self.to_s

		# Validations
		validates :comment, presence: true
		validates :comment, length: { minimum: 2, maximum: 1500 }

		def clear_html
			self.comment = strip_tags self.comment
		end
	end
end
