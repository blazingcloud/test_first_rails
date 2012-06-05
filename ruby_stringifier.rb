class RubyStringifier
  def stringify(file) 
    line_number = 0
    @string_code = ''
    File.read(file).each_line do |line|
      line_number += 1
      @string_code += line_number.to_s + ' ' + line + "\n"
    end
    @string_code
  end
  
  def dump
    @string_code = ''
  end
end
