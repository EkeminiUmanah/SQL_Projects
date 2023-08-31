-- Cleaning Data in SQL Queries
-- This script performs data cleaning operations on the NashvilleHousing table.

--******************************************************************************************************************************************

-- Standardize Date Format
-- Convert SaleDate to the Date data type.

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate);

--******************************************************************************************************************************************

-- Populate Property Address data
-- Fill missing PropertyAddress using data from related records.

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

--******************************************************************************************************************************************

-- Breaking out Property Address into Individual Columns (Address, City, State)
-- Split PropertyAddress into separate columns for Address and City.

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

--******************************************************************************************************************************************
-- Breaking out Owner Address into Individual Columns (Address, City, State)
-- Split OwnerAddress into separate columns for Address, City, and State.

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD Owner_Address NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD Owner_City NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD Owner_State NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

--******************************************************************************************************************************************
-- Change Y and N to Yes and No in "Sold as Vacant" field
-- Replace Y and N values in SoldAsVacant column.

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END;

--******************************************************************************************************************************************
-- Remove Duplicates
-- Remove duplicate records based on certain columns.

WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM PortfolioProject.dbo.NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1;

--******************************************************************************************************************************************
-- Delete Unused Columns
-- Drop columns OwnerAddress and PropertyAddress.

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress;
