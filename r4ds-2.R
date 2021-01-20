library(tidyverse)
library(nycflights13)
install.packages("egg")
library(dplyr)
library(egg)
data(flights)
flights
#filter() : 행 추출
# dep_time : 출발 시간, arr_time : 도착 시간, carrier : 화사 이름, tailnum : 비행기 꼬리 번호, origin : 소속된 공항, dest : 목적지, air_time : 떠있는 시간

jan <- flights %>% 
  filter(flights$month == 1, flights$day == 1)

dec25 <- flights %>% 
  filter(flights$month == 12, flights$day == 25)

ggjan1 <- ggplot(jan, aes(x = dep_delay)) +
  geom_histogram()

ggdec25 <- ggplot(dec25, aes(x = dep_delay)) +
  geom_histogram()

april1 <- flights %>% 
  filter(flights$month == 4, flights$day == 1)

ggapril1 <- ggplot(april1, aes(x = dep_delay)) +
  geom_histogram()

# ggarrange() : 그래프를 한꺼번에 그려줌
ggarrange(ggjan1, ggdec25, ggapril1)

ggjan_a <- ggplot(jan, aes(x = arr_delay)) +
  geom_histogram()

ggdec_a <- ggplot(dec25, aes(x = arr_delay)) + 
  geom_histogram()

ggapril_a <- ggplot(april1, aes(x = arr_delay)) +
  geom_histogram()

ggarrange(ggjan_a, ggdec_a, ggapril_a)

# 이상치는 평균값에 영향을 많이 받음으로 중앙값을 많이 사용함.
# 1, 4, 12월달 추출
jad <- flights %>% 
  filter(flights$month == 1 | flights$month == 4 | flights$month == 12)

# 도착 지연시간이 120보다 작거나 같은 기준으로 추출
flights %>% 
  filter(flights$arr_delay <= 120)

# 2시간 이상 지연 도착했지만, 지연 출발하지는 않음.
flights %>% 
  filter(arr_delay >= 120, dep_delay <= 0)

# 지연 도착시간을 내림차순으로 정렬
flights %>% 
  arrange(-arr_delay)

# 지연 도착시간과 출발 시간을 내림차순으로 정렬
flights %>% 
  arrange(-arr_delay, -dep_delay)

# select() : 열 추출
# 년, 월, 일만 추출
flights %>% 
  select(year, month, day)

flights %>% 
  select(year : day)

flights %>% 
  select(-distance : - time_hour)

# select를 이용한 이름 바꾸기
flights %>% 
  select(chulbalsigan = dep_time,
         yesangsigan = sched_dep_time)

# 내가 보고싶은것만 맨 앞으로 나머지는 그대로
flights %>% 
  select(dest, everything()) # everything(): 나머지 전부 보여줌

flights %>% 
  select(dest:air_time, everything())

# ends_with("xzy") : xzy로 끝나는 이름에 매칭
flights %>% 
  select(ends_with("delay"))

# starts_with("abc") : abc로 시작되는 이름에 매칭
flights %>% 
  select(starts_with("arr"))

# sched의 단어로 시작되는 변수 추출
flights %>% 
  select(starts_with("sched"))


# mutate() : 변수를 만드는것
flights_sml <- select(flights,
                      year : day,
                      ends_with("delay"),
                      distance,
                      air_time)

flights_sml %>% 
  mutate(gain = arr_delay - dep_delay,
         speed = distance / air_time * 60)

# air_time와 arr_time(도착) - dep_time(출발)을 비교하라.
flights %>% 
  mutate(air_time2 = arr_time - dep_time) %>% 
  select(air_time, air_time2)
# 이유 : dep_time 과 arr_time은 활주로에 있는 시간까지 포함하기 때문이다.

# 조건문 사용하기
flights_sml %>% 
  mutate(ind = arr_delay > dep_delay) %>% 
  filter(ind)

flights_sml %>% 
  filter(arr_delay > dep_delay)
#filter는 TRUE 값만 남긴다

# FALSE만 추릴때 !를 사용한다.
flights_sml %>% 
  mutate(ind = arr_delay > dep_delay) %>% 
  filter(!ind)

flights_sml %>% 
  filter(!(arr_delay > dep_delay))

## 자율 연습
#3.2.4
# 1-a.
flights %>% 
  filter(arr_delay >= 120)
# 1-b.
flights %>% 
  filter(dest == "IAH" | dest == "HOU")
# 1-c.
flights %>% 
  filter(carrier == "AA" | carrier == "UA" | carrier == "DL")
# 1-d.
flights %>%
  filter(month == 7 | month == 8 | month == 9)
# 1-f.
flights %>% 
  filter(dep_delay >= 60, dep_delay - arr_delay > 30)
# 1-g.
flights %>% 
  filter(600 <= dep_time | dep_time == 2400)

# 2.
# between() 는 구간을 조회하는 함수이다.

# 3.
table(is.na(flights$dep_time))
#8255개의 결측값을 가지고 있다.

# 4.
NA ^ 0
NA | TRUE
FALSE & NA
# NA를 하나의 값으로 취급하기 떄문에.

# 3.3.1
# 1.
flights %>% 
  arrange(!is.na(dep_time))

# 2.
# 가장 지연된 항공편
flights %>% 
  arrange(desc(dep_delay))
# 가장 일찍 출발한 항공편
flights %>% 
  arrange(dep_delay)

# 3.
flights %>% 
  arrange(air_time)

# 4.
flights %>% 
  select(distance, carrier) %>% 
  arrange(desc(distance))
# 가장 멀리 운항한 항공편은 HA이다.
flights %>% 
  select(distance, carrier) %>% 
  arrange(distance)
# 가장 짧게 운항한 항공편은 US이다.

# 3.4.1
# 1.
flights %>% 
  select(dep_time,dep_delay, arr_time, arr_delay)
flights %>% 
  select(starts_with("dep_"), starts_with("arr_"))
flights %>% 
  select(ends_with("_delay"), ends_with("_time"))

# 2.
flights %>% 
  select(dep_time, dep_time, arr_time)
# 반복하여도 한번만 나온다.

# 3.
# all of() : 모두 조건이 동일해야 TRUE
# any of() : 하나라도 만족하면 TRUE

# 4.
select(flights, contains("TIME"))
# time 이라는 문자가 포함된 변수를 추출한다.

#3.5.2
# 1. 
flights_times <- mutate(flights,dep_time_mins = (dep_time %/% 100 * 60 + dep_time %% 100) %% 
1440, sched_dep_time_mins = (sched_dep_time %/% 100 * 60 + sched_dep_time %% 100) %% 1440)

# 3.
# dep_time에서 sched_dep_time 을 빼면 dep_delay의 시간이 나온다.

# 4.


# 5.
# 1:3 과 1:10은 배수차이가 아니기때문에 값이 나오지 않는다.

# 6.

# 3.6.7
# 1.

# 2.
flights %>% 
  group_by(dest) %>% 
  summarise(n = n())

# 3.
# 출발하지 않으면 도착도 하지 않기 때문에 가장 중요한 열은 arr_delay이다.

# 4.
cancelled_flights <- flights %>% 
  mutate(cancelled = is.na(arr_delay), is.na(dep_delay)) %>% 
  group_by(year, month, day) %>% 
  summarise(cancelled_num = sum(cancelled),
            flights_num = n())
