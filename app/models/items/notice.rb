class Notice < Item

  STYLES = ['success', 'info', 'warning', 'danger']

  store_accessor :fields, :style
  validates_inclusion_of :style, :in => STYLES

  def self.icon
    'exclamation-triangle'
  end
end

