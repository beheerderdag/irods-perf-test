
#### 100k files: 

```
 $ /usr/bin/time iput -r /eudatCache/perftest/100k
174.71user 182.65system 1:18:05elapsed 7%CPU (0avgtext+0avgdata 5604maxresident)k
204861544inputs+0outputs (34major+301511minor)pagefaults 0swaps

```
 
#### 100k files with bulk: 
```
$ /usr/bin/time iput -rb /eudatCache/perftest/100k
5.09user 176.54system 51:58.75elapsed 5%CPU (0avgtext+0avgdata 34256maxresident)k
204894408inputs+0outputs (39major+8681minor)pagefaults 0swaps
```


#### 300k bulk:

```
$ /usr/bin/time iput -rb /eudatCache/perftest/300k
14.84user 550.02system 2:33:31elapsed 6%CPU (0avgtext+0avgdata 33328maxresident)k
614573304inputs+0outputs (38major+29379minor)pagefaults 0swaps
```

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




 
  

  
 


