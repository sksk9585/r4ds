library(tidyverse)

data(diamonds)
diamonds

# 범주형 변수
ggplot(diamonds) +
  geom_bar(aes(x = cut))

diamonds %>% 
  count(cut)

# geom_bar(1변수), geom_col(2변수)는 count (1변수), group_by %>% count(2변수) 를 그래프로 표현한 것이다.

diamonds %>% 
  group_by(color) %>% 
  count(cut)

ggplot(diamonds) +
  geom_col(aes(x = color,
               y = cut))

# 연속형 변수

ggplot(diamonds) +
  geom_histogram(aes(x = carat), binwidth = 0.5)

diamonds %>% 
  count(cut_width(carat, 0.5))  # cut_width : 도수분표표를 나타낸다.

# 이상치 제거
small <- diamonds %>% 
  filter(carat < 3)

ggplot(small, aes(x = carat)) +
  geom_histogram(binwidth = 0.1) #binwidth = 급간

# geom_freqpoly : histogram 그래프를 선으로 나타낸것
ggplot(small, aes(x = carat, color = cut)) +
  geom_freqpoly(binwidth = 0.2)

ggplot(small, aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

ggplot(faithful, aes(x = eruptions)) +
  geom_histogram(binwidth = 0.25)

ggplot(faithful, aes(x = eruptions)) +
  geom_histogram(binwidth = 0.05)

# 이상치
ggplot(diamonds) +
  geom_histogram( aes(x = y),
                  binwidth = 0.5)

diamonds %>% 
  count(cut_width(y, 0.5))

ggplot(diamonds) +
  geom_histogram( aes(x = y),
                  binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>% 
  arrange(y)
unusual

## 연습문제
# 5.3.4
# 1.
ggplot(diamonds) +
  geom_histogram(aes(x = x), binwidth = 0.5)

ggplot(diamonds) +
  geom_histogram(aes(x = y), binwidth = 0.5)

ggplot(diamonds) +
  geom_histogram(aes(x = z), binwidth = 0.5)

diamonds %>% 
  count(cut_width(x, 0.5))
diamonds %>% 
  count(cut_width(y, 0.5))
diamonds %>% 
  count(cut_width(z, 0.5))

# 2.
ggplot(diamonds) +
  geom_histogram(aes(x = price))

ggplot(diamonds, aes(x = price, color = cut)) +
  geom_freqpoly(binwidth = 30)

# 3.
diamonds %>% 
  filter(carat == 0.99)
# 0.99 = 23개
diamonds %>% 
  filter(carat == 1)
# 1 = 1,558개
# 두 캐럿의 갯수의 차이는 0.99 캐럿을 1로 포함하는 경우가 있기 때문이다.
ggplot(diamonds) +
  geom_point(aes(x = carat,
                 y = price))

diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))

diamonds %>% 
  filter(y >= 3 & y <= 20)

# 이상치를 결측값으로
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA ,y))

ggplot(diamonds2, aes(x = x,
                      y = y)) +
  geom_point()

ggplot(diamonds2, aes(x = x,
                      y = y)) +
  geom_point(na.rm = TRUE)

library(nycflights13)

# %% : 나머지 구하기, %/% : 몫을 구해주는 연산자
flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) +
  geom_freqpoly(
    mapping = aes(color = cancelled),
    binwidth = 1/4
  )

# 5.4.1 연습문제
# 1.
# 히스토그램
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA ,y))
ggplot(diamonds2) +
  geom_histogram(aes(x = y))
# 히스토그램에서 그래프를 만들떄 결측값을 제거하여 나타나고, 막대그래프는 결측값을 다른 범주로 보여준다.

# 2.
# na.rm = TRUE는 결측값을 통계 분석할때 미포함 시키는 역할을 한다.

## 공변동
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_freqpoly(aes(color = cut), binwidth = 500)
# 전체적인 빈도수가 많음으로 분포 차이 파악 어려움
ggplot(diamonds) +
  geom_bar(aes(x = cut))

ggplot(diamonds,
       aes(x = price,
           y = ..density..)) +
  geom_freqpoly(aes(color = cut), binwidth = 500)
# 해석하기 어려움
# 박스플롯을 이용
ggplot(diamonds, aes(x = cut,
                     y = price)) +
  geom_boxplot()

# 자동차 종류에 따라 고속도로 주행거리가 어떻게 달라지는가
ggplot(mpg, aes(x = class,
                y = hwy)) +
  geom_boxplot()

ggplot(mpg) +
  geom_boxplot(aes(x = reorder(class, hwy, FUN = median),
                   y = hwy))
# reorder() : 오름차순 정렬
ggplot(mpg) +
  geom_boxplot(aes(x = reorder(class, hwy, FUN = median),
                   y = hwy)) +
  coord_flip()

# 5.5.2 연습문제
# 1.
flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot() +
  geom_boxplot(
    mapping = aes(x = cancelled,
                  y = sched_dep_time))

# 2.
ggplot(diamonds, aes(x = price,
           y = clarity)) +
  geom_boxplot()

ggplot(diamonds, aes(x = price,
           y = carat)) +
  geom_boxplot()

ggplot(diamonds, aes(x = price,
                     y = color)) +
  geom_boxplot()

#가격을 에측하는데 가장 중요한 변수는 carat 이다.
ggplot(diamonds, aes(x = cut,
                     y= carat)) +
  geom_boxplot()
# 품질이 낮은 다이아몬드를 왜 더 비싸게 만드는 이유는 다이아의 크기가 크면 낮은 cut을 사용하여도 가격을 비싸게 팔 수 있기 떄문이다.

# 3.
install.packages("ggstance")

ggplot(diamonds, aes(x = cut,
                     y= carat)) +
  geom_boxplot() +
  coord_flip()

ggplot(diamonds, aes(x = cut,
                     y= carat)) +
  geom_boxploth()
# 두개의 그래프 결과가 모두 똑같다.

# 4.
install.packages("lvplot")
library(lvplot)
ggplot(diamonds, aes(x = cut,
                     y = price)) +
  geom_boxplot()

ggplot(diamonds, aes(x = cut,
                     y = price)) +
  geom_lv()
# geom_lv 가 더 큰 데이터를 이용하여 정확하게 나타낼수 있다.

# 5.
ggplot(diamonds, aes(x = price, color = cut)) +
  geom_freqpoly(binwidth = 30)

ggplot(diamonds, aes(x = price)) +
  geom_histogram() +
  facet_wrap(~cut)

ggplot(diamonds, aes(x = cut, price)) +
  geom_violin()

# freqpoly는 색으로 구분하여 쉽게 구분할수 있지만 겹쳐진 부분에서는 구별하기 힘들다. 하지만 화면분할과 violin()는 한눈에 볼수 있다.

# 6.
# geom_jitter()은 geom_point에서 각각의 점의 위치를 범위 내에서 무작위로 수평분산 시켜준다.
ggplot(mpg, aes(x = class,
                     y = cty)) +
  geom_point()

ggplot(mpg, aes(x = class,
                y = cty)) +
  geom_jitter()

## 두개의 범주형 변수
ggplot(diamonds) +
  geom_count(aes(x = cut,
                 y = color))
diamonds %>% 
  count(color, cut)

# 시각화
diamonds %>% 
  count(color, cut) %>% 
  ggplot(aes(x = color,
             y = cut)) +
  geom_tile(aes(fill = n))

## 5.5.4 연습문제
# 1.
# count를 비율로 계산하여 나타낸다.
diamonds %>% 
  count(color, cut) %>% 
  group_by(color) %>% 
  mutate(prop = n / sum(n)) %>% 
  ggplot(aes(x = color,
             y = cut)) +
  geom_tile(aes(fill = prop))

# 2.
data(flights)
flights %>% 
  group_by(month, dest) %>% 
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = dest,
             y = factor(month))) +
  geom_tile(aes(fill = delay))

flights %>% 
  group_by(month, dest) %>% 
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = reorder(dest, delay),
             y = delay)) +
  geom_col(aes(fill = dest))+
  coord_flip() +
  facet_wrap(~factor(month))
#  이 플롯을 이해하기 힘든 이유는 너무 많은 데이터를 가지고 있기 때문이다. 그래서 막대그래프 등을 사용하여 개선할수 있다.

# 3.
# 더 많은 범주의 범주형 변수를 사용하거나, y축에 더 긴 이름을 사용하는 것이 좋기 때문이다. 그래야 이름이 겹치지 않기 때문이다.

## 두 개의 연속형 변수
ggplot(diamonds) +
  geom_point(aes(x = carat,
                 y = price))

# apph를 이용하여 투명도를 추가
ggplot(diamonds) +
  geom_point(aes(x = carat,
                 y = price),
             alph = 1/100)

# 직 사각형 bin
ggplot(small) +
  geom_bin2d(aes(x = carat,
                 y = price))

# 육각형 bin
install.packages("hexbin")
ggplot(small) +
  geom_hex(aes(x = carat,
               y = price))

# 연속변수를 그룹화
ggplot(small, aes(x = carat,
                  y = price)) +
  geom_boxplot(aes(group = cut_width(carat, 0.1)))

# cut_number() : 각 bin에 대략적으로 같은 수의 점을 표시
ggplot(small, aes(x = carat,
                  y = price)) +
  geom_boxplot(aes(group = cut_number(carat, 20)))

## 5.5.6 연습문제
# 1.
# cut_width() : 어떤 변수를 지정된 숫자의 급간으로 쪼개주는 기능을 한다.
# cut_number() : 각 bin에 대략적으로 같은 수의 점을 표시
ggplot(diamonds, aes(color = cut_number(carat, 5),
                     x = price)) +
  geom_freqpoly()

ggplot(diamonds, aes(color = cut_width(carat, 1),
                     x = price)) +
  geom_freqpoly()

# 2.
ggplot(diamonds, aes(x = cut_number(price, 5),
                     y = carat)) +
  geom_boxplot() +
  coord_flip()

# 3.
library(modelr)
mod <- lm(log(price) ~ log(carat), data = diamonds)
summary(mod)

diamonds3 <- diamonds %>% 
  add_residuals(mod) %>%   # residuals : 잔차 :표본집단에서 회귀식을 얻었다면, 그 회귀식을 통해 얻은 예측값과 실제 관측값의 차이가 잔차
  mutate(resid = exp(resid)) # exp : 2.73 배

ggplot(diamonds3) +
  geom_point(aes(x = carat,
                 y = resid))
ggplot(diamonds3) +
  geom_boxplot(aes(x = cut,
                   y = resid))
# 큰 다이아몬드 일수록 비싸며, 좋은 등급일 수록 더 많이 비싸다.

# 4.
ggplot(diamonds, aes(x = cut_number(carat, 5),
                     y = price,
                     color = cut)) +
  geom_boxplot()

# 5.
ggplot(diamonds) +
  geom_point(aes(x = x,
                 y = y)) +
  coord_cartesian(xlim = c(4,11), ylim = c(4,11))
# 차원이 많을 수록 정보를 관계속에서 확인 할 수 있기 때문이다. 
ggplot(diamonds) +
  geom_histogram(aes(x = x))

ggplot(diamonds) +
  geom_histogram(aes(x = y))

grid.arrange(ggplot(diamonds) +
               geom_histogram(aes(x = x)),
             ggplot(diamonds)+
               geom_histogram(aes(x = y)),
             ggplot(diamonds) +
               geom_point(aes(x = x,
                              y = y))+
               coord_cartesian(xlim = c(4,11), ylim = c(4,11)))
