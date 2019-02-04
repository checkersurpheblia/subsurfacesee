
# Builder: Nathan Benton
# Description: retrieves pdf files online
# and concatenates all files into single
# PDF file
# Built: 10/28/2018
# Modified: 10/29/2018
# -------------------------------------------------------------------

###

from urllib.request import urlretrieve
import requests
import pandas as pd
from PIL import Image
from fpdf import FPDF
from tkinter import Tk
from tkinter.filedialog import askopenfilename
import ntpath
import time
from bs4 import BeautifulSoup
import os
from PyPDF2 import PdfFileMerger

###

# --------------------------- SECTION 1 ----------------------------#

# User input
print("\n| File Input Section |\n")
time.sleep(1.5)

# Prompt file file path input and file name extraction via GUI
Tk().withdraw()
id1 = askopenfilename()
Vs_file=ntpath.basename(id1)
print("{}".format(id1))

# Read all data from input file
input_data_1 = pd.read_csv(id1)

# Open file handle (fh) for text file to hold data that does not
# retain a URL
fh1 = open('missing_well_data.txt', 'w')

# Make string header for output file
missing_well_data_header = "PAWellID\tLatitudeDD\tLongitudeDD\n"
fh1.write(missing_well_data_header)

# Calculate number of rows to analyze in input file and loop counter
count_row = input_data_1.shape[0]

# Make empty lists for later use/assignment below
pdf_list = []
pdf_list2 = []

# --------------------------- SECTION 2 ----------------------------#

for i1 in range(0, count_row):

    # Ongoing counter to keep track of current row being read
    row = i1

    # Read each row of PaperImageLink column (which holds the URL
    # to the pdf image online)
    print(input_data_1['PaperImageLink'][row])

    # If there is NO URL, then assign whatever useful data you can
    # to the text file defined above
    if input_data_1['PaperImageLink'][row] == ' ':
        print('... Empty ...')
        fh1.write(str(input_data_1['PAWellID'][row]) + '\t')
        fh1.write(str(input_data_1['LatitudeDD'][row]) + '\t')
        fh1.write(str(input_data_1['LongitudeDD'][row]) + '\n')
        continue
    else:
        print('... Not Empty ...')

        # If a URL does exist, then let's get the image!
        url_1 = input_data_1['PaperImageLink'][row]

        ###

        # Parse each URL and use BeautifulSoup to configure output
        def poster(linker):
            """Parses URL data into readable and usable format"""
            request = requests.get(linker)
            content = request.content
            soup = BeautifulSoup(content, "html.parser")
            print(soup.prettify())
            tag1 = soup.img
            return (tag1['src'])


        # Send URL to function
        parsed_url_1 = poster(url_1)
        print(parsed_url_1)

        ###

        # Constant path for each pdf URL
        constant_path = "http://www.iframeapps.dcnr.state.pa.us/topogeo/PaGWIS_search/" + parsed_url_1

        # Establish naming convention for URL files and subsequent processing
        constant_image_name = 'image'
        row_string = str(row)
        constant_image_name = constant_image_name + '_' + \
                              row_string + '_' + \
                              str(input_data_1['PAWellID'][row])

        # Make unique file name for GIF (note that URL files are initially GIF format)
        constant_image_name_gif = constant_image_name + row_string + '.gif'

        # URL data is retrieved
        online_file = urlretrieve(constant_path,
                                  constant_image_name_gif)

        ###

        # Naming convention for JPG established (note that GIF are converted to JPG)
        constant_image_name_jpg = constant_image_name + '.jpg'
        Image.open(constant_image_name_gif).convert('RGB').save(constant_image_name_jpg)

        # Declare a list variable for use of generating PDFs from single JPGs
        imagelist = [constant_image_name_jpg]

        ###

        # Set unique naming convention and extension for PDFs files
        constant_image_name_pdf = constant_image_name + '.pdf'

        # Begin process of converting separate JPG files to corresponding PDF files
        pdf = FPDF()
        for image in imagelist:
            pdf.add_page()
            pdf.image(image, 0, 0, 200, 200)
        pdf.output(constant_image_name_pdf, "F")
        print('New File: ', constant_image_name_pdf)

        # Remove unnecessary GIF and JPG data
        os.remove(constant_image_name_jpg)
        os.remove(constant_image_name_gif)

        ###

        # List of ALL generated PDFs will now be used to concatenate all files into 1 file
        pdf_list.append(constant_image_name_pdf)
        pdf_list2.append(constant_image_name_pdf)

print('\nImage Generation Complete ... Now Combining Files\n')
time.sleep(2)

# Begin process of collecting and concatenating all PDFs into single PDF file
merger = PdfFileMerger()
for pdf in pdf_list:
    merger.append(open(pdf, 'rb'))
with open('ALL_IMAGES.pdf', 'wb') as fout:
    merger.write(fout)
time.sleep(2)

# End prompts for user
dir_path = os.path.dirname(os.path.realpath('ALL_IMAGES.pdf'))
print('\nCurrent PWD: \n', dir_path)

print('\nProcess Complete - New File: ALL_IMAGES.pdf\n')
time.sleep(5)
