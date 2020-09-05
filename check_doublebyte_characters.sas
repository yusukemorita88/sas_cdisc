options nomlogic nomprint nosymbolgen nofmterr;
*-----------------------------------------;
*configulation;
*-----------------------------------------;
%let check_folder = %str(fullpath of check folder);
%let pdf_output = %str(check_dbcs.pdf); *output filename (pdf);

*-----------------------------------------;
*find DBCS characters(ex.Japanese) in the datasets;
*-----------------------------------------;
%macro check_dbcs(folder);

    libname check "&folder." access = readonly;

    proc sql noprint;

        %*count the numbers of datasets;
        select count(distinct memname) into :_dsnum trimmed
        from dictionary.columns
        where upcase(libname) = "CHECK" and memtype = "DATA";


        %*save the datasets name in the folder;
        select distinct memname into :_dsname1 - :_dsname&_dsnum. 
        from dictionary.columns
        where upcase(libname) = "CHECK" and memtype = "DATA";


        %*iteration;
        %do _i = 1 %to &_dsnum. ;

            %*count the number of character variable;
            select count(distinct name) into :_varnum trimmed
            from dictionary.columns
            where upcase(libname) = "CHECK" and memtype = "DATA" and upcase(memname) = "%upcase(&&_dsname&_i.)" and upcase(type) = "CHAR";
            

            %*save the variable name in the dataset;
            select distinct name into :_varname1 - :_varname&_varnum. 
            from dictionary.columns
            where upcase(libname) = "CHECK" and memtype = "DATA" and upcase(memname) = "%upcase(&&_dsname&_i.)" and upcase(type) = "CHAR";

            %*find Double Byte Character Set;
            create table _&&_dsname&_i. as
                select 
                    %do _j = 1 %to &_varnum.;
                        sum(length(&&_varname&_j.) ^= klength(&&_varname&_j.) and &&_varname&_j. ^= "" ) as &&_varname&_j ,
                    %end;
                    "&&_dsname&_i." as MEMNAME
                from CHECK.&&_dsname&_i.
            ;
        %end;

    quit;

    
    %*output the results;
    %do _i = 1 %to &_dsnum. ;
        proc transpose data = _&&_dsname&_i. out = __&&_dsname&_i.;
            by MEMNAME;
            var _numeric_;
        run;
    %end;

    data _results;
        set
    %do _i = 1 %to &_dsnum. ;
        __&&_dsname&_i
    %end;
        ;
        rename _NAME_ = VARNAME COL1 = OBSNUM;
    run;

    ods pdf file = "&pdf_output.";
    proc print data = _results noobs;
    where OBSNUM > 0;
    run;
    ods pdf close;

%mend;

%*execution;
%check_dbcs(folder=&check_folder.);
