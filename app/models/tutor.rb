require 'net/http'

class Tutor < ActiveRecord::Base

  TUTORS_URL = "http://schedule.sumdu.edu.ua/index/json?method=getTeachers"

  def self.setup
    json = Net::HTTP.get(URI(TUTORS_URL))
    Tutor.delete_all
    data = JSON.parse(json)
    data.each do |k, v|
      t= Tutor.new(name: v)
      t.id =k
      t.save
    end
  end

end
