* Encoding: windows-1252.
TEMPORARY.
SELECT IF NOT LAT="".
SAVE OUTFILE "W:\Accu_Internal_D3_Projects\TropicalImpact\EVENTS_US48.sav".
GET FILE "W:\Accu_Internal_D3_Projects\TropicalImpact\EVENTS_US48.sav".
EXECUTE.

COMPUTE START_MON = XDATE.MONTH(BEGIN_DATE_TIME).
EXECUTE.

COMPUTE END_MON = XDATE.MONTH(END_DATE_TIME).
EXECUTE. 

SELECT IF START_MON= 5 OR START_MON=6 OR START_MON=7 OR START_MON=8 OR START_MON= 9 OR START_MON=10 OR START_MON=11.
EXECUTE.

FREQUENCIES STATE.

TEMPORARY.
SELECT IF NOT (STATE = "AMERICAN SAMOA" OR STATE = "ALASKA" OR STATE = "GUAM" OR STATE ="HAWAII" OR STATE="PUERTO RICO" OR STATE ="VIRGIN ISLANDS").
SAVE OUTFILE "W:\Accu_Internal_D3_Projects\TropicalImpact\STORM_EVENTS\SELECT_TROP_REPORTS.sav".
GET FILE "W:\Accu_Internal_D3_Projects\TropicalImpact\STORM_EVENTS\SELECT_TROP_REPORTS.sav".
EXECUTE.

DELETE VARIABLES DATA_SOURCE MAGNITUDE MAGNITUDE_TYPE FLOOD_CAUSE
CATEGORY TOR_F_SCALE TOR_LENGTH TOR_WIDTH TOR_OTHER_WFO
TOR_OTHER_CZ_STATE TOR_OTHER_CZ_FIPS TOR_OTHER_CZ_NAME BEGIN_RANGE
BEGIN_AZIMUTH BEGIN_LOCATION END_RANGE END_AZIMUTH
END_LOCATION BEGIN_LAT BEGIN_LON END_LAT END_LON CZ_TIMEZONE WFO CZ_TYPE.

*-----Find Report Observation Values-----*.
*Surge*.
COMPUTE FLAG_SURGE2=INDEX(UPCASE(EVENT_NARRATIVE),"SURGE")>0.
EXECUTE.

COMPUTE FLAG_SURGE=SUM(INDEX(UPCASE(EVENT_NARRATIVE),"FEET"), INDEX(UPCASE(EVENT_NARRATIVE)," FT"))>0.
EXECUTE.

COMPUTE FEET_FIRST = CHAR.INDEX(UPCASE(EVENT_NARRATIVE), "FEET").
EXECUTE.

COMPUTE FT_FIRST = CHAR.INDEX(UPCASE(EVENT_NARRATIVE), " FT").
EXECUTE.

STRING SURGE_VALUE (A7).
IF (FLAG_SURGE = 1 AND FEET_FIRST GT 0) SURGE_VALUE = (CHAR.SUBSTR(EVENT_NARRATIVE, FEET_FIRST-6, FEET_FIRST-5)).
IF (FLAG_SURGE = 1 AND FT_FIRST GT 0) SURGE_VALUE = (CHAR.SUBSTR(EVENT_NARRATIVE, FT_FIRST-6, FT_FIRST-5)).
EXECUTE.

COMPUTE SURGE_VALUE = REPLACE(SURGE_VALUE, "one", "1").
COMPUTE SURGE_VALUE = REPLACE(SURGE_VALUE, "two", "1").
COMPUTE SURGE_VALUE = REPLACE(SURGE_VALUE, "three", "1").
COMPUTE SURGE_VALUE = REPLACE(SURGE_VALUE, "four", "1").
COMPUTE SURGE_VALUE = REPLACE(SURGE_VALUE, "five", "1").
COMPUTE SURGE_VALUE = REPLACE(SURGE_VALUE, "six", "1").
COMPUTE SURGE_VALUE = REPLACE(SURGE_VALUE, "seven", "1").
COMPUTE SURGE_VALUE = REPLACE(SURGE_VALUE, "eight", "1").
COMPUTE SURGE_VALUE = REPLACE(SURGE_VALUE, "nine", "1").
COMPUTE SURGE_VALUE = REPLACE(SURGE_VALUE, "ten", "1").
EXECUTE.

LOOP.
COMPUTE I = INDEX(SURGE_VALUE,"abcdefghijklmnopqrstuvwxyz",1).
IF I >0 SURGE_VALUE=CONCAT(SUBSTR(SURGE_VALUE,1,I-1),SUBSTR(SURGE_VALUE,I+1)).
END LOOP IF I=0.
EXECUTE.

LOOP.
COMPUTE I = INDEX(SURGE_VALUE,"ABCDEFGHIJKLMNOPQRSTUVWXYZ",1).
IF I >0 SURGE_VALUE=CONCAT(SUBSTR(SURGE_VALUE,1,I-1),SUBSTR(SURGE_VALUE,I+1)).
END LOOP IF I=0.
EXECUTE.

COMPUTE SURGE_VALUE = LTRIM(SURGE_VALUE).
COMPUTE SURGE_VALUE = RTRIM(SURGE_VALUE).
EXECUTE.

DELETE VARIABLES I.
EXECUTE.

AUTORECODE SURGE_VALUE /INTO SURGE.
EXECUTE.

IF FLAG_SURGE2 =0 SURGE_VALUE = $SYSMIS.
EXECUTE.

DELETE VARIABLES FLAG_SURGE2 FT_FIRST FEET_FIRST FLAG_SURGE.

STRING PROP_AMT (A1).
COMPUTE PROP_AMT=CHAR.SUBSTR(DAMAGE_PROPERTY,CHAR.LENGTH(DAMAGE_PROPERTY),1).
EXECUTE.

STRING CROP_AMT (A1).
COMPUTE CROP_AMT=CHAR.SUBSTR(DAMAGE_CROPS,CHAR.LENGTH(DAMAGE_CROPS),1).
EXECUTE.

FREQUENCIES PROP_AMT.
FREQUENCIES CROP_AMT.

COMPUTE PROP_FACTOR = 1. 
COMPUTE CROP_FACTOR = 1. 
IF PROP_AMT ="K" PROP_FACTOR = 1000.
IF PROP_AMT ="M" PROP_FACTOR = 1000000.
IF PROP_AMT="B" PROP_FACTOR =1000000000.
IF CROP_AMT ="K" CROP_FACTOR = 1000.
IF CROP_AMT ="M" CROP_FACTOR = 1000000.
IF CROP_AMT="B" CROP_FACTOR =1000000000.
EXECUTE.

COMPUTE DAMAGE_PROPERTY = REPLACE(DAMAGE_PROPERTY, "K","").
COMPUTE DAMAGE_PROPERTY = REPLACE(DAMAGE_PROPERTY, "B","").
COMPUTE DAMAGE_PROPERTY = REPLACE(DAMAGE_PROPERTY, "M","").
COMPUTE DAMAGE_CROPS = REPLACE(DAMAGE_CROPS, "K","").
COMPUTE DAMAGE_CROPS = REPLACE(DAMAGE_CROPS, "B","").
COMPUTE DAMAGE_CROPS = REPLACE(DAMAGE_CROPS, "M","").
EXECUTE.


COMPUTE PROP_DAMAGE = DAMAGE_PROPERTY*PROP_FACTOR.
COMPUTE CROP_DAMAGE = DAMAGE_CROPS*CROP_FACTOR.
EXECUTE.

DELETE VARIABLES PROP_AMT CROP_AMT PROP_FACTOR CROP_FACTOR DAMAGE_PROPERTY DAMAGE_CROPS.
EXECUTE.

COMPUTE DEATHS = DEATHS_DIRECT+DEATHS_INDIRECT.
COMPUTE INJURY = INJURIES_DIRECT+INJURIES_INDIRECT.
EXECUTE.

DELETE VARIABLES INJURIES_DIRECT INJURIES_INDIRECT DEATHS_DIRECT DEATHS_INDIRECT.
EXECUTE.

TEMPORARY.
SELECT IF NOT EVENT_TYPE ="Storm Surge/Tide".
SAVE OUTFILE "W:\Accu_Internal_D3_Projects\TropicalImpact\TROP_REPORTS_ONLY.sav".
GET FILE "W:\Accu_Internal_D3_Projects\TropicalImpact\TROP_REPORTS_ONLY.sav".
EXECUTE.
