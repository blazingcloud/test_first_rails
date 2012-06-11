~~~ Blazing Cloud's Pml To Html Converter ~~~

1 - Place the '.pml' files you want to convert in the 'pml_and_xml' directory.

2 - In the command line, go to the pml_to_html directory.

3 - Run the pml_to_html.rb file by typing 'ruby pml_to_html.rb' and pressing 'enter'.

4 - Enter 'Y' to generate a table of contents that's going to be added to the resulting html file (This option should NOT be used if the resulting file will be converted to .epub or .mobi since Calibre will create it's own table of contents.) Enter 'N' to skip generating the table of contents.

5 - Enter the number of chapters to join when prompted by the program. Enter 'n' to skip joining the files.

6 - The converted files will be in the 'html' directory inside the 'pml_to_html' directory.

7 - These files will also get joined into a single html file if the number of chapters is provided. The file will be in the 'pml_to_html' directory. 
The html files get joined in the right order as long as they have a number attribute inside their chapter's div tag. Example: <div class='chapter' number='2'>

6 - To convert to other formats (.epub, .mobi), use Calibre and convert from HTML to EPUB, then from EPUB to any other format desired.

8 - Calibre has many options to customize the page structure and table of contents, but it will not insert page breaks intelligently when converting to .pdf. 
When converting to .pdf, some tag should be placed in the document to represent the page breaks. Exmaple: <hr/>. Calibre has an option for searching given elements and inserting page breaks before them. Links referencing places within the same document don't work with .pdf files.

9 - Customize the style in the rubyBook.css file before converting the document to other formats. 
