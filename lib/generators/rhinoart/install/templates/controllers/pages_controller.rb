class PagesController < ApplicationController

  def index
    @page = Rhinoart::Page.index
    render template
  end

  def internal
    @page = Rhinoart::Page.find(params[:id])
    if (action = @page.field('action')).present? and respond_to?(action)
      return send(action.to_sym)
    end
    redirect_to @page.field('redirect_to') if @page.field('redirect_to').present?
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