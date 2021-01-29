library(tidyverse)

## 티블
iris
str(iris)  # str : 파일 형태 확인
#as.character() : 변수를 문자로 변경해주는것
#as.numeric() : 숫자로 변경

as_tibble(iris) 
# as_tibble : 있는 데이터셋을 tibble로 바꿔 준다.

data.frame(x = 1:5,
           y = 1,
           z = x^2 + y)   # data.frame은 없는 변수를 호출할수 없다.

tibble(x = 1:5,
       y = 1,
       z = x^2 + y)  

tb <- tibble(
  `:)` = "smile",
  ` ` = "space",
  `2000` = "number"
)

tb

data.frame(`:)` = "smile",
           ` ` = "space",
           `2000` = "number")  # 공백처리X

tribble(
  ~x, ~y, ~z,
  "a", 2, 3.6,
  "b", 1, 8.5
)

iris %>% 
  mutate(seq = 1:nrow(iris)) %>% 
  as_tibble()

tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)  

library(nycflights13)
flights %>% 
  print(n = 15, width = Inf)

## 7.4.1연습문제
# 1.
mtcars
as_tibble(mtcars)

# 2.
df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

# 변수의 값만
flights %>% 
  .$year

flights %>% 
  .[["year"]]

# 변수자체
flights %>% 
  .["year"]

flights %>% 
  select(year)

# 3.
mtcars <- as_tibble(mtcars)
mtcars

var <- "mpg"
mtcars[var]
vars <- c("mpg", "cyl")
mtcars[1:5, vars]

# 4.
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` *2 +rnorm(length(`1`))
)

# a.
annoying[1]
annoying %>% 
  select(`1`)

annoying$`1`
annoying[[1]]

# b.
ggplot(annoying) +
  geom_point(aes(x = `1`,
                 y = `2`))

# c.
annoying %>% 
  mutate(`3` = `2` / `1`) -> annoying2

# d.
annoying2 %>% 
  rename(one = `1`,
         two = `2`,
         three = `3`)

# 5.
?enframe
# 이름있는 벡터, 또는 리스트를 티블형태로 변경해준다.
enframe(1:3)
enframe(c(a = 5, b = 7))

# deframe : 다시 데이터프레임으로 변경해준다.
deframe(tibble(a = 1:3))
deframe(tibble(a = as.list(1:3)))

##readr로 데이터 불러오기
read_csv("a,b,c
         1,2,3
         4,5,6")

read_csv("The first line of metadata
         The second line of metadata
         x,y,z
         1,2,3", skip = 2)

read_csv("# A comment I want to skip
         x,y,z
         1,2,3", comment = "#")

read_csv("1,2,3\n4,5,6",
         col_names = FALSE)

read_csv("1,2,3\n4,5,6",
         col_names = c("x","y","z"))

# 결측 처리
read_csv("a,b,c\n1,2.", na = ".")

## 8.2.2 연습문제
# 1.
read_delim("a|b|c\n1|2|.", delim = "|",
           na = ".")
# delim을 이용하여 |로 분리된 파일을 읽을수 있다.

# 2.
# file, col_names, col_types, Locale, na, quoted_na, na, quote, comment, trim_ws, skip, n_max, guess_max, progress, skip_empty_rows

# 3.
# read_fwf는 모든 필드가 모든 행에서 동일한 위치에 있기 때문에 데이터 열이 어디서 시작되고 끝나는지 알려주는 col_positions가 제일 중요한 인수라고 생각한다.

# 4.
x <- "x,y\n,'a,b'"
read_csv(x, quote = "'") # quote : 행 이름에 "" 생략.
# 5.
read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b,c\n,1,2\n1,2,3,4")
read_csv("a,b\n\"1")

## 백터 파싱하기

# parse = as
str(as.logical(c("TRUE", "FALSE", "NA")))

str(parse_logical(c("TRUE", "FALSE", "NA")))   

str(parse_integer(c("1","2","3")))

as.Date(c("2010-01-01", "1979-10-14"), format = "%Y-%m-%d")

parse_date(c("2010-01-01", "1979-10-14"))

str(parse_date(c("2010-01-01", "1979-10-14")))

tb2 <- tibble(logi = c("TRUE", "FALSE", "NA"),
              inte = c("1", "2", "3"),
              datk = c("2010-01-01", "1979-10-14",
                       "2021-01-29"))
tb2 %>%
  mutate(logi = parse_logical(logi),
         inte = parse_integer(inte),
         datk = parse_date(datk))

tb2 %>%
  mutate(logi = as.logical(logi),
         inte = as.integer(inte),
         datk = as.Date(datk, format = "%Y-%m-%d"))

# 숫자 파싱하기
parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ","))

parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")

# 문자열
charToRaw("Hadley")

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "shift-JIS"))

# 팩터형
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)

# 데이트형, 데이트-타임형, 타임형
parse_datetime("2010-10-01T2010")
parse_datetime("20101010")

# parse_date() : 네 자리 연도 또는 /, 월 또는 /, 날짜
parse_date("2010-10-01")

# parse_time() : 시, ", 분 또는 :, 초 또는 a.m/p.m
library(hms)
parse_time("01:10 am")
parse_time("20:10:01")

# 연 : %Y(4자리) , %y(2자리, 00-69 -> 2000-2069)
# 월 : %m(2자리) , %b("Jan"), %B("January)
# 일 : %d(2자리) , %e(선택적 선행 공백)
# 시간 : %H(0-23시간 형식), %I(0-12, %P와 함께), %p(a.m/p.m), %M(분), %S(정수 초), %OS(실수 초), %Z(시간대), %z(UTC와의 오프셋)
# 숫자가 아닌 문자 : %.(숫자가 아닌 문자를 하나를 건너뛴다.) , %*(숫자가 아닌 문자 모두를 건너 뛴다.)

parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")
parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

## 8.3.5 연습문제
# 1.
# 날짜 및 시간 형식 : date_names, date_format, time_format
# 시간대 : tz
# 숫자 : decimal_mark, grouping_mark
# 부호화 : encoding

# 2.
# decimal_mark와 grouping_mark 동일시 : 오류가 발생함
# decimal_mark를 ","로 설정하면 grouping_mark의 기본값 : "."
# grouping_mark를 "."로 설정하면 decimal_mark의 기본값 : ","

# 3.
parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

# 4.
parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")

# 5.
# read_csv : 쉼표로 구분된 파일 읽기
# read_csv2 : 세미콜론으로 구분된 파일 읽기(,가 소숫점 자리로 사용되는 국가에 일반적 형태)

# 6.
# 유럽 : ISO-8859-1
# 아시아(일본어) : shift-JIS

# 7.
d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015")
d5 <- "12/30/14" # Dec 30, 2014
t1 <- "1705"
t2 <- "11:15:10.12 PM"

parse_date(d1, "%B %d, %Y")
parse_date(d2, "%Y-%b-%d")
parse_date(d3, "%d-%b-%Y")
parse_date(d4, "%B %d (%Y)")
parse_date(d5, "%m/%d/%y")
parse_time(t1, "%H%M")
parse_time(t2, "%H:%M:%OS %p")

## 파일 파싱하기
guess_parser("2010-10-01")
guess_parser("15:01")
guess_parser(c("TRUE", "FALSE"))
guess_parser(c("1", "5", "9"))
guess_parser(c("12,352,561"))
str(guess_parser("2010-10-10"))
# 논리형 : "F", "T", 'FALSE', 'TRUE'
# 정수형 : 수치형 문자
# 더블형 : 4.5e-5와 같은 숫자를 포함하는 더블형만 포함
# 수치형 : 내부에 그룹화 마크가 있는 유효한 더블형
# 타임형 : time_format과 일치
# 데이트형 : date_format과 일치
# 데이트-타임형 : ISO 8601 날짜

# 문제점
