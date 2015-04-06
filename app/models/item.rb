class Item < ActiveRecord::Base

  has_many :answers

  SUB_TYPES = Hash[[Link, Attach, Choise, Rate, Notice, Quest].map { |x| [x.to_s.downcase, x] }]

  belongs_to :event

  acts_as_list scope: :event
  attr_accessor :fid

  store :fields, accessors: []

  def self.by_type(type)
    SUB_TYPES[type.downcase]
  end

  def stype
    @stype ||= type.to_s.downcase
  end

  def self.icon
    'quote-left'
  end

  def process_params params
    params
  end

  def answer_params
    []
  end

  def content
    RDiscount.new(description).to_html
  end

  def answer(user)
    @answer ||= {}
    @answer[user] ||= answers.detect{|x| x.session_id == user} || Answer.new(item_id: id, session_id: user)
  end

end
