## Checking the DataSet
use portfolio;

select * from portfolio.housing;
-----------------------------------------------------------------------------------------------------------------
## Null/Blank Value Detection
-- We are not suppose to delete any data from the table, in proffesional way it is not considered as a standard practice 
-- but in here i am just showing the querey to delete the data 

SELECT count(*) FROM housing as h
WHERE h.uniqueID = '';

SELECT * FROM housing as h
WHERE h.UniqueID = '';
------------------------------------------------------------------------------------------------------------------
## Droping the Invalid Row from the Table:

Delete from housing 
where UniqueID = '';

------------------------------------------------------------------------------------------------------------------
## PropertyAddress 
-- I filled the Blank/Null in PropertyAddress with values depending on ParcelId.
-- when i obsereved the table i found that similar parcelId have Similar propertyAddress
-- so if propertyAddress is Null/Blank then if that parcel id repeated in the table then i used that parcel id property address to fill that Blank/Null position in the table   

SELECT count(*) FROM housing as h
WHERE h.PropertyAddress = '';

SELECT * FROM housing as h
WHERE h.ParcelID = '';

UPDATE housing t1
JOIN housing t2 ON t1.ParcelID = t2.ParcelID and t1.UniqueID <> t2.UniqueID
SET t1.PropertyAddress = t2.PropertyAddress
WHERE t1.PropertyAddress = '';
------------------------------------------------------------------------------------------------------------------
## Spliting Property Address 
-- in here i splitted the Propert Address details into two columns street and city 

ALTER TABLE housing
ADD COLUMN street VARCHAR(255),
ADD COLUMN City VARCHAR(255);

select PropertyAddress,street,City from housing;


update Housing
set 
	street =trim(SUBSTRING_INDEX(PropertyAddress,',',1)),
   	City =trim(SUBSTRING_INDEX(PropertyAddress,',',-1));

------------------------------------------------------------------------------------------------------------------
## SalePrice, OwnerName, Acreage
-- in salePrice i found black position in these columns but i didn't fill these position because of there is no reference to do 

select * from portfolio.housing;

SELECT count(*) FROM housing as h
WHERE h.SalePrice = ''
   or h.OwnerName = ''
   or h.Acreage = '';

SELECT * FROM housing as h
WHERE h.SalePrice = ''
   or h.OwnerName = ''
   or h.Acreage = '';

SELECT COUNT(*) FROM housing
WHERE SalePrice is Null
   or OwnerName is Null
   or h.Acreage is Null;
------------------------------------------------------------------------------------------------------------------
##Legal Reference, SoldASVacant
-- in these columns i didn't find any Blanks or Null Values

select * from portfolio.housing;

SELECT count(*) FROM housing as h
WHERE h.LegalReference = '' 
   or h.SoldAsVacant = '';
   
   
SELECT * FROM housing as h
WHERE h.LegalReference is Null
   or h.SoldAsVacant is Null;

--------------------------------------------------------------------------------------------------------------------
## OwnerAddress
-- In ownerAddress i found 30461 position Blank/Null 
-- i updated these Blanks/null with the Property Address

select * from portfolio.housing;

SELECT count(*) FROM housing as h
WHERE h.OwnerAddress = '';

SELECT * FROM housing as h
WHERE h.OwnerAddress = '';

update housing
set OwnerAddress = PropertyAddress
where OwnerAddress = '';
------------------------------------------------------------------------------------------------------------------------
## SoldAsVacant
-- in SoldAsVacant their are 4 Distinct values are there (Yes, No, Y, N)
-- so i replaced the Y and N Values with Yes & No respectively

select distinct SoldAsVacant from portfolio.housing;

select distinct SoldAsVacant, count(SoldAsVacant) from portfolio.housing
group by SoldAsVacant
order by 2;
-- we can update the position in two ways 
# 1
update housing 
set SoldAsVacant = 'Yes'
where SoldAsVacant = 'Y';

update housing 
set SoldAsVacant = 'No'
where SoldAsVacant = 'N';

# 2 
update housing 
set SoldAsVacant = case when SoldAsVacant = 'Y' Then 'Yes'
						when SoldAsVacant = 'N' Then 'No'
                        Else SoldAsVacant
                        End;

select distinct SoldAsVacant from portfolio.housing;
---------------------------------------------------------------------------------------------------
## Duplicates
-- Checking for Duplicates if Duplicates present in the table then remove that rows from the table 
-- but in here i didn't find any duplicates

select * from portfolio.housing;

SELECT LegalReference, COUNT(*) as count
FROM housing
GROUP BY LegalReference
HAVING COUNT(*) > 1;

SELECT *
FROM housing
GROUP BY UniqueID, ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference, SoldAsVacant, OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath, street, City
HAVING COUNT(*) > 1;
--------------------------------------------------------------------------------------------------------
## Droping the Columns PropertAddress because we already split this data into new columns

 select * from portfolio.housing;

ALTER TABLE housing
DROP COLUMN PropertyAddress;


