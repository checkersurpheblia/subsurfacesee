
## Retrieving and Processing URL-Encoded (GIF) Images from the Web

This Python script uses a lot of useful libraries - most of which were new to 
me when I made it. If you take a quick look inside the CSV file, you'll see 
a lot of rows with numerous columns with various data types. 

The problem here is this: I want a PDF file of EVERY image shown via the URL 
in the CSV file. There are thousands of them, so if you're patient and perhaps 
crazy, then fire up Excel and invidually open each hyperlink and manually save
all the images. However, if you'd like to quickly fix and automate this task, let's 
try to use some Python code to address and resolve this issue!

Before getting into any more details, I implore you to read over the question I 
asked here that motivated this objective:

https://stackoverflow.com/questions/53109038/saving-gif-file-via-pythons-urllib

GIG.py works by first asking the user to provide an input file. After that, it takes
care of the rest! For data rows within the CSV file that do not retain a URL,
then the Northing and Easting values are recorded and stored in a text file.
