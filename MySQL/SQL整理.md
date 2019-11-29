# SQL整理

## DDL

## DML

### FUNCTION

#### STRING

#### NUMBER

#### logic function

##### coalesce - 返回第一个非NULL的值

#### aggregation function

#### window function

##### first_value

```sql
last_value(_col) over (partition by p_col order by o_col1 desc, o_col2 asc rows between unbounded preceding and unbounded following) n_col
```





## EXPAND

### JOIN

#### FULL OUTER JOIN

> FULL OUTER JOIN 关键字只要左表（table1）和右表（table2）其中一个表中存在匹配，则返回行.
>
> FULL OUTER JOIN 关键字结合了 LEFT JOIN 和 RIGHT JOIN 的结果。

![SQL FULL OUTER JOIN](https://www.runoob.com/wp-content/uploads/2013/09/img_fulljoin.gif)

#### 