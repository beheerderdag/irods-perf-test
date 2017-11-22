For the test we used 1kb small files. 

### Test environment: 
 * Centos 6.9 
 * Dell Power Edge R720xd 
 * Intel Xeon 2.40 GHz, 8 CPUs (1 thread per core, 4 cores per socket, 2 sockets) 
 * 64 GB memory 
 * 28TB disk (SATA, RAID-6)
  * Postgres: 
    * shared buffers = 1024MB 
    * work_mem = 128kB 
    * maintenance_work_mem = 64GB 


#### 100000 files: 

```
 $ /usr/bin/time iput -r /eudatCache/perftest/100k
174.71user 182.65system 1:18:05elapsed 7%CPU (0avgtext+0avgdata 5604maxresident)k
204861544inputs+0outputs (34major+301511minor)pagefaults 0swaps
```
 
#### 100000 files with bulk: 
```
$ /usr/bin/time iput -rb /eudatCache/perftest/100k
5.22user 182.76system 52:53.71elapsed 5%CPU (0avgtext+0avgdata 33544maxresident)k
204869224inputs+0outputs (4major+8492minor)pagefaults 0swaps
```

#### 300k bulk:

```
$ /usr/bin/time iput -rb /eudatCache/perftest/300k
14.84user 550.02system 2:33:31elapsed 6%CPU (0avgtext+0avgdata 33328maxresident)k
614573304inputs+0outputs (38major+29379minor)pagefaults 0swaps
```
### 600k bulk: 
```
$ /usr/bin/time iput -rb /eudatCache/perftest/600k
29.79user 1086.91system 5:16:12elapsed 5%CPU (0avgtext+0avgdata 34272maxresident)k
1229175544inputs+0outputs (38major+44399minor)pagefaults 0swaps
```

### One million bulk: 
```
$ /usr/bin/time iput -rb /eudatCache/perftest/onemil
50.60user 1806.56system 8:49:08elapsed 5%CPU (0avgtext+0avgdata 34840maxresident)k
2036295536inputs+0outputs (6major+73101minor)pagefaults 0swaps
```


### One million files with 8 parallel iputs in different directories:

```
1. 13.75user 382.24system 2:52:55elapsed 3%CPU (0avgtext+0avgdata 33744maxresident)k
409839240inputs+3552outputs (0major+21225minor)pagefaults 0swaps

2. 15.58user 394.52system 3:35:15elapsed 3%CPU (0avgtext+0avgdata 37784maxresident)k
410108648inputs+248512outputs (0major+20942minor)pagefaults 0swaps

3. 15.73user 399.79system 3:37:33elapsed 3%CPU (0avgtext+0avgdata 36004maxresident)k
409917592inputs+73280outputs (0major+23004minor)pagefaults 0swaps

4. 15.59user 393.16system 3:41:12elapsed 3%CPU (0avgtext+0avgdata 33840maxresident)k
410039032inputs+3552outputs (0major+22758minor)pagefaults 0swaps

5. 15.33user 394.96system 3:48:12elapsed 2%CPU (0avgtext+0avgdata 35500maxresident)k
409825552inputs+3552outputs (0major+23007minor)pagefaults 0swaps

6. 15.43user 399.57system 3:49:18elapsed 3%CPU (0avgtext+0avgdata 33392maxresident)k
409847960inputs+56472outputs (1major+22756minor)pagefaults 0swaps

7. 15.99user 395.55system 3:58:15elapsed 2%CPU (0avgtext+0avgdata 34108maxresident)k
410309288inputs+3552outputs (6major+22752minor)pagefaults 0swaps

8. 26.66user 762.31system 5:21:09elapsed 4%CPU (0avgtext+0avgdata 33616maxresident)k
819824792inputs+113640outputs (1major+10675minor)pagefaults 0swaps
```

#### Summary table: 

| Operation | Filecount | Time | Table growth (MB) |
| ------------- | ------------- |------------- |------------- |
| iput  | 100000 | 01:18:05 | 25 |
| iput -rb | 100000  |00:52:53 | 25 |
| iput -rb | 100000  |00:52:53 | 25 |
| iput  | 200000  |02:38:59 | 51 |
| iput -rb | 200000  |01:41:26 | 51|
| iput -rb | 300000  |02:33:31 | 77|
| iput -rb | 600000  |05:16:12 | 145|
| iput -rb | 1000000  |08:49:08 | 266|
| ireg | 1000000  |02:49:08 | 266|




 
  

  
 


