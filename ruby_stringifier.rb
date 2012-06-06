class RubyStringifier
  def stringify(file, part=nil) 
    @string_code = ''

    @start = false
    @end = false
    @extract = false
    @labels = []

    if part != nil
      line_number = 1
      File.read(file).each_line do |line|
        check(line, part)
        if @extract && !comment?(line)
          @string_code += escape_symbols(find_labels(add_line_numbers(line, line_number), line_number))
          line_number += 1
        end
      end
    else
      line_number = 1
      File.read(file).each_line do |line|
        if !comment?(line)
          @string_code += escape_symbols(find_labels(add_line_numbers(line, line_number), line_number))
          line_number += 1
        end
      end
    end
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
    line = number.to_s +  '   ' + line
  end
   
  def comment?(line)
    line.include?("# ") || line.include?("#START") || line.include?("#END") || line.include?("<!--")
  end  
    
  def escape_symbols(line)
  	if !line.include?("<a class='label'")
	    line.gsub!(/</, '&#60;')
    	line.gsub!(/>/, '&#62;')
    	line.gsub!(/\//, '&#47;')
    end
    line
  end
    
  def dump
    @string_code = ''
  end
  
  def find_labels(line, number)
  	id = ''
  	if line.include?("#<label id")
      id = line.slice!(/#<label\sid=".*"\s?\/>/).slice(/".*"/).slice(/[^"]+/)
  		line = "<a class='label' id='#{id}'>" + line + "</a>"
      @labels << {'id' => id, 'line_number' => number}
    end
  	line
  end
  	
  def get_labels
  	@labels
  end
end







