# == Schema Information
#
# Table name: rhinoart_page_contents
#
#  id       :integer          not null, primary key
#  page_id  :integer
#  name     :string(100)      not null
#  content  :text
#  position :integer          not null
#

module Rhinoart
	class PageContent < Rhinoart::ApplicationRecord
		belongs_to :page, touch: true

		acts_as_list  :scope => :page_id
		default_scope { order 'position asc' }

		has_paper_trail

		validates :name, length: {maximum: 100}

		def name=(name)
			self[:name] = name.to_s.downcase.gsub(/[^a-z_]+/, '_')
		end
	end
end

