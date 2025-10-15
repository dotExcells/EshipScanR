
# EshipScanR v2.5.0 - 15/10/2025 "Open Release"

This processing code is only compatible with data produced by the [Entrepreneurship Competency Scan](https://edu.nl/mqmny)

MS Forms is constantly adding extra columns to the .xls output of a form, so the program may need to be adjusted from time to time to remove them.

## Form Setup

1. Duplicate the [Entrepreneurship Competency Scan](https://edu.nl/mqmny) form

2. Click "Collect responses".
   Then, on the left-hand side, select "Anyone can respond" and then click "Copy Link"

4. Share this link with your participants

5. Once you are ready to process the data, navigate to "View Responses".
    Then, on the right-hand side under "Insights and actions", click the downward-facing arrow next to the spreadsheet icon and select "Download a copy"

6. Place the downloaded data in a new folder, ensuring it is the **ONLY** .xls file in that folder

## process.R Usage

0. Ensure [RStudio Desktop](https://cran.rstudio.com/) is installed 

1. Download the file "process.R" and put it in the folder containing your data

2.	Open "process.R" in RStudio

3.	Click in the section containing the code and press Ctrl+A to select all

4.	Press Ctrl+Enter to run the code

5.	You should now see a folder called "Charts d-m-y H M" in your original folder

6.	Cross reference the first and last chart with your original data to double check
