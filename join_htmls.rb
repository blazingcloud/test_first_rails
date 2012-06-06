DIR = File.dirname(__FILE__)
html_files = Dir[DIR+'/html/*.html']
whole_file = File.new("Test_First_With_Rails.html", "w+")

html_files.each do |file|
  whole_file.write(File.read(file))
end
whole_file.close