# Database settings and performance measurement 

The database settings and performance play a crucial role in iRODs (our setup was with postgres, there are other options as well however the fundamental issues and approach for such investigations should remain same regardless of database platform). The irods setup with postgres runs lots of queries for all irods operation. So it is important to understand the inner workings of the database and basics of performance measurement . Some of the iRODS operations create large SQL joins with multiple tables. One irods command can trigger various SQL operations.  Here's an example of a query that was triggered when a irm command was issued (there were also an UPDATE and DELETE SQL statement as well for this particular operation). 

```
select distinct R_DATA_MAIN.data_id ,R_DATA_MAIN.data_name ,R_COLL_MAIN.coll_name ,
R_DATA_MAIN.coll_id ,R_DATA_MAIN.data_repl_num ,R_DATA_MAIN.data_version ,R_DATA_MAIN.data_type_name,
R_DATA_MAIN.data_size ,R_DATA_MAIN.resc_name ,R_DA\TA_MAIN.data_path ,
R_DATA_MAIN.data_owner_name ,R_DATA_MAIN.data_owner_zone ,R_DATA_MAIN.data_is_dirty ,
R_DATA_MAIN.data_status ,R_DATA_MAIN.data_checksum ,R_DATA_MAIN.data_expiry_ts ,
R_DATA_MAIN.data_map_id ,R_DATA_MAIN.r_comment ,R_DATA_MAIN.create_ts ,R_DATA_MAIN.modify_ts ,
R_DATA_MAIN.data_mode ,R_DATA_MAIN.resc_hier  from  
R_DATA_MAIN , R_COLL_MAIN  where R_COLL_MAIN.coll_name =$1  AND R_DATA_MAIN.data_name =$2  
AND R_COLL_MAIN.coll_id = R_DATA_MAIN.coll_id  AND R_DATA_MAIN.data_id in (select object_id 
from R_OBJT_ACCESS OA, R_USER_GROUP UG, R_USER_MAIN UM, R_TOKN_MAIN TM where UM.user_name=$3 and 
UM.zone_name=$4 
and UM.user_type_name!=? and UM.user_id = UG.user_id and UG.group_user_id = OA.use
r_id and OA.object_id = R_DATA_MAIN.data_id and OA.access_type_id >= TM.token_id
```

## Extentions 

We installed several postgres extensions (*pg_buffercache* and *pg_stat_statements* are two very useful extentions) in order to gather more data. To install and use these you will need admin access to the database. Some of these extensions locks tables and have some associated overhead so proceed with caution when running in a production systems. 

``` 
postgres=# \dx+
Objects in extension "pg_buffercache"
       Object Description        
---------------------------------
 function pg_buffercache_pages()
 view pg_buffercache
(2 rows)

Objects in extension "pg_stat_statements"
         Object Description          
-------------------------------------
 function pg_stat_statements()
 function pg_stat_statements_reset()
 view pg_stat_statements
(3 rows)
```

## Postgres bench mark 

Run the pg_bench tool and play with these settings to understand what can be tuned. Some of these settings will depend on the workload and specific database operations. 
```
max_connections = 100
shared_buffers = 2GB
effective_cache_size = 48GB
work_mem = 83886kB
maintenance_work_mem = 2GB
checkpoint_segments = 128
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 500
```

## Shared buffer usage 

pg_buffercache helps you track the shared buffer usage. You can track the buffer usage by tables. 

##  Query stat 
pg_stat_statements shows the queries that are currently runnig and number of times they have been called. 
For example this query shows the top 5 queries. You need to run ``` SELECT pg_stat_statements_reset();``` to reset the counter. 

```
postgres=# select substring(query, 1, 30) AS short_query, round(total_time::numeric, 2) AS total_time, 
calls, round((100 * total_time / sum(total_time::numeric) OVER ())::numeric, 2) AS percentage_cpu 
from pg_stat_statements ORDER BY total_time DESC LIMIT 5;

          short_query           | total_time | calls | percentage_cpu 
--------------------------------+------------+-------+----------------
 select distinct R_DATA_MAIN.da |    3142.35 | 14631 |          34.06
 select data_id from R_DATA_MAI |    1673.38 | 14629 |          18.14
 select object_id from R_OBJT_A |    1078.22 | 14631 |          11.69
 delete from R_DATA_MAIN where  |    1050.07 | 14629 |          11.38
 update R_RESC_MAIN set resc_ob |     584.93 | 14629 |           6.34
(5 rows)
```
## Database maintenance 

Peridocally run vacuum and analyze 

Vacuum: (a full vacuum will lock the table and will slow down certain operations such as ils). 

```
ICAT=# vacuum verbose r_meta_main;
INFO:  vacuuming "public.r_meta_main"
INFO:  index "idx_meta_main1" now contains 221182 row versions in 609 pages
DETAIL:  0 index row versions were removed.
0 index pages have been deleted, 0 are currently reusable.
CPU 0.00s/0.00u sec elapsed 0.52 sec.
INFO:  index "idx_meta_main2" now contains 221182 row versions in 1007 pages
DETAIL:  0 index row versions were removed.
0 index pages have been deleted, 0 are currently reusable.
CPU 0.00s/0.00u sec elapsed 0.64 sec.
INFO:  index "idx_meta_main3" now contains 221182 row versions in 1069 pages
DETAIL:  0 index row versions were removed.
0 index pages have been deleted, 0 are currently reusable.
CPU 0.01s/0.00u sec elapsed 0.76 sec.
INFO:  index "idx_meta_main4" now contains 221182 row versions in 1069 pages
DETAIL:  0 index row versions were removed.
0 index pages have been deleted, 0 are currently reusable.
CPU 0.01s/0.00u sec elapsed 0.79 sec.
INFO:  "r_meta_main": found 0 removable, 221182 nonremovable row versions in 3041 out of 3041 pages
DETAIL:  0 dead row versions cannot be removed yet.
There were 0 unused item pointers.
0 pages are entirely empty.
CPU 0.08s/0.04u sec elapsed 2.80 sec.
INFO:  vacuuming "pg_toast.pg_toast_16424"
INFO:  index "pg_toast_16424_index" now contains 0 row versions in 1 pages
DETAIL:  0 index row versions were removed.
0 index pages have been deleted, 0 are currently reusable.
CPU 0.00s/0.00u sec elapsed 0.00 sec.
INFO:  "pg_toast_16424": found 0 removable, 0 nonremovable row versions in 0 out of 0 pages
DETAIL:  0 dead row versions cannot be removed yet.
There were 0 unused item pointers.
0 pages are entirely empty.
CPU 0.00s/0.00u sec elapsed 0.00 sec.
```
Analyze 
```
INFO:  analyzing "public.r_user_auth"
INFO:  "r_user_auth": scanned 1 of 1 pages, containing 4 live rows and 2 dead rows; 4 rows in sample, 4 estimated total rows
INFO:  analyzing "public.r_quota_main"
INFO:  "r_quota_main": scanned 0 of 0 pages, containing 0 live rows and 0 dead rows; 0 rows in sample, 0 estimated total rows
INFO:  analyzing "public.r_quota_usage"
INFO:  "r_quota_usage": scanned 1 of 1 pages, containing 3 live rows and 0 dead rows; 3 rows in sample, 3 estimated total rows
INFO:  analyzing "public.r_specific_query"
INFO:  "r_specific_query": scanned 1 of 1 pages, containing 12 live rows and 0 dead rows; 12 rows in sample, 12 estimated total rows
INFO:  analyzing "public.r_ticket_main"
INFO:  "r_ticket_main": scanned 0 of 0 pages, containing 0 live rows and 0 dead rows; 0 rows in sample, 0 estimated total rows
INFO:  analyzing "public.r_ticket_allowed_hosts"
INFO:  "r_ticket_allowed_hosts": scanned 0 of 0 pages, containing 0 live rows and 0 dead rows; 0 rows in sample, 0 estimated total rows
INFO:  analyzing "public.r_ticket_allowed_users"
INFO:  "r_ticket_allowed_users": scanned 0 of 0 pages, containing 0 live rows and 0 dead rows; 0 rows in sample, 0 estimated total rows
INFO:  analyzing "public.r_ticket_allowed_groups"
INFO:  "r_ticket_allowed_groups": scanned 0 of 0 pages, containing 0 live rows and 0 dead rows; 0 rows in sample, 0 estimated total rows
INFO:  analyzing "public.r_grid_configuration"
INFO:  "r_grid_configuration": scanned 1 of 1 pages, containing 1 live rows and 3 dead rows; 1 rows in sample, 1 estimated total rows
INFO:  analyzing "public.r_objt_access"
INFO:  "r_objt_access": scanned 30000 of 57372 pages, containing 2833273 live rows and 376107 dead rows; 30000 rows in sample, 5455483 estimated total rows
```
