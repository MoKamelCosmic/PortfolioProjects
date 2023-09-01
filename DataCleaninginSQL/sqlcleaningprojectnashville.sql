Select *
From PortfolioProject.dbo.NashvilleHousing

--Change SaleDate Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add	SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--Populate Property Address Table

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID




Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <>b.[UniqueID ]
	where a.PropertyAddress is null

	Update a
	SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <>b.[UniqueID ]
	where a.PropertyAddress is null

--Splitting Address

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add	SplitPropertyAddress NvarChar(255);


Update NashvilleHousing
SET SplitPropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 


ALTER TABLE NashvilleHousing
Add	SplitPropertyCity NvarChar(255);


Update NashvilleHousing
SET SplitPropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) 






Select OwnerAddress
From PortfolioProject..NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject..NashvilleHousing



ALTER TABLE portfolioProject.dbo.NashvilleHousing
Add	SplitOwnerAddress NvarChar(255);


Update portfolioproject..NashvilleHousing
SET SplitOwnerAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE portfolioproject..NashvilleHousing
Add	SplitOwnerCity NvarChar(255);


Update portfolioproject..NashvilleHousing
SET SplitOwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE portfolioproject..NashvilleHousing
Add	SplitOwnerState NvarChar(255);


Update portfolioproject..NashvilleHousing
SET SplitOwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


Select *
From PortfolioProject..NashvilleHousing


--change Y and N to yes and no in soldasvanat

Select Distinct(SoldAsVacant), COUNT(soldasvacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
,Case when SoldAsVacant = 'Y' Then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  ELSE SoldAsVacant
	  END
From PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
SET SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  ELSE SoldAsVacant
	  END


--Removing duplicates 
WITH RowNumCTE AS (
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From Portfolioproject..NashvilleHousing
--order by ParcelID
 )
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


Select*
From PortfolioProject..NashvilleHousing



--Delete Unused Columns
Select *
From PortfolioProject..NashvilleHousing

ALTER TABLE Portfolioproject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Portfolioproject..NashvilleHousing
DROP COLUMN SaleDate

