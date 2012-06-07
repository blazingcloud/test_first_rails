~~~ Blazing Cloud's Pml To Html Converter ~~~

1 - Place the '.pml' files you want to convert in the 'pml_and_xml' directory.

2 - In the command line, go to the pml_to_html directory.

3 - Run the pml_to_html.rb file by typing 'ruby pml_to_html.rb' and pressing 'enter'.

4 - Enter the number of chapters to join when prompted by the program. Enter 'n' to skip joining the files.

4 - The converted files will be in the 'html' directory inside the 'pml_to_html' directory.

5 - These files will also get joined into a single html file if the number of chapters is provided. The file is inside the 'pml_to_html' directory and they get joined in order as long as they have a number attribute inside their chapter's div tag. Example: <div class='chapter' number='2'>

6 - To convert to other formats (.epub, .mobi, .pdf), use Calibre and convert from HTML to EPUB, then from EPUB to any other format desired.

7 - When converting to pdf, is necessary to add tags to the main html file to use them as a reference for page breaks in Calibre. These elements are not necessary when converting to other formats.

8 - Calibre has many options to customize the page structure and table of contents.