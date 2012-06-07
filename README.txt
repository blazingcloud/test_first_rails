~~~ Blazing Cloud's Pml To Html Converter ~~~

1 - Place the '.pml' files you want to convert in the 'pml_and_xml' directory.

2 - In the command line, go to the pml_to_html directory.

3 - Run the pml_to_html.rb file by typing 'ruby pml_to_html.rb' and pressing 'enter'.

4 - Enter the number of chapters to join when prompted by the program. Enter 'n' to skip joining the files.

4 - The converted files will be in the 'html' directory inside the 'pml_to_html' directory.

5 - These files will also get joined into a single html file if the number of chapters is provided. The file is inside the 'pml_to_html' directory and they get joined in order as long as they have a number attribute inside their chapter's div tag. Example: <div class='chapter' number='2'>
A PDF File will also be created in the same directory.

6 - To convert to other formats (.epub, .mobi), use Calibre and convert from HTML to EPUB, then from EPUB to any other format desired.

8 - Calibre has many options to customize the page structure and table of contents.

To customize the style, use the rubyBook.css file and run the pml_to_html.rb file again.