# == Schema Information
#
# Table name: rhinoart_page_fields
#
#  id       :integer          not null, primary key
#  page_id  :integer          not null
#  name     :string(120)      not null
#  value    :text
#  type    :string(60)
#  position :integer          not null
#

module Rhinoart
	class PageField < Rhinoart::ApplicationRecord

		module TYPE
			STRING 		= :string
			TEXT 			= :text
			FILE 			= :file
			BOOLEAN		= :boolean
			META			= :meta
			INTEGER   = :integer
		end

		belongs_to :page, touch: true, required: false
		accepts_nested_attributes_for :page

		has_one :attachment, as: :owner, class_name: "Rhinoart::File", autosave: true, dependent: :destroy
		accepts_nested_attributes_for :attachment, allow_destroy: true, reject_if: :all_blank

		scope :meta, ->{ where(type: :meta) }

		TYPES = [TYPE::STRING, TYPE::TEXT, TYPE::FILE, TYPE::BOOLEAN, TYPE::META]

		validates :name, :type, presence: true
		validates_uniqueness_of :name, :scope => :page_id

		validates :type, inclusion: { in: TYPES.map(&:to_s) }
	
		has_paper_trail

		def value
			case type.to_sym
				when TYPE::FILE then attachment.try(:file_url)
				when TYPE::BOOLEAN then ['1','true'].include?(self[:value])
				when TYPE::INTEGER then self[:value].to_i
				else super
			end
		end

	end
end
