# == Schema Information
#
# Table name: rhinoart_files
#
#  id                :integer          not null, primary key
#  attachable_id     :integer
#  attachable_type   :string(255)
#  file              :string(255)
#  file_content_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

module Rhinoart
	class File < Rhinoart::ApplicationRecord
		belongs_to :owner, polymorphic: true

		validates :file, presence: true

		mount_uploader :file, FileUploader

		def self.files_by_type(type)
			where parent_type: type
		end

		def file_url
			file.try(:url)
		end		
	end
end
