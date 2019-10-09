* Encoding: windows-1252.
COMMENT Correlation Testing.
COMMENT Demographics. 
CORRELATIONS
  /VARIABLES= POPULATION SENIORS CHILDREN HOUSEHOLDS BUSINESSES EMPLOYEES WITH LOSS_EVALUATED
  /MISSING=PAIRWISE.
COMMENT Seasonality.
CORRELATIONS
  /VARIABLES= MONTH LATE_SEASON EARLY_SEASON PEAK_SEASON WITH LOSS_EVALUATED
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
COMMENT Weather.
CORRELATIONS
  /VARIABLES= WIND_RI RAIN_RI SURGE_RI RI RAIN WIND HEIGHT EXTENT DAYS GT_WINDB DIFF_WIND WITH LOSS_EVALUATED
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
COMMENT No demographics were found to be correlation, retest using new variables. 
COMMENT MONTH, WIND_RI, SURGE_RI, RI, RAIN, WIND, HEIGHT, EXTENT all found to be significantly correlated.
COMMENT Compute New Variables and Categorical Variables. 
FREQUENCIES POPULATION.
COMPUTE POP_CAT=0.
IF POPULATION LE 100000 POP_CAT=1. 
IF POPULATION GT 100000 AND POPULATION LE 1000000 POP_CAT=2. 
IF POPULATION GT 1000000 AND POPULATION LE 10000000 POP_CAT=3. 
IF POPULATION GT 10000000 AND POPULATION LE 30000000 POP_CAT=4. 
IF POPULATION GT 30000000 POP_CAT=5. 
EXECUTE.
FREQUENCIES BUSINESSES.
COMPUTE BUS_CAT=0.
IF POPULATION LE 10000 BUS_CAT=1. 
IF POPULATION GT 10000 AND POPULATION LE 100000 BUS_CAT=2. 
IF POPULATION GT 100000 AND POPULATION LE 500000 BUS_CAT=3. 
IF POPULATION GT 500000 AND POPULATION LE 1000000 BUS_CAT=4. 
IF POPULATION GT 1000000 BUS_CAT=5. 
EXECUTE.
COMMENT Categorical Data Split. *TEST FOR POP CAT*.
Sort Cases by RI. 
Split File by RI.
CORRELATIONS VARIABLES = LOSS_EVALUATED WITH SENIORS.
CORRELATIONS VARIABLES = LOSS_EVALUATED WITH CHILDREN. 
CORRELATIONS VARIABLES = LOSS_EVALUATED  WITH HOUSEHOLDS.
CORRELATIONS VARIABLES = LOSS_EVALUATED WITH BUSINESSES.
CORRELATIONS VARIABLES = LOSS_EVALUATED WITH EMPLOYEES. 
Split File Off.
COMMENT Children and RI 3 - new var.
Sort Cases by POP_CAT. 
Split File by POP_CAT.
CORRELATIONS VARIABLES = LOSS_EVALUATED WITH WIND_RI.
CORRELATIONS VARIABLES = LOSS_EVALUATED WITH SURGE_RI. 
CORRELATIONS VARIABLES = LOSS_EVALUATED  WITH RI.
CORRELATIONS VARIABLES = LOSS_EVALUATED WITH RAIN.
CORRELATIONS VARIABLES = LOSS_EVALUATED WITH WIND. 
CORRELATIONS VARIABLES = LOSS_EVALUATED  WITH HEIGHT.
CORRELATIONS VARIABLES = LOSS_EVALUATED  WITH EXTENT.
Split File Off.
COMMENT Extent and Population category 4 - new var. 
Sort Cases by SURGE_RI. 
Split File by SURGE_RI.
CORRELATIONS VARIABLES = LOSS_EVALUATED WITH SENIORS.
CORRELATIONS VARIABLES = LOSS_EVALUATED WITH CHILDREN. 
CORRELATIONS VARIABLES = LOSS_EVALUATED  WITH HOUSEHOLDS.
CORRELATIONS VARIABLES = LOSS_EVALUATED WITH BUSINESSES.
CORRELATIONS VARIABLES = LOSS_EVALUATED WITH EMPLOYEES. 
CORRELATIONS VARIABLES = LOSS_EVALUATED WITH POPULATION.
Split File Off.
*SIG*.
COMPUTE MAX_RAIN =0.
IF RAIN GE 20 MAX_RAIN = RAIN.
COMPUTE MAX_WIND =0.
IF WIND GE 110 MAX_WIND= WIND.
EXECUTE.
COMPUTE POP_HEIGHT=0.
IF POP_CAT = 3 POP_HEIGHT = HEIGHT.
EXECUTE.
COMPUTE MAX_SURGE =0.
IF HEIGHT GE 13 MAX_SURGE = HEIGHT.
EXECUTE.
COMPUTE POP_EXTENT = 0. 
IF POP_CAT = 4 POP_EXTENT = EXTENT.
EXECUTE.
COMPUTE POP_BI = 0.
IF POP_CAT = 2 OR POP_CAT =3 POP_BI = 1.
EXECUTE.
COMPUTE CHILD_RI =0.
IF RI = 3 CHILD_RI = 1.
EXECUTE.
COMPUTE MON_RI =0.
IF MONTH LE 7 AND WIND_RI = 0 MON_RI =WIND.
EXECUTE.
COMPUTE MIN_WIND =0.
IF WIND LE 50 MIN_WIND = WIND.
COMPUTE MIN_SURGE =0.
IF HEIGHT LE 2 MIN_SURGE = HEIGHT.
EXECUTE.
*SIG*.
COMPUTE POP_WIND=0.
IF POPULATION LT 1000000 AND WIND GT 50 POP_WIND = WIND.
EXECUTE.
COMPUTE MAX_DAYS=0.
IF DAYS GE 3 MAX_DAYS = DAYS.
EXECUTE.
COMPUTE RI_NONPEAK=0.
IF PEAK_SEASON =0 RI_NONPEAK = RI.
EXECUTE.
*SIG*.
COMPUTE RI_RAINWIND =0.
IF RAIN_RI GE 3 AND WIND_RI GE 3 RI_RAINWIND =1.
COMPUTE RI_ALL =0.
IF RAIN_RI LT 1 AND WIND_RI LT 1 AND SURGE_RI LT 1 RI_ALL=1.
EXECUTE.
COMPUTE SURGEWIND=0.
IF SURGE_RI=0 AND WIND_RI LE 2 SURGEWIND=1.
EXECUTE.
COMPUTE JUNE_0=0.
IF MONTH = 6 AND WIND_RI LE 2 JUNE_0=1.
EXECUTE.
COMPUTE WIND_2 =0.
IF WIND_RI LE 2 WIND_2 =1.
EXECUTE.
COMPUTE WIND_1 =0.
IF WIND_RI LE 1 WIND_1 =1.
COMPUTE WIND_0 = 0.
IF WIND_RI EQ 0 WIND_0 = 1.
EXECUTE.
COMPUTE RAIN_2 =0.
COMPUTE RAIN_1 =0.
COMPUTE RAIN_0 =0.
COMPUTE SURGE_2 =0.
COMPUTE SURGE_1 =0.
COMPUTE SURGE_0 =0.
IF RAIN_RI LE 2 RAIN_2 =1.
IF RAIN_RI LE 1 RAIN_1 =1.
IF RAIN_RI LE 0 RAIN_0 =1.
IF SURGE_RI LE 2 SURGE_2 =1.
IF SURGE_RI LE 1 SURGE_1 =1.
IF SURGE_RI EQ 0 SURGE_0 =1.
EXECUTE.
COMPUTE LOW_RAINWIND =0.
IF RAIN_2 = 1 AND WIND_1=1 LOW_RAINWIND=1.
COMPUTE LOW_RAINSURGE=0.
IF RAIN_2= 1 AND SURGE_1 =1 LOW_RAINSURGE=1.
COMPUTE LOW_WINDSURGE=0.
IF WIND_2 = 1 AND SURGE_1 =1 LOW_WINDSURGE=1.
EXECUTE.

COMPUTE JUN_LOW =0.
COMPUTE JUL_LOW =0.
COMPUTE EARLY_LOW =0.
IF MONTH = 6 AND LOW_WINDSURGE=1 JUN_LOW =1.
IF MONTH = 7 AND LOW_WINDSURGE=1 JUL_LOW =1.
IF MONTH LE 7 AND LOW_WINDSURGE=1 EARLY_LOW =1.
EXECUTE.


CORRELATIONS 
  /VARIABLES= POP_EXTENT POP_BI CHILD_RI WITH LOSS_EVALUATED
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
COMMENT POP_EXTENT Found to be correlated.

COMMENT Regression Model. 
REGRESSION
     /MISSING=LISTWISE
     /STATISTICS=ALL
     /CRITERIA POUT(0.1) PIN(0.05)
     /NOORIGIN
     /DEPENDENT= LOSS_EVALUATED
     /METHOD=STEPWISE POP_EXTENT MONTH WIND_RI SURGE_RI RAIN RI WIND HEIGHT EXTENT.
COMMENT HEIGHT, EXTENT, RAIN .... 47% R-squared.
REGRESSION
     /MISSING=LISTWISE
     /STATISTICS=ALL
     /CRITERIA POUT(0.1) PIN(0.05)
     /NOORIGIN
     /DEPENDENT=LOSS_EVALUATED
     /METHOD=STEPWISE MONTH POP_EXTENT RAIN HEIGHT PEAK_SEASON.
COMMENT RAIN, POP_EXTENT, HEIGHT .... 28% R-squared.
REGRESSION
     /MISSING=LISTWISE
     /STATISTICS=ALL
     /CRITERIA POUT(0.1) PIN(0.05)
     /NOORIGIN
     /DEPENDENT=LOSS_EVALUATED
     /METHOD=STEPWISE GT_WINDB DIFF_WIND LATE_SEASON EARLY_SEASON PEAK_SEASON POP_CAT POP_EXTENT
CHILD_RI BUS_CAT WIND_BUS RAIN_BUS RI_BUS MONTH_RAIN RI_RAIN MONTH_WIND POP_HEIGHT
MONTH WIND_RI RAIN_RI SURGE_RI RI POPULATION SENIORS CHILDREN HOUSEHOLDS BUSINESSES EMPLOYEES
RAIN WIND HEIGHT EXTENT DAYS MAX_RAIN MAX_WIND.
COMMENT HEIGHT, MAX_RAIN, EXTENT, POP_HEIGHT 53% R-Squared.
REGRESSION
     /MISSING=LISTWISE
     /STATISTICS=ALL
     /CRITERIA POUT(0.1) PIN(0.05)
     /NOORIGIN
     /DEPENDENT=LOSS_NEW
     /METHOD=STEPWISE GT_WINDB
DIFF_WIND
LATE_SEASON
EARLY_SEASON
PEAK_SEASON
POP_CAT
POP_EXTENT
CHILD_RI
BUS_CAT
WIND_BUS
RAIN_BUS
RI_BUS
MONTH_RAIN
RI_RAIN
MONTH_WIND
POP_HEIGHT
MAX_SURGE
MAX_RAIN
MAX_WIND
MIN_WIND
MIN_SURGE
POP_WIND
MONTH
WIND_RI
RAIN_RI
SURGE_RI
RI
POPULATION
SENIORS
CHILDREN
HOUSEHOLDS
BUSINESSES
EMPLOYEES
RAIN
WIND
HEIGHT
EXTENT
DAYS
MAX_DAYS
RI_NONPEAK
RI_RAINWIND
RI_ALL
SURGE_0
SURGEWIND
JUNE_0
WIND_2
WIND_1
WIND_0
RAIN_2
RAIN_1
RAIN_0
SURGE_2
SURGE_1
LOW_RAINWIND
LOW_RAINSURGE
JUN_LOW
JUL_LOW
EARLY_LOW
LOW_WINDSURGE.
COMMENT HEIGHT, MAX_RAIN, EXTENT, POP_WIND RI_RAINWIND 59.8% R-Squared.
******************************************************************************************************************************.
*FINAL*
******************************************************************************************************************************.
REGRESSION
     /MISSING=LISTWISE
     /STATISTICS=ALL
     /CRITERIA POUT(0.1) PIN(0.05)
     /NOORIGIN
     /DEPENDENT=LOSS_NEW
     /METHOD=ENTER RI_RAINWIND HEIGHT POP_EXTENT WIND_2 MAX_RAIN
     /SAVE RESID (res_loss2) SRESID (sres_loss2) PRED (predict_loss2).
DESCRIPTIVES  LOSS_NEW predict_loss2 res_loss2. 
DESCRIPTIVES VARIABLES=LOSS_NEW predict_loss2 res_loss2
  /STATISTICS=MEAN SUM STDDEV VARIANCE RANGE MIN MAX KURTOSIS SKEWNESS.
EXAMINE /VARIABLES=LOSS_NEW predict_loss2 res_loss2.


COMPUTE ECON_PRED2 = predict_loss2.
IF ECON_PRED2 LE 10000 ECON_PRED2 = 1000000000.
IF ECON_PRED2 GE 250000000000 ECON_PRED2 = 250000000000.
EXECUTE.

COMPUTE ECON_PRED2 =  RND(ECON_PRED2).
EXECUTE.

COMPUTE CONTROL2 = ABS(sres_loss2).
EXECUTE.

REGRESSION
     /MISSING=LISTWISE
     /STATISTICS=ALL
     /CRITERIA POUT(0.1) PIN(0.05)
     /NOORIGIN
     /DEPENDENT=LOSS_NEW
     /METHOD=ENTER RI_RAINWIND HEIGHT POP_EXTENT WIND_2 MAX_RAIN.
COMPUTE LOSS_NEW = LOSS_EVALUATED.
EXECUTE.
IF NAME = "Camille 1969" OR NAME = "Donna 1960" OR NAME = "Hugo 1989" LOSS_NEW =$SYSMIS.
EXECUTE.
IF NAME = "Andrew 1992" OR NAME ="Alicia 1983" OR NAME ="Agnes 1972" OR NAME = "Elena 1985" OR NAME ="Opal 1995" OR NAME ="Floyd 1999"  LOSS_NEW = $SYSMIS.
EXECUTE.
IF NAME = "Allison 1995" OR NAME = "Diane 1955" OR NAME ="Fran 1996" LOSS_NEW =$SYSMIS.
EXECUTE.
