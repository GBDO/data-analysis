# 출처 : Do it R 텍스트마이닝닝

library(stringr)
library(dplyr)
library(tidytext)
library(ggplot2)

# str_replace_all() 사용
txt <- "외모로!! 사람을 판단해서는 xyz 안된다!@#"
str_replace_all(string = txt, pattern = "[^가-힣]", replacement = " ")
str_replace_all(replacement = " ", string = txt, pattern = "[^가-힣]")
str_replace_all(txt, "[^가-힣]", " ")
str_replace_all("[^가-힣]", " ",txt)


raw_park <- readLines("/speech_park.txt", encoding = "UTF-8")
head(raw_moon)

text_park <- raw_park %>% 
  str_replace_all('[^가-힣0-9]', ' ') %>% # 한글, 숫자만 남기기
  str_squish() %>% # 연속된 공백 제거
  as_tibble() # tibble로 변환


# 뛰어쓰기 기준 토큰화
token_park <- text_park %>% unnest_tokens(input = value,
                                          output = word,
                                          token = 'words')
token_park

word_space <- token_park %>%
  count(word, sort = T) %>%
  filter(str_count(word) > 1) %>% # 두 글자 이상만 남기기
  head(20)

word_space

# 가장 많이 사용된 단어 20개에 대한 시각화(막대 그래프)
font_add_google(name = "Gamja Flower", family = "gamjaflower")
showtext_auto()

ggplot(word_space, aes(x = reorder(word, n), y = n)) +
  geom_col() +
  coord_flip() +
  geom_text(aes(label = n), hjust = -0.3) +
  
  labs(title = "박근혜 대통령 출마 선언문 단어 빈도",
       x = NULL, y = NULL) +
  
  theme(title = element_text(size = 12),
        text = element_text(family = "gamjaflower"))  # 폰트 적용
