# MaxCompute

## 使用

### 函数

#### 日期函数

```
日期字符串格式： 
    yyyy-mm-dd hh:mi:ss 
说明： 
部分 字符串
年   yyyy
月   mm(01 ~ 12)
日   dd(01 ~ 31)
时   hh(00 ~ 23)
分   mi(00 ~ 59)
秒   ss(00 ~ 59)
```

##### dateadd

```
命令格式： 
    dateadd(datetime, delta, datepart)
用途： 
    按照指定的单位和幅度修改datetime的值 
参数说明： 
●  datetime:datetime类型，日期值。若输入为string类型会隐式转换为datetime类型后参与运算，其它类型抛异常。。 
●  delta:bigint类型，修改幅度。若输入为string类型或double型会隐式转换到biging类型后参与运算，其他类型会引发异常。若delta大于0，加；否则减。 
●  datepart: string类型常量, 修改单位，，支持格式对天的修改 "dd" , 对月的修改  "mm"，对年的修改 "yyyy" ，对小时修改"hh",对分钟修改"mi"，对秒修改"ss" ，此外也支持扩展的日期格式, 年-“year”, 月-“month”或”mon”, 日-“day”, 小时-“hour”。 非常量、不支持的格式会或其它类型抛异常。
返回值： 
    返回修改后的结果，datetime类型。若任一输入参数为NULL，返回NULL。 
备注： 
    按照指定的单位增减delta时导致的对更高单位的进位或退位，年、月、时、分、秒分别按照10进制、12进制、24进制、60进制、60进制计算。当delta的单位是月时，计算规则如下：若datetime的月部分在增加delta值之后不造成day溢出，则保持day值不变，否则把day值设置为结果月份的最后一天。 
示例： 
●  加一天：dateadd(trans_date, 1, 'dd') 
●  减一天：dateadd(trans_date, -1, 'dd') 
●  加二十个月：dateadd(trans_date, 20, 'mm') 
    若trans_date = '2005-02-28 00:00:00',  dateadd(transdate, 1, 'mm') = '2005-03-28 00:00:00' 
    若trans_date = '2005-01-29 00:00:00', dateadd(transdate, 1, 'mm') = '2005-02-28 00:00:00' 
    若trans_date = '2005-03-30 00:00:00', dateadd(transdate, -1, 'mm') = '2005-02-28 00:00:00' 
```

##### datediff

```
命令格式： 
    datediff(datetime1, datetime2, datepart)
用途： 
    计算两个时间的差值，并转换成指定的单位，如：秒。 
参数说明： 
●  datetime1 , datetime2: datetime类型，被减数和减数，若输入为string类型会隐式转换为datetime类型后参与运算，其它类型抛异常。
●  datepart: string类型常量，修改单位，yyyy、mm、dd、hh、mi、ss中的一个，指定时间差值的单位，也支持扩展的日期格式, 年-“year”, 月-“month”或”mon”, 日-“day”, 小时-“hour”。。若datepart不符合指定的几种pattern或者其它类型则会发生异常。 
返回值： 
    返回时间差值，int类型。任一输入参数是NULL，返回NULL。 
备注： 
    计算时会按照datepart切掉低单位部分，然后再计算结果。 
示例： 
   若start = ‘2005-12-31 23:59:59’, end = ‘2006-01-01 00:00:00’: 
? datediff(end, start, 'dd') = 1 
? datediff(end, start, 'mm') = 1 
? datediff(end, start, 'yyyy') = 1 
? datediff(end, start, 'hh') = 1 
? datediff(end, start, 'mi') = 1 
? datediff(end, start, ＇ｓｓ＇) = 1 
```

##### datepart

```
命令格式：
    datepart(datetime, part)
用途： 
    提取日期中part指定的部分 
参数说明： 
●  datetime: datetime类型，日期值，若输入为string类型会隐式转换为datetime类型后参与运算，其它类型抛异常。 
●  part：string类型常量。支持的pattern包括yyyy、mm、dd、hh、mi、ss，此外也支持扩展的日期格式, 年-“year”, 月-“month”或”mon”, 日-“day”, 小时-“hour”。。不支持的pattern或其它类型会抛异常。 
返回值： 
    返回值类型为bigint.若任一输入参数为NULL，返回NULL
```

##### datetrunc

```
命令格式：
    datetrunc (datetime,format)
用途： 
    返回截取后的日期值。 
参数说明： 
●  datetime: datetime类型,日期值，若输入为string类型会隐式转换为datetime类型后参与运算，其它类型抛异常。
●  format: string类型常量，候选值为：yyyy - 年, mm - 月, dd – 日，hh – 小时, mi – 分钟, ss – 秒，也支持扩展的日期格式, 年-“year”, 月-“month”或”mon”, 日-“day”, 小时-“hour”。 非常量、其它类型或不支持的格式会引发异常。
返回值： 
    返回datetime. 
备注： 
    任意一个参数为NULL的时候返回NULL。 
示例： 
●  datetrunc("2011-12-07 16:28:46", "yyyy")返回 "2011-01-01 00:00:00" 
●  datetrunc("2011-12-07 16:28:46", "month")返回"2011-12-01 00:00:00" 
●  datetrunc("2011-12-07 16:28:46", "DD")返回 "2011-12-07 00:00:00"
```

##### from_unixtime

```
命令格式：
    from_unixtime(unixtime)
用途： 
    将数字型的unix 时间日期值转为DE日期值
参数说明： 
●  unixtime: bigint类型，秒数，unix格式的日期时间值，若输入为string,double类型会隐式转换为bigint后参与运算。
返回值： 
    DATETIME类型的日期值, unixtime为NULL时返回NULL。
```

##### getdate

```
命令格式：
    getdate()
用途： 
    获取当前系统时间 
返回值： 
    返回当前日期和时间，datetime类型。 
备注： 
    在一个任务中，即使有多个INSTANCE，getdate总是返回一个固定的值。
```

##### isdate

```
命令格式： 
    isdate(datetime,  format)
用途： 
    判断一个日期字符串能否根据对应的格式串转换为一个日期值，如果转换成功返回TRUE,否则返回FALSE。 
参数说明： 
●  datetime: string格式的日期值，若输入为bigint, double, datetime类型会隐式转换为string类型后参与运算， 其它类型报异常。
●  format: string类型常量，指定日期格式,可选值见上表10-1 。其它类型或不支持的格式会抛异常。如果format string中出现多余的格式串，则只取第一个格式串对应的日期数值，其余的会被视为分隔符。如isdate('1234-yyyy ', 'yyyy-yyyy ')，会返回TRUE，如果用to_date('1234-yyyy ', 'yyyy-yyyy ')则会返回1234-01-01 00:00:00。
返回值： 
    返回BOOLEAN，如dt或fmt为NULL，返回NULL.
```

##### lastday

```
命令格式： 
    lastday(datetime)
用途： 
    取一个月的最后一天, 截取到天，时分秒部分为00:00:00。 
参数说明： 
●  datetime: datetime格式的日期值，若输入为string类型会隐式转换为datetime类型后参与运算， 其它类型报异常。
返回值： 
    返回datetime，如输入为NULL，返回NULL
```

##### to_date

```
命令格式：
    to_date(datetime, format)
用途： 
    将一个字符串按照format指定的格式转成日期值。 
参数说明： 
●  datetime: string类型，要转换的字符串格式的日期值，若输入为bigint, double, datetime类型会隐式转换为string类型后参与运算，为其它类型抛异常，为空串时抛异常。
●  format: string类型常量，日期格式。非常量或其他类型会引发异常。format参数中标识的间类型的元素（如年、月、日等），可选值见上表10-1，其他字符作为无用字符在parse时忽略。format参数至少包含’yyyy’，否则引发异常，如果format string中出现多余的格式串，则只取第一个格式串对应的日期数值，其余的会被视为分隔符。如to_date('1234-2234 ', 'yyyy-yyyy ')会返回1234-01-01 00:00:00
返回值： 
    返回datetime类型。若任一输入为NULL，返回NULL值。 
备注： 
    format参数在parse时，出于效率考虑，会要求yyyy对应的部分是四个字符，mm、dd、hh、mi、ss对应的部分是分别是两个字符，否则会引发异常。详见示例。 
示例： 
●  to_date('阿里金融2010-12*03', '阿里金融yyyy-mm*dd')返回‘2010-12-03 00:00:00’ 
●  to_date('阿里金融2010-12*3’, ‘阿里金融yyyy-mm*dd’)会引发异常 
●  to_date('2010-24-01’, ‘yyyy’)会引发异常 
●  to_date('20080718’, ‘yyyymmdd’)返回’2008-07-18 00:00:00’ 
●  to_date('2008718', ‘yyyymmdd’)会引发异常 
```

##### to_char

```
命令格式： 
    to_char(datetime, format)
用途： 
    将日期类型按照format指定的格式转成字符串 
参数类型： 
●  datetime: datetime类型，要转换的日期值，若输入为string类型会隐式转换为datetime类型后参与运算，其它类型抛异常。
●  format: string类型常量。非常量或其他类型会引发异常。Format中的日期格式部分会被替换成相应的数据，其它字符直接输出。详情见示例 
返回值： 
    返回值为字符串类型。任一输入参数为NULL，返回NULL。 
示例： 
●  to_char(trade_date, ‘阿里金融yyyyddmm’)返回’阿里金融20102308’ 
●  to_char(trade_date, ‘从前有座山’)返回’从前有座山’ 
●  to_char(trade_date, ‘yyyyyy’)返回’2010yy’
```

##### unix_timestamp

```
命令格式：
    unix_timestamp(datetime)
用途： 
    将日期转化为整型的unix格式的日期时间值
参数说明： 
●  datetime: datetime类型日期值，若输入为string类型会隐式转换为datetime类型后参与运算，其它类型抛异常。 
返回值： 
    整型unix格式日期值, datetime为NULL时返回NULL
```

##### weekday

```
命令格式： 
    weekday (datetime)
用途： 
    返回一个日期值是星期几，
参数说明： 
●  datetime: datetime类型，日期值，若输入为string类型会隐式转换为datetime类型后参与运算，其它类型抛异常。
返回值： 
    返回BIGINT，若输入参数为NULL，返回NULL.
星期一:0
星期二:1
星期三:2
星期四:3
星期五:4
星期六:5
星期天：6
```

##### weekofyear

```
命令格式： 
    weekofyear (datetime)
用途： 
    返回一个日期位于那一年的第几周。周一作为一周的第一天。 
参数说明： 
●  datetime:datetime类型日期值，若输入为string类型会隐式转换为datetime类型后参与运算，其它类型抛异常。
返回值： 
    Bigint类型， 属于一年的第几周，数字。 若输入为NULL，返回NULL
```

#### 字符串函数

##### chr

```
命令格式： 
    chr(ascii)
参数说明：
●  ascii: bigint类型ascii值,若输入为string类型或double类型会隐式转换到bigint类型后参与运算，其它类型抛异常。
返回值： 
    string 
用途： 
    将给定ASCII转换成字符，参数范围是0~255，超过此范围会引发异常。输入值为NULL返回NULL。
```

##### concat

```
命令格式： 
    concat(string A, string B...)
参数说明：
●  A,B等为string类型，若输入为bigint, double, datetime类型会隐式转换为string后参与运算，其它类型报异常。
返回值： 
    string 
用途： 
    返回值是将参数中的所有字符串连接在一起的结果。 
备注：
    如果没有参数或者某个参数为NULL，结果均返回NULL
concat(), concat(null, 'a'), concat('a', null, 'b')返回值都是NULL。
```

##### in

```
命令格式：
    key in (value1[, value2, value3, …])
用途： 
    查看key是否在给定列表中出现
参数说明： 
●  key是待判断值，为任意类型。
●  value1, value2, …是指定的列表，必须为常量，至少有一项，所有value的类型要一致，否则抛异常。关于in的隐式类型转换参考类型转换一节。
返回值： 
key在列表中出现返回TRUE，否则为FALSE
备注： 
●  如果key为NULL，结果返回NULL
示例： 
●   'net' IN ('Tech on the net', 'e') would return FALSE 
●  'net' IN ('Tech on the’,  'net', 'e')would return TRUE
```

##### instr

```
命令格式：
    instr(string1, string2[, start_position[, nth_appearance]])
用途： 
    计算一个子串在字符串中的位置. 
参数说明： 
●  string1:string类型，搜索的字符串，若输入为bigint, double, datetime类型会隐式转换为string后参与运算，其它类型报异常。
●  string2:string类型， 要搜索的子串，若输入为bigint, double, datetime类型会隐式转换为string后参与运算, 其它类型报异常。
●  start_position:bigint类型，其它类型会抛异常，表示从string1的第几个字符开始搜索，默认起始位置是第一个字符位置1。开始位置如果小于等于0会引发异常。
●  nth_appearance:bigint类型，大于0，表示子串在字符串中的第n次匹配的位置，如果nth_appearance为其它类型或小于等于0会抛异常。
返回值： 
    string2在string1中的出现的位置。
备注： 
●  如果在string1中未找到string2，返回0. 
●  任一输入参数为NULL返回NULL 
●  如果string2为空串时总是能匹配成功， 因此instr(‘abc’,’’) 会返回1
示例： 
●  INSTR ('Tech on the net', 'e') 返回 2 
●  INSTR ('Tech on the net', 'e', 1, 1)返回 2. 
●  INSTR ('Tech on the net', 'e', 1, 2)返回 11. 
●  INSTR ('Tech on the net', 'e', 1, 3)返回14. 
```

##### keyvalue

```
命令格式
    keyvalue(string srcStr，string split1，string split2， string key)
    keyvalue(string srcStr， string key) //split1 = “;”，split2 = “:”
keyvalue的功能：
●  将srcStr按split1分成key-value对，按split2将key-value对分开，返回key所对应的value
●  只有两个参数时，split1 = ' ;', split2 = ' :'
●  Split1或split2 为NULL时，返回NULL.
●  srcStr,key为NULL或者没有匹配的key时，返回NULL
●  如果有多个key-value匹配，返回第一个匹配上的key对应的value
示例：
keyvalue("\;decreaseStore:1\;xcard:1\;isB2C:1\;tf:21910\;cart:1\;shipping:2\;pf:0\;market:shoes\;instPayAmount:0\;", "\;",":","tf")  返回 “21910”
注：
    如果从declient console输入时字符串中有分号，应该用\;转义。该函数行为是实现成与taobao hive里的UDF一致，如果在taobao hive里的UDF行为有改动，请联系产品经理。
```

##### length

```
命令格式：
    length(string)
参数说明：
●  string: string类型，若输入为bigint, double, datetime类型会隐式转换为string后参与运算，其它类型报异常。
用途：
    返回一个字符串的长度。返回值为整型。若string是NULL返回NULL。如果string非UTF-8编码格式，返回-1。
```

##### lengthb

```
命令格式：
    lengthb(string)
参数说明：
●  string: string类型，若输入为bigint, double, datetime类型会隐式转换为string后参与运算，其它类型报异常。
用途：
    返回一个字符串的以字节为单位的长度。返回值为整型。若string是NULL返回NULL。
```

##### md5

```
命令格式: 
    md5(value)
返回值： 
    输入字符串的md5值
参数说明：
●  value: string类型，如果输入类型是bigint或double会隐式转换成string类型参与运算，其它类型报异常。输入为NULL，返回NULL。
```

##### regexp_instr

```
命令格式：
    regexp_instr(source, pattern[, start_position[,nth_occurrence[,return_option]])
返回值： 
    视return_option指定的类型返回匹配的子串在source中的开始或结束位置。
参数说明： 
●  source: string类型，待搜索的字符串。 
●  pattern: string类型常量，pattern为空串时抛异常。
●  start_position:bigint类型常量,搜索的开始位置。不指定时默认值为1，其它类型或小于等于0的值会抛异常。 
●  nth_occurrence: bigint类型常量，不指定时默认值为1， 表示搜索第一次出现的位置。小于等于0或者其它类型抛异常。
●  return_option: bigint类型常量，值为0或1， 其它类型或不允许的值会抛异常。0表示返回匹配的开始位置，1表示返回匹配的结束位置。 
用途： 
    返回字符串source从start_position开始, 和pattern第n次（nth_occurrence）匹配的子串的 起始/结束 位置。 任一输入参数为NULL时返回NULL。 
示例：
    regexp_instr("i love www.taobao.com", "o[[:alpha:]]{1}",3, 2)，返回 14
```

##### regexp_replace

```
命令格式：
    regexp_replace(source, pattern, replace_string, occurrence)
返回值： 
    将source字符串中匹配pattern的子串替换成指定字符串后返回，当输入source, pattern, occurrence参数为NULL时返回NULL，若replace_string为NULL且pattern有匹配，返回NULL，replace_string为NULL但pattern不匹配，则返回原串。
参数说明： 
●  source: string类型，要替换的字符串。
●  pattern: string类型常量，要匹配的模式，pattern为空串时抛异常。
●  replace_string:string，将匹配的pattern替换成的字符串。
●  occurrence: bigint类型常量，必须大于等于0，表示将第几次匹配替换成replace_string，为0时表示替换掉所有的匹配子串。其它类型或小于0抛异常。
●  当引用不存在的组时，不进行替换。

例如：
regexp_replace("123.456.7890","([[:digit:]]{3})\\.([[:digit:]]{3})\\.([[:digit:]]{4})","(\\1)\\2-\\3",0) 结果为(123)456-7890

regexp_replace("abcd","(.)","\\1 ",0) 结果为"a b c d "

regexp_replace("abcd","(.)","\\1 ",1) 结果为"a bcd"

regexp_replace("abcd","(.)","\\2",1) 结果为"abcd"，因为pattern中只定义了一个组，引用的第二个组不存在。

regexp_replace("abcd","(.*)(.)$","\\2",0) 结果为"d"

regexp_replace("abcd","a","\\1",0)，结果为” \1bcd”，因为在pattern中没有组的定义，所以\1直接输出为字符。
```

##### regexp_substr

```
regexp_substr(source, pattern[,start_position[,nth_occurrence]]) 

返回值： 
source中匹配pattern指定模式的子串，任一输入参数为NULL返回NULL。 

参数说明：

●  source: string类型，搜索的字符串。 

●  pattern: string类型常量，要匹配的模型，pattern为空串时抛异常。

●  start_position: 整型常量，必须大于0。其它类型或小于等于0时抛异常，不指定时默认为1， 表示从source的第一个字符开始匹配。 

●  nth_occurrence:整型常量，必须大于0，其它类型或小于等于0时抛异常。不指定时默认为1，表示返回第一次匹配的子串。 
```

##### sample

```
命令格式：
    sample (sample_parameter, column_name)
用途：
    对所有读入的column_name的值，sample_function根据sample_parameter的要求做sample，并过滤掉不满足sample条件的行。
参数说明： 
●  sample_parameter为x, y，代表哈希为x份，取第y份。y可省略，省略时取第一份。x,y为整型常量，大于0，其它类型或小于等于0时抛异常，若y>x也抛异常。x,y任一输入为NULL时返回NULL。
●  column_name是采样的目标列。column_name可以省略，省略时根据x, y的值随机采样。任意类型，列的值可以为null。不做隐式类型转换。如果column_name为常量null会报异常。
备注：
?  为了避免null值带来的数据倾斜，因此对于column_name中为null的值，会在y个bullet中进行均匀哈希。
示例：
    SELECT * FROM TBLA where sample (4, 1 , COLA) = TRUE;
表示数值会根据COLA hash为4份，取第1份。
```

##### split_part

```
命令格式： 

split_part(string, separator, start[, end]) 

用途： 
    拆分字符串，返回指定的部分 

参数说明： 

●  String：string类型，要拆分的字符串。如果是bigint, double. datetime类型会隐式转换到string类型后参加运算，其它类型报异常。

 ●  Separator：string类型常量，拆分用的分隔符，可以是一个字符，也可以是一个字符串，其它类型会引发异常。 
●  start:bigint类型常量，必须大于0。非常量或其它类型抛异常。返回段的开始编号（从1开始），如果没有指定end，则返回start指定的段。

  ●  end：bigint类型常量，大于等于start。返回段的截止编号，非常量或其他类型会引发异常。(start 必须大于 0, end 必须大于或等于 start, 否则抛异常，结果为start到end的闭区间) 
返回值： 
    separator连接的字符串片断.若任意参数为NULL，返回NULL；若separator为空串，返回string. 
```

##### to_char

```
命令格式： 
    to_char(boolean)
    to_char(bigint)
    to_char(double)
用途： 
    将布尔型、整型或者浮点型数值转为对应的字符串表示 
参数类型： 
●  单参数的to_char可以接受布尔型，整型或者浮点型输入，其它类型抛异常。对datetime类型的格式化输出请参考10.4节。
返回值： 
    对应值的字符串表示，如果输入为NULL，返回NULL。 
示例： 
●  to_char(123)返回’123’ 
●  to_char(true)返回’TRUE’ 
●  to_char(1.23)返回’1.23’
●  to_char(cast(null as bigint)) 返回NULL。
```

##### substr

```
命令格式： 
    substr(string1, start_position[, length])
用途： 
    返回字符串string1从start_position开始长度为length的子串。
参数说明： 
●  string1: string类型，若输入为bigint, double, datetime类型会隐式转换为string后参与运算，其它类型报异常。
●  start_position: bigint类型，当start_position为负数时表示开始位置是从字符串的结尾往前倒数，最后一个字符是-1。其它类型抛异常。
●  length: bigint类型，大于0，其它类型或小于等于0抛异常。子串的长度。 
返回值:
    在string1中的子串，若任一输入为NULL,返回NULL.
备注： 
    当length被省略时，返回到string1结尾的子串。 
示例： 
●  substr("abc", 2)，返回bc 
●  substr("abc", 2, 1)，返回b 
```

##### tolower

```
命令格式： 
    tolower(source)
用途： 
    输入字符串对应的小写字符串。 
参数说明： 
●  source: string类型，若输入为bigint, double, datetime类型会隐式转换为string后参与运算，其它类型报异常。
返回值：
    小写字符串，输入为NULL时返回NULL.
示例： 
●  tolower(“aBcd”) 结果”abcd” 
●  tolower(“哈哈Cd”) 结果”哈哈cd”
```

##### toupper

```
命令格式： 
    toupper(source)
用途： 
    输入字符串对应的大写字符串。 
参数说明： 
●  source: string类型，若输入为bigint, double, datetime类型会隐式转换为string后参与运算，其它类型报异常。
返回值：
    大写字符串，输入为NULL时返回NULL.
示例： 
●  toupper(“aBcd”) 结果”ABCD” 
●  toupper(“哈哈Cd”) 结果”哈哈CD”
```

##### trim

```
命令格式： 
    trim(string )
用途： 
    将输入字符串去除左右空格。
参数说明：
●  string：string类型，若输入为bigint, double, datetime类型会隐式转换为string后参与运算，其它类型报异常。
返回值： 
    string类型，输入为NULL时返回NULL。
```

##### wm_concat

```
命令格式： 
    wm_concat(separator, string)
用途： 
    用指定的spearator做分隔符，做字符串类型的SUM操作。 
参数说明： 
●  separator，string类型常量，分隔符。其他类型或非常量将引发异常。 
●  string，string类型，若输入为bigint, double, datetime类型会隐式转换为string后参与运算，其它类型报异常。
返回值： 
    以separator分隔的字符串。 
备注： 
    对语句SELECT wm_concat(‘,’,name) from table;若table为空集合，这条语句返回{NULL}。 
示例： 
SELECT deptno, wm_concat(‘阿里巴巴’,ename) AS employees
FROM   emp
GROUP BY deptno;

    DEPTNO EMPLOYEES
---------- --------------------------------------------------
        10 CLARK阿里巴巴KING阿里巴巴MILLER
        20 SMITH阿里巴巴FORD阿里巴巴ADAMS阿里巴巴SCOTT阿里巴巴JONES
        30 ALLEN阿里巴巴BLAKE阿里巴巴MARTIN阿里巴巴TURNER阿里巴巴JAMES阿里巴巴WARD
```

##### get_json_object

```
命令格式:
string get_json_object(string json,string path)
用途:
在一个标准json字符串中，按照path抽取指定的字符串参数说明:
json:String类型，标准的json格式字符串。
path:String类型，用于描述在json中的path，以$开头。
返回值：String类型
注解： 如果json为空或者非法的json格式，返回NULL 如果path为空或者不合法（json中不存在）返回NULL 如果json合法，path也存在则返回对应字符串
示例1
+----+
 json
+----+
{""store"":
   {""fruit"":[{""weight"":8,""type"":""apple""},{""weight"":9,""type"":""pear""}],
      ""bicycle"":{""price"":19.95,""color"":""red""}
   },
   ""email"":""amy@only_for_json_udf_test.net"",
   ""owner"":""amy""
 }
通过以下查询，可以提取json对象中的信息：
 odps> SELECT get_json_object(src_json.json, '$.owner') FROM src_json;
 amy
 odps> SELECT get_json_object(src_json.json, '$.store.fruit[0]') FROM src_json;
 {""weight"":8,""type"":""apple""}
 odps> SELECT get_json_object(src_json.json, '$.non_exist_key') FROM src_json;
 NULL
示例2
get_json_object('{""array"":[[aaaa,1111],[bbbb,2222],[cccc,3333]]}','$.array[1].[1]') = ""2222""
get_json_object('{""aaa"":""bbb"",""ccc"":{""ddd"":""eee"",""fff"":""ggg"",""hhh"":[""h0"",""h1"",""h2""]},""iii"":""jjj""}','$.ccc.hhh[*]') = ""[""h0"",""h1"",""h2""]""
get_json_object('{""aaa"":""bbb"",""ccc"":{""ddd"":""eee"",""fff"":""ggg"",""hhh"":[""h0"",""h1"",""h2""]},""iii"":""jjj""}','$.ccc.hhh[1]') = ""h1""
```

##### is_encoding

```
命令格式:
boolean is_encoding(string str, string from_encoding, string to_encoding)
用途:
通常的用法是将from_encoding设为’utf-8’，to_encoding设为’gbk’参数说明:
str：String类型，输入为NULL返回NULL。空字符串则可以被认为属于任何字符集。
from_encoding，to_encoding：String类型，源及目标字符集。输入为NULL返回NULL。
返回值：Boolean类型，如果str能够成功转换，则返回true，否则返回false。
示例：
    is_encoding('测试', 'utf-8', 'gbk') = true
    is_encoding('測試', 'utf-8', 'gbk') = true
    -- gbk字库中有这两个繁体字
    is_encoding('測試', 'utf-8', 'gb2312') = false
    -- gb2312库中不包括这两个字
```

##### parse_url

```
命令格式:
string parse_url(string url, string part[,string key])
用途:
对url的解析，按key提取信息参数说明:
url或part为NULL则返回NULL，url为无效抛异常。
part：String 类型，支持HOST, PATH, QUERY, REF, PROTOCOL, AUTHORITY, FILE, 和 USERINFO，不区分大小写，不在此范围抛异常
当part为QUERY时根据key的值取出在query string中的value值，否则忽略key参数。
返回值：String类型。
示例：
url = file://username:password@example.com:8042/over/there/index.dtb?type=animal&name=narwhal#nose
parse_url('url', 'HOST') = ""example.com""
parse_url('url', 'PATH') = ""/over/there/index.dtb""
parse_url('url', 'QUERY') = ""type=animal&name=narwhal""
parse_url('url', 'QUERY', 'name') = ""narwhal""
parse_url('url', 'REF') = ""nose""
parse_url('url', 'PROTOCOL') = ""file""
parse_url('url', 'AUTHORITY') = ""username:password@example.com:8042""
parse_url('url', 'FILE') = ""/over/there/index.dtb?type=animal&name=narwhal""
parse_url('url', 'USERINFO') = ""username:password""
```

##### regexp_count

```
命令格式:
bigint regexp_count(string source, string pattern[, bigint start_position])
用途:
计算source中从start_position开始，匹配指定模式pattern的子串的次数参数说明:
source：String类型，搜索的字符串，其它类型报异常。
pattern：String类型常量，要匹配的模型，pattern为空串时抛异常，其它类型报异常。
start_position：Bigint类型常量，必须大于0。其它类型或小于等于0时抛异常，不指定时默认为1，表示从source的第一个字符开始匹配。
返回值：Bigint类型。没有匹配时返回0。任一输入参数为NULL返回NULL。
示例：
    regexp_count('abababc', 'a.c') = 1
    regexp_count('abcde', '[[:alpha:]]{2}', 3) = 1
```

##### regexp_extract

```
命令格式:
string regexp_extract(string source, string pattern[, bigint occurrence])
用途:
将字符串source按照pattern正则表达式的规则拆分，返回第occurrence个group的字符参数说明:
source：String类型，待搜索的字符串。
pattern：String类型常量，pattern为空串时抛异常，pattern中如果没有指定group，抛异常。
occurrence：Bigint类型常量，必须>=0，其它类型或小于0时抛异常，不指定时默认为1，表示返回第一个group。若occurrence = 0，返回满足整个pattern的子串。
返回值：String类型，任一输入为NULL返回NULL。
示例：
    regexp_extract('foothebar', 'foo(.*?)(bar)', 1) = the
    regexp_extract('foothebar', 'foo(.*?)(bar)', 2) = bar
    regexp_extract('foothebar', 'foo(.*?)(bar)', 0) = foothebar
    regext_extract('8d99d8', '8d(\d+)d8') = 99
    -- 如果是在ODPS客户端上提交正则计算的SQL，需要使用两个""""作为转移字符
    regexp_extract('foothebar', 'foothebar')
    -- 异常返回，pattern中没有指定group
```

##### url_decode

```
命令格式:
string url_decode(string input[, string encoding])
用途:
将输入字符串从application/x-www-form-urlencoded MIME格式转为正常字符串，是url_encoding的逆过程参数说明:
* a-z, A-Z保持不变
* ”.”, “-”, “*”,”_”保持不变
* “+”转为空格
* %xy格式的序列转为对应的字节值，连续的字节值根据输入的encoding名称解成对应的字符串
* 其余的字符保持不变
* 函数最终的返回值是UTF-8编码的字符串
参数说明
* input：要输入的字符串。
* encoding：指定的编码格式，不输入默认UTF-8。
返回值：String类型。input为NULL时返回空。
示例：
url_decode('%E7%A4%BA%E4%BE%8Bfor+url_encode%3A%2F%2F+%28fdsf%29')= ""示例for url_encode:// (fdsf)"" url_decode('Exaple+for+url_encode+%3A%2F%2F+dsf%28fasfs%29', 'GBK') = ""Exaple for url_encode :// dsf(fasfs)"" ```
```

##### url_encode

```
命令格式:
string url_encode(string input[, string encoding])
用途:
将输入字符串编码为application/x-www-form-urlencoded MIME格式参数说明:

用途：，规范参考: http://zh.wikipedia.org/wiki/%E7%99%BE%E5%88%86%E5%8F%B7%E7%BC%96%E7%A0%81。
a-z, A-Z保持不变
”.”, “-”, “*”,”_”保持不变
空格转为”+”
其余字符根据指定的encoding转为字节值, encoding不输入默认UTF-8， 然后将每个字节值表示为%xy的格式, xy是该字符值的十六进制表示方式
参数说明：
input：要输入的字符串。
encoding：指定的编码格式，不输入默认UTF-8。
返回值：String类型。input为NULL时返回空。
示例：
url_encode('示例for url_encode:// (fdsf)') = ""%E7%A4%BA%E4%BE%8Bfor+url_encode%3A%2F%2F+%28fdsf%29""
url_encode('Exaple for url_encode :// dsf(fasfs)', 'GBK') = ""Exaple+for+url_encode+%3A%2F%2F+dsf%28fasfs%29""
```

#### 窗口函数

开窗数据范围

- 如果 ROWS BETWEEN..AND 沒有指明，默認為：RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW，即從最開始行到當前行
- 如果要选取所有行，需指定条件并去重：ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

##### dense_rank

```
命令格式： 
    dense_rank() over(partition by col_list1 order by col_list2)
用途：
    连续排名，1 2 3 4 5
参数说明:
●  col_list1: 指定开窗口的列
●  col_list2: 指定排名依据的值
返回值：
    BIGINT类型
```

##### rank

```
命令格式： 
    rank() over(partition by col_list1 order by col_list2)
用途：
    计算排名，1 2 2 4 5
参数说明:
●  col_list1: 指定开窗口的列
●  col_list2: 指定排名依据的值
返回值：
    BIGINT类型
```

##### percent_rank

```
命令格式:
percent_rank() over(partition by col1[, col2…]
        order by col1 [asc|desc][, col2[asc|desc]…])
用途:
计算一组数据中某行的相对排名参数说明:
partition by col1[, col2..]：指定开窗口的列。
order by col1 [asc|desc], col2[asc|desc]：指定排名依据的值。
返回值：Double类型，值域为[0, 1]，相对排名的计算方式为为：(rank-1)/(number of rows -1)。
备注:
目前限制单个窗口内的行数不超过10,000,000条。
```

##### row_number

```
命令格式： 
    row_number() over(partition by col_list1 order by col_list2)
用途：
    返回行号，从1开始
参数说明：
●  col_list1: 指定开窗口的列
●  col_list2: 指定结果返回时的排序的值
返回值：
    BIGINT类型
```

##### avg

```
命令格式:
avg([distinct] expr) over(partition by col1[, col2…]
    [order by col1 [asc|desc] [, col2[asc|desc]…]] [windowing_clause])
用途:
计算平均值参数说明:
distinct：当指定distinct关键字时表示取唯一值的平均值。
expr：Double类型，若输入为string，bigint会隐式转换到double类型后参与运算，其它类型抛异常。当值为NULL时，该行不参与计算。 Boolean类型不允许参与计算。
partition by col1[, col2]…：指定开窗口的列。
order by col1 [asc|desc], col2[asc|desc]：不指定order by时返回当前窗口内所有值的平均值，指定order by时返回结果以指定的方式排序， 并且返回窗口内从开始行到当前行的累计平均值。
返回值：Double类型。
备注:
windowing_clause部分可以用rows指定开窗方式，有两种方式：
rows between x preceding|following and y preceding|following表示窗口范围是从前或后x行到前或后y行。
rows x preceding|following窗口范围是从前或后第x行到当前行。
x，y必须为大于等于0的整数常量，限定范围0 ~ 10000，值为0时表示当前行。必须指定order by才可以用rows方式指定窗口范围
指明distinct关键字时不能写order by。
```

##### count

```
命令格式： 
    count([distinct] expr) over(partition by col_list1 [order by col_list2] [windowing_clause])
用途：
    计数值
参数说明：
●  distinct: 当指定distinct关键字时表示取唯一值的计数值。
●  expr: 任意类型，当value值为NULL时，该行不参与计算。
●  col_list1: 指定开窗口的列
●  col_list2: 不指定order by时，返回当前窗口内expr的计数值，指定order by 时返回结果以col_list2指定的顺序排序，并且值为当前窗口内从开始行到当前行的累计计数值。
返回值：
    BIGINT类型
注：
    当指定distinct关键字时不能写order by。dfgfdsg
```

##### sum

```
命令格式： 
    sum( [distinct] expr) over(partition by col_list1 [order by col_list2] [windowing_clause])
用途：
    计算汇总值
参数说明：
●  distinct:指定distinct关键字时表示计算唯一值的汇总值
●  expr: double类型，当输入为string, bigint时隐式转换为double参与运算，其它类型报异常。当value值为NULL时，该行不参与计算。
●  col_list1: 指定开窗口的列
●  col_list2: 不指定order by时，返回当前窗口内expr的汇总值。指定order by时，返回结果以col_list2指定的方式排序，并且返回当前窗口从首行至当前行的累计汇总值。
返回值：double类型
注：
    当指定distinct时不能用order by。
```

##### lag

```
命令格式：
    lag( expr, offset, default) over(partition by col_list1 order by col_list2)
用途：
    按偏移量取当前行之前第几行的值，如当前行号为rn，则取行号为rn-offset的值
参数说明：
●  expr: 任意类型。
●  offset: bigint类型常量, 输入为string, double到bigint的隐式转换, offset>0。
●  default: 当offset指定的范围越界时的缺省值，常量。
●  col_list1: 指定开窗口的列
●  col_list2: 指定返回结果的排序方式
返回值：
    同expr类型
```

##### lead

```
命令格式：
    lead( expr, offset, default) over(partition by col_list1 order by col_list2)
用途：
    按偏移量取当前行之后第几行的值, 如当前行号为rn则取行号为rn+offset的值
参数说明：
●  expr: 任意类型。
●  offset: bigint类型常量, 输入为string, double到bigint的隐式转换, offset>0。
●  default: 当offset指一的范围越界时的缺省值，常量。
●  col_list1: 指定开窗口的列
●  col_list2: 指定返回结果的排序方式
返回值：
    同expr类型
```

##### cluster_sample

```
命令格式:
boolean cluster_sample(bigint x[, bigint y])
        over(partition by col1[, col2..])
用途:
分组抽样参数说明:
x：Bigint类型常量，x>=1。若指定参数y，x表示将一个窗口分为x份；否则，x表示在一个窗口中抽取x行记录(即有x行返回值为true)。x为NULL时，返回值为NULL。
y：Bigint类型常量，y>=1，y<=x。表示从一个窗口分的x份中抽取y份记录(即y份记录返回值为true)。y为NULL时，返回值为NULL。
partition by col1[, col2]：指定开窗口的列。
返回值：Boolean类型。
示例，如表test_tbl中有key，value两列，key为分组字段，值有groupa，groupb两组，value为值，如下
    +------------+--------------------+
    | key        | value              |
    +------------+--------------------+
    | groupa     | -1.34764165478145  |
    | groupa     | 0.740212609046718  |
    | groupa     | 0.167537127858695  |
    | groupa     | 0.630314566185241  |
    | groupa     | 0.0112401388646925 |
    | groupa     | 0.199165745875297  |
    | groupa     | -0.320543343353587 |
    | groupa     | -0.273930924365012 |
    | groupa     | 0.386177958942063  |
    | groupa     | -1.09209976687047  |
    | groupb     | -1.10847690938643  |
    | groupb     | -0.725703978381499 |
    | groupb     | 1.05064697475759   |
    | groupb     | 0.135751224393789  |
    | groupb     | 2.13313102040396   |
    | groupb     | -1.11828960785008  |
    | groupb     | -0.849235511508911 |
    | groupb     | 1.27913806620453   |
    | groupb     | -0.330817716670401 |
    | groupb     | -0.300156896191195 |
    | groupb     | 2.4704244205196    |
    | groupb     | -1.28051882084434  |
    +------------+--------------------+
想要从每组中抽取约10%的值，可以用以下ODPS SQL完成：
    select key, value
    from (
        select key, value, cluster_sample(10, 1) over(partition by key) as flag
        from tbl
        ) sub
    where flag = true;
    +--------+--------------------+
    | key    | value              |
    +--------+--------------------+
    | groupa | -1.34764165478145  |
    | groupb | -0.725703978381499 |
    | groupb | 2.4704244205196    |
    +-----+-----------------------+
```

#### 数学函数

##### conv

```
命令格式： 
    string conv(string input, bigint from_base,       bigint to_base)
用途： 
    进制转换函数
参数说明： 
●  input: 以string表示的要转换的整数值，接受bigint, double的隐式转换。
●  from_base,to_base，以十进制表示的进制的值，可接受的的值为2,8,10,16。接受string,double的隐式转换。
●  转换过程以64位精度工作，溢出时报异常。
●  输入如果是负值，即以’-‘开头，报异常。
返回值： 
    string类型。任一输入为NULL，返回NULL。
注：如果输入的是小数，则会转为整数值后进行进制转换，小数部分会被舍弃。
```

##### rand

```
命令格式： 
    double rand(seed)
用途： 
    返回double类型的随机数，返回值区间是的0～1.
参数说明：
●  seed:bigint类型， 随机数种子， 决定随机数序列的起始值。
```

##### trunc

```
命令格式：
    trunc(number[, decimal_places])
用途：
    将输入值截取到指定小数点位置。 
参数说明： 
●  number:double类型，若输入为string类型或bigint类型会隐式转换到double类型后参与运算，其他类型抛异常。
●  decimal_places: bigint类型常量，要截取到的小数点位置，其他类型参数会引发异常，省略此参数时默认到截取到个位数。 
返回值： 
    返回值类型为double。若number或decimal_places为NULL，返回NULL。 
备注： 
●  truncate掉的部分补0。 
●  decimal_places可以是负数，负数会从小数点往左开始truncate，并且不保留小数部分；如果decimal_places超过了整数部分长度，返回0. 
示例： 
●  trunc(125.815) 返回 125 
●  trunc(125.815, 0) 返回125 
●  trunc(125.815, 1) 返回 125.8 
●  trunc(125.815, 2) 返回 125.81 
●  trunc(125.815, 3) 返回 125.815 
●  trunc(-125.815, 2) 返回 -125.81 
●  trunc(125.815, -1) 返回 120 
●  trunc(125.815, -2) 返回 100 
●  trunc(125.815, -3) 返回 0 
```

##### round

```
命令格式： 
    round(number, [decimal_places])
用途： 
    四舍五入到指定小数点位置。 
参数说明： 
●  number: double类型，若输入为string类型或bigint类型会隐式转换到double类型后参与运算，其他类型抛异常。 
●  decimal_place: bigint类型常量，四舍五入计算到小数点后的位置，其他类型参数会引发异常. 如果省略表示四舍五入到个位数。 
返回值： 
    返回四舍五入的结果, double类型。若number或decimal_places为NULL，返回NULL。 
备注： 
●  decimal_places可以是负数。负数会从小数点往左开始round，并且不保留小数部分；如果decimal_places超过了整数部分长度，返回0. 
示例： 
●  round(125.315) 返回 125 
●  round(125.315, 0) 返回125 
●  round(125.315, 1) 返回 125.3 
●  round(125.315, 2) 返回 125.32
●  round(125.315, 3) 返回 125.315 
●  round(-125.315, 2) 返回 -125.32
●  round(null) 返回null
```

##### floor

```
命令格式： 
    bigint floor(double number)
用途： 
    向下取整，返回比number小的整数值。
参数说明： 
●  number: double类型，若输入为string类型或bigint型会隐式转换到double类型后参与运算，其他类型抛异常
返回值： 
    返回向下取整的结果, bigint类型。若number为NULL，返回NULL。 
示例： 
●  floor(1.2)=1
●  floor(1.9)=1
●  floor(0.1)=0
●  floor(-1.2)=-2
●  floor(-0.1)=-1
●  floor(0.0)=0
●  floor(-0.0)=0
```

##### ceil

```
命令格式:
bigint ceil(double value)
bigint ceil(decimal value)
用途:
返回不小于输入值value的最小整数参数说明:
value：Double类型或Decimal类型，若输入为string类型或bigint类型会隐式转换到double类型后参与运算，其他类型抛异常。
返回值：Bigint类型。任一输入为NULL，返回NULL。
示例：
    ceil(1.1) = 2
    ceil(-1.1) = -1
```

#### 其他函数

##### coalesce

```
命令格式： 
    coalesce(expr1, expr2,...)
用途： 
    返回列表中第一个非null的值，如果列表中所有的值都是null则返回null。
参数说明： 
●  expri是要测试的值。所有这些值类型必须相同或为NULL，否则会引发异常。 
返回值： 
    返回值类型和参数类型相同。 
备注： 
    参数至少要有一个，否则引发异常。
```

##### decode

```
命令格式：
    decode(expression, search, result[, search, result]...[, default])
用途： 
    实现IF-THEN-ELSE分支选择的功能。
参数说明： 
●  Expression: 要比较的表达式. 
●  Search: 和expression进行比较的搜索项。. 
●  Result:search和expression的值匹配时的返回值. 
●  Default:可选项，如果所有的搜索项都不匹配，则返回此default值，如果未指定，则会返回null。 
返回值： 
    返回匹配的search；如果没有匹配，返回default；如果没有指定default，返回NULL。 
备注： 
●  至少要指定三个参数。 
●  所有的result类型必须一致，或为NULL。不一致的数据类型会引发异常。所有的search和expression类型必须一致，否则报异常。 
●  如果decode中的search选项有重复时且匹配时，会返回第一个值。
示例： 
 SELECT supplier_name, decode(supplier_id, 10000, 'IBM', 10001, 'Microsoft', 10002, 'Hewlett  ackard', 'Gateway') result FROM suppliers;
上面的decode函数实现了下面IF-THEN-ELSE语句中的功能
  IF supplier_id = 10000 THEN
    result := 'IBM';
  ELSIF supplier_id = 10001 THEN
    result := 'Microsoft';
  ELSIF supplier_id = 10002 THEN
    result := 'Hewlett Packard';
  ELSE
    result := 'Gateway';
  END IF;
```

##### greatest

```
命令格式： 
    greatest(var1,var2…)
用途： 
    返回输入参数中最大的一个
参数说明：
●  var1,var2可以为bigint,double,datetime,string。
●  null为最小
●  当输入参数类型不同时，double,bigint,string之间的比较转为double; string,datetime的比较转为datetime。
不允许其它的隐式转换。
返回值： 
    输入参数中的最大值，当不存在隐式转换时返回同输入参数类型。
    有隐式转换时，double,bigint,string之间的转换返回double。
    string,datetime之间的转换返回datetime
```

##### least

```
命令格式： 
    least(var1,var2…)
用途： 
    返回输入参数中最小的一个
参数说明：
●  var1,var2可以为bigint,double,datetime,string。
●  null为最小
●  当输入参数类型不同时，double,bigint,string之间的比较转为double, string,datetime的比较转为datetime
不允许其它的隐式转换
返回值： 
    输入参数中的最小值，当不存在隐式转换时返回同输入参数类型。
    有隐式转换时，double,bigint,string之间的转换返回double。
    string,datetime之间的转换返回datetime
```

##### ordinal

```
命令格式： 
    ordinal(bigint nth, var1,var2…)
用途： 
    将输入变量按从小到大排序后，返回nth指定的位置的值
参数说明
●  nth: bigint类型, 指定要返回的位置
●  var1,var2，类型可以为bigint,double,datetime,string。
●  null为最小
●  当输入参数类型不同时，double,bigint,string之间的比较转为double; string,datetime的比较转为datetime
不允许其它的隐式转换
返回值： 
    排在第nth位的值，当不存在隐式转换时返回同输入参数类型。
有隐式转换时，double,bigint,string之间的转换返回double。
string,datetime之间的转换返回datetim
例：
ordinal(3,1,2,2,3,4,5,6) 返回2
```

##### option_bit

```
使用命令：
    option_bit(value, path)
参数类型：
    Value: string。如果value为NULL，返回“0”
    Path: string
返回类型：
    string
功能描述：
   返回一个string类型的“数字”，假设该数字为returnvalue，returnvalue由下列原则确定：
1. 如果value含有字符串”vip”, returnvalue = 1；
2. 在原则1的基础上，如果value含有字符串“ppay”:
   a) 如果returnvalue!= 0， returnvalue按位或 64，此结果作为returnvalue新的值；
   b) 否则returnvalue=64；
3. 在原则2的基础上，如果value含有字符串“suitSeller”:
   a) 如果returnvalue!= 0， returnvalue按位或16384，此结果作为returnvalue新的值；
   b) 否则returnvalue=16384;
4. 在原则3的基础上，如果value含有字符串“suitBuyer”:
   a) 如果returnvalue!= 0， returnvalue按位或32768，此结果作为returnvalue新的值；
   b) 否则returnvalue=32768;
5. 在原则4的基础上，如果value含有字符串“wap”:
   a) 如果returnvalue!= 0， returnvalue按位或262144，此结果作为returnvalue新的值；
   b) 否则returnvalue=262144;
6. 在原则5的基础上，如果value含有字符串“fbuy:1”:
   a) 如果returnvalue!= 0， returnvalue按位或524288，此结果作为returnvalue新的值；
   b) 否则returnvalue=524288;
7. 在原则6的基础上，如果 path不为NULL并且不是空串：
   a) 如果returnvalue!= 0， returnvalue按位或131072，此结果作为returnvalue新的值；
   b) 否则returnvalue=131072;
备注：
    此函数是应阿里金融的要求依照淘宝的hive的业务逻辑实现的，我们无法保证在淘宝的hive中此函数的行为发生变化时DE中的函数行为会随之发生同样的变化。如果你在使用中发现此函数的行为不满足你的要求，请联系产品经理张云远。
```

##### trans_cols 

```
命令格式：
    trans_cols (num_keys, key1,key2,…,col1, col2,col3) as (idx, key1,key2,…,col1, col2)
用途：
    用于将一行数据转为多行的UDTF，将不同的列转为行。
参数说明：
    num_keys: bigint类型常量，必须>=0。在转为多行时作为转置key的列的个数。
Key是指在将一行转为多行时，在多行中重复的列,如要将A,B,C,D转为
A,B,C
A,B,D
则A,B列为key
keys: 转置时作为key的列，由num_keys决定哪些列作为key。
cols: 要转为行的列，类型必须相同。
返回：
    转置后新的列名由as指定。输出的第一列是转置的下标，下标从1开始。
作为key的列类型保持不变，其余所有的列与原来类型一致。如果num_keys指定所有的列都作为key（即num_keys等于所有列的个数），则只返回一行。
注：
    UDTF使用上有一些限制
●  所有作为key的列必须处在前面，而要转置的列必须放在后面。
●  在一个select中只能有一个udtf，不可以再出现其它的列，如不可以写成
Select login_id, trans_cols(1, login_id, login_ip1, login_ip2) as(idx, login_id, login_ip)
●  不可以与roup by/cluster by/distribute by/sort by一起使用。
例，表中的数据如
Login_id     Login_ip1      Login_ip2
wangwangA    192.168.0.1    192.168.0.2
则 trans_cols(1, login_id, login_ip1, login_ip2) as (idx, login_id, login_ip)的输出为:
idx    Login_id     Login_ip
1      wangwangA    192.168.0.1
2      wangwangA    192.168.0.2
```

##### trans_array 

```
命令格式：
    trans_array (num_keys, separator, key1,key2,…,col1, col2,col3) as (key1,key2,…,col1, col2)
用途：
    用于将一行数据转为多行的UDTF，将列中存储的以固定分隔符格式分隔的数组转为多行。
参数说明：
●  num_keys: bigint类型常量，必须>=0。在转为多行时作为转置key的列的个数。
Key是指在将一行转为多行时，在多行中重复的列。
●  separator:string类型常量，用于将字符串拆分成多个元素的分隔符。为空时报异常。
●  keys:转置时作为key的列， 个数由num_keys指定。如果num_keys指定所有的列都作为key（即num_keys等于所有列的个数），则只返回一行。
●  cols: 要转为行的数组，keys之后的所有列视为要转置的数组，必须为string类型，存储的内容是字符串格式的数组，如“Hangzhou;Beijing;shanghai”，是以”;”分隔的数组。
返回：
    转置后的行，新的列名由as指定。作为key的列类型保持不变，其余所有的列是string类型。拆分成的行数以个数多的数组为准，不足的补NULL。
注：
    UDTF使用上有一些限制
●  所有作为key的列必须处在前面，而要转置的列必须放在后面。
●  在一个select中只能有一个udtf，不可以再出现其它的列
●  不可以与group by/cluster by/distribute by/sort by一起使用。
例，表中的数据如
Login_id      LOGIN_IP                     LOGIN_TIME
wangwangA     192.168.0.1,192.168.0.2      20120101010000,20120102010000

则trans_array(1, “,”, login_id, login_ip, login_time) as (login_id,login_ip,login_time)
产生的数据是
Login_id      Login_ip        Login_time
wangwangA     192.168.0.1     20120101010000
wangwangA     192.168.0.2     20120102010000

如果表中的数据是
Login_id    LOGIN_IP                     LOGIN_TIME
wangwangA   192.168.0.1,192.168.0.2      20120101010000

则对数组中不足的数据补NULL
Login_id     Login_ip        Login_time
wangwangA    192.168.0.1     20120101010000
wangwangA    192.168.0.2     NULL
```

##### unique_id

```
uuid命令格式：
    string unique_id()
用途：
    返回一个随机的唯一id，形式示例：“29347a88-1e57-41ae-bb68-a9edbdd94212_1”，相对于uuid运行效率比较高。
```

##### uuid

```
uuid命令格式：
    string uuid()
用途：
    返回一个随机的唯一id，形式示例：“29347a88-1e57-41ae-bb68-a9edbdd94212”。
```











