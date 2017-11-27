# irods-perf-test
iRODS performance test scripts

This is a collection of scripts and procedures for running various iRODS commands (such as iput, iquest) and recording the timing information. The goal is to understand how iRODs is performing in various cases. I also provide some queries and configuration information regarding database settings (postgres in this case). 

## Getting Started
I have provided some scripts and also raw test data based on my various runs. The basic idea is create lots of small files and run iput/iget and record the time. 

### Prerequisites
* Working irods installation. 
* Enough disk space (this depends on how many files and how many tests you want to run). 
* Enough knowledge about the hardware, OS, and database settings. 
* Organize and manage the test by creating a new collection and user. I usually disbale any replication and compound resource settings to keep the structure simple. 

## Running the iput tests

Here is an example of measuring iput for 300 files of 1KB size. The [runiputtest.sh](https://github.com/beheerderdag/irods-perf-test/blob/master/test-scripts/runiputtest.sh) takes several arguments and calls [maketestfile.sh](https://github.com/beheerderdag/irods-perf-test/blob/master/test-scripts/maketestfile.sh) which prepares the directories with numbers of files defined by the user. Based on the user input the script also constructs the full iput command, executes it then saves the timing information (using /usr/bin/time) of the aforementioned iput command in an output file.  

Example: 

```
sharifi$ sh runiputtest.sh 
Usage: runiputtest.sh <iput_commands_to_run> <number_of_files> <dir_name> 
<file_size_in_kb> <out_put_file_name>

sharifi$ sh runiputtest.sh "iput -r -b" 300 test.300 1 test.300.out 
Creating 300 files of size 1kb in directory
1
2
3
4
5
6
7
[...]
296
297
298
299
--- Timing iput -r -b of 300 files ---- 
Running iput -r -b test.300....

sharifi$ cat test.300.out 
--- Timing iput -r -b of 300 files ---- 
start:  Fri Nov 24 15:06:31 CET 2017
timing: 7.32
end:    Fri Nov 24 15:06:38 CET 2017

```

Of course this can be done without the script. 

```
$ sh maketestfile.sh 
Usage: maketestfile.sh <number_of_files> <dir_name> <file_size_in_kb>

$ sh maketestfile.sh 1000 test.1000 1
Creating 1000 files of size 1kb in directory
....

sharifi$ /usr/bin/time -f "%e" iput -r -b -v test.1000 
C- /SURFsaraTest01/home/perf/test.1000:
C- /SURFsaraTest01/home/perf/test.1000:
Bulk upload 50 files.
   file.test.1000.764              0.049 MB | 1.183 sec | 0 thr |  0.041 MB/s
Bulk upload 50 files.
   file.test.1000.765              0.049 MB | 1.177 sec | 0 thr |  0.041 MB/s
Bulk upload 50 files.
   file.test.1000.818              0.049 MB | 1.194 sec | 0 thr |  0.041 MB/s
Bulk upload 50 files.
   file.test.1000.48               0.049 MB | 1.200 sec | 0 thr |  0.041 MB/s
Bulk upload 50 files.
   file.test.1000.599              0.049 MB | 1.199 sec | 0 thr |  0.041 MB/s
Bulk upload 50 files.
   file.test.1000.573              0.049 MB | 1.177 sec | 0 thr |  0.041 MB/s
Bulk upload 50 files.
   file.test.1000.382              0.049 MB | 1.166 sec | 0 thr |  0.042 MB/s
Bulk upload 50 files.
   file.test.1000.35               0.049 MB | 1.172 sec | 0 thr |  0.042 MB/s
Bulk upload 50 files.
   file.test.1000.19               0.049 MB | 1.175 sec | 0 thr |  0.042 MB/s
Bulk upload 50 files.
   file.test.1000.856              0.049 MB | 1.173 sec | 0 thr |  0.042 MB/s
Bulk upload 50 files.
   file.test.1000.87               0.049 MB | 1.188 sec | 0 thr |  0.041 MB/s
Bulk upload 50 files.
   file.test.1000.555              0.049 MB | 1.180 sec | 0 thr |  0.041 MB/s
Bulk upload 50 files.
   file.test.1000.606              0.049 MB | 1.181 sec | 0 thr |  0.041 MB/s
Bulk upload 50 files.
   file.test.1000.375              0.049 MB | 1.171 sec | 0 thr |  0.042 MB/s
Bulk upload 50 files.
   file.test.1000.621              0.049 MB | 1.179 sec | 0 thr |  0.041 MB/s
Bulk upload 50 files.
   file.test.1000.569              0.049 MB | 1.171 sec | 0 thr |  0.042 MB/s
Bulk upload 50 files.
   file.test.1000.450              0.049 MB | 1.183 sec | 0 thr |  0.041 MB/s
Bulk upload 50 files.
   file.test.1000.576              0.049 MB | 1.167 sec | 0 thr |  0.042 MB/s
Bulk upload 50 files.
   file.test.1000.71               0.049 MB | 1.171 sec | 0 thr |  0.042 MB/s
Bulk upload 50 files.
   file.test.1000.543              0.049 MB | 1.179 sec | 0 thr |  0.041 MB/s
23.80
```
23.80 seconds is the time we want to capture. 

If you want to capture this in a file to keep the record run the following (redirect the output to a file and omit the verbose output: 

``` 
$ date >> mytest.out ; echo "iput 1000 files test" >> mytest.out ; /usr/bin/time -f "%e" iput -r -b test.1000 2>>mytest.out 

$ cat mytest.out 
Thu Nov 23 12:54:58 CET 2017
iput 1000 files test
23.87
```
You can repeat this test with a different file count, size and keep collecting the data in this manner. 


## Add some metadata 

We run a script that adds random metadata per file. We measure this time. 
```
$ /usr/bin/time -f "%e" sh add_meta_data.sh test.1000 color red
150.82
```

You can speed this time with a wild card 

```
$ /usr/bin/time -f "%e" imeta addw -d test.1000/% color green 
AVU added to 1000 data-objects
2.51
```

Add different metadata name and value per file to make this more interesting: 

```
$ for i in $(seq 1 1000); do imeta addw -d test.1000/% mymetadataname mymetadatavalue.$i mymetadataunit.$i ; done
AVU added to 1000 data-objects
AVU added to 1000 data-objects
AVU added to 1000 data-objects
AVU added to 1000 data-objects
AVU added to 1000 data-objects
AVU added to 1000 data-objects
....

```
## Measure iquest performance 

```
$ date ;  echo  "== count all metadata == "  ; /usr/bin/time -f "%e" iquest "select count(META_DATA_ATTR_VALUE)"
Thu Nov 23 16:28:40 CET 2017
== Q3  count all metadata == 
META_DATA_ATTR_VALUE = 400045
------------------------------------------------------------
0.27
```

You can use the script I have here to run all the iquest commands and it will save the timing information. See the rawtestdata for a test-run output. 

```
sh run-iquest-test.sh test-run
```

## Table size 

As I was adding more and more files to irods via iput I was also keeping track of various table size growth, in particular the r_data_main table size. pg_total_relation_size index+table. You can do this via postgres commands. For my tests, I recorded the table size of before and after running a test. 

```
ICAT=# SELECT pg_size_pretty(pg_relation_size('"public"."r_data_main"'));
 pg_size_pretty 
----------------
 1515 MB
(1 row)

ICAT=# SELECT pg_size_pretty(pg_total_relation_size('"public"."r_data_main"'));
 pg_size_pretty 
----------------
 2885 MB
 ```
 ## Shared buffer usage 
 This is understanding how postgres is behaving while certain irods operation is performing. I installed the pg_buffercache extension to track this. 
