"""
Created on Thu Feb 28 15:17:01 2019
@author: Arianna
"""

import os
import time
import csv
import urllib.request 
from bs4 import BeautifulSoup
import pandas as pd

# SET THE PATH TO THE ROOT OF THIS ARCHIVE HERE
path_to_archive = '/path/to/replication'
os.chdir(path_to_archive)

# NOTE: this script was run in July 2022 against the FCC CDBS public-access call sign history pages.
# Its output (data/acquisitions/callsigns_history.csv) is included in the archive.
    
##############################################
# scrapes FCC CDBS call sign history by facility ID #
##############################################

if os.path.isfile(r'data/acquisitions/callsigns_history.csv'):    
	os.remove(r'data/acquisitions/callsigns_history.csv')

fccIDs = pd.read_stata('data/acquisitions/fccidnumbers_for_scraping.dta')
fccIDs = fccIDs['fccidnumber'].tolist()

callsign_history_FULL = pd.DataFrame(columns=['callsign','from_date','fccID'])

for fccID in fccIDs:
    
    print('getting information for fccID: '+str(fccID))
    
    try:
        url = 'https://licensing.fcc.gov/cgi-bin/ws.exe/prod/cdbs/pubacc/prod/call_hist.pl?Facility_id='+str(fccID)
        dfs = pd.read_html(url)
        callsign_history_df = dfs[6]
        callsign_history_df.drop(callsign_history_df.head(1).index,inplace=True) 
        callsign_history_df.columns = ['callsign','from_date']
        callsign_history_df['fccID']=str(fccID)
        callsign_history_FULL = callsign_history_FULL.append(callsign_history_df)

    except:
        print('  cannot scrape fccID: '+str(fccID))
        continue
                    
callsign_history_FULL.to_csv('data/acquisitions/callsigns_history.csv')

