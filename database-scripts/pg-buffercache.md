During 
/usr/bin/time iput -rb /eudatCache/perftest/100k
with shared_buffer = 1024MB. 
```
ICAT=# SELECT c.relname,
   Pg_size_pretty(Count(*) * 8192)
   AS buffered,
   Round(100.0 * Count(*) / (SELECT setting
                             FROM   pg_settings
                             WHERE  name = 'shared_buffers') :: INTEGER, 1)
   AS
   buffers_percent,
   Round(100.0 * Count(*) * 8192 / Pg_relation_size(c.oid), 1)
   AS
   percent_of_relation
FROM   pg_class c
       INNER JOIN pg_buffercache b
               ON b.relfilenode = c.relfilenode
       INNER JOIN pg_database d
               ON ( b.reldatabase = d.oid
                    AND d.datname = Current_database() )
WHERE  Pg_relation_size(c.oid) > 0
GROUP  BY c.oid,
          c.relname
ORDER  BY 3 DESC
LIMIT  10;   
         relname         |  buffered  | buffers_percent | percent_of_relation 
-------------------------+------------+-----------------+---------------------
 r_data_main             | 52 MB      |             5.1 |                68.1
 r_objt_access           | 15 MB      |             1.5 |                68.3
 idx_data_main3          | 5968 kB    |             0.6 |                60.0
 idx_objt_access1        | 6392 kB    |             0.6 |                59.1
 idx_data_main6          | 1032 kB    |             0.1 |                 2.2
 pg_constraint_oid_index | 8192 bytes |             0.0 |                50.0
 idx_coll_main1          | 16 kB      |             0.0 |               100.0
 pg_namespace_oid_index  | 16 kB      |             0.0 |               100.0
 idx_zone_main2          | 8192 bytes |             0.0 |                50.0
 idx_tokn_main4          | 8192 bytes |             0.0 |                50.0
```

Done 

```
sharifi$ /usr/bin/time iput -rb /eudatCache/perftest/100k
5.19user 183.08system 52:34.33elapsed 5%CPU (0avgtext+0avgdata 34716maxresident)k
204888920inputs+0outputs (21major+8769minor)pagefaults 0swaps
```

buffer usage 

```
         relname         |  buffered  | buffers_percent | percent_of_relation
-------------------------+------------+-----------------+---------------------
 r_data_main             | 76 MB      |             7.5 |                99.7
 r_objt_access           | 22 MB      |             2.2 |               100.1
 idx_data_main6          | 14 MB      |             1.3 |                29.5
 idx_objt_access1        | 9328 kB    |             0.9 |                86.2
 idx_data_main2          | 8424 kB    |             0.8 |                27.8
 idx_data_main3          | 8600 kB    |             0.8 |                86.5
 idx_data_main4          | 5456 kB    |             0.5 |                29.0
 idx_data_main5          | 2824 kB    |             0.3 |                28.1
 idx_data_main1          | 2272 kB    |             0.2 |                29.0
 pg_constraint_oid_index | 8192 bytes |             0.0 |                50.0
 ```
 
 So it used r_data_main only used 24MB of buffer space, not much at all. 
