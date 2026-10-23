////////////////////////////
// NUMBER OF ACQUISITIONS //
////////////////////////////

use ${PATH}/data/acquisitions/acquisition_panel_station_top3_FINAL.dta, clear

foreach group in sinclair nexstar gray {
	bysort stationID: egen min_`group' = min(station_ownedby_`group'_LMA)
	bysort stationID: egen max_`group' = max(station_ownedby_`group'_LMA)
	}

unique stationID if max_sinclair==1
unique stationID if max_nexstar==1
unique stationID if max_gray==1
	
unique stationID if min_sinclair==0&max_sinclair==1
unique stationID if min_nexstar==0&max_nexstar==1
unique stationID if min_gray==0&max_gray==1