require_dependency "rhinoart/application_controller"

module Rhinoart
	class FileworksController < ApplicationController
		
		def upload_image
			uploader = RedactorImageUploader.new
			uploader.store!(params[:file])
			
			render json: { filelink: uploader.url }
		end

		def upload_file
			uploader = RedactorFileUploader.new
			uploader.store!(params[:file])

			render json: { filelink: uploader.url, filename: File.basename(uploader.url) }
		end

		def image_list
			uploader = RedactorImageUploader.new
			path = RedactorImageUploader::File.expand_path(uploader.store_dir, uploader.root)

			filesjson = []
			Dir.glob("#{path}/**/*").each do |f|
				next if File.directory?(f)
				image_path = f.sub(uploader.root, '')
				filesjson << { thumb: image_path, image: image_path }
			end
			render json: filesjson
		end
	end
end
