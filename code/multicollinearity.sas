libname sasba '/home/u61013211/EST142/data/import';


data amesreg300;
 set sasba.amesreg300;
run;

ods trace on;
options locale=en;
proc reg data=amesreg300;
 model SalePrice= Gr_Liv_Area Fullbath_2plus Total_Bsmt_SF 
 Age_at_Sale Open_Porch_SF Garage_Area
 /scorr2;
run;

ods trace on;
options locale=en;
proc reg data=sasba.ameshousing; 
model SalePrice= Gr_Liv_Area  
Total_Bsmt_SF  Lot_Area / vif   collin  collinoint  ;
run;

ods trace on;
options locale=en;
proc reg data=sasba.amesreg300; 
model SalePrice = Gr_Liv_Area Total_Bsmt_SF Lot_Area Age_at_Sale/     collinoint   vif  ; 
run;
