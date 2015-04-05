class Rate < Item

  def self.icon
    'star-o'
  end

  def answer_params
    super()+[:number]
  end

end

