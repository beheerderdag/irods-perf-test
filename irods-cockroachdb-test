
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
Bulk upload 50 files.
   xaaaaaaaaajp                    0.000 MB | 3.182 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaaaaln                    0.000 MB | 3.095 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaaaanl                    0.000 MB | 3.256 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaaaapj                    0.000 MB | 3.282 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaaaarh                    0.000 MB | 3.322 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaaaatf                    0.000 MB | 4.726 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaaaavd                    0.000 MB | 3.399 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaaaaxb                    0.000 MB | 3.287 sec | 0 thr |  0.000 MB/s
Bulk upload 50 files.
   xaaaaaaaaayz                    0.000 MB | 3.184 sec | 0 thr |  0.000 MB/s
   ````
   
