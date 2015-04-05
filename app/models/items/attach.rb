class Attach < Item

  store_accessor :fields, :items
  mount_uploader :items, ItemsUploader

  def self.icon
    'file'
  end
end

