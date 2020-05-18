<!-- # --- -->
<!-- # title: "README" -->
<!-- # author: "Alex Ivanova" -->
<!-- # date: "5/18/2020" -->
<!-- # output: html_document -->
<!-- # --- -->
## How to run the R script

1. Download the zip file that contains the data and unzip it.
2. Put all the necessary files in your work dir.
3. Make sure you have all the packages installed and then run the script.
4. The output will be in the `tidydata.txt`.

More information about the data we process can be found in the CodeBook.

### Implementing of the processing steps

The processing steps can be found in the Code Book.
The rough description of how `run_analysis.R` works:

* Load `dplyr`, `tidyr`, and `data.table` packages
* Read in the data
* Merge the data so we have one data table
* Extract the data containing only mean and standard deviation columns
* Change activity labels to descriptive activity names
* Change the feature labels to more comprehensive descriptive names
* Create an independent tidy data set with the average of each variable for each activity and each subject
