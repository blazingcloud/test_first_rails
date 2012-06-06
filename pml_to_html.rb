DIR = File.dirname(__FILE__)

require "#{DIR}/parser.rb"
@parser = Parser.new
pml_files = Dir[DIR+'/pml_and_xml/*.pml']
xml_files = Dir[DIR+'/pml_and_xml/*.xml']

pml_files.each do |file|
  file.slice!("#{DIR}/pml_and_xml/")
  file.slice!(/\.\S+/)
  File.rename("pml_and_xml/#{file}.pml", "pml_and_xml/#{file}.xml")  
  html_file = File.new("html/#{file}.html", "w+")
  puts "parsing #{file}"
  @parser.load("#{DIR}/pml_and_xml/#{file}.xml")
  html_string = @parser.replace_all
  @parser.dump
  html_file.write html_string
  html_file.close
  html_string = ''
  puts "#{file} was converted"
end

xml_files.each do |file|
  file.slice!("#{DIR}/pml_and_xml/")
  file.slice!(/\.\S+/)
  html_file = File.new("html/#{file}.html", "w+")
  puts "parsing #{file}"
  @parser.load("#{DIR}/pml_and_xml/#{file}.xml")
  html_string = @parser.replace_all
  @parser.dump
  html_file.write html_string
  html_file.close
  html_string = ''
  puts "#{file} was converted"
end




puts "----Done!----"