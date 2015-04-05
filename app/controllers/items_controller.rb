class ItemsController < ApplicationController

  def new
    type = params.delete(:type)
    @item = Item.by_type(type).new(event_id: params[:event_id])
    @item.fid = 'f'+rand.to_s[2..-1]
    render :partial => "/items/#{@item.stype}/form"
  end

  def create
    param = params.detect { |x| Item::SUB_TYPES.keys.include? x[0].to_s }[1]
    param[:event_id] = params[:event_id]
    param.permit!
    @item = Item.new(param)
    if @item.save
      respond_to do |f|
        f.html { show }
        f.js
      end
    else
      respond_to do |f|
        f.html { render :partial => "/items/#{@item.stype}/form" }
        f.js
      end
    end
  end

  def show
    @item ||= Item.find(params[:id])
    render :partial => "/items/#{@item.stype}/show"
  end

end
