/***************************************************************************************************
* Filename: Collinearity.sas
* Purpose: This SAS script is designed to conduct a detailed collinearity diagnostic analysis on the
*          'amesreg300' dataset. The aim is to identify and quantify the degree of multicollinearity 
*          among several predictors of SalePrice.
*          
*          The analysis proceeds through several stages:
*          1. Initial exploration of correlations using the SCORR2 option to detect high pairwise correlations.
*          2. Further diagnostics employing VIF, collin, and collinoint options to assess the impact
*             of collinearity on the regression coefficients and to explore potential redundancy among predictors.
*          3. Comprehensive assessment across different models to ensure robustness and reliability of the 
*             model findings.
*
*          Each step is designed to enhance understanding of the dataset’s dynamics and to support robust
*          model building by ensuring the predictors used do not unduly influence each other.
* 
* Author: Ajmal Sarwary
* Date:   30.11.2023
***************************************************************************************************/


libname sasba '/home/u61013211/EST142/data/import';

/* Data preparation and cofigs*/

data amesreg300;
    set sasba.amesreg300;
run;

ods trace on;


/* Initial regression analysis with collinearity diagnostics */
/* I perform this regression analysis to identify potential multicollinearity among predictors. The 'scorr2' option computes the squared correlations among the predictors, 
   highlighting which variables are highly correlated and might affect the stability and interpretability of the regression model due to multicollinearity. */
options locale=en;
proc reg data=amesreg300;
    model SalePrice = Gr_Liv_Area Fullbath_2plus Total_Bsmt_SF Age_at_Sale Open_Porch_SF Garage_Area / scorr2;
    title 'Regression Analysis with Standardized Collinearity Diagnostics';
run;


/* Separate regression model to assess additional multicollinearity diagnostics */
/* In this model, I use 'vif' to calculate the Variance Inflation Factor, 'collin' to check for collinearity diagnostics, and 'collinoint' to provide collinearity diagnostics including interaction terms.
   These measures help identify not just multicollinearity but also the specific impact of each predictor in the presence of others, highlighting potential redundancy. */
options locale=en;
proc reg data=sasba.ameshousing;
    model SalePrice = Gr_Liv_Area Total_Bsmt_SF Lot_Area / vif collin collinoint;
    title 'Detailed Collinearity Diagnostics on Key Housing Factors';
run;


/* Further detailed analysis with additional multicollinearity diagnostics on an extended subset of predictors */
/* This comprehensive assessment uses 'collinoint' and 'vif' to rigorously evaluate how much predictors inflate the variance of estimated regression coefficients.
   It ensures the robustness of the model by confirming that predictors do not unduly influence each other, maintaining the model’s credibility and reliability. */
options locale=en;
proc reg data=sasba.amesreg300;
    model SalePrice = Gr_Liv_Area Total_Bsmt_SF Lot_Area Age_at_Sale / collinoint vif;
    title 'Comprehensive Collinearity Assessment for Selected Variables';
run;
