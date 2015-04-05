class Link < Item

  before_save :set_name

  store_accessor :fields, :url, :name

  validates_presence_of :url

  def self.icon
    'link'
  end

  def set_name
    self.name ||= url
  end

end

