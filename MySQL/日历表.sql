CREATE TABLE g_dimension.g_dim_calendar(
  day_id int NOT NULL comment '年月日',
  day_date date comment '年月日',
  year int comment '年份',
  year_start date COMMENT '今年年初',
  year_end date COMMENT '今年年末',
  last_year_start date COMMENT '去年年初',
  last_year_end date COMMENT '去年年末',
  days_of_year int COMMENT '本年总天数',
  day_of_year int COMMENT '本年初开始第几天',
  month int comment '月份',
  month_start date COMMENT '本月初',
  month_end date COMMENT '本月末',
  last_month_start date COMMENT '上月初',
  last_month_end date COMMENT '上月末',
  next_month_start date COMMENT '下月初',
  next_month_end date COMMENT '下月末',
  days_of_month int COMMENT '本月总天数',
  day_of_month int COMMENT '本月初开始第几天',
  quarter int comment '季度',
  quarter_start date COMMENT '本季初',
  quarter_end date COMMENT '本季末',
  days_of_quarter int COMMENT '本季度总天数',
  day_of_quarter int COMMENT '本季度第几天',
  weekday varchar(8) comment '周几',
  week_num_0 varchar(8) COMMENT '周日开始周次',
  week_num_1 varchar(8) COMMENT '周一开始周次',
  week_num_2 varchar(8) COMMENT '周二开始周次',
  week_num_3 varchar(8) COMMENT '周三开始周次',
  week_num_4 varchar(8) COMMENT '周四开始周次',
  week_num_5 varchar(8) COMMENT '周五开始周次',
  week_num_6 varchar(8) COMMENT '周六开始周次',
  is_weekend bool default false comment '是否是周末',
  is_holiday_cn bool default false comment '是否属于中国节假日',
  festival_name varchar(64) default null comment '节日名',
  festival_desc longtext default null comment '节日简述',
  PRIMARY KEY(day_id)
);



CREATE DEFINER=`admin`@`%` PROCEDURE `g_dimension`.`p_dim_day`(in start_date varchar(20), in day_count int)
BEGIN
   DECLARE i int;
   SET i=0;
   while i < day_count DO
     insert into g_dimension.g_dim_calendar(day_id
         ,day_date
         ,year
         ,year_start
         ,year_end
         ,last_year_start
         ,last_year_end
         ,days_of_year
         ,day_of_year
         ,month
         ,month_start
         ,month_end
         ,last_month_start
         ,last_month_end
         ,next_month_start
         ,next_month_end
         ,days_of_month
         ,day_of_month
         ,quarter
         ,quarter_start
         ,quarter_end
         ,days_of_quarter
         ,day_of_quarter
         ,weekday
         ,week_num_0
         ,week_num_1
         ,week_num_2
         ,week_num_3
         ,week_num_4
         ,week_num_5
         ,week_num_6
         ,is_weekend
         ,is_holiday_cn
     )
     select DATE_FORMAT(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'), '%Y%m%d') day_id
       ,DATE(str_to_date(start_date, '%Y-%m-%d %H:%i:%s')) day_date
       ,YEAR(str_to_date(start_date, '%Y-%m-%d %H:%i:%s')) year
       ,DATE_SUB(start_date, INTERVAL dayofyear(start_date)-1 DAY) year_start
       ,DATE_FORMAT(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'), '%Y-12-31 00:00:00') year_end
       ,DATE_SUB(start_date, INTERVAL dayofyear(start_date)-1 DAY) - INTERVAL 1 YEAR AS last_year_start
       ,DATE_SUB(start_date, INTERVAL dayofyear(start_date)-1 DAY) - INTERVAL 1 DAY AS last_year_end
       ,TO_DAYS(DATE_FORMAT(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'), '%Y-12-31 00:00:00')) - TO_DAYS(DATE_SUB(start_date, INTERVAL dayofyear(start_date)-1 DAY) - INTERVAL 1 DAY) AS days_of_year
       ,DAYOFYEAR(start_date) AS day_of_year
       ,MONTH(str_to_date(start_date, '%Y-%m-%d %H:%i:%s')) month
       ,DATE_SUB(start_date, INTERVAL dayofmonth(start_date)-1 DAY) month_start
       ,LAST_DAY(start_date)  month_end
       ,DATE_SUB(start_date, INTERVAL dayofmonth(start_date)-1 DAY) - INTERVAL 1 MONTH AS last_month_start
       ,DATE_SUB(start_date, INTERVAL dayofmonth(start_date)-1 DAY) - INTERVAL 1 DAY AS last_month_end
       ,DATE_SUB(start_date, INTERVAL dayofmonth(start_date)-1 DAY) + INTERVAL 1 MONTH AS next_month_start
       ,DATE_SUB(start_date, INTERVAL dayofmonth(start_date)-1 DAY) + INTERVAL 2 MONTH - INTERVAL 1 DAY AS next_month_end
       ,TO_DAYS(LAST_DAY(start_date)) - TO_DAYS(DATE_SUB(start_date, INTERVAL dayofmonth(start_date)-1 DAY)) + 1 AS days_of_month
       ,DAYOFMONTH(start_date) AS day_of_month
       ,QUARTER(start_date) AS quarter
       ,DATE_SUB(start_date, INTERVAL dayofyear(start_date)-1 DAY) + INTERVAL (QUARTER(start_date)-1)*3 MONTH AS quarter_start
       ,DATE_SUB(start_date, INTERVAL dayofyear(start_date)-1 DAY) + INTERVAL QUARTER(start_date)*3 MONTH - INTERVAL 1 DAY AS quarter_end
       ,TO_DAYS(DATE_SUB(start_date, INTERVAL dayofyear(start_date)-1 DAY) + INTERVAL QUARTER(start_date)*3 MONTH) - TO_DAYS(DATE_SUB(start_date, INTERVAL dayofyear(start_date)-1 DAY) + INTERVAL (QUARTER(start_date)-1)*3 MONTH) AS days_of_quarter
       ,TO_DAYS(start_date) - TO_DAYS(DATE_SUB(start_date, INTERVAL dayofyear(start_date)-1 DAY) + INTERVAL (QUARTER(start_date)-1)*3 MONTH) AS day_of_quarter
       ,case dayofweek(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'))
          when 1 then '星期日'
          when 2 then '星期一'
          when 3 then '星期二'
          when 4 then '星期三'
          when 5 then '星期四'
          when 6 then '星期五'
          when 7 then '星期六'
        end weekday
        ,week(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'), 0) week_num_0
        ,week(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'), 1) week_num_1
        ,week(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'), 2) week_num_2
        ,week(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'), 3) week_num_3
        ,week(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'), 4) week_num_4
        ,week(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'), 5) week_num_5
        ,week(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'), 6) week_num_6
        ,if(weekday(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'))>4, true, false) is_weekend
        ,if(weekday(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'))>4, true, false) is_holiday_cn
     from dual;
     set i=i+1;
     set start_date = DATE_FORMAT(date_add(str_to_date(start_date, '%Y-%m-%d %H:%i:%s'), interval 1 day), '%Y-%m-%d');
   end while; 
END


call g_dimension.p_dim_day('2019-01-01', 365);

-- 更新节假日
UPDATE g_dimension.g_dim_calendar SET is_holiday_cn=1 WHERE day_date in ('2018-12-30'
,'2018-12-31'
,'2019-01-01'
,'2019-02-04'
,'2019-02-05'
,'2019-02-06'
,'2019-02-07'
,'2019-02-08'
,'2019-02-09'
,'2019-02-10'
,'2019-04-05'
,'2019-04-05'
,'2019-04-07'
,'2019-05-01'
,'2019-05-02'
,'2019-05-03'
,'2019-05-04'
,'2019-06-07'
,'2019-06-08'
,'2019-06-09'
,'2019-09-13'
,'2019-09-14'
,'2019-09-15'
,'2019-10-01'
,'2019-10-02'
,'2019-10-03'
,'2019-10-04'
,'2019-10-05'
,'2019-10-06'
,'2019-10-07');

-- 更新调休
UPDATE g_dimension.g_dim_calendar SET is_holiday_cn=0 WHERE day_date in ('2018-12-29'
,'2019-02-02'
,'2019-02-03'
,'2019-04-28'
,'2019-05-05'
,'2019-09-29'
,'2019-10-12')
