-- To get a count of how many records in the table
-- Found over 10M records

select count(*)
from tasks_used_da
;

-- To get the fields' names to understand what the table contains
-- Found 4 fields (date, user_id, account_id, sum_tasks_used)

select top 50 *
from tasks_used_da
;

-- To get date ranges of the data

select min(date), max(date)
from tasks_used_da
;

-- To do some quick and dirty quality checks on data (eg null records)
-- replace 'date' with three other fields

select *
from tasks_used_da
where date is null
;

select *
from tasks_used_da
where sum_tasks_used <0
;





