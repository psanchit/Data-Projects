--Data cleaning

select * from nashvillehousing;

--Standardise Data format

select saledate, cast(saledate as date) from nashvillehousing;

update nashvillehousing
set saledate = cast(saledate as date);

--Populate property address data

select a.propertyaddress,a.parcelid,b.propertyaddress ,b.parcelid,replace(b.propertyaddress,a.propertyaddress)
from nashvillehousing a
join nashvillehousing b
on a.parcelid = b.parcelid
and a.uniqueid_ <> b.uniqueid_
where a.propertyaddress is null;

select * from nashvillehousing;

update nashvillehousing a 
set a.propertyaddress = (select max(b.propertyaddress)
              from nashvillehousing b
              where b.parcelid = a.parcelid and a.uniqueid_ <> b.uniqueid_)
where a.propertyaddress is null;

--Breaking out Address into Individual Columns (Address, City, State)
select * from nashvillehousing;

select propertyaddress,
substr(propertyaddress,0,(instr(propertyaddress,',')-1)) as address,
substr(propertyaddress,(instr(propertyaddress,',')+1),length(propertyaddress)) as cit
from nashvillehousing;

Alter table nashvillehousing
add address varchar(255);

update nashvillehousing
set address = substr(propertyaddress,0,(instr(propertyaddress,',')-1));

Alter table nashvillehousing
add city varchar(255);

update nashvillehousing
set city = substr(propertyaddress,(instr(propertyaddress,',')+1),length(propertyaddress)) ;

Alter table nashvillehousing
rename COLUMN city to propertysplitcity;


select owneraddress,
substr(owneraddress,0,(instr(owneraddress,',')-1)) as address,
substr(owneraddress,(instr(owneraddress,',')+1),(instr(owneraddress,',',1,2)-1)-(instr(owneraddress,','))) as city,
substr(owneraddress,(instr(owneraddress,',',1,2)+1),length(propertyaddress)) as state
from nashvillehousing;

Alter table nashvillehousing
add ownersplitaddress varchar(255);

update nashvillehousing
set ownersplitaddress = substr(owneraddress,0,(instr(owneraddress,',')-1));

Alter table nashvillehousing
add ownersplitcity varchar(255);

update nashvillehousing
set ownersplitcity = substr(owneraddress,(instr(owneraddress,',')+1),(instr(owneraddress,',',1,2)-1)-(instr(owneraddress,',')));

Alter table nashvillehousing
add ownersplitstate varchar(255);

update nashvillehousing
set ownersplitstate = substr(owneraddress,(instr(owneraddress,',',1,2)+1),length(propertyaddress));

select * from nashvillehousing;

--Change Y and N to Yes and No in "Sold as Vacant" field --

select distinct(soldasvacant),count(soldasvacant)
from nashvillehousing
group by soldasvacant;

select soldasvacant,
case when soldasvacant='Y' then 'Yes'
     when soldasvacant='N' then 'No'
     else soldasvacant
     end
from nashvillehousing;

update nashvillehousing
set soldasvacant=case when soldasvacant='Y' then 'Yes'
     when soldasvacant='N' then 'No'
     else soldasvacant
     end;


--Delete Unused Columns

select * from nashvillehousing;


Alter table nashvillehousing
drop column taxdistrict;
