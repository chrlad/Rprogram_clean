#Introduction
The codebook gives an update on the existing codebooks for the relevant datasets.

The original data is coming from here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The script run_Analysis.R takes the fields containig std or mean from the original data and binds it all together in one dataset 
together with the subject and activity files. It then calculates the average on all variables by subject and activity labels, 
the resulting dataset can be seen in the file averages.txt.
