class PagesController < ApplicationController

  def index
    return p404 if !(@page = Rhinoart::Page.find_by_path('index'))
  end

  def internal
    return p404 if params[:url] == 'index' or !(@page = Rhinoart::Page.friendly.find(params[:url]))
    redirect_to @page.field('redirect_to'), status: :moved_permanently if @page.field('redirect_to').present?
    render template
  end

  def p404
    render :p404, status: 404
  end

  def p422
    render :p422, status: 422
  end

  def p500
    render :p500, status: 500
  end

  private

  def template
    @page.field('template').presence || :default
  end

end