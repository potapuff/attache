class Event < ActiveRecord::Base

  has_many :items
  belongs_to :tutor

  before_save :generate_uid

  def self.update(json)
    logger.info(json.to_s)
    ids = json.map { |x|
      [Event.generate_uid(x["DATE_REG"], x["NAME_PAIR"], x["NAME_AUD"]), x];
    }
    ids = Hash[ids]
    events = Event.includes(:items).where(uid: ids.keys)
    ids.each do |key, value|
      unless events.any? { |x| x.uid == key }
        event = Event.build(value)
        event.save
        events << event
      end
    end
    events
  end

  private

  def self.build(record)
    event = Event.new
    event.pair = record["NAME_PAIR"].to_i
    event.date = Date.parse(record["DATE_REG"])
    event.name_aud = record["NAME_AUD"].upcase
    event.name_group = record["NAME_GROUP"].upcase
    event.tutor_id = record["KOD_FIO"].to_i
    event.abbr_disc = record["ABBR_DISC"]
    event.name_stud = record["NAME_STUD"]
    event.reason = record["REASON"]
    event.stud_type_id = record["KOD_STUD"].to_i
    event.info= record["info"]
    return event
  end

  def self.aud_normalize(name_aud)
    Russian::transliterate(name_aud.upcase)
  end

  def generate_uid
    reg_date = date.strftime('%d%m%y')
    self.uid = pair.to_s+reg_date+Event.aud_normalize(name_aud)
  end

  def self.generate_uid(reg_date, name_pair, name_aud)
    reg_date = reg_date.sub('.20', '').sub('.', '')
    name_pair = name_pair.gsub(/\D+/, '')
    name_aud = Event.aud_normalize(name_aud)
    name_pair+reg_date+name_aud
  end

end
