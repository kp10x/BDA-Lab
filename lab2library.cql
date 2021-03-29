CREATE KEYSPACE Library WITH replication = {'class': 'SimpleStrategy','replication_factor': 1};
DESC KEYSPACES;
USE library ;


CREATE TABLE library_info ( 
    stud_id int, 
    counter_value counter, 
    stud_name text, 
    book_name text, 
    book_id int, 
    date_of_issue date, 
    PRIMARY KEY (stud_id, stud_name, book_name, book_id, date_of_issue)
    ) ;
DESC TABLE library_info;

/*
CREATE TABLE library.library_info (
    stud_id int,
    stud_name text,
    book_name text,
    date_of_issue date,
    counter_value counter,
    PRIMARY KEY (stud_id, stud_name, book_name, date_of_issue)
) WITH CLUSTERING ORDER BY (stud_name ASC, book_name ASC, date_of_issue ASC)
    AND additional_write_policy = '99p'
    AND bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND cdc = false
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '16', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND crc_check_chance = 1.0
    AND default_time_to_live = 0
    AND extensions = {}
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair = 'BLOCKING'
    AND speculative_retry = '99p';
*/

-- cannot apply batch
UPDATE library_info SET counter_value = counter_value + 1 WHERE stud_id = 110 AND stud_name = 'Aravindh' AND book_name = 'ML' AND book_id = 110 AND date_of_issue = '2020-06-16';
UPDATE library_info SET counter_value = counter_value + 1 WHERE stud_id = 111 AND stud_name = 'Karthik' AND book_name = 'OOMD' AND book_id = 111 AND date_of_issue = '2020-04-23';
UPDATE library_info SET counter_value = counter_value + 1 WHERE stud_id = 113 AND stud_name = 'Krishna' AND book_name = 'BDA' AND book_id = 112 AND date_of_issue = '2020-07-09';
SELECT * FROM library_info ;

/*
 stud_id | stud_name | book_name | book_id | date_of_issue | counter_value
---------+-----------+-----------+---------+---------------+---------------
     110 |  Aravindh |        ML |     110 |    2020-06-16 |             1
     111 |   Karthik |      OOMD |     111 |    2020-04-23 |             1
     112 |   Krishna |       BDA |     112 |    2020-07-09 |             1
*/

UPDATE library_info SET counter_value = counter_value + 1 WHERE stud_id = 112 AND stud_name = 'Krishna' AND book_name = 'BDA' AND book_id = 112 AND date_of_issue = '2020-07-09';
SELECT * FROM library_info ;

/*
 stud_id | stud_name | book_name | book_id | date_of_issue | counter_value
---------+-----------+-----------+---------+---------------+---------------
     110 |  Aravindh |        ML |     110 |    2020-06-16 |             1
     111 |   Karthik |      OOMD |     111 |    2020-04-23 |             1
     112 |   Krishna |       BDA |     112 |    2020-07-09 |             2
*/

SELECT * FROM library_info WHERE stud_id = 112;

/*
 stud_id | stud_name | book_name | book_id | date_of_issue | counter_value
---------+-----------+-----------+---------+---------------+---------------
     112 |   Krishna |       BDA |     112 |    2020-07-09 |             2
*/


COPY library_info TO 'library_info.csv';

/*
Using 1 child processes
Starting copy of library.library_info with columns [stud_id, stud_name, book_name, book_id, date_of_issue, counter_value].
cqlshlib.copyutil.ExportProcess.write_rows_to_csv(): writing row
cqlshlib.copyutil.ExportProcess.write_rows_to_csv(): writing row
cqlshlib.copyutil.ExportProcess.write_rows_to_csv(): writing row
Processed: 3 rows; Rate:       6 rows/s; Avg. rate:       6 rows/s
3 rows exported to 1 files in 0.541 seconds.
*/


CREATE TABLE library_info_1 ( 
    stud_id int, 
    counter_value counter, 
    stud_name text, 
    book_name text, 
    book_id int, 
    date_of_issue date, 
    PRIMARY KEY (stud_id, stud_name, book_name, book_id, date_of_issue)
    ) ;

COPY library_info_1 FROM 'library_info.csv';

/*
Using 1 child processes
Starting copy of library.library_info_1 with columns [stud_id, stud_name, book_name, book_id, date_of_issue, counter_value].
Processed: 3 rows; Rate:       4 rows/s; Avg. rate:       7 rows/s
3 rows imported from 1 files in 0.445 seconds (0 skipped).
*/

SELECT * FROM library_info_1 ;

/*
 stud_id | stud_name | book_name | book_id | date_of_issue | counter_value
---------+-----------+-----------+---------+---------------+---------------
     110 |  Aravindh |        ML |     110 |    2020-06-16 |             1
     111 |   Karthik |      OOMD |     111 |    2020-04-23 |             1
     112 |   Krishna |       BDA |     112 |    2020-07-09 |             2
*/