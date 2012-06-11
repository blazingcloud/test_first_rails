# encoding: ISO-8859-1
require 'rubygems'
require 'nokogiri'

# DIR = File.dirname(__FILE__)
require "#{DIR}/ruby_stringifier.rb"

class Parser
  def initialize
    @titles = {}
  end
  
  def load(filepath)
    file = File.open(filepath)
    @document = Nokogiri::XML(file)
    file.close
    
    @string_document = File.read(filepath).to_s
    @stringifier = RubyStringifier.new
  end
  
  def document
    @string_document
  end
  
  def load_html(filepath)
    file = File.open(filepath)
    @html_document = Nokogiri::HTML(file)
    file.close
  end
  
  def chapter_number?(number)
    !@html_document.css("[number='#{number}']").empty?
  end
  
  def dump
    @document = ''
    @string_document = ''
  end
  
  def gather_titles_from_ids
    @document.css("[id]").each do |node|
      @titles["#{node['id']}"] = "#{node.css('title')[0].text}"
    end
  end
  
  def replace_tag(xml_tag, html_tag, html_class)
    @string_document.gsub!(/<#{xml_tag}>/, "<#{html_tag} class='#{html_class}'>")
    @string_document.gsub!(/<\/#{xml_tag}>/, "<\/#{html_tag}>")
    @string_document
  end
    
  def replace_tag_with_attribute(xml_tag, xml_attribute, html_tag, html_class, html_attribute)
    @document.css(xml_tag).each do |tag|
      attribute = tag.attributes[xml_attribute]
      @string_document.gsub!(/<#{xml_tag}\s#{xml_attribute}=\'?\"?#{attribute}\'?\"?>/, "<#{html_tag} class='#{html_class}' #{html_attribute}='#{attribute}'>")
      @string_document.gsub!(/<\/#{xml_tag}>/, "<\/#{html_tag}>")
    end
    @string_document
  end
  
  def replace_tag_with_attributes(xml_tag, xml_attribute_1, xml_attribute_2, html_tag, html_class, html_attribute_1, html_attribute_2)
    @document.css(xml_tag).each do |tag|
      attribute_1 = tag.attributes[xml_attribute_1]
      attribute_2 = tag.attributes[xml_attribute_2]    
      if attribute_1 && attribute_2
      	@string_document.gsub!(/<#{xml_tag}\s#{xml_attribute_1}="(#{attribute_1})"\s+#{xml_attribute_2}="(#{attribute_2})"\s*\S*\s*>/, 
          "<#{html_tag} class='#{html_class}' #{html_attribute_1}='#{attribute_1}' #{html_attribute_2}='#{attribute_2}'>")
      	@string_document.gsub!(/<\/#{xml_tag}>/, "<\/#{html_tag}>")
      end
    end
    @string_document
  end
  
  def replace_tag_with_content(xml_tag, html_tag, html_class, html_attribute)
    @document.css(xml_tag).each do |tag|
      content = tag.content
      @string_document.gsub!(/<#{xml_tag}>#{content}<\/#{xml_tag}>/, "<#{html_tag} class='#{html_class}' #{html_attribute}='#{content}'>#{content}<\/#{html_tag}>")
    end
    @string_document
  end
  
  def replace_selfclosing_tag_with_attribute(xml_tag, xml_attribute, html_tag, html_class, html_attribute)
    @document.css(xml_tag).each do |tag|
      attribute = tag.attributes[xml_attribute]
      @string_document.gsub!(
        /<#{xml_tag}\s#{xml_attribute}=\'?\"?#{attribute}\'?\"?\s*\S*\s*\/>/, 
        "<#{html_tag} class='#{html_class}' #{html_attribute}='#{attribute}'></#{html_tag}>")
    end
    @string_document
  end
  
  def replace_selfclosing_tag_with_attributes(xml_tag, xml_attribute_1, xml_attribute_2, html_tag, html_class, html_attribute_1, html_attribute_2)
    @document.css(xml_tag).each do |tag|
      attribute_1 = tag.attributes[xml_attribute_1]
      attribute_2 = tag.attributes[xml_attribute_2]    
      if attribute_1 && attribute_2
        @string_document.gsub!(
          /<#{xml_tag}\s#{xml_attribute_1}="(#{attribute_1})"\s+#{xml_attribute_2}="(#{attribute_2})"\s*\S*\s*\/>/, 
          "<#{html_tag} class='#{html_class}' #{html_attribute_1}='#{attribute_1}' #{html_attribute_2}='#{attribute_2}'></#{html_tag}>")
      end
    end
    @string_document
  end
    
  def add_external_code
    @document.css('code').each do |tag|
      attribute_1 = tag.attributes['file']
      attribute_2 = tag.attributes['part'] 
      if attribute_1 && attribute_2
        @string_code = @stringifier.stringify("#{attribute_1}", "#{attribute_2}")
    	  replace_cref(@stringifier.get_labels) if !@stringifier.get_labels.empty?
        @string_document.gsub!(/<code\sfile="(#{attribute_1})"\s+part="(#{attribute_2})"\s*\/>/, "<pre class='external'>#{@string_code}\n</pre>")
      elsif attribute_1 != nil
        @string_code = @stringifier.stringify("#{attribute_1}")
		    replace_cref(@stringifier.get_labels) if !@stringifier.get_labels.empty?
        @string_document.gsub!(/<code\sfile="(#{attribute_1})"\s*\/>/, "<pre class='external'>#{@string_code}\n</pre>")
      end
      @stringifier.dump
    end
    @string_document
    
  end
    
  def remove_tag(xml_tag)
    @string_document.force_encoding('ISO-8859-1') 
  	while @string_document.slice(/<#{xml_tag}>[a-zA-Z\s\.\n\"\'\,\?\d\)\(\’\—\:\-“”\*\!]*<\/#{xml_tag}>/) != nil
      @string_document.slice!(/<#{xml_tag}>[a-zA-Z\s\.\n\"\'\,\?\d\)\(\’\—\:\-“”\*\!]*<\/#{xml_tag}>/)
  	end
  	@string_document
  end
  
  def change_doctype
    @string_document.slice!(/<\?xml.*>/)
    @string_document.gsub!(/<!DOCTYPE\s.*>/, '<!DOCTYPE html>')
    @string_document
  end
  
  def add_css
    @string_document.gsub!(/<!DOCTYPE\s+html>/, "<!DOCTYPE html>\n<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>\n<head><link href='rubyBook.css' rel='stylesheet' type='text/css'></head>")
    @string_document
  end
    
  def replace_chapter
    replace_tag_with_attributes('chapter', 'id', 'number', 'div', 'chapter', 'id', 'number')
  end
  
  def replace_title
    @string_document.sub!(/<title>/, "<h2 class='chapter_title'>")
    @string_document.sub!(/<\/title>/, "<\/h2>")
    replace_tag('title', 'h3', 'title')
  end
  
  def replace_footnote
    replace_tag('footnote', 'div', 'footnote')
  end
  
  def replace_joeasks
    replace_tag('joeasks', 'div', 'ask_sidebar')
    replace_tag_with_attribute('joeasks', 'id', 'div', 'ask_sidebar', 'id')
  end
  
  def replace_firstuse
    replace_tag('firstuse', 'span', 'firstuse')
  end
  
  def remove_ed
    remove_tag('ed')
  end
  
  def remove_author
    remove_tag('author')
  end
  
  def replace_commandname
    replace_tag('commandname', 'span', 'commandname')
  end
  
  def replace_method
    replace_tag('method', 'span', 'method')
  end
  
  def replace_emph
    replace_tag('emph', 'em', 'emph')
  end
  
  def replace_sidebar
    replace_tag_with_attribute('sidebar', 'id', 'div', 'sidebar', 'id')
  end 
  
  def replace_ref
    @document.css('ref').each do |tag|
      attribute = "#{tag.attributes['linkend']}"
      if @string_document.slice(/<ref\n(.*)linkend="(#{attribute})"\s*\/>/)
        @string_document.gsub!(/<ref\n(.*)linkend="(#{attribute})"\s*\/>/, "<a class='ref' href='##{attribute}'>#{@titles[attribute]}</a>")
      elsif @string_document.slice(/<ref\slinkend="(#{attribute})"\s*\/>/)
        @string_document.gsub!(/<ref\slinkend="(#{attribute})"\/>/, "<a class='ref' href='##{attribute}'>#{@titles[attribute]}</a>")
      end
    end
    @string_document
  end 
  
  def replace_cref(labels)
  	line_number = ''
  	@document.css('cref').each do |tag|
      attribute = tag.attributes['linkend'].to_s
      labels.each do |id, line_number|
        if id == attribute
          @string_document.gsub!(/<cref\slinkend="(#{attribute})"\/>/, "<a class='cref' href='##{attribute}'>#{line_number}</a>")
        end
      end
    end
    @string_document

  end

  def replace_sect1
    replace_tag_with_attribute('sect1', 'id', 'div', 'sect1', 'id')
  end
  
  def replace_sect2
    replace_tag_with_attribute('sect2', 'id', 'div', 'sect2', 'id')
  end
  
  def replace_sect3
    replace_tag_with_attribute('sect3', 'id', 'div', 'sect3', 'id')
  end
  
  def replace_quotes
    @string_document.gsub!('&lquot','&ldquo')
    @string_document.gsub!('&rquot','&rdquo')
    @string_document
  end
  
  def replace_class
    replace_tag('class', 'span', 'rubyclass')
  end
  
  def replace_ic
    replace_tag('ic', 'span', 'ic')
  end
  
  def escape_symbols
    while @string_document.slice(/\#<[A-Z]/) != nil
      if @string_document.slice(/\#<\S+\s?/)
        object = @string_document.slice(/\#<\S+\s?/).slice(/\w\S+\s?\S+\w/)
        @string_document.gsub!(/\#<\S+\s?/,"#&#060;#{object}&#062;")
      elsif @string_document.slice(/\#<\S+\s?\S+\s+/)
        object = @string_document.slice(/\#<\S+\s?\S+\s+/).slice(/\w\S+\s?\S+\w/)
        @string_document.gsub!(/\#<\S+\s?\S+\s+/, "#&#060;#{object}")
      end
    end
    @string_document
  end
  
  def replace_constant
    replace_tag('constant', 'span', 'constant')
  end
  
  def replace_filename
     replace_tag('filename', 'span', 'filename')
  end
  
  def replace_keyword
     replace_tag('keyword', 'span', 'keyword')
  end
  
  def replace_figure
  	replace_tag_with_attribute('figure', 'id', 'div', 'figure', 'id')
  end
  
  def replace_imagedata
  	replace_selfclosing_tag_with_attribute('imagedata', 'fileref', 'img', 'imagedata', 'src')
  end
  
  def replace_url
    replace_tag_with_content('url', 'a', 'url', 'href')
  end
  
  def replace_thead
  	replace_tag('thead', 'tr', 'thead')
  end
  
  def replace_table_headers
    @document.css('thead').children.css('col').css('p').each do |p|
      head = p.content
      @string_document.gsub!(/<col><p>#{head}<\/p><\/col>/, "<th><p>#{head}</p></th>")
    end
    @string_document
  end
  
  def replace_table_row
    replace_tag('row', 'tr', 'row')
  end
  
  def replace_table_col
    replace_tag('col', 'td', 'col')
  end
  
  def replace_table
    replace_table_headers
    replace_thead
    replace_table_row
    replace_table_col
  end

  def replace_code_tag
    replace_tag('code', 'pre', 'code')
  	replace_tag_with_attribute('code', 'language', 'pre', 'code', 'language')
  end

  def replace_dir
    replace_tag('dir', 'span', 'dir')
  end
  
  def replace_all
    change_doctype
    replace_table
    replace_chapter
    replace_title
    replace_sidebar
    replace_ref
    replace_sect1
    replace_sect2
    replace_sect3
    replace_quotes
    escape_symbols
    replace_figure
    replace_imagedata
    replace_url
    add_external_code
    replace_code_tag
    replace_joeasks
    @document = ''
    replace_dir
    replace_class
    replace_ic
    replace_constant
    replace_filename
    replace_keyword
    replace_emph
    replace_commandname
    replace_method
    replace_firstuse
    replace_footnote
    remove_author
    remove_ed
    add_css
    @string_document
  end
    
end

# 
# parser = Parser.new
# parser.load('chapter.xml')
# parser.remove_author