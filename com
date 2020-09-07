from pdfminer3.layout import LAParams
from pdfminer3.pdfpage import PDFPage
from pdfminer3.pdfinterp import PDFResourceManager
from pdfminer3.pdfinterp import PDFPageInterpreter
from pdfminer3.converter import TextConverter
import io
import re

### Setting up the pdf file for processing and extracting the text in it into a string ###

resource_manager = PDFResourceManager()
filehandler = io.StringIO()
converter = TextConverter(resource_manager, filehandler, laparams=LAParams())
page_interpreter = PDFPageInterpreter(resource_manager, converter)

with open('pdfregexsearch.pdf', 'rb') as searchpdf: # ----->  You need to change this to the directory the pdf is in

    for page in PDFPage.get_pages(searchpdf,caching=True,check_extractable=True):
        page_interpreter.process_page(page)

    text = filehandler.getvalue()


# close open handles
converter.close()
filehandler.close()



test_list = [] # creates an empty list
test_list += [text] # assigns all the values in text to the empty list

s = test_list


### Using a regular expression to find specific patterns in the text ###

# using list comprehension to convert list to string
# this way we can search through the string for occurences of what you are looking for
listToStr = '\n'.join([str(elem) for elem in s])

print(listToStr)

re_list = [r'\b(\w*NSDL\w*\/\w*POLICY\w*\/\w*2020\w*\/\w*0010\w*)\b',
r'\b(\w*RBI\w*\/\w*2019-20\w*\/\w*154 DPSS.CO.PD No. 1465\w*\/\w*02.14.003\w*\/\w*2019-20\w*)\b',
r'\b(\w*RBI\w*\/\w*2019-20\w*\/\w*203    DOR.CO.Leg.BC.No.59\s\w*\/\w*09.07.005\w*\/\w*2019-20\w*)\b',
r'\b\w*SEBI\w*\/\w*HO\w*\/\w*MIRSD\w*\/\w*RTAMB\w*\/\w*CIR\w*\/\w*P\w*\/\w*2019\w*\/\w*122\w*\b',
r'\b(\w*RBI\w*\/\w*2017-18\w*\/\w*161\w*)\b',
r'\b(\w*RBI\w*\/\w*2015-16\w*\/\w*59 DBR No.Leg.BC.21\w*\/\w*09.07.006\w*\/\w*2015-16\w*)\b',
r'\b(\w*RBI\w*\/\w*FED\w*\/\w*2015-16\w*\/\w*7 FED Master Direction No.  12\w*\/\w*2015-16\w*)\b',
r'\b(\w*RBI\w*\/\w*FED\w*\/\w*2015-16\w*\/\w*9         FED Master Direction No. 14\w*\/\w*2015-16\w*)\b',
r'\b(\w*RBI\w*\/\w*2018-19\w*\/\w*151           FMRD.DIRD.13\w*\/\w*14.03.041\w*\/\w*2018-19\w*)\b',
r'\b(\w*PS&BT\w*\/\w*GOVT\w*\/\w*8878\w*)\b',
r'\b(\w*RBI\w*\/\w*2019-20\w*\/\w*177\.       A\. P\.\(DIR Series\) Circular No\.22\w*)\b',
r'\b(\w*SPL-08.BC\w*\/\w*Commodity Hedge\w*\/\w*2018\w*)\b',
r'\b(\w*SEBI\w*\/\w*HO\w*\/\w*CFD\w*\/\w*DIL2\w*\/\w*CIR\w*\/\w*P\w*\/\w*2020\w*\/\w*13\w*)\b']

matches = []
for r in re_list:
   matches = re.findall(r, listToStr)
   print(matches)
