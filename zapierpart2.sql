
--## basic stats

select count(distinct user_id)
from source_data.tasks_used_da
;

-- 319,573



-- ## date range

select min(date), max(date)
from source_data.tasks_used_da
;

-- Jan 1, 2017 to Jun 1, 2017



--## Is account_id relevant?

select user_id, account_id, count(*) as count
from source_data.tasks_used_da
where user_id != account_id
group by user_id, account_id
having count(*) !=152
order by user_id
;

-- account_ids have -1 and different users have same account ids. not relevant.
-- Only extract date, user_id, and sum_tasks_used.


-- ## Step 1: create a date table with all dates from Jan 1 to Jun 1, 2017


create table date_table as
select
'2017-01-01'::DATE + d AS date
FROM
( SELECT ROW_NUMBER() over(order by user_id) -1 AS d from source_data.tasks_used_da ORDER BY user_id LIMIT 152 ) as d
;

select * from date_table
;



-- ## Step 2: create a daily table summing up activities regardless of the account_ids

create table daily_activity as
select
--top 200
date as active_date,
user_id,
sum(sum_tasks_used) as sum_activities
from source_data.tasks_used_da
--where user_id =1
group by user_id, date
order by user_id, date
;

select * from daily_activity;





-- ## Step 3: Cross reference daily_activity table with the dates table
-- to determine if user has been active (ie. at least 1 activity in a 28 day window)

create table active_or_churn as
select
date,
user_id,
days_since_last_activity,
CASE when days_since_last_activity <=28 then 1 else 0 end as active_ind,
CASE when days_since_last_activity > 28 then 1 else 0 end as churn_ind
from
(

select
date_table.date as date,
daily_activity.user_id,
min(date_table.date::date - daily_activity.active_date::date) as days_since_last_activity
FROM aching.date_table
LEFT JOIN aching.daily_activity
ON date_table.date >= daily_activity.active_date
GROUP BY 1, 2
ORDER BY 2, 1
)
;

-- The caveat with this approach is that it assumes all users are new users in 2017.
-- If in the event, the user's account is activated before 2017, and there is a record of activity
-- in Jan 18, 2017 (as an example), this table will not record the user to be active from Jan 1 to Jan 17
-- (as per definition of active) which could lead to misleading results.

-- I've tried but could not reach a solution to fix this issue.

-- Reference: Looker Block on Active Users


