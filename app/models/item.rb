class Item < ActiveRecord::Base

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

  def answer_params
    []
  end

  def content
    RDiscount.new(description).to_html
  end

end
