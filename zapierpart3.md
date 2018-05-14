# Part Three: Analyze MAU (Monthly Active Users) and Churn
Steps below are done in Mode Analytics Studio


## a) Monthly Active Users versus churn

select
date_trunc('month', date) as month,
sum(active_ind) as active,
sum(churn_ind) as churn
from aching.active_or_churn
group by month
order by month
;

* See MAU vs Churn Table and MAU vs Churn Chart for visualizations

### Caveats
The problems with the table and the chart are such that, it is not comparing cohorts.
For example, those who were active in January have a higher chance to churn in May than those who were active in April. 
From this chart, it is hard to draw conclusions to distinguish between the two groups. Furthermore, We also cannot tell from this chart 
what proportion of users were active and churned but resumed to be active again.

## b) Daily Active Users versus Churn

* see Excel file: zapierpart3visualizations.xlsm for chart

## c) By Cohorts

Ideally, I'd like to be able to pivot the table so I can see by cohort and generate recommendations/findings.

The thought was to create something along the line of: https://modeanalytics.com/benn/reports/0637bbe8c034/runs/6df518d2ca01

For each date (down the column), we can see the churn rate by days since last activity across the row and flag 
any anomalies or opportunities in that way. 

I ended up doing pivot to see the number of active users on a daily basis and it looks like there's a weekly pattern.
Weekends, the user activity drops. During the weekday, it seems to pick up. 

* See Excel file: zapierpart3visualizationsp2.xlsm for chart







