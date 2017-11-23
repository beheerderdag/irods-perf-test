outputfilename="$1"
touch $1; 

# capture current counts: 

iquest "select count(DATA_NAME)" 1>>$outputfilename 
iquest "select count(META_DATA_ATTR_NAME)" 1>>$outputfilename 
iquest "select count(RESC_NAME)" 1>>$outputfilename

{ date & echo "== Q1 count all data_name == ";   }  >> $outputfilename;  /usr/bin/time -f "%e"  iquest "select count(DATA_NAME)" 2>> $outputfilename

{ date &  echo "== Q2 count all users ==";       }  >> $outputfilename ; /usr/bin/time -f "%e" iquest "SELECT count(USER_NAME)" 2>> $outputfilename

{ date & echo  "== Q3  count all metadata == " ; } >> $outputfilename ; /usr/bin/time -f "%e" iquest "select count(META_DATA_ATTR_NAME)" 2>> $outputfilename

{ date &  echo "== Q4 sum data size ==" ;        }  >> $outputfilename ; /usr/bin/time -f "%e" iquest "SELECT sum(DATA_SIZE)" 2>> $outputfilename

{ date &  echo "== Q5 order by create time ==" ; }  >> $outputfilename ; /usr/bin/time -f "%e" iquest --no-page "SELECT DATA_NAME, COLL_NAME, DATA_REPL_NUM, DATA_SIZE, order(DATA_CREATE_TIME)" 2>> $outputfilename

{ date &  echo "== Q6 data path query with count ==" ;  }  >>$outputfilename ;  /usr/bin/time -f "%e" iquest --no-page "SELECT count(DATA_NAME)  WHERE DATA_PATH like  '/eudatCache/Vault/PerfResc/home/perf/200k%'" 2>> $outputfilename

{ date &  echo "== Q7 data path query with details ==" ;} >> $outputfilename ; /usr/bin/time -f "%e" iquest --no-page "SELECT DATA_NAME, DATA_CHECKSUM, DATA_VERSION, DATA_PATH, DATA_COLL_ID, DATA_RESC_NAME, DATA_STATUS  WHERE DATA_PATH like '%file.1%'" 2>>$outputfilename 

{ date &  echo "== Q8 list all meta data ==" ;          } >> $outputfilename ; /usr/bin/time -f "%e"   iquest --no-page "SELECT META_DATA_ATTR_NAME" 2>>$outputfilename 

{ date &  echo "== Q9 meta data filter by value ==" ;   } >> $outputfilename ; /usr/bin/time -f "%e"   iquest --no-page "SELECT META_DATA_ATTR_NAME , META_DATA_ATTR_VALUE where META_DATA_ATTR_VALUE like '%21.%'" 2>> $outputfilename 

{ date &  echo "== Q10 data path filter by value ==";   } >> $outputfilename ; /usr/bin/time -f "%e"   iquest --no-page "SELECT DATA_PATH WHERE DATA_PATH like '%9999%' || like '%2%'" 2>>$outputfilename 

{ date &  echo "== Q11 resource name and meta data look up ==" ; } >> $outputfilename ; /usr/bin/time -f "%e"  iquest --no-page "select COLL_NAME,DATA_NAME where COLL_NAME like '%perf%' AND RESC_NAME = 'PerfResc' and AND META_DATA_ATTR_VALUE like '2%'" 2>>$outputfilename 

{ date &  echo "== Q12 OR filter meta data value =="    ;        } >> $outputfilename ; /usr/bin/time -f "%e"  iquest --no-page "SELECT META_DATA_ATTR_NAME , META_DATA_ATTR_VALUE where META_DATA_ATTR_VALUE like '%21.%' || like 'True'" 2>>$outputfilename

{ date &  echo "== Q13 COLL name filter ==";                     } >> $outputfilename ; /usr/bin/time -f "%e"  iquest --no-page "SELECT COLL_NAME, META_COLL_ATTR_VALUE WHERE COLL_NAME like '%perf%'" 2>>$outputfilename

{ date &  echo "== Q14 count COLL name and filter ==";           } >> $outputfilename ; /usr/bin/time -f "%e"   iquest --no-page "SELECT COUNT(coll_name) FROM r_coll_main WHERE coll_name LIKE '%test%'" 2>>$outputfilename

{ date &  echo "== Q15 Lookup one meta data name ==" ;           } >> $outputfilename ; /usr/bin/time -f "%e"   iquest --no-page "select DATA_PATH where META_DATA_ATTR_NAME = 'color'" 2>>$outputfilename 

{ date &  echo "== Q16 Lookup one meta data value name ==";      } >> $outputfilename ; /usr/bin/time -f "%e"  iquest --no-page "select DATA_PATH where META_DATA_ATTR_VALUE = 'blue'" 2>>$outputfilename
