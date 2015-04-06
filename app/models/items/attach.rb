class Attach < Item

  store_accessor :fields, :item
  mount_uploader :item, ItemsUploader

  def self.icon
    'paperclip'
  end

  #hack over save fields into json attribute
  def item_will_change!
    fields_will_change!
    @item_changed = true
  end

  def item_changed?
    @item_changed
  end

  def write_uploader(column, identifier)
    self.fields||={}
    self.fields[column.to_s] = identifier
    self.fields[column.to_sym] = identifier
  end

  def read_uploader(column)
    self.fields ||={}
    self.fields[column.to_s] || self.fields[column.to_sym]
  end

end

