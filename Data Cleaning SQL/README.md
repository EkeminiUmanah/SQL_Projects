## Project Title: Nashville Housing Data Cleaning Project

** Project Description:
Welcome to the Nashville Housing Data Cleaning Project! This repository contains SQL queries aimed at cleaning and preparing the Nashville housing dataset for analysis. 

## Data Source:
The project uses the Nashville housing dataset, which contains information about properties in Nashville, including attributes such as property addresses, sale prices, land use, and more. The dataset is sourced from [https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data].

## Script Overview:
The provided SQL script covers a series of data cleaning operations performed on the Nashville housing dataset. Here's an overview of the steps taken:

1. **Standardize Date Format:** Convert the SaleDate column to a consistent Date format.
2. **Populate Property Address Data:** Fill in missing property addresses by combining data from related records.
3. **Breaking Out Property Address:** Split the PropertyAddress column into separate columns for Address and City.
4. **Breaking Out Owner Address:** Split the OwnerAddress column into separate columns for Address, City, and State.
5. **Change Y and N to Yes and No:** Standardize the SoldAsVacant column values to 'Yes' and 'No'.
6. **Remove Duplicates:** Remove duplicate records based on specific columns.
7. **Delete Unused Columns:** Drop unnecessary columns, OwnerAddress and PropertyAddress.

