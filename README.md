# irods-perf-test
iRODS performance test scripts

This is a collection of scripts and procedures for running various iRODS commands (such as iput, iquest) and recording the timing information. The goal is to understand how iRODs is performing in various cases. I also provide some queries and configuration information regarding postgres. 

## Getting Started
The scripts here will create the test files and run the irods operations. I also describe the operations in detail so one can run them without the scripts as well. 


### Prerequisites
* Working irods installation. 
* Enough disk space (this depends on how many files and how many tests you want to run). 
* Have enough knowledge about the hardware, OS, and database settings. 
* To better organize and manage the test create a new collection and user. I also disbaled any replication and compound resource settings to keep the structure simple. 


## Running the tests

Here is an example of measuring iput for 1000 files of 1KB size. 

```
$ sh maketestfile.sh 
Usage: maketestfile.sh <number_of_files> <dir_name> <file_size_in_kb>


$ sh maketestfile.sh 1000 test.1000 1
Creating 1000 files of size 1kb in directory
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

If you want to capture this is a file to keep the record, run this (without the verbose option and redirecting the output to a file: 

``` 
$ date >> mytest.out ; echo "iput 1000 files test" >> mytest.out ; /usr/bin/time -f "%e" iput -r -b test.1000 2>>mytest.out 

$ cat mytest.out 
Thu Nov 23 12:54:58 CET 2017
iput 1000 files test
23.87
```
