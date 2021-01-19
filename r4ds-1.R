library(tidyverse)
install.packages(c("nycflights13", "Lahman", "gapminder"))

data(mpg)
mpg

# x = displ, y = hwy 산점도 그래프
ggplot(mpg, aes(x = displ,
                 y = hwy)) +
  geom_point(aes(color = class))

# size
ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point(aes(size = class,
                 color = class))

# alpha (음영)
ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point(aes(alpha = class))

# shape
ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point(aes(shape = class))

# 화면 분할
# facet_wrap
ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point(aes(color = class)) +
  facet_wrap(~class,
             nrow = 2)
# ncol = 열 정렬, nrow = 행 정렬

# facet_grid
ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point(aes(color = class)) +
  facet_grid(~class)
# 내가 보고싶은 변수기준으로 화면을 볼때

# 추세선
ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(method = "lm") # method = "lm" 곡선을 선으로


# diamonds

data("diamonds")
diamonds

# cut을 이용한 막대그래프
ggplot(diamonds, aes(cut)) +
  geom_bar()

# 확률로 나타내기
ggplot(diamonds) +
  geom_bar(aes(x = cut,
               y = stat(prop),
               group = 1))


ggplot(diamonds) +
  geom_bar(aes(x = cut,
               fill = clarity))

ggplot(diamonds) +
  geom_bar(aes(x = cut,
               fill = clarity),
           position = "fill")

ggplot(diamonds) +
  geom_bar(aes(x = cut,
               fill = clarity),
           position = "dodge")

# 지도 그리기

install.packages("mpas")

nz <- map_data("nz")
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap() # 지도에 맞게 가로세로 비율이 설정된다.

# 자율활동
# 3장
library(nycflights13)
library(tidyverse)

# 3.2.4 연습문제
# 1. ggplot(data = mpg)을 실행하라. 무엇이 나타나는가?
ggplot(data = mpg)
# 그래프를 그리기 전의 흰 바탕

# 2. mpg는 행이 몇 개인가? 열은 몇 개인가?
# 행 : 234개, 열 : 11개

# 3. drv 변수는 무엇을 나타내는가?
# 구동방식을 나타낸다.

# 4. hwy 대 cyl의 산점도를 만들어라.
ggplot(mpg, aes(x = hwy,
                y = cyl)) +
  geom_point()

# 5. class 대 drv 산점도를 만들면 어떻게 되는가? 이 플롯이 유용하지 않는 이유는?
ggplot(mpg, aes(x = class,
                y = drv)) +
  geom_point()
# 이 플롯이 유용하지 않는 이유는 두 개의 변수의 상관관계가 없기 때문이다.

# 1.3.1
# 1. 다음의 코드는 무엇이 문제인가? 점들이 왜 파란색이 아닌가?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ,
                           y = hwy,
                           color = "blue"))
# color = "blue"는 aes밖으로 밖으로 뺴내야 한다.

# 2. mpg의 어느 변수가 범주형인가? 어떤 변수가 연속형인가?
# 범주형 : class, manufacturer, model, trans, drv, fl
# 연속형 : displ, year, cyl, cty, hwy

# 3. 연속형 변수 하나를 color, size, shape로 매핑하라. 이러한 심미성은 범주형, 연속형 변수에 따라 어떻게 다르게 작동하는가?
# color
ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point(aes(color = cty))
# size
ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point(aes(size = cty))
# shape
ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point(aes(shape = cty))
# shape는 연속형 변수에서 쓸 수 없음. shape는 class같이 범주형에서만 사용가능하다.

# 4. 하나의 변수를 여러 심미성에 매핑하면 어떻게 되는가?
ggplot(mpg, aes(x = displ,
                y = hwy))+
  geom_point(aes(color = cty,
                 size = cty))

# 5. stroke 심미성의 역할은 무엇인가?
ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point(aes(stroke = cty))
# 점의 크기가 달라진다.

# 6. aes(color = displ < 5)처럼 심미성을 변수 이름이 아닌 다른 것에 매핑하면 어떻게 되는가?
ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point(aes(color = displ <5))
# True와 False로 나뉜다.

# 1.5.1
# 1. 연속형 변수로 면분할하면 어떻게 되는가?
ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point() +
  facet_wrap(~cty)

# 2.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv,
                           y = cyl))+
  facet_grid(drv ~ cyl)
# 빈 셀에 조건에 해당되는 산점도가 없기 때문이다.

# 3.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ,
                           y = hwy)) +
  facet_wrap(drv ~ .)
# 열이나 행으로 면분할하고 싶지 않을때 .을 쓴다.

# 4.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ,
                           y = hwy)) +
  facet_wrap( ~ class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ,
                           y = hwy,
                           color = model)) +
  facet_wrap( ~ class, nrow = 2)
# 설정한 변수가 한눈에 보기 쉽다. 단점은 데이터가 클수록 난잡해 진다.

# 5.
# nrow : 행으로 정렬
# ncol : 열로 정렬
# grid에 nrow와 ncol이 없는 이유는 이미 내가 보고 싶은 변수를 기준으로 분할 하였기 때문이다.

# 6.
# grid가 두 변수를 이용하여 면분할 하여 비교하기 때문에, 열에 고유 수준이 더 많은 변수를 두어야 비교하기 쉽다.

# 1.6.1
# 1.
# 선 그래프를 그리기 위해서는 geom_point를 사용한다. 박스 플롯은 geom_boxplot를 사용한다. 히스토그램은 geom_histogram 이고 면적은 geom_area를 사용한다.

# 2.
ggplot(data = mpg,
       mapping = aes(x = displ,
                     y = hwy,
                     color = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)
# 추세선이 drv별로 생기고 se = FALSE를 사용함으로 써 표준오차를 사라지게 만들어 준다.

# 3.
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ,
                            y = hwy,
                            color = drv),
              show.legend = FALSE)
# show.legend 를 사용하면 범례를 사라지게 해준다.

# 4.
# se는 오차범위를 출력하지 않게 해주는 역할을 한다.

# 5.
# 두 그래프 모두 같이 나타난다. 왜냐하면 첫번째 코드는 전체적인 부분에 변수를 넣었고, 두 번째 코드는 전체적인 분에 넣지 않았기 때문에 하나하나 설정을 해주어야 추세선이 하나로 나타난다.

#1.7.1
# 1.
# stat_summary와 연관된 기본 geom은 bar와 point이다.(나머지는 모르겠어요)

#2.
# col은 x축, y축 둘다 설정한 요약된 자료의 막대그래프이고, bar은 x축만 설정하고 y는 비도수로 자동 설정 된다 bar 그래프는 전체자료의 그래프이다.

# 3.
#mapping, data, position, ..., na.rm, show.legend, inherit.aes, binwidth, bins, bins, geom, stat, center, boundary, breaks, closed, pad 

# 4.
# y 변수를 계산한다. 

# 5.
#group을 설정하지 않으면 모든 변수에 각각 백분율을 부여하기 때문에 한 그룹으로 묶어서 x 전체에 백분율을 부여한다.
