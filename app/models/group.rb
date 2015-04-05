require 'net/http'

class Group < ActiveRecord::Base

  GROUPS_URL = "http://schedule.sumdu.edu.ua/index/json?method=getGroups"

  def self.setup
    json = Net::HTTP.get(URI(GROUPS_URL))
    Group.delete_all
    data = JSON.parse(json)
    data.each do |k, v|
      t= Group.new(name: v)
      t.id = k
      t.save
    end
  end

end
