library(tidyverse)

### forcats로 하는 팩터형
## 팩터형 생성하기
x1 <- c("Dec", "Apr", "Jan", "Mar")
# 두 가지 문제
# 1. 12개의 달 외의 오타를 입력했을 때, 경고가 발생되지 않아 실수를 알아채기 어렵다.
x2 <- c("Dec", "Apr", "Jam", "Mar")
# 2. 유용한 순서로 정렬되지 않는다.
sort(x1)

# 팩터형을 생성하기 위해서는 유효한 레벨들의 리스트를 생성하는 것부터 시작
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)
y1 <- factor(x1, levels = month_levels)
y1
sort(y1)
y2 <- factor(x2, levels = month_levels)
y2
# 경고가 발생되길 원하는 경우 readr::parse_factor
y2 <- parse_factor(x2, levels = month_levels)
factor(x1)

# 팩터형 생성 시 레벨을 unique로 설정하거나 사후적으로 fct_inorder를 사용
f1 <- factor(x1, levels = unique(x1))
f1
f2 <- x1 %>% 
  factor() %>% fct_inorder()
f2

# 유효한 레벨 집합에 직접 접근하려면 levels로 할 수 있다.
levels(f2)

## 종합사회조사
forcats::gss_cat

gss_cat %>% 
  count(race)

ggplot(gss_cat, aes(x = race)) +
  geom_bar()

ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

## 팩터 순서 수정하기
relig_summary <- gss_cat %>% 
  group_by(relig) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
ggplot(relig_summary, aes(x = tvhours,
                          y = relig)) +
  geom_point()
# fct_reorder()를 사용하여 relig의 레벨을 재정렬해서 개선할 수 있다.
# f : 레벨을 수정할 팩터.
# x : 레벨을 재정렬하기 위해 사용할 수치형 백터.
# 선택적으로 fun: f의 각 값에 대해 x 값이 여러 개가 있을 때 사용할 함수. 기본값은 median
ggplot(relig_summary, aes(x = tvhours,
                          fct_reorder(relig, tvhours))) +
  geom_point()


relig_summary %>% 
  mutate(relig = fct_reorder(relig, tvhours)) %>% 
  ggplot(aes(x = tvhours,
             y = relig)) +
  geom_point()
# 종교를 모르는 범주의 사람들이 TV를 훨씬 많이 보고, 힌두교와 다른 동양 종교 사람들이 훨씬 덜 본다는 것을 쉽게 알 수 있다.

# 좀 더 복잡한 변환을 해야 된다면 aes 내부보다 mutate 단계에서 할 것을 추천
relig_summary %>% 
  mutate(relig = fct_reorder(relig, tvhours)) %>% 
  ggplot(aes(x = tvhours,
             y = relig)) +
  geom_point()

# 보고된 소득 레벨에 따라 평균 나이가 어떻게 변화하는가
rincome_summary <- gss_cat %>% 
  group_by(rincome) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
ggplot(rincome_summary, aes(age, fct_reorder(rincome, age))) +
  geom_point()

# 해당 없음(Not applicable)를 함께 가져오는 것이 좋음
ggplot(rincome_summary, aes(x = age, fct_relevel(rincome, "Not applicable"))) +
  geom_point()

# fct_reorder2는 가장 큰 x 값과 연관된 y 값으로 팩터형을 재정렬한다.
by_age <- gss_cat %>% 
  filter(!is.na(age)) %>% 
  count(age, marital) %>% 
  group_by(age) %>% 
  mutate(prop = n / sum(n))

ggplot(by_age, aes(x = age,
                   y = prop,
                   color = marital)) +
  geom_line(na.rm = TRUE)

ggplot(by_age, aes(x = age,
                   y = prop,
                   color = fct_reorder2(marital, age, prop))) +
  geom_line() +
  labs(color = "marital")

# fct_infreq를 사용해 빈도 오름차순으롤 레벨을 정렬
gss_cat %>% 
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>% 
  ggplot(aes(marital)) +
  geom_bar()

## 팩터 레벨 수정하기
# fct_recode는 레벨을 병합하여 상위 레벨 시각화를 할 수 있다.
gss_cat %>% count(partyid)

gss_cat %>% 
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong" = "Strong republican",
                              "Republican, weak" = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak" = "Not str democrat",
                              "Democrat, strong" = "Strong democrat")) %>% 
  count(partyid)

# 그룹 결합
gss_cat %>% 
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong" = "Strong republican",
                              "Republican, weak" = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak" = "Not str democrat",
                              "Democrat, strong" = "Strong democrat",
                              "Other" = "No answer",
                              "Other" = "Don't know",
                              "Other" = "Other party")) %>% 
  count(partyid)
# 이 기술은 신중히 사용해야 할 것. 서로 같지 않은 범주들을 함께 묶는다면 잘못된 결과를 도출
# 다수의 레벨을 병합하고자 하면 fct_recode의 변형 함수인 fct_collapse가 편리
gss_cat %>% 
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat"))) %>% 
           count(partyid)

# 소규모 그룹 모두를 묶고 싶을때 fct_lump
gss_cat %>% 
  mutate(relig = fct_lump(relig)) %>% 
  count(relig)
# n 인수를 사용하여 유지하고 싶은 그룹 개수를 지정할 수 있다.
gss_cat %>% 
  mutate(relig = fct_lump(relig, n = 10)) %>% 
  count(relig, sort = TRUE) %>% 
  print(n = Inf)
