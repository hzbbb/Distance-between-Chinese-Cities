****** Calculate Distance between Main Cities in China 	******
****** Zibin Huang 2019.9.7                       		******
****** Input: Chinese_City_Coordinate.xlsx (287 Cities) ******
******        City_pair_list.dta						******
****** Output: City_distance.dta (287*287=82369 pairs)	******

clear
set more off

cd "D:\Dropbox\Dropbox\My documents\Micro dataset\全国各城市坐标及互相距离\Main Cities"

/** Import and convert coordinate file **/
import excel Chinese_City_Coordinate.xlsx, sheet("Sheet1") firstrow
drop if X==.
rename X longitude
rename Y latitude
save Chinese_City_Coordinate.dta,replace

/** Merge with city-list data **/
/* Hukou city */
rename Citycode hukou_city
tostring hukou_city,replace
rename Cityname hukou_city_name
rename longitude hukou_longitude
rename latitude hukou_latitude
merge 1:m hukou_city using city_pair_list.dta
drop _merge

save temp.dta,replace

/* Living city */
use Chinese_City_Coordinate.dta,clear

rename Citycode living_city
tostring living_city,replace
rename Cityname living_city_name
rename longitude living_longitude
rename latitude living_latitude
merge 1:m living_city using temp.dta

drop _merge

/* Calculate distance */
geodist hukou_latitude hukou_longitude living_latitude living_longitude,gen(distance)
sort hukou_city living_city

save City_distance.dta,replace

erase temp.dta




