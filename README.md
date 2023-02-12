# covidapp-autoupdater
Autoupdater utility for https://github.com/KevRunAmok/Covid19app

# Steps to update Counts

1. Pull counts

*** STEPS TO EDIT THE NY TIMES DATA AND CREATE THE INSERT AND UPDATE STATEMENTS. ***

    Most counties are already in the system, would be rare at this point to need to 
    add another one.  There are sql files with inserts for this purpose and would be
    done by hand to add one or two.
    
Source File: 
https://github.com/nytimes/covid-19-data
https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties-recent.csv

Cut the days not yet entered, I have been doing 3 days at a time but can be done daily
if we get these steps eventually automated.
Disclaimer: The time estimates  are for running on my old windows 10 laptop, A more
powerful machine may reduce these execution times to short manageable, acceptable values.

1. Prep

    ___ Cut and paste into MySQL > NYT Data Import > Daily Import File.txt

    ___ Search for 'Rota' and remove line.  (This is tiny new county in Northern Mariana Islands)
    
    ___ Search for 'Pending' and remove line.  (This is in Texas and not assigned a county yet)
    
    ___ Search for 'Joplin' and remove line. (exclude outer '')
        
    ___ Search for 'Kalawao' and remove line. (exclude outer '')
        
    ___ Search for ' Ana' and replace the '~n' with 'n'. (exclude outer '')
             [may be called an umlaut, its shorthand for nn in spanish, may be some 
              keyboard shortcut or some way to eventually automate matching this.]

    ___ Replace ''' with '\'' (deselect Regular Expression) (exclude outer '')
    
    ___ Replace ',$' with ',0' (select Regular Expression) (exclude outer '')
    
    ___ Replace 'plus Lake and Peninsula' with 'Borough' (exclude outer '')
    
    ___ Replace 'plus Hoonah-Angoon' with 'City and Borough'  (exclude outer '')
    
    ___ Copy and Append this to AllThruYYYYMMDD.txt file (Rename with YYYYMMDD of last
        entry date.

2. Generate following Insert and Update tables, currently using Excel formulas

    ___ file is MySQL > NYT Data Import > Temp Prep Doc.xlsx
        ___ Tabs 'raw data 1' and 'raw data 2' alternate.  Edit as follows:
            ___ Find which tab has the largest 'usa_raw_data_id' value on its last row.
            ___ Enter that value on the other tab in the formula of cell H1. Example
                location ..."&ROW(A1)+1687876&"...  The value 1687876 would be changed.
            ___ Highlight contents of columns A - F and right click to select 'Clear Contents'.
            ___ Highlight cell A1, select 'Data' > 'From Text' and select the 
                'Daily Import File.txt' for insert.  Click Next, select comma separated,click
                Done, then ensure its pasted in cell A1.
                ___ Note: sometimes 'From Text' is grayed out.  In this case, select 'Data' >
                    'Properties'. De-Select Save Query Definition, click Ok in popup, then click
                    ok again from menu.  Then the grayed out should become selectable.  May have
                    to repeat several times.
                ___ Now copy cell H1, and highlight that rows cells H2 all the way to end of data
                    and paste.  Follow this with 'Formulas' > 'Calculate Sheet' and you are done.
                ___ now cut and paste all of these INSERT commands into 'covid19_raw_data_tables_insert_batch.sql'
                ___ a short cut to prepare the batch sql file, highlight first 5 rows (the rows just before
                    the first insert).  Then click in order ctrl-X, ctr-A, ctrl-V.  This will remove all the
                    insert rows and leave the DB info at the top.  Then when you copy the new insert rows
                    from the excel file and paste them into the sql file you will have a ready to run sql file.
                ___ For the 'covid19_raw_data_table_batch_insert_FULL.sql' append this same date to end of that file
                    and save both files.
                ___ In MySQL select 'File' > 'Run SQL script...' and select 'covid19_raw_data_tables_insert_batch.sql'
                    file and click Open followed by clicking on RUN.  Monitor until it completes successfully.
                    Note: execution can take 20-30 min or so.

    ___ file is MySQL > NYT Data Import > InsertStateAndDailyTable.xlsx
        ___ Select tab 'Insert Raw County Daily'
        ___ Find which tab has the largest 'usa_raw_county_daily_id' value on its last row.
        ___ Enter that value in cell G1.
        ___ A - F should be set with Data > Filter so sort on column A Newest to Oldest.
        ___ keep the Newest data, scroll down and highlight older entried in columns A-F and 'Clear Contents'
        ___ then click on first cell in column A below the last Newest entry value (approx cell A3250)
        ___ Select Data > From Text and select file 'Daily Import File.txt'.  Click Next, comma, Finish and
            ensure its placed into that cell in column A and hit OK.
        ___ Scroll to bottom and see if there are fewer or extra entries in column G,H,I.  Fi extra, remove
            them, if short, copy last entry in cells G,H,I into cells below until even.
        ___ Go back to top and sort on column C > A to Z, then column B > A to Z.
        ___ Then click on Formulas > Calculate Sheet and you should see a clean update of insert command
        ___ Copy all the insert entries in column I and place them into the following files.
            ___  Append into 'covid19_raw_county_daily_tables_insert_full.sql' and save.
            ___  Clear, leave the 5 DB lines at top and drop these new lines into file 
                 'covid19_raw_county_daily_tables_insert_batch.sql' and save.
        ___ In MySQL select 'File' > 'Run SQL script...' and select 
            'covid19_raw_county_daily_tables_insert_batch.sql' file and click Open followed by clicking on RUN.  
            Monitor until it completes successfully. Note execution can take 20 min or so

        ___ Select tab 'Insert Raw State Daily'
        ___ Find the largest 'usa_raw_state_daily_id' value on its last row.
        ___ Enter that value in cell G1.
        ___ Highlight columns A - F and select 'Clear Contents'.
        ___ then click on cell A1
        ___ Go to tab 'Insert Raw County Daily' and highlight columns A-F, copy them and paste them into
            cell A1 of tab 'Insert Raw State Daily'.
        ___ In tab 'Insert Raw State Daily' highlight date cells in column A2 down to match the number of 
            date cells in column F.  Highlight and copy and paste in cell J2.  This will update those dated 
            cells.
        ___ Then click on Formulas > Calculate Sheet and you should see a clean update of insert command
        ___ Copy all the insert entries in column N and place them into the following files.
            ___  Append into 'covid19_raw_state_daily_tables_insert_full.sql' and save.
            ___  Clear, leave the 5 DB lines at top and drop these new lines into file 
                 'covid19_raw_state_daily_tables_insert_batch.sql' and save.
        ___ In MySQL select 'File' > 'Run SQL script...' and select 
            'covid19_raw_state_daily_tables_insert_batch.sql' file and click Open followed by clicking on RUN.  
            Monitor until it completes successfully.  Note: execution time about 5 min.

        ___ Back in file 'Temp Prep Doc.xlsx'. Select tab 'Update County Cases Max'
        ___ in MySQL run query and when done cut and paste into Cell A2
            Query is in MySQL tab 'Update County and State Totals..'.  Run first query for County
        ___ then do Formual > Calculate Sheet, cut and paste update commands into batch and FULL files.
            County file is: update_county_totals_batch.sql (No FULL file for this update table)
            Note: query calculation can take half hour or so, and the execution 15-20 min.
        ___ Back in file 'Temp Prep Doc.xlsx'. Select tab 'Update State Cases Max'
        ___ in MySQL run query and when done cut and paste into Cell A1   
            Query is in MySQL tab 'Update County and State Totals..'.  Run second query for State
        ___ then do Formual > Calculate Sheet, cut and paste update commands into batch and FULL files.
            State file is: update_state_totals_batch.sql (No FULL file for this update table)
            Note: query calculation can take 15 min or so, the execution is much quicker.
        
3.  adminStates
    ___ Run app, enter in url adminStates.  let it load.  Then for the dates that you are loading select
        the following.By Date to Current ensuring that all of the dates you want to enter are noted in
        your selection.  Note: this takes 2-3 min for example for 3 days of data to update.
        

4.  adminCounties

    ___ Run app, enter in url adminCounties.  let it load.  Then for the dates that you are loading select
        the following.  'By Date to Current' ensuring that all of the dates you want to enter are noted in
        your selection, Note:  this takes 10-14 hours to complete for example 3 days of data to update.





*** STEPS TO EDIT THE HOSPITAL DATA AND CREATE THE WEEKLY TABLE INSERT STATEMENTS. ***

     When new hospitals are added you will need to also add those hospitals to the 
     usa_hospitals table, we do this manually when they appear, will see this when 
     running inserts and it fails when no hospitalname found.

Source File:
https://healthdata.gov/Hospital/COVID-19-Reported-Patient-Impact-and-Hospital-Capa/anag-cw7u

In excel file before generating the INSERT statements do the follow updates

1. Prep
    ___ Drop raw data into Excel file Hospital Data Assess.xlsx

    ___ Keep following columns: B - C, E - P, S, U-Z, AB-DA
        NOTE: They may change columns (rarely) so be sure to double check it is keeping the ones below
              On 1/7/2022 dataset they have removed several columns and that caused an incorrect insert
              so had to remove and redo all of this.  There was a warning in that we usually have 1 or 
              2 blank entries to convert to 0, this time there were 100+.  In hindsight that was a red
              flag but I proceeded anyway, then some of the charts did not look right.  Had to remove
              all inserts and redo all processing, fortunately the name changes are already done so the
              run should be smooth once data is reconstituted.
            ** OLD OLD ** This means deleting:A, D, Q, S, Z, AB - DB   ** OLD OLD ** Pre-1/7/2022 Only
            This means deleting:A, D, Q, R, T. AA. AC - DX
            leaves you with:  A: collection_week	
                              B: state	
                              C: hospital_name	
                              D: address	
                              E: city	
                              F: zip	
                              G: hospital_subtype	
                              H: fips_code	
                              I: is_metro_micro	
                              J: total_beds_7_day_avg	
                              K: all_adult_hospital_beds_7_day_avg	
                              L: all_adult_hospital_inpatient_beds_7_day_avg	
                              M: inpatient_beds_used_7_day_avg	
                              N: all_adult_hospital_inpatient_bed_occupied_7_day_avg	
                              O: total_adult_patients_hospitalized_confirmed_covid_7_day_avg	
                              P: total_pediatric_patients_hospitalized_confirmed_covid_7_day_avg	
                              Q: inpatient_beds_7_day_avg	
                              R: total_icu_beds_7_day_avg	
                              S: total_staffed_adult_icu_beds_7_day_avg	
                              T: icu_beds_used_7_day_avg	
                              U: staffed_adult_icu_bed_occupancy_7_day_avg	
                              V: staffed_icu_adult_patients_confirmed_covid_7_day_avg																																																																																				


2. Clean up numerical data

    ___ Nulls and -999999 entries - Change all of these to Zero. This must be done on all the numerical data 
        columns (J - V after rows removed)
        ____ Highlight J - V and select ctrl-F then Replace, enter '-999999' and '0' and replace all (exclude '')
             ~5167 replacements
    NOTE: Blanks will be dealt at the end of the cleanup phase.
3. Clean up textual data.  Applies to Column's C and D

    ____ Highlight C - D - E and select ctrl-F then Replace, enter ''' and '\'' and replace all (exclude '')
         ~207 Replacements. 

         Above handles some of these considerations

             'ALENE                        to    \'ALENE
             DAUGHTERS'                    to    DAUGHTERS\'                     (2 of them)
             DOCTORS'                      to    DOCTORS\'                       (3 of them)
             NEW YORK-PRESBYTERIAN/QUEENS  to    NEW YORK-PRESBYTERIAN\/QUEENS
             PATIENTS'                     to    PATIENTS\'
             2351 'G' RD                   to    2351 \'G\' RD
             HO'OLA                        to    HO\'OLA
             PHYSICIANS'                   to    PHYSICIANS\'                    (3 of them)
             SHRINERS'                     to    SHRINERS\'                      (2 of them)
             L' ANSE                       to    L\' ANSE
             'O' NEILL'                    to    'O\' NEILL'
             MINERS'                       to    MINERS\'
             O'CONNOR                      to    O\'CONNOR
             O'BLENESS                     to    O\'BLENESS

    ____ There are a handful of embedded / slashes Columns C - D. Globally Replace / with \/.  Takes care of below...

    _X__ Highlight C and select ctrl-F then Replace, enter 'NEW YORK-PRESBYTERIAN/QUEENS' and 
         'NEW YORK-PRESBYTERIAN\/QUEENS' and replace
         
    _X__ Highlight C and select ctrl-F then Replace, enter  'UNIVERSITY MEDICAL CENTER-MESABI/ MESABA CLINICS' and
         'UNIVERSITY MEDICAL CENTER-MESABI\/ MESABA CLINICS' and replace
         
4. Remove the following hospitals in Guam, American Northern Mariana Islands, American Samoa and empty FL entry

    ____ GUAM MEMORIAL HOSPITAL AUTHORITY  fip 66010 (1 row)
         GUAM REGIONAL MEDICAL CITY        fip 66010 (1 row)
         ____ In Excel, data filter, select fip 66010, highlight each row separately and delete.

    ____ COMMONWEALTH HEALTH CENTER        fip 69000 (1 row)
         ____ In Excel, data filter, select fip 69000, highlight each row separately and delete.

    ____ LBJ TROPICAL MEDICAL CENTER       zip 96799 (1 row) note: fip is null on this one...
         ____ In Excel, data filter, select zip 96799, highlight each row separately and delete.
         
    _X__ PARKSIDE SURGERY CENTER           1 entry all zeros and TX wrong. All jacksonville FL represented so remove.
         __X_ In Excel, data filter, select this hospital_name in column menu, note, may no longer reporting this one.


5. Convert the individual NYC Boroughs fips to the New York City County fips (36061)

    ____ In Excel, data filter, select the fips indicated below, bulk change them to 36061
    
    For each of...
    
        ____ STATEN ISLAND UNIVERSITY HOSPITAL                  fips from 36085 to 36061
        ____ RICHMOND UNIVERSITY MEDICAL CENTER                 fips from 36085 to 36061

        ____ LONG ISLAND JEWISH MEDICAL CENTER                  fips from 36081 to 36061
        ____ NEW YORK-PRESBYTERIAN\/QUEENS                      fips from 36081 to 36061
        ____ FLUSHING HOSPITAL MEDICAL CENTER                   fips from 36081 to 36061
        ____ ST JOHN\'S EPISCOPAL HOSPITAL AT SOUTH SHORE       fips from 36081 to 36061
        ____ QUEENS HOSPITAL CENTER                             fips from 36081 to 36061
        ____ JAMAICA HOSPITAL MEDICAL CENTER                    fips from 36081 to 36061
        ____ ELMHURST HOSPITAL CENTER                           fips from 36081 to 36061

        ____ CONEY ISLAND HOSPITAL CENTER                       fips from 36047 to 36061
        ____ KINGS COUNTY HOSPITAL CENTER                       fips from 36047 to 36061
        ____ NEW YORK-PRESBYTERIAN BROOKLYN METHODIST HOSPITAL  fips from 36047 to 36061
        ____ MAIMONIDES MEDICAL CENTER                          fips from 36047 to 36061
        ____ NEW YORK COMMUNITY HOSPITAL OF BROOKLYN, INC.      fips from 36047 to 36061
        ____ KINGSBROOK JEWISH MEDICAL CENTER                   fips from 36047 to 36061
        ____ WYCKOFF HEIGHTS MEDICAL CENTER                     fips from 36047 to 36061
        ____ BROOKLYN HOSPITAL CENTER - DOWNTOWN CAMPUS         fips from 36047 to 36061
        ____ INTERFAITH MEDICAL CENTER                          fips from 36047 to 36061
        ____ WOODHULL MEDICAL & MENTAL HEALTH CENTER            fips from 36047 to 36061
        ____ BROOKDALE HOSPITAL MEDICAL CENTER                  fips from 36047 to 36061
        ____ SUNY HEALTH SCIENCE CENTER AT BROOKLYN UNIVERSITY  fips from 36047 to 36061

        ____ MONTEFIORE MEDICAL CENTER                          fips from 36005 to 36061
        ____ JACOBI MEDICAL CENTER                              fips from 36005 to 36061
        ____ LINCOLN MEDICAL & MENTAL HEALTH CENTER             fips from 36005 to 36061
        ____ ST BARNABAS HOSPITAL                               fips from 36005 to 36061
        ____ NORTH CENTRAL BRONX HOSPITAL                       fips from 36005 to 36061
        ____ CALVARY HOSPITAL INC                               fips from 36005 to 36061
        ____ BRONXCARE HOSPITAL CENTER                          fips from 36005 to 36061


6. The following incorrect or missing addresses and cities are already updated in usa_hospitals table.
   Here just need to update the fips as follows for the inserts to work
   
    ____ Can change all 3 at same time by selecting fips Blanks, these will be there.
    
         ____ Alexandria Emergency Hospital
              ____ Rapides parrish (fips = 22079)
              ____ In Excel, data filter, select hospital_name above, set fips to 22079.  

         ____ Crescent City Surgical Centre
              ____ 3017 Galleria Drive, Metairie, LA 70118
              ____ Its in Orleans county (fips = 22071)
                   ____ In Excel, data filter, select hospital_name above, set fips to 22071.
                   ____ If address and city are null update to match above

         ____ Surgery Center of Zachary 
              ____ 4845 Main Street Suite A, Zachary, LA 70791
              ____ Its in East Baton Rough parrish (fips = 22033)
                   ____ In Excel, data filter, select hospital_name above, set fips to 22033.
                   ____ If address and city are null update to match above
            
         _X__ MURRAY-CALLOWAY COUNTY HOSPITAL
              __X_ 803 POPLAR STREET, MURRAY, KY 42071 (fips=21035)
              __X_ Address was messed up once, check, may be one time issue
              
    _XX_ Elite Medical Center
         _XX_ Its in Clark County   (Appears to no longer be reporting)
 
     
7. Manually update this information in file

    ____ Change 'BAYLOR SCOTT & WHITE MEDICAL CENTER GÇô PFLUGERVILLE' to 'BAYLOR SCOTT & WHITE MEDICAL CENTER - PFLUGERVILLE'
         Partially fixed, they now had a wider dash, so replace it with the normal - to match what is in DB

    ____ Change 'BAYLOR SCOTT & WHITE MEDICAL CENTER GÇô BUDA' to 'BAYLOR SCOTT & WHITE MEDICAL CENTER - BUDA'
    
    ____ Change 'LMH' to 'LAWRENCE MEMORIAL HOSPITAL'
         This is the one at 325 MAINE STREET, LAWRENCE, KS
         Lazy data entry person did not write it out, hope next week they aren't so lazy
         
    ____ Select and Delete from Excel file: 'UH REGIONAL HOSPITALS', '13207 RAVENNA ROAD', 'CHARDON'
    
    ____ Select and Delete from Excel file: 'THE CHILDREN\'S CENTER, INC', '6800 NW 39TH EXPRESSWAY', 'BETHANY'
    
    ____ Select and Delete from Excel file: 'EAGLE BUTTE INDIAN HEALTH SERVICE HOSPITAL','24276 166TH AIRPORT ROAD','EAGLE BUTTE'
         
    _XX_ Change 'Queen's Medical Center GÇô West Oahu' to 'The Queen\'s Medical Center West Oahu'
         (Has not reported since 2020) Note leave as is 'THE QUEENS MEDICAL CENTER' '1301 PUNCHBOWL ST' 
         which is a different hospital and spelled correctly.
         
8. Convert these additional incorrect fips

    ____ In Excel, data filter, select the fips indicated below, change them as noted
    
    For each of...

        ____ CENTRAL PENINSULA GENERAL HOSPITAL, AK             fips from 2120 to 2122   
        ____ SOUTH PENINSULA HOSPITAL, AK                       fips from 2120 to 2122
        
        ____ PROVIDENCE SEWARD MEDICAL CENTER, AK               fips from 2210 to 2122
     
        ____ CORDOVA COMMUNITY MEDICAL CENTER, AK               fips from 2080 to 2063

        ____ PROVIDENCE VALDEZ MEDICAL CENTER, AK               fips from 2260 to 2063

        ____ PETERSBURG MEDICAL CENTER, AK                      fips from 2280 to 2195


9. POSSIBLE NEW ITEM.  Seeing following duplicates in weekly data.

        ____ usa_hospital_id 383, 'BAXTER REGIONAL MEDICAL CENTER', '624 HOSPITAL DRIVE', 'MOUNTAIN HOME' 
             has 2 submittals, one in 20s other in 220s, Remove smaller of the two.

             ____ Select hospital_name, delete row with smaller set of data.
             
        ____ usa_hospital_id 3308, 'MADONNA REHABILITATION SPECIALTY HOSPITAL OMAHA', '17500 BURKE STREET', 
             'OMAHA' has 2 submittals, one as 48 other in 60-70s, For some reason larger number was skipped
             on 10/8/2021 data but picked up again 10/15/2021 data.  Remove smaller of the two.

10. The following entries are not picking up hospital_id from mapping hosp_name, hosp_addr and hosp_fips
    from the new data sets against existing hospital table.  Make following changes to the source data
    before creating inserts.
    
    [Consider permanent solution - rename usa_hospitals entries for name, addr, fips to match new data]
    [Why?  Check each, but most likely these hospitals are the same but were renamed for some reason,]
    [perhaps through acquisition, consolidation, corporate take over, etc.  Interesting notion gleaned]
    [from this data.]

    incorrect hospital names in new hospital weekly data sets, other info correct
    
    X Below have been updated in usa_hospitals table so can skip...
    
    _X_ 'STEWARD HIALEAH HOSPITAL'  to 'HIALEAH HOSPITAL'
    _X_ 'THE UNIVERSITY OF VERMONT HEALTH NETWORK  - CHAMPL' to 'CHAMPLAIN VALLEY PHYSICIANS HOSPITAL MEDICAL CTR'
    _X_ 'BITTERROOT HEALTH - DALY HOSPITAL' to 'MARCUS DALY MEMORIAL HOSPITAL - CAH'
    _X_ 'MUSC HEALTH KERSHAW MEDICAL CENTER' to 'KERSHAWHEALTH'
    _X_ 'NEMOURS CHILDREN\'S HOSPITAL, DELAWARE' to 'ALFRED I DUPONT HOSPITAL FOR CHILDREN'
    _X_ 'WELLINGTON REGIONAL MEDICAL CENTER' to 'WELLINGTON REGIONAL MEDICAL CENTER LLC'
    _X_ 'PIEDMONT CARTERSVILLE MEDICAL CENTER' to 'CARTERSVILLE MEDICAL CENTER'
    _X_ 'PIEDMONT MACON MEDICAL CENTER' to 'COLISEUM MEDICAL CENTERS'
    _X_ 'PIEDMONT MACON NORTH HOSPITAL' to 'COLISEUM NORTHSIDE HOSPITAL'
    _X_ 'SOUTHEAST IOWA REGIONAL MEDICAL CENTER' to 'GREAT RIVER MEDICAL CENTER'
    _X_ 'TEXAS VISTA MEDICAL CENTER' to' 'SOUTHWEST GENERAL HOSPITAL'
    _X_ 'SILVER LAKE HOSPITAL' to 'COLUMBUS HOSPITAL LTACH'
    _X_ 'PIEDMONT EASTSIDE MEDICAL CENTER' to 'EASTSIDE MEDICAL CENTER'                      
    _X_ 'PLATTE HEALTH CENTER' to 'PLATTE HEALTH CENTER - CAH'
    _X_ 'WEST TENNESSEE HEALTHCARE MILAN HOSPITAL' to 'MILAN GENERAL HOSPITAL'
    _X_ 'WEST TENNESSEE HEALTHCARE BOLIVAR HOSPITAL' to 'BOLIVAR GENERAL HOSPITAL'
    _X_ 'TIDALHEALTH NANTICOKE, INC.' to 'NANTICOKE MEMORIAL HOSPITAL'
    _X_ 'WEST TENNESSEE HEALTHCARE CAMDEN HOSPITAL' to 'CAMDEN GENERAL HOSPITAL'
    _X_ 'HUNTINGTON HOSPITAL' to 'HUNTINGTON MEMORIAL HOSPITAL' with address of 100 W  CALIFORNIA BLVD, PASADENA
    _X_ 'HUNTINGTON MEMORIAL HOSPITAL' to 'HUNTINGTON HOSPITAL' with address of 270 PARK AVENUE, HUNTINGTON
    _X_ 'UNIVERSITY OF MICHIGAN HEALTH - WEST' to 'METRO HEALTH HOSPITAL'
    _X_ 'VANDERBILT BEDFORD HOSPITAL' to 'TENNOVA HEALTHCARE-SHELBYVILLE'
    _X_ 'PROVIDENCE SEWARD MEDICAL CENTER' to 'PROVIDENCE SEWARD HOSPITAL'
    _X_ 'CHI HEALTH - MERCY CORNING' to 'CHI HEALTH  - MERCY CORNING' -- simply 2 spaces rather than 1
    _X_ 'NOVANT HEALTH UVA HEALTH SYSTEM CULPEPER MED CENTE' to 'UVA CULPEPER MEDICAL CENTER'
    _X_ 'DREW MEMORIAL HOSPITAL' to 'DREW MEMORIAL HEALTH SYSTEM'
    _X_ 'NORTH SHORE MEDICAL CENTER' to 'STEWARD NORTH SHORE MEDICAL CENTER'
    _X_ 'AULTMAN HOSPITAL' to 'AULTMAN SPECIALTY HOSPITAL'
    _X_ 'KEARNEY COUNTY HEALTH SERVICES HOSPITAL' to 'KEARNEY COUNTY HEALTH SERVICES'
    _X_ 'MEMORIAL HOSPITAL OF TAMPA' to 'HCA FLORIDA SOUTH TAMPA HOSPITAL'
    _X_ 'NEMOURS CHILDRENS HOSPITAL' to 'NEMOURS CHILDRENS HOSPITAL, FLORIDA'
    _X_ 'UM CAPITAL REGION MEDICAL CENTER' to 'UNIVERSITY OF MD CAPITAL REGION MEDICAL CENTER'
    _X_ 'FLAMBEAU HOSPITAL' to 'MARSHFIELD MEDICAL CENTER - PARK FALLS'
    _X_ 'OCEAN MEDICAL CENTER' to 'OCEAN UNIVERSITY  MEDICAL CENTER'
    _X_ 'FULTON MEDICAL CENTER LLC' to 'NOBLE HEALTH CALLAWAY COMMUNITY HOSPITAL'
    _X_ 'BRODSTONE MEMORIAL HOSP' to 'BRODSTONE MEMORIAL HOSPITAL'
    _X_ 'BAYLOR SCOTT & WHITE  CLINIC - TEMPLE' to 'BAYLOR SCOTT & WHITE MEDICAL  CENTER - TEMPLE'
    _X_ 'UMD UPPER CHESAPEAKE MEDICAL CENTER' to 'UNIVERSITY OF MD UPPER CHESAPEAKE MEDICAL CENTER'
    _X_ 'UMD CHARLES REGIONAL  MEDICAL CENTER' to 'UNIVERSITY OF MD CHARLES REGIONAL  MEDICAL CENTER'
    _X_ 'HIAWATHA COMMUNITY HOSPITAL' to 'AMBERWELL HIAWATHA'
    _X_ 'UMD SHORE MEDICAL CENTER AT EASTON' to 'UNIVERSITY OF MD SHORE MEDICAL CENTER AT EASTON'
    _X_ 'CARIBOU MEMORIAL HOSPITAL' to 'CARIBOU MEMORIAL CENTER'
    
    _X_ incorrect address and fips with correct hospital name ('NATHAN LITTAUER HOSPITAL')

        _X_ address '375 GOLF COURSE ROAD' to '99 EAST STATE ST'
        _X_ fips '36057' to 36035'
    
    _X_ Changed address for hospital name ('LINCOLN SURGICAL HOSPITAL')
        _X_ address '1710 SOUTH 70TH STREET, SUITE 200' to '1710 SOUTH 70TH STREET'
        
    _X_ Address changed for hospital ('PRISMA HEALTH OCONEE MEMORIAL HOSPITAL')
        _X_ address '102B OMNI DR'  to '298 MEMORIAL DR'

    _X_incorrect name and address with correct hospital fips (45079)

        _X_ 'MUSC HEALTH COLUMBIA MEDICAL CENTER DOWNTOWN' to 'PROVIDENCE HEALTH' 
        _X_ '2435 FOREST DRIVE' to '120 GATEWAY CORPORATE BLVD'
                               

11.     ____ As of 2022-01-07 many cells will be blank, mostly in columns J and K.  (Why, who knows, CDC are a 
             bunch of morons. Quickest resolution:
             ____ Copy into new sheet the previous sheets columns C,D,E,J,K,L.  Put them next to new Sheets columns C,D,E,J,K,L. 
                  Be sure to sort each sheet beforehand bases on city then hospital_name columns!!
             ____ Put an X_ in front of column headers to show which are from the previous sheet.
             ____ Add a column after the X_hospital_name column and for each row do a =EXACT(C2,D2) function and repeat
                  it for all rows.  Do same for the Address and City columns. Then do formulas Calculate Sheet
             ____ The next painful step is to evaluate each FALSE return from the EXACT column.  There may be some
                  shuffling of order and swapping of lines (moving up the X_* entries only in most cases.  If there
                  appears to be a new hospital be sure to cross check first in the db.  Also you will catch hospital
                  name changes too.  Once you feel its as completed as possible do next step.
             ____ Now with Data>Filter properly set, sort column J alphabetically.  This will put all the blanks at the
                  bottom.  Then column K should have the previous entries, you can highlight the whole rest of row that
                  is adjacent to all the blanks and copy them into the blanks.  Repeat for next column over. At this point
                  you should have most blanks resolved, now highlight columns J - V and search for any remaing blanks and
                  resolve them manually, you may have to look at app itself in the cases where one week was skipped and
                  so forth.  Many ways to resolve.
             ____ Once you have resolved all the blank fields you can remove the X_ columns as they are no longer needed.
                  At this point you are ready to proceed and create the INSERT statements as described below

12. Generate the INSERT Commands, once in place, just have to run Formulas -> Calculate Sheet
   You need to get max(usa_raw_hospital_weekly_id) to start the inserts from

13. Cut and Paste into MySQL > SQL Scripts > covid19_hospitals_weekly_table_update_batch.sql

14. Append same to MySQL > SQL Scripts > covid19_hospitals_weekly_table_update_FULL.sql
    (May wait until after file runs incase there are errors, so you can correct in excel
     and then store the corrected commands into FULL file. Also check for usa_hospitals_id of NULL
     which indicates you need to add a new hospital or correct syntax change.  Do these before
     the usa_hospitals_latest table updates) To note, most remaining errors can be identified with a null table check
     for hospital_id for data on the specific collection date.  You may have to correct a changed hospital definition,
     name, address, whatever may have changed from previous week.  This could be an update to the hospitals table and
     a manual update of this weekly entries hospital_id field.

15, Run file in MySQL Workbench File > Run SQL Script...  Correct any errors, run until complete,
    make sure errors are reflected in FULL file as well.



*** STEPS TO EDIT THE HOSPITAL DATA AND CREATE THE LATEST TABLE INSERT / UPDATE STATEMENTS. ***

     When new hospitals are added you will need to also add those hospitals to the 
     usa_hospitals table, we do this manually when they appear, will see this when 
     running inserts and it fails when no hospitalname found.  May also have new entries
     in the weekly table and new entries in the latest table, need to compare in excel
     to determine whether update, insert or additional edits are needed.

Source File:
https://healthdata.gov/Hospital/COVID-19-Reported-Patient-Impact-and-Hospital-Capa/anag-cw7u

In excel file before generating the UPDATE statements do the follow updates

1. Prep

   ____ Download latest Weekly Data.  (Can get from Hospital Data Assess.xlsx table, will include
        the insert commands used earlier, can reference these for update commands)  Drop this into
        LATEST RAW tab on Hosp Latest Table Data Assess.xlsx
   ____ Be sure the UPDATE WEEKLY MISSING HOSP IDS modifications are applied first, ensure required
        renames of hospital names and addresses done above are applied to this download weekly data
   ____ Easiest approach is to delete that content of the table (truncate usa_hospitals_latest), 
        all rows. Then use new insert command but into the latest table rather than weekly table.
        
   ____ Note, if new hospitals detected, be sure to create a new Hospitals JSON file



FINI
