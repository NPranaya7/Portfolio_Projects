use portfolio;

create table housing(
UniqueID 	double,
ParcelID	varchar(255),
LandUse		varchar(255),
PropertyAddress	varchar(255),
SaleDate	date,
SalePrice	double,
LegalReference	varchar(255),
SoldAsVacant	varchar(255),
OwnerName	varchar(255),
OwnerAddress	varchar(255),
Acreage		decimal(10, 2),
TaxDistrict	varchar(255),
LandValue	double,
BuildingValue	double,
TotalValue	double,
YearBuilt	year,
Bedrooms	integer,
FullBath	integer,
HalfBath	integer
);

select * from housing;

show variables like 'local_infile';

SET GLOBAL local_infile=1;

load data local infile "/Users/prana/Downloads/Nashville Housing Data for Data Cleaning (reuploaded).csv"
into table housing
fields terminated by ','
ENCLOSED BY '"'
ignore 1 rows;

select * from housing;

