# encoding: UTF-8

#TODO: fix escape format, apply RDiscount
module OpinionHelper
  # анкета состоит из нескольких вопросов:
  # - каждый вопрос начинается с Q[число]. в начале строки
  # - вопрос может содержать :
  #   * одну группу radio , место для radio - ()
  #   * одну группу check , место для check - []
  #   * много многострочных полей rows:5, cols:80 - [____]
  #   * однострочное поле [===]
  # к opin_text будет применен escape_format

  def quest_iterator(opin_text, &block)
    q_num = 0
    field_count = 0
    out = []
    logger.info('----'*10)
    logger.info('start')
    opin_text.split(/^(Q\d+)/).each do |chunk|
      logger.info(chunk)
      if chunk =~ /^Q\d+/
        q_num += 1
        field_count = 0
        out << chunk
      elsif q_num >= 0
        chunk.split(/(\(\)|\[\]|\[__+\]|\[==+\])/).each do |fragment|
          case fragment
            when '()' # radio
              field_count += 1
              out << block.call(q_num, 'radio', field_count)
            when '[]' # checkbox
              field_count += 1
              out << block.call(q_num, 'check', field_count)
            when /^\[_+\]/ # textarea
              field_count += 1
              out << block.call(q_num, 'text', field_count)
            when /^\[=+\]/ # little text area
              field_count += 1
              out << block.call(q_num, 'stext', field_count)
            else
              out << escape_format(fragment)
          end
        end
      else
        out << escape_format(chunk)
      end
    end
    out.join("\n")
  end

  def form_for_opinion(opin_text)
    quest_iterator(opin_text) do |q_num, fragment, field_count|
      rid = 'r'+rand.to_s[2..-1]
      case fragment
        when 'radio';
          '<input type="radio" name="resp_radio['+q_num.to_s+']" value="'+field_count.to_s+'" id="'+rid+'"></input><label for="'+rid+'"></label>'
        when 'check';
          '<input type="checkbox" name="resp_check['+q_num.to_s+'][]" value="'+field_count.to_s+'" id="'+rid+'"></input><label for="'+rid+'"></label>'
        when 'text';
          '<textarea rows="5" cols="80" name="resp_text['+q_num.to_s+']['+field_count.to_s+']"></textarea>'
        when 'stext';
          '<input type="text" cols="80" name="resp_text['+q_num.to_s+']['+field_count.to_s+']"/>'
      end
    end
  end

  def single_response(opin_text, user_response)
    quest_iterator(opin_text) do |q_num, fragment, field_count|
      case fragment
        when 'radio'
          ur = user_response['resp_radio'][q_num.to_s] rescue nil
          '<input type="radio" name="resp_radio['+q_num.to_s+']" value="'+field_count.to_s+'" disabled="disabled"'+
              (ur == field_count.to_s ? ' checked="checked" ' : '') +'/>'
        when 'check'
          ur = user_response['resp_check'][q_num.to_s].to_a rescue []
          '<input type="checkbox" name="resp_check['+q_num.to_s+'][]" value="'+field_count.to_s+'" disabled="disabled"'+
              (ur.include?(field_count.to_s) ? ' checked="checked" ' : '') +'/>'
        when 'text'
          ur = user_response['resp_text'][q_num.to_s][field_count.to_s] rescue ''
          "<blockquote>" + escape_format(ur) + "</blockquote>"
        when 'stext'
          ur = user_response['resp_text'][q_num.to_s][field_count.to_s] rescue ''
          "<blockquote>" + escape_format(ur) + "</blockquote>"
      end
    end
  end

  def stats_response(opin_text, response_list)
    resp_size = response_list.size
    return single_response(opin_text, {}) if resp_size == 0
    quest_iterator(opin_text) do |q_num, fragment, field_count|
      case fragment
        when 'radio'
          check_count = response_list.inject(0) do |sum, user_response|
            ur = user_response['resp_radio'][q_num.to_s] rescue nil
            sum + (ur == field_count.to_s ? 1 : 0)
          end
          sprintf "<strong>%04.1f%%</strong> ", (check_count.to_f / resp_size * 100)
        when 'check'
          check_count = response_list.inject(0) do |sum, user_response|
            ur = (user_response['resp_check'][q_num.to_s] || []) rescue []
            sum + (ur.include?(field_count.to_s) ? 1 : 0)
          end
          sprintf "<strong>%04.1f%%</strong> ", (check_count.to_f / resp_size * 100)
        when 'text'
          out = []
          response_list.each do |user_response|
            ur = user_response['resp_text'][q_num.to_s][field_count.to_s] rescue ''
            out << escape_format(ur) unless ur.blank?
          end
          "<blockquote style=\"border:1px solid black; \">" + out.join("<hr/>")+ "</blockquote>"
        when 'stext'
          out = []
          response_list.each do |user_response|
            ur = user_response['resp_text'][q_num.to_s][field_count.to_s] rescue ''
            out << escape_format(ur) unless ur.blank?
          end
          "<blockquote style=\"border:1px solid black; \">" + out.join("<hr/>")+ "</blockquote>"
      end
    end
  end

  #TODO: rewrite, sanitize
  def escape_format(str)
    str
  end
end
