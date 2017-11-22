# irods-perf-test
iRODS performance test scripts

This is a collection of scripts and procedures that run various iRODS commands (such as iput, iquest) and records the timing information. I also provide some queries and configuration information regarding postgres performance. 

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

```
