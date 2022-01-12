SELECT SaleDate, CONVERT(DATE, SaleDate)
fROM NashvilleHousing

UPDATE NashvilleHousing
SET Sale_Date = CONVERT(date, SaleDate)

ALTER TABLE NashvilleHousing
ADD Sale_Date Date;

SELECT *
FROM PortfolioProjrct.dbo.NashvilleHousing

ALTER TABLE PortfolioProjrct.dbo.NashvilleHousing
DROP COLUMN SaleDate

--Fill Property address--
SELECT a.ParcelID, a.PropertyAddress, b.ParcelId, b.PropertyAddress
FROM PortfolioProjrct.dbo.NashvilleHousing a
JOIN PortfolioProjrct.dbo.NashvilleHousing b
       ON a.ParcelID = b.ParcelID
		And a.[UniqueID ]<> b. [UniqueID ]
WHERE a.PropertyAddress  is NULL

UPDATE a
SET a.PropertyAddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjrct.dbo.NashvilleHousing a
JOIN PortfolioProjrct.dbo.NashvilleHousing b
       ON a.ParcelID = b.ParcelID
		And a.[UniqueID ]<> b. [UniqueID ]
WHERE a.PropertyAddress  is NULL

-----Split Adsress and city from the PropertyAddress column---]
Select PropertyAddress,
 SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) as Adsress,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) as City
From PortfolioProjrct.dbo.NashvilleHousing

ALTER TABLE PortfolioProjrct.DBO.NashvilleHousing
ADD ProAddress Nvarchar(255)

UPDATE PortfolioProjrct.DBO.NashvilleHousing 
SET ProAddress =  SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE PortfolioProjrct.DBO.NashvilleHousing
ADD ProCity Nvarchar(255)

UPDATE PortfolioProjrct.DBO.NashvilleHousing 
SET ProCity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) 



-----------------------Split Owner Address, city, State-----
SELECT OwnerAddress
FROM PortfolioProjrct.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',', '.'),3),
PARSENAME(REPLACE(OwnerAddress,',', '.'),2),
PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
FROM PortfolioProjrct.dbo.NashvilleHousing

ALTER TABLE PortfolioProjrct.DBO.NashvilleHousing
ADD Owner_Address Nvarchar(255)

ALTER TABLE PortfolioProjrct.DBO.NashvilleHousing
ADD OwnerCity Nvarchar(255)

ALTER TABLE PortfolioProjrct.DBO.NashvilleHousing
ADD OwnerState Nvarchar(255)

UPDATE PortfolioProjrct.DBO.NashvilleHousing 
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

UPDATE PortfolioProjrct.DBO.NashvilleHousing 
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress,',', '.'),2)

UPDATE PortfolioProjrct.DBO.NashvilleHousing 
SET OwnerState = PARSENAME(REPLACE(OwnerAddress,',', '.'),1)

SELECT *
from PortfolioProjrct.DBO.NashvilleHousing


-----Change Y and N to 'YES' and 'NO' in Sold as Vacant column-----
SELECT 
CASE 
     WHEN SoldAsVacant = 'N' THEN 'No'
	 WHEN SoldAsVacant = 'Y' THEN  'Yes'
	 ELSE SoldAsVacant
	 END
From PortfolioProjrct.DBO.NashvilleHousing

UPDATE PortfolioProjrct.dbo.NashvilleHousing
SET SoldAsVacant = CASE 
     WHEN SoldAsVacant = 'N' THEN 'No'
	 WHEN SoldAsVacant = 'Y' THEN  'Yes'
	 ELSE SoldAsVacant
	 END

-----------------remoce Duplicates--------
 WITH CTE AS
 (
 SELECT *,
 ROW_NUMBER() OVER ( Partition by 
                 ParcelID,
				 SalePrice,
				 Sale_Date,
				 LegalReference
				 Order by UniqueID) row_num
FROM PortfolioProjrct.dbo.NashvilleHousing
)
SELECT *
FROM CTE
WHERE row_num >1

----------------Delete Unwanted columns--
SELECT *
FROM PortfolioProjrct.dbo.NashvilleHousing

ALTER TABLE PortfolioProjrct.DBO.NashvilleHousing
DROP COLUMN PropertyAddress

ALTER TABLE PortfolioProjrct.DBO.NashvilleHousing
DROP COLUMN TaxDistrict

