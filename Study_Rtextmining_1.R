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


