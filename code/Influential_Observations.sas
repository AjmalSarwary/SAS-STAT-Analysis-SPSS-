/***************************************************************************************************
* Filename: Influential_Observations.sas
* Purpose: This script is dedicated to performing a detailed analysis of the 'cas.amesreg300' 
*          real estate dataset to derive insights into property sales dynamics. The aim is to 
*          understand the relationship between sale price and various property attributes and 
*          to identify any influential observations that may skew the analysis.
*
*          The script will:
*          1. Conduct an initial regression analysis to explore relationships between SalePrice and 
*             selected predictors such as Gr_Liv_Area and Age_at_Sale.
*          2. Perform in-depth diagnostics to evaluate the influence of individual data points on
*             the regression results using measures like Cook’s D and DFFITS.
*          3. Prepare data for flagging influential cases based on the diagnostics to identify potential 
*             outliers or leverage points that could unduly influence the model's predictions.
*          4. Execute further tests to ensure the robustness of model assumptions, including normality tests 
*             and independent samples t-tests.
*
*          Each analytical step is designed to bolster the integrity of the model and enhance the 
*          reliability of insights derived from the data, thereby supporting informed model-building for  
*          decision-making in real estate markets.
*
* Author: Ajmal Sarwary
* Date:	  18.10.2023
***************************************************************************************************/



libname cas '/home/u61013211/EST142/data/import';

ods trace on;
options locale=en;
/* Initial regression analysis to explore the relationship between SalePrice and predictors */
proc reg data=cas.amesreg300 outest=res;
 model SalePrice = Gr_Liv_Area Age_at_Sale ;
 title 'Exploratory Regression Analysis for Sale Price Prediction';
run;

ods trace on;
options locale=en;
/* Detailed regression with diagnostics to evaluate the influence of individual data points */
proc reg data=cas.amesreg300 plots(only)=(rstudentbyleverage cooksd dffits dfbetas);
 model SalePrice = Gr_Liv_Area Age_at_Sale / influence;
 output out=diagnostics h=leverage rstudent=rstudent cookd=cooksd dffits=dffits;
 title 'In-depth Diagnostic Analysis to Identify Influential Observations';
run;

ods trace on;
options locale=en;
/* Data preparation for flagging influential cases based on diagnostics */
*Observations with higher values of Cook’s D, DFFITS, thus high flag counts, would be key candidates 
for further scrutiny. They might be leverage points, outliers, or both, and could unduly influence 
the model's predictions.
If and when influential points are found, performing a sensitivity analysis by recalculating the main statistics or 
redoing key tests with and without these influential points may be warranted;
data review2;
 set diagnostics;
 flag=0; 
 n=300; /* Total observations */
 k=2; /* Number of predictors */
 cooksd_cut = 4/n; /* Cook's distance cutoff */
 h_cut=2*(k+1)/n; /* Leverage cutoff */
 dffits_cut=2*sqrt((k+1)/n); /* DFFITS cutoff */
 if cooksd > cooksd_cut then flag+1;
 if abs(dffits) > dffits_cut then flag+1;
 if flag>0;
 title 'Flagging Influential Observations for Review';
run;

ods trace on;
options locale=en;
/* Sorting and printing the flagged data for review */
proc sort data=review2; 
 by cooksd;
run;

ods trace on;
options locale=en;
proc print data=review2;
 var SalePrice Gr_Liv_Area Age_at_Sale leverage rstudent cooksd dffits flag;
 title 'List of Flagged Influential Observations';
run;

*Conducting tests to ensure model assumptions are met;

ods trace on;
options locale=en;
/* Performing a normality test using the Kolmogorov-Smirnov test */
proc univariate data=cas.amesreg300 normal;
 var Gr_Liv_Area;
 title 'Kolmogorov-Smirnov Test of Normality for Living Area';
run;

ods trace on;
options locale=en;
/* Conducting an independent samples t-test to compare Gr_Liv_Area by Sale Condition */
proc ttest data=cas.amesreg300 alpha=.05;
 class Sale_Condition;
 var Gr_Liv_Area;
 title 'Independent Samples t-Test for Living Area by Sale Condition';
run;


