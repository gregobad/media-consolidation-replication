

** Bring in dma and congruence information

use "data/CCES/cd_dma/cd2dma.dta", clear
	merge m:1 state using "data/CCES/cd_dma/xwalk_state.dta"
	drop if _m!=3
	rename statefp state_temp
	tostring state_temp, gen(statefp)
	drop state_temp
	replace statefp = "0"+statefp if length(statefp)==1
	replace cong_district=statefp+cong_district
	tostring dma, replace
	collapse share_of_dma, by (statefp dma cong_district)
	preserve
	import delimited "data/CCES/cd_dma/DMA-zip.csv",  clear
	bys fips dmacode dmaname: gen dup=_n
	keep if dup==1
	keep fips dmacode dmaname
	tostring dmacode, replace
	rename dmacode dma
	rename dmaname dma_name
	tempfile countydma
	save `countydma'
	
	restore
	joinby dma using `countydma', unmatched(none) _merge(merge_indicator)
	

	** Ensure FIPS has leading zeros
	capture confirm numeric variable fips
	if _rc == 0 {
		tostring fips, replace format(%05.0f)
	}
	replace fips = string(real(fips), "%05.0f") if !missing(real(fips))

	** Renaming for CCES merge 
	rename cong_district cd 
	rename statefp statefips
** To numeric: dmacode
	gen dmacode =  dma
	destring dmacode, replace
	

** This creates "final_with_counties_new"
save "data/CCES/working/final_with_counties_new.dta", replace

	
	
