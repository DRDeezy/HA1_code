* HA1
 * Reading Stata (.dta) file
clear all 
 
use choice.dta.sec, clear 

set more off

* Generate a dummy variable equal to 0 for school=1 and equal to 0 o/w 
generate school=1 if at16==1
replace school=0 if at16==2
replace school=0 if at16==3

*summary of all statistics
summarize
*summary by school choice (расставляет данные по категориям также)
*bysort school: sum

*table of correlations for all variables// star(*) - sign level to display with a star
pwcorr at16 able7 loginc ctratio oldsib yngsib etot female school, star(0.01) 

**************************** LOGIT 
logit school able7 etot ctratio loginc female oldsib yngsib

**************************** ORDERED LOGIT 
ologit at16 able7 etot ctratio loginc female oldsib yngsib
*predict p1ologit p2ologit p3ologit, pr
*sum p1ologit p2ologit p3ologit at16

**************************** MULTINOMIAL LOGIT 
mlogit at16 able7 etot ctratio loginc female oldsib yngsib, baseoutcome(1)

**************************** Marginal Effects
*LOGIT
logit school able7 etot ctratio loginc female oldsib yngsib, nolog
*marginal effect
margins, dydx(loginc) at(able7=75 etot=7 ctratio=12 loginc=3 female=1 oldsib=0 yngsib=0)

*OLOGIT
ologit at16 able7 etot ctratio loginc female oldsib yngsib, nolog
*marginal effect
margins, dydx(loginc) at(able7=75 etot=7 ctratio=12 loginc=3 female=1 oldsib=0 yngsib=0)

*MLOGIT
mlogit at16 able7 etot ctratio loginc female oldsib yngsib, baseoutcome(1) nolog
*marginal effect at a representative value
margins, dydx(loginc) at(able7=75 etot=7 ctratio=12 loginc=3 female=1 oldsib=0 yngsib=0)

**************************** ALTERNATIVE MODELS
sum etot
*Poisson
poisson etot able7 ctratio loginc female oldsib yngsib, vce(robust)
*margins, dydx(*)
*gives prediction for etot=1
*predict pp, pr(1) 

*Negative binomial 1
nbreg etot able7 ctratio loginc female oldsib yngsib, d(c)


*Negative binomial 2
nbreg etot able7 ctratio loginc female oldsib yngsib, d(m)

*store results of our programm
*est store REG1
*est table REG1, se

*esttab REG1

*alternative
*outreg2 using C:\Users\Meilis\Desktop\Peres_HA1\results_prelim.xls
