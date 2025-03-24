
*set my working directory to be the downloads folder
cd "C:\Users\Laura\Downloads"

*importing the data as a csv file 
import delimited "C:\Users\Laura\Downloads\adoption data.csv", clear 

*CT gets same-sex marriage in 2008. We want to make sure this is not included in our dataset.
*to do this, use the Drop command and drop any observation after 2007. 
drop if year>2007

*we want to identify the effect of SSM on adoption. Lets create a treatment variable that turns on after SSM legalization in 2004 in MA
*we will use the generate command to do this.
gen treatment=0
replace treatment=1 if state=="massachusetts" & year>2003

*next, let's do a Difference-in-Differences analysis
*reghdfe is a regression command that allows us to include multiple fixed effects in our model.
*we want to include state and year fixed effects using the absorb option. 
*in DiD, we normally calculate standard errors at the level of treatment. So, let's add a state-level clustered standard error option to our regression
reghdfe adoptions treatment, absorb(state year) cluster(state)

*add a control variable for foster care to the regression
reghdfe adoptions treatment foster_care, absorb(state year) cluster(state)

*now, lets try dropping 2006 & 2007 to see if the impact is brief. 
drop if year>2005

*run the same regression on this new subset of the data.  
reghdfe adoptions treatment foster_care, absorb(state year) cluster(state)

*now let's analyze Vermont!
*VT legalizes SSM in 2009. So we need to re-import our original dataset. 

*importing the data as a csv file 
import delimited "C:\Users\Laura\Downloads\adoption data.csv", clear 

*the time period of interest for this analysis is 2005-2011. We need to drop all other years. 
*note that the symbol "|" is a logical symbol for "or"
drop if year<2005 | year>2011

*Six other states legalized SSM during this time period. We need to drop them so that those states do not affect the results for Vermont. 
drop if state=="massachusetts" | state=="connecticut" | state=="iowa" | state=="district of columbia" | state=="new hampshire" | state=="new york"

*now, the next steps are very similar to the Massachusetts example: 
*we want to identify the effect of SSM on adoption. Lets create a treatment variable that turns on after SSM legalization in 2009 in VT
*we will use the generate command to do this again.
gen treatment=0
replace treatment=1 if state=="vermont" & year>2008

*run the DiD model
reghdfe adoptions treatment, absorb(state year) cluster(state)

*run the model with the control for foster care:
reghdfe adoptions treatment foster_care, absorb(state year) cluster(state)




















