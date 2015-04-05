class Choise < Item

  before_save :check_qustion

  def initialize
    self.description = 'Вопрос:\n()ответ\n()ответ\n()ответ'
  end

  def self.icon
    'star'
  end

  private

  def check_qustion
    unless description[/\(\)/]
      self.description = description.strip+ "\n() вопрос"
    end
  end

  def content
    'hack'+description
  end

end

