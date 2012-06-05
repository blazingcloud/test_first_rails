puts DIR = File.dirname(__FILE__)

require "#{DIR}/parser.rb"
@parser = Parser.new

html_file = File.new("xml.html", "w+")
puts "parsing chapter.xml"
@parser.load("#{DIR}/chapter.xml")
html_string = @parser.replace_all
html_file.write html_string
puts "chapter.xml was converted"



# pml_files = Dir[DIR+'/pml_and_xml/*.pml']
# xml_files = Dir[DIR+'/pml_and_xml/*.xml']
# 
# pml_files.each do |file|
#   file.slice!("#{DIR}/pml_and_xml/")
#   file.slice!(/\.\S+/)
#   File.rename("pml_and_xml/#{file}.pml", "pml_and_xml/#{file}.xml")  
#   html_file = File.new("html/#{file}.html", "w+")
#   puts "parsing #{file}"
#   @parser.load("#{DIR}/pml_and_xml/#{file}.xml")
#   html_string = @parser.replace_all
#   html_file.write html_string
#   puts "#{file} was converted"
# end
# 
# xml_files.each do |file|
#   file.slice!("#{DIR}/pml_and_xml/")
#   file.slice!(/\.\S+/)
#   html_file = File.new("html/#{file}.html", "w+")
#   puts "parsing #{file}"
#   @parser.load("#{DIR}/pml_and_xml/#{file}.xml")
#   html_string = @parser.replace_all
#   html_file.write html_string
#   puts "#{file} was converted"
# end


puts "----Done!----"