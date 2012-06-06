class RubyStringifier
  def stringify(file, part=nil) 
    @string_code = ''

    @start = false
    @end = false
    @extract = false

    if part != nil
      line_number = 1
      File.read(file).each_line do |line|
        check(line, part)
        if @extract && !comment?(line)
          add_line_numbers(line, line_number)
          line_number += 1
        end
      end
    else
      line_number = 1
      File.read(file).each_line do |line|
        if !comment?(line)
          add_line_numbers(line, line_number)
          line_number += 1
        end
      end
    end
    escape_symbols
    @string_code
  end
  
  def check(line, part)
    if !@start && line.include?("START:#{part}")
      @start = true
      @end = false
      @extract = true
    end
    
    if !@end && line.include?("END:#{part}")
      @end = true
      @start = false
      @extract = false
    end
  end
  
  def add_line_numbers(line, number)
    @string_code += number.to_s +  ' ' + line
  end
   
  def comment?(line)
    line.include?("# ") || line.include?("#START") || line.include?("#END") || line.include?("<!--")
  end  
    
  def escape_symbols
    @string_code.gsub!(/</, '&#60;')
    @string_code.gsub!(/>/, '&#62;')
    @string_code.gsub!(/\//, '&#47;')    
  end
    
  def dump
    @string_code = ''
  end
end
