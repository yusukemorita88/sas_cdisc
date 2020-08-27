*from XPORT to SAS7BDAT;
libname sasds "C:\work\sas";
libname xptds xport "C:\work\xpt\dm.xpt";

proc copy in = xptds out = sasds;
run;
