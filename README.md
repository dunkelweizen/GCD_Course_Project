# Course Project for Getting and Cleaning Data
## Tidy data set for UCI HAR Dataset


The data for this project is courtesy of the UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/)

The course projecty asked us to create a tidy data set, according to the principles of tidy data outlined in Coursera's Getting and Cleaning Data course, of the "Human Activity Recognition Using Smartphones" dataset:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## File listing

* README.md - this file
* run_analysis.R - the documented R script to create the tidy data set
* tidydata.txt - the tidy data set itself. This can be read into R using the R command read.table('tidydata.txt', header=T)
* CODEBOOK.md - the codebook detailing the variables in tidydata.txt

## Notes

run_analysis.R was run under version 3.1.2 (Pumpkin Helmet) and requires the reshape package (version 0.8.5 was used)

## Citation

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012