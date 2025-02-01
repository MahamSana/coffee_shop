class ItemsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @items = Item.all
    render json: @items
  end
end
