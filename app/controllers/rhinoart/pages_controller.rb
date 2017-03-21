#encoding: utf-8
require_dependency "rhinoart/application_controller"

module Rhinoart
	class PagesController < ApplicationController
		before_action { authorize!(:manage, :content) }
		before_action :set_rhinoart_page, only: [:edit, :update, :destroy]
		before_action :set_tree_ids, only: [:index, :children, :edit]		


		def index
			store_location
			@pages = Page.active.order(:name).page(params[:page])
			if params[:parent].present?
				@pages = @pages.where(parent_id: params[:parent])
			else
				@pages = @pages.roots
			end

			respond_to do |format|
				format.html { }
				format.js { }
			end
		end

		def children
			store_location
			@index = params[:index].to_i
			@page = Page.find(params[:id])
			@pages = @page.children
			#@pages = @pages.reorder(published_at: :desc, lft: :asc) if Rhinoart.config.order_in_list == :by_date
			@pages = @pages.page(params[:page])
			
			respond_to do |format|
				format.html { }
				format.js { }
			end
		end

		def hide_children
			@page = Page.find(params[:id])
			respond_to do |format|
				format.js { }
			end
		end

		def new
	    	@page = Page.new

		    @page.parent = Page.find_by(id: params[:id]) if params[:id].present?
		    @page.type = @page.parent.try(:type) || params[:type]

	    	if !@page.type.present?
	    		content_fields(@page)
	    		content_tabs(@page)
	    	else
		    	case @page.type
		    	when Page::TYPE::ARTICLE.to_s.downcase
		    		additional = [
		    			{ name: 'image', type: 'file'}
		    		]
		    		content_fields(@page, 'default', additional)
		    		content_tabs(@page,  %w[preview main_content])
		    	when Page::TYPE::BLOG.to_s.downcase
		    		fields =  [
							{ name: 'title', type: 'meta'},
							{ name: 'h1', type: 'meta'},
							{ name: 'description', type: 'meta'},
							{ name: 'keywords', type: 'meta'},
							{ name: 'template', type: 'string', value: Rhinoart.config.blog_post_template }
						]
		    		content_fields(@page, fields)
		    		content_tabs(@page,  %w[preview main_content])
		    	when Page::TYPE::TESTIMONIAL.to_s.downcase
		    		fields =  [
						{ name: 'title', type: 'meta' },
						{ name: 'h1', type: 'meta' },
						{ name: 'author', type: 'textarea' },
						{ name: 'image', type: 'file' },
					]
		    		content_fields(@page, fields)
		    		content_tabs(@page,  %w[preview main_content])
		    	else
		    		content_fields(@page)
		    		content_tabs(@page)
		    	end
	    	end

		end

		def create
			@page = Page.new
			if @page.update_attributes(admin_pages_params)
				@page.move_to_top if @page.type == 'article'
				flash[:info] = t('_PAGE_SUCCESSFULLY_CREATED')
				if params[:continue].present? 
					#redirect_to structure_path([@page, :edit])
					redirect_to :back
				else
					redirect_back_or pages_path
				end			
			else	
				render action: 'new'
			end
		end

		def edit
		end

		def update			
			if @page.update(admin_pages_params)
				flash[:info] = t('_PAGE_SUCCESSFULLY_UPDATED')
				if params[:continue].present? 
					redirect_to :back
				else
					redirect_back_or pages_path
				end
			else
				render action: 'edit'
			end
		end

		def tree
			store_location
		end
		
		def destroy		
			page_name = @page.name
			@page.destroy

			flash[:info] = t('_PAGE_SUCCESSFULLY_DELITED', name: page_name)
			redirect_back_or pages_path
		end

		def showhide
			page = Page.find(params[:id])
			page.update( :active => !page.active? )

			redirect_back_or pages_path
		end

		def sort
			params[:page].each_with_index do |id, index|
				Page.update_all(['position=?', index+1], ['id=?', id])
			end
			render :nothing => true
		end

		def up				
			@page = Page.find(params[:page_id])	
			@page.move_left if @page.left_sibling.present?
			redirect_back_or( @page.parent ? children_page_path(@page.parent) : structures_path )
		end

		def down
			@page = Page.find(params[:page_id])	
			@page.move_right if @page.right_sibling.present?
			redirect_back_or( @page.parent ? children_page_path(@page.parent) : structures_path )
		end

		def field_page_add
			@count_page = params[:count_page]
			
			@field_name = params[:field_name]
			@field_type = params[:field_type]

			field_new = [{ :name => @field_name, :type => @field_type, :position => @count_page }]

			@page.page_field.build(field_new)

			@field = @page.page_field.last

			#debugger

			respond_to do |format|
		    format.js
		  end
			
		end

		private

	    # Use callbacks to share common setup or constraints between actions.
	    def set_rhinoart_page
				begin
					@page = Page.find(params[:id])
				rescue
					render template: 'rhinoart/shared/error404', status: :not_found
				end
			end

			# Never trust parameters from the scary internet, only allow the white list through.
			def admin_pages_params
				params[:page].permit!.tap do |p|
					p[:published_at] = (Time.strptime(p[:published_at], '%m/%d/%Y') rescue nil) if p[:published_at].present?
					if @page and @page.persisted?
						contents = @page.contents.group_by{|c| c.name.downcase}
						p[:contents_attributes] = (p[:contents_attributes] || {}).values.reject do |attrs|
							contents[attrs[:name].downcase].present? and attrs[:id].blank?
						end

						fields = @page.fields.group_by{|f| f.name.downcase}
						p[:fields_attributes] = (p[:fields_attributes] || {}).values.reject do |attrs|
							fields[attrs[:name].downcase].present? and attrs[:id].blank?
						end
					end
				end
			end

			def set_tree_ids
				@tree_ids = cookies[:tree_ids].split(',').map { |s| s.to_i } if cookies[:tree_ids].present?
			end

			def content_tabs(page, names=%w[main_content])
				names.each do |name|
					page.contents.build(name: name) if page.contents.where(name: name).empty?
				end
			end

			def content_fields(page, fields = 'default', additional = nil)
				if fields == 'default'
					fields =  [
							{ :name => 'title', :type => 'meta' },
							{ :name => 'h1', :type => 'meta' },
							{ :name => 'description', :type => 'meta' },
							{ :name => 'keywords', :type => 'meta' }
					]
				end

				fields.push(additional[0]) if additional

				fields.each do |field|
					field.assert_valid_keys(:name, :type, :position, :value) # валидация
					page.fields.build(field)
				end
			end
	end
end
