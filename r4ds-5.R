#### 9(12)장 : tidyr로 하는 타이디 데이터
library(tidyverse)
### tidy 데이터
# 각 데이터셋은 네 개의 변수, country(국가), year(연도), population(인구), cases(사례 수)의 값을 동일하게 보여주지만 다른 방식으로 구성되어있다.
table1
table2
table3
# 티블 두 개로 펼처짐
table4a # 사례수
table4b # 인구

## 데이터셋을 타이디하게 만드는, 서로 연관된 세 가지 규칙
# 1. 변수마다 해당되는 열이 있어야 한다.
# 2. 관측값마다 해당되는 행이 있어야 한다.
# 3. 값마다 해당하는 하나의 셀이 있어야 한다.

## tidy의 장점
# 1. 일관된 데이터 구조를 사용하면 이에 적용할 도구들이 공통성을 가지게 되어, 이들을 배우기가 더 쉬워진다.
# 2. 변수를 열에 배치하면 R의 백터화 속성이 가장 잘 발휘할 수 있다.

## table1을 사용하여 작업하는 몇가지 예제
# 10,000명 당 비율 계산
table1 %>% 
  mutate(rate = cases / population * 10000)
# 연간 사례 수 계산
table1 %>% 
  count(year, wt = cases)
# 시간에 따른 변화 시각화
library(ggplot2)
ggplot(table1, aes(x = year,
                   y = cases)) +
  geom_line(aes(group = country),
            color = "grey50") +
  geom_point(aes(color = country))

## 피봇하기
## 대부분의 데이터는 tidy하지 않는 이유
# 1. 대부분의 사람들은 tidy 데이터의 원리에 익숙하지 않으며, 데이터 작업에 많은 시간을 써야만 tidy 데이터로 만들 수 있다.
# 2. 데이터 분석보다는 다른 용도에 편리하도록 구성되는 경우가 많기 때문이다.

## 더 길게 만들기
table4a
# 열 이름 1999와 2000은 year 변수 값을 나타내며, 각 행은 하나가 아닌 두개의 관측값을 나타낸다.
# table4a의 데이터셋을 tidy하게 만들려면 해당 열을 새로운 두 변수로 pivot해야 한다.
table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")

# table4a와 table4b의 tidy하게 된 버전을 하나의 티블로 결합하려면 dplyr::left_join()을 사용한다.
tidy4a <- table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")
tidy4b <- table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")
left_join(tidy4a, tidy4b)

## 더 넓게 만들기
# pivoy_longer()의 반대, 관측값이 여러 행에 흩어져 있을 떄 사용
table2
table2 %>% 
  pivot_wider(names_from = type, values_from = count)

### Separate와 Unite
## sepqrate()로 분리하기
# separate()는 구분 문자가 나타는 곳마다 쪼개서 한의 열을 여러 열로 분리한다.
table3
table3 %>% 
  separate(rate, into = c("cases", "population"))

# separate()는 숫자나 글자가 아닌 문자를 볼 때마다 값을 쪼갠다. 특정 문자를 사용하여 열을 구분하려면 이를 separate()의 sep 인수로 전달하면 된다.
table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")
table3 %>% 
  separate(
    rate,
    into = c("cases", "population"),
    convert = TRUE
  )
table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)

## unite()로 결합하기
# unite()는 separate()의 반대, 여러 열을 하나의 열로 결합한다.
table5
table5 %>% 
  unite(new, century, year)
# 분리기호(_)를 원하지 않을 경우 sep = ""를 사용
table5 %>% 
  unite(new, century, year, sep = "")

### 결측값
# 명시적으로, 즉 NA로 표시된다.
# 암묵적으로, 즉 단순히 데이터에 존재하지 않는다.
stocks <- tibble(year = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
                 qtr = c(1, 2, 3, 4, 2, 3, 4),
                 return = c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66))
stocks %>% 
  pivot_wider(names_from = year, values_from = return)
# values_drop_na = TRUE : 명시적 결측값을 암묵적으로 전환
stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`),
    names_to = "year",
    values_to = "return",
    values_drop_na = TRUE
  )
# complete() : tidy 데이터에서 결측값을 명시적으로 표현
stocks %>% 
  complete(year, qtr)
#fill() : 결측값을 가장 최근의 비결측값으로 치환
treatment <- tribble(
  ~ person, ~treatment, ~response,
  "Derrick Whitmore", 1, 7,
  NA, 2, 10,
  NA, 3, 9,
  "Katherine Burke", 1, 4
)
treatment %>% 
  fill(person)

### 사례연구
tidyr::who
# 결핵(TB) 사례가 연도, 국가, 나이, 성별, 진당 방법별로 세분화 되어있는 데이터
who
# country, iso2, iso3는 국가를 중복해서 지정하는 변수
# year 또한 분명한 변수
# new_sp_m014, new_ep_m014, mew_ep_f014같은 변수 이름은 변수가 아닌 값이다.
who1 <- who %>% 
  pivot_longer(
    cols = new_sp_m014:newrel_f65,
    names_to = "key",
    values_to = "cases",
    values_drop_na = TRUE
)
who1 %>% 
  count(key)
# 각 열의 세 글자는 해당 열이 포함하는 결핵 사례가, 새로운 사례인지 과거 사례인지 나타냄.
# 그 다음 두 글자는 다음의 결핵의 유형을 기술 : rel(재발 사례), ep(폐외 결핵 사례 의미),  sn(폐 얼룩으로 보이지 않는 폐결핵의 사례를 의미), sp(폐 얼룩으로 보이는 폐결핵 사례를 의미)
# 여섯 번째 글자는 결핵 환자의 성별 : m(남자), f(여성)
# 나머지 숫자는 연령대를 나타낸다 : 014(0-14세), 1524(15-24세), 2534(25-34세), 3544(35-44세), 4554(45-54세), 5564(55-64세), 65(65세 이상)

# 열 이름이 newrel이라 이름에 일관성이 없다. 따라서 new_rel로 변경해준다.
who2 <- who1 %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2
# 각 코드의 값을 separate()를 2번 실행하여 분리할 수 있다. 먼저, 각 _마다 코드를 쪼갠다.
who3 <- who2 %>% 
  separate(key, c("new", "type", "sexage"), sep = "_")
who3           
# new 열은 상수이므로 제거할수 있다. iso2와 iso3또한 중복임으로 제거할 수 있다.
who3 %>% 
  count(new)
who4 <- who3 %>% 
  select(-new, -iso2, -iso3)
# sexage를 sex와 age로 분리
who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)

# 한번에 나타난 코드
who %>% 
  pivot_longer(
    cols = new_sp_m014:newrel_f65,
    names_to = "key",
    values_to = "cases",
    values_drop_na = TRUE
  ) %>% 
  mutate(
    key = stringr::str_replace(key, "newrel", "new_rel")
  ) %>% 
  separate(key, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)

### 9(12)장의 연습 문제
## 9.2.1
# 1.
# table1 : 은 국가, 연도
# table2 : 국가, 연도 변수
# table3 : 국가, 년
# table4 : table4a, table4b로 나뉘어져 있으며 국가와 연도를 나타낸다.

# 2.
# a : 연도별, 국가별로 결핵 사례 수(cases)를 추츨하라
# b : 연도별, 국가별로 해당하는 인구를 추출하라.
# c : 사례 수를 인구로 나누고 10000을 곱하라
# d : 적절한 곳에 저장
t2_cases <- filter(table2, type == "cases") %>% 
  rename(cases = count) %>% 
  arrange(country, year)
t2_population <- filter(table2, type == "population") %>% 
  rename(popluation = count) %>% 
  arrange(country, year)
t2_cases_per_cap <- tibble(
  year = t2_cases$year,
  country = t2_cases$country,
  cases = t2_cases$cases,
  population = t2_population$popluation
) %>% 
  mutate(cases_per_cap = (cases / population) * 10000) %>% 
  select(country, year, cases_per_cap)
t2_cases_per_cap <- t2_cases_per_cap %>% 
  mutate(type = "cases_per_cap") %>% 
  rename(count = cases_per_cap)
bind_rows(table2, t2_cases_per_cap) %>% 
  arrange(country, year, type, count)
table4c <- tibble(
  country = table4a$country,
  `1999` = table4a[["1999"]] / table4a[["1999"]] * 10000,
  `2000` = table4a[["2000"]] / table4b[["2000"]] * 10000
)

# 3.
table2 %>%
  filter(type == "cases") %>%
  ggplot(aes(year, count)) +
  geom_line(aes(group = country), colour = "grey50") +
  geom_point(aes(colour = country)) +
  scale_x_continuous(breaks = unique(table2$year)) +
  ylab("cases")

## 9.3.3 연습문제
# 1.
stocks <- tibble(
  year = c(2015, 2015, 2016, 2016),
  half = c(1, 2, 1, 2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")
# pivot_longer()는 여러 데이터 유형이 있을 수 있는 여러 열을 단일 데이터 유형이있는 단일 열로 스택한다. pivot_wider() 열의 값에서 열 이름을 만든다.

# 2.
table4a %>% 
  pivot_longer(c(1999, 2000), names_to = "year", values_to = "cases")
# 올바른 코드
table4a %>% 
  pivot_longer(c(`1999`,`2000`), names_to = "year", values_to = "cases")

# 3.
people <- tribble(
  ~name, ~key, ~value,
  #-----------------|--------|------
  "Phillip Woods",  "age", 45,
  "Phillip Woods", "height", 186,
  "Phillip Woods", "age", 50,
  "Jessica Cordero", "age", 37,
  "Jessica Cordero", "height", 156
)
# 정답
pivot_wider(people, names_from = "name", values_from = "value")
people2 <- people %>% 
  group_by(name, key) %>% 
  mutate(obs = row_number())
people2
pivot_wider(people2, names_from = "name", values_from = "value")
people %>% 
  distinct(name, key, .keep_all = TRUE) %>%  # distict() : 중복값 제거하기
  pivot_wider(names_from = "name", values_from = "value")

# 4.
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes", NA, 10,
  "no", 20, 12
)
# 정답
preg_tidy <- preg %>% 
  pivot_longer(c(male, female), names_to = "sex",values_to = "count")
preg_tidy
preg_tidy2 <- preg %>% 
  pivot_longer(c(male, female), names_to = "sex", values_to = "count", values_drop_na = TRUE)
preg_tidy2

## 9.4.3 연습 문제
# 1.
tibble(x = c("a,b,c", "d,e,f", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))
# 정답
# extra() : 조각이 너무 많으면 어떻게 해야 하는지 구분
# fill() : 주변 것으로 채우기
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = "drop")
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = "merge")
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill = "right")
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill = "left")

# 2.
# remove는 결과 데이터 프레임의 입력 항목을 폐기한다.

# 3.
# 정답
# separate
tibble(x = c("X_1", "X_2", "AA_1", "AA_2")) %>% 
  separate(x, c("variable", "into"), sep = "_")
tibble(x = c("X1", "X2", "Y1", "Y2")) %>% 
  separate(x, c("variable", "into"), sep = c(1))
# extract
tibble(x = c("X_1", "X_2", "AA_1", "AA_2")) %>%
  extract(x, c("variable", "id"), regex = "([A-Z])_([0-9])")
tibble(x = c("X1", "X2", "Y1", "Y2")) %>%
  extract(x, c("variable", "id"), regex = "([A-Z])([0-9])")
# unite
tibble(variable = c("X", "X", "Y", "Y"), id = c(1, 2, 1, 2)) %>% unite(x, variable, id, sep = "_")
# separte와 extract는 다양하게 분류할수 있지만 unite는 여러 열을 하나의 방법이 있다.

## 9.5.1
# 1.

stocks <- tibble(
  year = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr = c( 1, 2, 3, 4, 2, 3, 4),
  return = c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66)
)
# pivot_wider
stocks %>% 
  pivot_wider(names_from = year, values_from = return,
              values_fill = 0)
# complete
stocks %>% 
  complete(year, qtr, fill = list(return = 0))

# 2.
# fill()의 direction 인수는 채우기를 사용하여 NA 값을 이전 비결측값("down") 또는 다음 비결측값("up")으로 대체할 것인지 결정한다.

## 9.6.1
# 4.
who5 %>% 
  group_by(country, year, sex) %>% 
  filter(year > 1995) %>% 
  summarise(cases = sum(cases)) %>% 
  unite(country_sex, country, sex, remove = FALSE) %>% 
  ggplot(aes(x = year,
             y = cases,
             group = country_sex,
             color = sex)) +
  geom_line()


#### 10(13)장 : dplyr로 하는 관계형 데이터
# mutating(변형) 조인 : 다른 데이터프레임에 있는 해당 관측값에서 가져와 새로운 변수를 생성하여 추가
# 필터링 조인 : 다른 테이블의 관측값과 일치하는지에 따라 관측값을 걸러냄
# 집합 연산 : 관측값을 집합 원소로 취급

# nycflights13을 이용하여 탐색하기
library(tidyverse)
library(nycflights13)

# airlines : 해당 약어 코드로 전체 항공사명을 찾아 볼 수 있다.
airlines

# airports : 각 공항에 대한 정보가 faa 공항 코드로 식별되어 있다.
airports

# planes : 각 여객기에 대한 정보가 tailnum으로 식별되어 있다.
planes

# weather : 각 NYC 공항의 매 시각 날씨 정보가 있다
weather

### 키
# 각 테이블 쌍을 연결하는 데 사용되는 변수를 키라고 한다.
# 키는 관측값을 고유하게 식별하는 변수(또는 변수 집합).
# 기본키 : 자신의 테이블에서 관측값을 고유하게 식별한다.
# 외래키 : 다른 테이블의 관측값을 고유하게 식별한다.
planes %>% 
  count(tailnum) %>% 
  filter(n > 1)
weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)
flights %>% 
  count(year, month, day, flight) %>% 
  filter(n > 1)
flights %>% 
  count(year, month, day, tailnum) %>% 
  filter(n > 1)

### 뮤테이팅 조인
# 뮤테이팅 조인을 사용하면 두 테이블의 변수를 결합 할 수 있다. mutate와 마찬가지로 조인 함수는 오른쪽에 변수를 추가하므로 이미 많은 변수가 있는 경우 새 변수가 출력되지 않는다.
flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2
flights2 %>% 
  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")
flights2 %>% 
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

## 조인 이해하기
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)
## 내부 조인 : 내부 조인은 키가 같을 때 마다 두 관측값을 매칭한다.
x %>% 
  inner_join(y, by = "key")
## 외부 조인 : 내부 조인에서는 두 테이블 모두에 나타나는 관측값이 보존된다 외부조인에서는 저거도 하나의 테이블에 있는 관측값은 보존된다.
# 왼쪽 조인 : x의 모든 관측값을 보존한다.
# 오른쪽 조인 : y의 모든 관측값을 보존한다.
# 전체 조인 : x와 y의 모든 관측값을 보존한다.

## 중복키
# 하나의 테이블에 중복키
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)
left_join(x, y, by = "key")
# 두 테이블 모두 중복키
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)
left_join(x, y, by = "key")

## 키 열 정의하기
# 테이블 쌍은 항상 하나의 변수에 의해 조인되었으며 그 변수는 두 테이블에서 같은 이름을 가졌다. 
# by에 다른 값을 사용하여 다른 방법으로 테이블을 연결 할 수 있다.
# 기본값 by = NULL을 사용하면 두 테이블에 있는 모든 변수를 사용하며 이는 자연 조인(natural join)이라 부른다
flights2 %>% 
  left_join(weather)
# 문자형 백터 by = "x", 자연 조인과 같지만 일부 공통 벼수만 사용한다.
flights2 %>% 
  left_join(planes, by = "tailnum")
# 이름 있는 문자 백터, by = c("a" = "b"), 테이블 x의 변수 a와 테이블 y의 변수 b를 매칭시킨다.
flights2 %>% 
  left_join(airports, c("dest" = "faa"))
flights2 %>% 
  left_join(airports, c("origin" = "faa"))

## 기타 구현
# base::merge()
# inner_join(x, y) = merge(x, y)
# left_join(x, y) = merge(x, y, all.x = TRUE)
# right_join(x, y) = merge(x, y, all.y = TRUE)
# full_join(x, y) = merge(x, y, all.x = TRUE, all.y = TRUE)

### 필터링 조인
# 필터링 조인은 뮤테이팅 조인과 같은 방식으로 관측값을 매칭하지만 변수가 아닌 관측값에 영향을 준다.
# semi_join(x, y) : y와 매치되는 x의 모든 관측값을 보존한다.
# anti_join(x, y) : y와 매치되는 x의 모든 관측값을 삭제한다.
# semi_join은 필터링된 요약 테이블을 다시 원래 행과 매치시키는데 유용하다.
top_dest <- flights %>% 
  count(dest, sort = TRUE) %>% 
  head(10)
top_dest
flights %>% 
  filter(dest %in% top_dest$dest)
flights %>% 
  semi_join(top_dest)
# ainti_join은 매칭되지 않는 행을 보존한다.
flights %>% 
  anti_join(planes, by = "tailnum") %>% 
  count(tailnum, sort = TRUE)

### 집합 연산
# intersect(x, y) : x, y 모두에 있는 관측값만 반환.
# union(x, y) : x와 y의 고유한 관측값을 반환.
# setdiff(x, y) : x에 있지만, y에 없는 관측값을 반환/
df1 <- tribble(
  ~x, ~y,
  1, 1,
  2, 1
)
df2 <- tribble(
  ~x, ~y,
  1, 1,
  1, 2
)
intersect(df1, df2)
# 행이 4개가 아니라 3개임을 주목
union(df1, df2)

setdiff(df1, df2)
setdiff(df2, df1)

### 10(13)장의 연습 문제
## 10.2.1 연습문제
# 1.
flights_latlon <- flights %>% 
  inner_join(select(airports, origin = faa, origin_lat = lat, origin_lon = lon),
             by = "origin") %>% 
  inner_join(select(airports, dest = faa, dest_lat = lat, dest_lon = lon),
             by = "dest")
flights_latlon %>% 
  slice(1:100) %>% 
  ggplot(aes(x = origin_lon, xend = dest_lon,
             y = origin_lat, yend = dest_lat)) +
  borders("state") +
  geom_segment(arrow = arrow(length = unit(0.1, "cm"))) +
  coord_quickmap() +
  labs(y = "Latitude", x = "Longitude")

## 10.4.6 연습문제
# 1.
airports %>% 
  semi_join(flights, c("faa" = "dest")) %>% 
  ggplot(aes(x = lon,
             y = lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()
avg_dest_delays <- flights %>% 
  group_by(dest) %>% 
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>% 
  inner_join(airports, by = c(dest = "faa"))
avg_dest_delays %>% 
  ggplot(aes(x = lon,
             y = lat,
             color = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

# 2.
airport_locations <- airports %>% 
  select(faa, lat, lon)

flights %>% 
  select(year:day, hour, origin, dest) %>% 
  left_join(
    airport_locations,
    by = c("origin" = "faa")
  ) %>% 
  left_join(
    airport_locations,
    by = c("dest" = "faa")
  )

# 3.
plane_cohorts <- inner_join(flights,
                            select(planes, tailnum, plane_year = year),
                            by = "tailnum") %>% 
  mutate(age = year - plane_year) %>% 
  filter(!is.na(age)) %>% 
  mutate(age = if_else(age > 25, 25L, age)) %>% 
  group_by(age) %>% 
  summarise(
    dep_delay_mean = mean(dep_delay, na.rm = TRUE),
    dep_delay_sd = sd(dep_delay, na.rm = TRUE),
    arr_delay_mean = mean(arr_delay, na.rm = TRUE),
    arr_delay_sd = sd(arr_delay, na.rm = TRUE),
    n_arr_delay = sum(!is.na(arr_delay)),
    n_dep_delay = sum(!is.na(dep_delay))
  )
ggplot(plane_cohorts, aes(x = age,
                          y = dep_delay_mean)) +
  geom_point() +
  scale_x_continuous("Age of plane (years)", breaks = seq(0, 30, by = 10)) +
  scale_y_continuous("Mean Departure Delay (minutes)")
ggplot(plane_cohorts, aes(x = age,
                          y = arr_delay_mean)) +
  geom_point() +
  scale_x_continuous("Age of Plane (years)", breaks = seq(0, 30, by = 10)) +
  scale_y_continuous("Mean Arrival Delay (minutes)")

# 4.
flights_weather <- 
  flights %>% 
  inner_join(weather, by = c(
    "origin" = "origin",
    "year" = "year",
    "month" = "month",
    "day" = "day",
    "hour" = "hour"
  ))
flights_weather %>% 
  group_by(precip) %>% 
  summarise(delay = mean(dep_delay, na.rm = TRUE)) %>% 
  ggplot(aes(x = precip, y = delay)) +
  geom_line() + geom_point()
flights_weather %>% 
  ungroup() %>% 
  mutate(visib_cat = cut_interval(visib, n = 10)) %>% 
  group_by(visib_cat) %>% 
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>% 
  ggplot(aes(x = visib_cat,
             y = dep_delay)) +
  geom_point()

## 10.5.1 연습문제
# 2.
planes_gte100 <- flights %>% 
  filter(!is.na(tailnum)) %>% 
  group_by(tailnum) %>% 
  count() %>% 
  filter(n >= 100)
flights %>% 
  semi_join(planes_gte100, by = "tailnum")

# 4.
worst_hours <- flights %>% 
  mutate(hour = sched_dep_time %/% 100) %>% 
  group_by(origin, year, month, day, hour) %>% 
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>% 
  ungroup() %>% 
  arrange(desc(dep_delay)) %>% 
  slice(1:48)
weather_most_delayed <- semi_join(weather, worst_hours,
                                  by = c("origin", "year",
                                         "month", "day", "hour"))
select(weather_most_delayed, temp, wind_speed, precip) %>% 
  print(n = 48)
ggplot(weather_most_delayed, aes(x = precip,
                                 y = wind_speed,
                                 color = temp)) +
  geom_point()
