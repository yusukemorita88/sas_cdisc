*from SAS7BDAT to XPORT;
libname sasds "C:\work\sas" access = readonly;
libname xptds xport "C:\work\xpt\dm.xpt";

data xptds.dm;
    set sasds.dm;
run;
