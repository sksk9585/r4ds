library(tidyverse)
## 문자열 기초
string1 <- "문자열입니다"
string2 <- '문자열 내에 "인용문"이 포함된 경우, 나는 작은 따옴표를 사용한다'

# 따옴표를 닫는것을 까먹었다면 esc를 누르고 다시 시도
# 작은따옴표 문자나 큰 따옴표 문자를 문자열에 포함하려면 벗어나기를 뜻하는 역슬래쉬(\)를 사용한다
double_quote <- "\"" # 또는 '"'
single_qoute <- '\'' # 또는 "'"

# 역슬래쉬(\)를 포함하려면 "\\"과 같이 두번 입력
# 문자열의 원시 형태를 보려면 wirteLines()를 사용
x <- c("\"", "\\")
x
writeLines(x)

# 줄바꿈 : "\n"
# 탭 : "\t"
# "\u00b5" : 비영어 문자를 동작하도록 작성한 것
x <- "\u00b5"
x

c("one", "two", "three")

## 문자열 길이
# str_length() : 문자열의 문자 개수를 알려준다.
str_length(c("a", "R for data science", NA))

## 문자열 결합
# 둘 이상의 문자열을 결할할 때 : str_c()
str_c("x", "y")
str_c("x", "y", "z")
# 구분 방식을 조정할 때 : sep
str_c("x", "y", sep = ", ")
# 결측값을 "NA"로 출력하기 원할 때 : str_replace_na()
x <- c("abc", NA)
str_c("|-", x, "-|")
str_c("|-", str_replace_na(x), "-|")

# str_c는 벡터화되고 짧은 벡터ㅏ 긴 벡터와 길이가 같도록 자동으로 재사용
str_c("prefix-", c("a", "b", "c"), "-suffix")

# 길이가 0인 객체는 조용히 삭제된다. 이 특성은 if와 함께 쓰면 유용
name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE
str_c(
  "Good", time_of_day, " ", name,
  if(birthday) " and HAPPY BIRTHDAY",
  "."
)

# 문자열 벡터를 하나의 문자열로 합치려면 collapse
str_c(c("x", "y","z"), collapse = ", ")

## 문자열 서브셋하기
# str_sub()를 사용하여 추출가능
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
# 음수는 끝에서부터 반대 방향으로 센다.
str_sub(x, -3, -1)
# 문자열이 짧은 경우에도 오류없이 가능한 만큼 반환
str_sub("a", 1, 5)
# str_sub를 할당 형식을 사용하여 문자열 수정
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1)) # str_to_lower() : 텍스트를 소문자로 변경
x

# 터키어는 i가 점이 있는 것과 없는 것 두 개이다.
# 또한 대문자도 다르다
str_to_upper(c("i", "ı"))
str_to_upper(c("i", "ı"), locale = "tr")

x <- c("apple", "eggplant", "banana")
str_sort(x, locale = "en") # 영어
str_sort(x, locale = "haw") # 하와이어

### 정규표현식을 이용한 패턴 매칭
## 기초 매칭
x <- c("apple", "banana", "pear")
str_view(x, "an")

str_view(x, ".a.")
# 정규표현식을 생성하기 위해 \\이 필요함
dot <- "\\."

# 그러나 이 정규표현식 자체는 역슬래시를 하나만 갖게 됨
writeLines(dot)

# R에서 .을 정확하게 찾는 방법
str_view(c("abc", "a.c", "def"), "a\\.c")

x <- "a\\b"
writeLines(x)

str_view(x, "\\\\")

## 앵커
# ^ : 문자열의 시작과 매칭
# $ : 문자열의 끝과 매칭
x <- c("apple", "banana", "pear")
str_view(x, "^a")

str_view(x, "a$")

x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
str_view(x, "^apple$")

## 문자 클래스와 대체 구문
# \d는 임의의 숫자와 매치한다
# \s는 임의의 여백 문자와 매치한다.
# [abc]는 a, b 또는 c와 매치한다
# [^abc]는 a, b 또는 c를 제외한 임의의 문자와 매치한다.
str_view(c("grey", "gray", "gr(e|a)y"))

## 반복
# ? : 0 또는 1
# + : 1회 이상
# * : 0회 이상
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, 'C[LX]+')

# 매칭 횟수를 정확하게 지정할 수 있다.
# {n} : 정확히 n회
# {n,} : n회 이상
# {,m} : 최대 m회
# {n,m} : n과 m회 사이
str_view(x, "C{2}")
str_view(x, "C{2,}")
str_view(x, "C{2,3}")
# 뒤에 ?를 넣으면 가장 짧은 문자열과 매칭한다.
str_view(x, "C{2,3}?")
str_view(x, "C[LX]+?")

## 그룹화와 역참조
str_view(fruit, "(..)\\1", match = TRUE)

### 도구
## 매칭 탐지
# 문자형 벡터가 패턴과 매칭하는지 확인하려면, str_detect를 사용
x <- c("apple", "banana", "pear")
str_detect(x, "e")

# t로 시작하는 단어의 개수는?
sum(str_detect(words, "^t"))
# 모음으로 끝나는 단어의 비율은?
mean(str_detect(words, "[aeiou]$"))
# 모음이 최소 하나가 있는 단어 모두를 찾은 뒤, 그 역을 취함
no_vowels_1 <- !str_detect(words, "[aeiou]")
# 자음(비-모음)으로만 이루어진 단어를 모두 찾음
no_vowels_2 <- str_detect(words, "^[aeiou]+$")
identical(no_vowels_1, no_vowels_2)

words[str_detect(words, "x$")]
str_subset(words, "x$")

df <- tibble(
  word = words,
  i = seq_along(word)
)
df %>% 
  filter(str_detect(words, "x$"))

# str_count는 str_detect의 변형 함수, 하나의 문자열에서 몇 번 매칭되는지를 알려준다.
x <- c("apple", "banana", "pear")
str_count(x, "a")

# 단어당 모음 평균 개수는?
mean(str_count(words, "[aeiou]"))

# str_count는 mutate와 함께 쓰는 것이 자연스럽다.
df %>% 
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )

# 매칭들끼리 서로 겹치지 않는다는 것을 주의
str_count("abababa", "aba")
str_view_all("abababa", "aba")

## 매칭 추출
# 매칭한 실제 텍스트를 추출하려면 str_extract를 사용
stringr::sentences
length(sentences)
head(sentences)

# 색상을 포함하는 모든 문장을 찾을때
color <- c("red", "orange", "yellow", "green", "blue", "purple")
color_match <- str_c(color, collapse = "|")
color_match

has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)
head(matches)

# str_extract는 첫 번쨰 매칭만 추출한다는 것을 주의
more <- sentences[str_count(sentences, color_match) > 1]
str_view_all(more, color_match)
str_extract(more, color_match)
# 매칭 모두를 얻으려면 str_extract_all
str_extract_all(more, color_match)

# str_extract_all에서 simplify = TRUE를 하면 짧은 매칭이 가장 긴 것과 같은 길이로 홖장된 행렬이 반환된다.
str_extract_all(more, color_match, simplify = TRUE)
x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)

## 그룹화 매칭
noun <- "(a|the) ([^ ]+)"

has_noun <- sentences %>% 
  str_subset(noun) %>% 
  head(10)
has_noun %>% 
  str_extract(noun)

has_noun %>% 
  str_match(noun)

# 데이터가 티블인 경우, tidyr::extract()를 사용하는 것이 더 쉽다.
tibble(sentence = sentences) %>% 
  tidyr::extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)",
    remove = FALSE
  )

## 매칭 치환
# str_replace와 str_replace_all을 이용하여 매치를 새로운 문자열로 치환할 수 있다.
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
str_replace_all(x, "[aeiou]", "-")

x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

# 두 번째와 세 번째 단어의 순서를 바꾸는 코드
sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>% 
  head(5)

## 문자열 분할
# str_split
sentences %>% 
  head(5) %>% 
  str_split(" ")

"a|b|c|d" %>% 
  str_split("\\|") %>% 
  .[[1]]

sentences %>% 
  head(5) %>% 
  str_split(" ", simplify = TRUE)

# 반환할 조각의 최대 개수를 지정 할 수 있다.
fields <- c("Name: Hadley", "Country: NZ", "AGE: 35")
fields %>% str_split(": ", n = 2, simplify = TRUE)

# boundry 함수를 사용하여 문자, 줄, 문장 혹은 단어를 경계로 분할할 수도 있다.
x <- "This is a sentence. This is another sentence."
str_view_all(x, boundary("word"))[[1]]
str_split(x, boundary("word"))[[1]]

## 매칭 찾기
# str_locate와 str_locate_all을 사용하면 각 매치의 시작과 종료 위치를 알 수 있다.

### 기타 패턴 유형
# 문자열로 된 패턴을 사용하면 자동으로 regex 호출로 래핑된다.
# 일반적인 호출(아래의 긴 호출과 같다)
str_view(fruit, "nana")
# 긴 호출
str_view(fruit, regex("nana"))
# ignore_case = TRUE를 하면 문자가 대문자나 소문자 형태 모두로 매칭
bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))
# multiline = TRUE를 하면 ^와 $이 전체 문자열의 시작, 끝이 아니라 각 라인의 시작과 끝이 매칭된다.
x <- "Line 1\nLine 2\nLine 3"
str_extract_all(x, "^Line")[[1]]
str_extract_all(x, regex("^Line", multiline = TRUE))[[1]]
# comments = TRUE를 하면 복잡한 정규표현식을 이해하기 쉽도록 설명과 공백을 사용할 수 있게 된다. # 뒤에 나오는 다른 문자들처럼 공백도 무시된다. 공백 문자를 매치하기 위해서는 "\\"로 이스케이프 해야 한다.
phone <- regex("
               \\(?  # 선택적인 여는 괄호
               (\\d{3}) # 지역 번호
               [)- ]? # 선택적인 닫는 괄호, 대사 혹은 빈칸
               (\\d{3}) # 세 자리 숫자
               [ -]? # 선택적인 빈칸 혹은 대시
               (\\d{3}) # 세 자리 숫자",
               comments = TRUE)
str_match("514-791-8141", "phone")
# dotall = TRUE를 하면 .이 \n을 포함한 모든 문자에 매칭된다.
# fixed는 지정된 일련의 바이트와 정확히 매치한다.
microbenchmark::microbenchmark(
  fixed = str_detect(sentences, fixed("the")),
  regex = str_detect(sentences, "the"),
  times = 20
)
# coll은 표준 대조 규칙을 사용하여 문자열을 비교한다.
# 따라서 대소문자를 구분하지 않는 매치를 수행할 경우
# 지역별 차이에 대해 조심해야한다

## 정규표현식의 기타 용도
# apropos는 전역 환경에서 사용할 수 있는 모든 객체를 검색
apropos("replace")
# dir은 디렉터리에 있는 모든 파일을 나열한다.
head(dir(pattern = "\\.Rmd$"))