class Quest < Item

  has_many :answers, foreign_key: :item_id
  belongs_to :event

  def self.icon
    'pencil-square-o'
  end

  def answer_params
    super()+[:text]
  end

end

