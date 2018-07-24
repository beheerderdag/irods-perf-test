
Test setup 

4 nodes (all VMs) 

iRODS resource server: 4 cpus, 32GB RAM. 

3-node cockroachdb cluster (each with 8cpus and 64GB RAM). 

Start config option: 

```
cockroach start --insecure --cache=.30 --max-sql-memory=.40 --host=145.100.xx.xxx --advertise-host=145.100.xx.xxx
```

Then add two more nodes to join this cluster: 


Start a simple iput test with 100k small (1k) files. 
```
[root@145 testdata]# /usr/bin/time iput -rb -v 100k/
C- /tempZone/home/rods/100k:
C- /tempZone/home/rods/100k:
Bulk upload 50 files.
   xaaaaaaaaabx                    0.000 MB | 3.318 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaaaadv                    0.000 MB | 3.220 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaaaaft                    0.000 MB | 3.077 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaaaahr                    0.000 MB | 3.199 sec | 0 thr |  0.000 MB/s

.......
...

Bulk upload 50 files.
   xaaaaaaafrql                    0.000 MB | 17.991 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaafrsj                    0.000 MB | 18.032 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaafruh                    0.000 MB | 18.056 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaafrwf                    0.000 MB | 17.712 sec | 0 thr |  0.000 MB/s
Bulk upload 48 files.
   xaaaaaaafryd                    0.000 MB | 16.927 sec | 0 thr |  0.000 MB/s
1.00user 1.86system 6:07:02elapsed 0%CPU (0avgtext+0avgdata 7884maxresident)k
0inputs+0outputs (0major+6107minor)pagefaults 0swaps

````
 cpu usage on node 1 of the cluster 
 
 ```
 Tasks: 131 total,   2 running, 129 sleeping,   0 stopped,   0 zombie
%Cpu0  : 16.0 us,  5.8 sy,  0.0 ni, 78.2 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu1  : 10.8 us,  3.4 sy,  0.0 ni, 85.9 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu2  : 11.1 us,  4.4 sy,  0.0 ni, 84.2 id,  0.3 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu3  : 11.5 us,  2.7 sy,  0.0 ni, 85.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu4  : 45.8 us, 12.7 sy,  0.0 ni, 38.0 id,  0.0 wa,  0.0 hi,  3.5 si,  0.0 st
%Cpu5  :  6.4 us,  2.4 sy,  0.0 ni, 91.2 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu6  : 10.6 us,  3.4 sy,  0.0 ni, 86.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu7  : 12.9 us,  3.1 sy,  0.0 ni, 84.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem : 65809544 total, 58326700 free,  1591908 used,  5890936 buff/cache
KiB Swap:   524284 total,   524284 free,        0 used. 63573016 avail Mem 

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                                                 
15362 root      20   0 1717348   1.1g  32636 R 172.8  1.8 580:22.10 cockroach
```


overview of queries per second 


<a href="url"><img src="https://raw.githubusercontent.com/beheerderdag/irods-perf-test/master/cockroachdb-overview.png" align="left" height="200" width="300" ></a>
