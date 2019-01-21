
## Retrieving and Processing URL-Encoded (GIF) Images from the Web

This Python script uses a lot of useful libraries - most of which were new to 
me when I made it. If you take a quick look inside the CSV file ('cumberland_co_all.csv'), 
it appears to be a complete mess. The file is made of 16 columns of data with 
thousands of rows. Some rows retain a URL that directs to a URL-encoded 
gif file. I want to retrieve that code, convert it to a pdf file, and
at the end of the while process - concatenate every image together into 
one big pdf file for manual viewing/processing.

Using Python, I have developed a script that accomplishes this overall task.
Note that you need to following libraries to run this script:


Before getting into any more details, I implore you to read over the question I 
asked here that motivated this objective:

https://stackoverflow.com/questions/53109038/saving-gif-file-via-pythons-urllib

GIG.py works by first asking the user to provide an input file. After that, it takes
care of the rest! For data rows within the CSV file that do not retain a URL,
then the Northing and Easting values are recorded and stored in a text file.
