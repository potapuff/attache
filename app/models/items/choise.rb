class Choise < Item

  #TODO add validation
  before_save :check_question

  def initialize(args)
    super(args)
    self.description ||= "Вопрос:\n()ответ\n()ответ\n()ответ"
  end

  def self.icon
    'check-square-o'
  end

  def process_params params
    params[:answer] ||= {}
    params[:answer][:text] = {
            'resp_radio' => params[:resp_radio],
            'resp_check' => params[:resp_check],
            'resp_text'  => params[:resp_text]
        }.to_json.to_s
    params
  end

  def answer_params
    super()+[:text]
  end

  def content
    description.gsub("\n","<br/>")
  end

  private

  def check_question
    unless description[/(\(\)|\[\])/]
      self.description = description.strip+ "\n() вопрос"
    end
  end

end

