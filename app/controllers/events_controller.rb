require 'rqrcode_png'
require 'net/http'

class EventsController < ApplicationController

  has_mobile_fu
  has_mobile_fu_for :show

  before_filter :require_id, except: :index


  def index
    render layout: 'minimal';
  end

  def by_group
    update('group', params[:id]) if params[:update]
    @events ||= Event.all.includes(:items)
    render :list
  end

  def by_tutor
    update('fio', params[:id]) if params[:update]
    @events ||= Event.all.includes(:items)
    render :list
  end

  def show
    @event = Event.find(params[:id])
    respond_to do |f|
      f.html { render action: 'show' }
#      f.html {render layout:'mobile', action:'show'}
      f.qr { qr }
      f.mobile { render layout: 'mobile', action: 'show' }
    end
  end

  private

  def require_id
    unless params[:id]
      redirect_to action: :index
    end
  end

  def qr
    @event ||= Event.find(params[:id])
    path = url_for(@event)
    filepath = "public/qr/#{@event.id}.png"
    qr = RQRCode::QRCode.new(path, size: 4, level: :h)
    png = qr.to_img
    png.resize(300, 300).save(filepath)
    send_file(filepath)
  end

  def update(param, id)
    url = "http://schedule.sumdu.edu.ua/index/json?id_#{param}=#{id}"
    logger.info(url)
    json = Net::HTTP.get(URI(url))
    data = JSON.parse(json)
    @events = Event.update(data)
  end

end
