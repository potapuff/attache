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
    update('grp', params[:id])
    @group = Group.find(params[:id])
    @events = Event.where(name_group: @group.name.upcase, date: [Date.today..1.week.from_now])
                  .eager_load(:items => [:answers])
                  .where('(session_id = ? or session_id is null)', session[:user])
    render :list
  end

  def by_tutor
    update('fio', params[:id])
    #update('fio', params[:id]) if params[:update]
    #@events ||= Event.all.includes(:items)
    @events = Event.where(tutor_id: params[:id], date: [Date.today..1.week.from_now])
                  .eager_load(:items => [:answers])
                  .where('(session_id = ? or session_id is null)', session[:user])
    render :list
  end

  def show
    @event = Event.where(uid: params[:id]).first
    respond_to do |f|
      f.html { render action: 'show' }
      f.qr { qr }
      f.mobile { render layout: 'mobile.html', action: 'show' }
    end
  end

private

  def require_id
    redirect_to(action: :index) unless params[:id]
  end

  def qr
    @event ||= Event.find(params[:uid])
    path = url_for(@event)
    filepath = "public/qr/#{@event.to_param}.png"
    qr = RQRCode::QRCode.new(path, size: 4, level: :q)
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
