# This is the model file which contains all the functions which completes our
# Prediction model and the model is very simple actually its a lame model which 
# only predicts the next word based on the highest frequency count from bigrams,
# trigrams and quadgrams and returns the predicted word based on the most frequent
# word. It runs on very simple logic and does not require fancy processing or 
# training etc but it gives fairly accurate suggestion in compare to other models

# Load required libraries
library(dplyr)
library(tidytext)
library(tidyverse)
library(RWeka)

# The data sets were converted into RDS files and loaded for usage.
biwords <- readRDS("./bigram.rds")
triwords <- readRDS("./trigram.rds")
quadwords <- readRDS("./quadgram.rds")

# The function to get the most frequent bigrams
bigram <- function(input_words){
  num <- length(input_words)
  filter(biwords, 
         word1==input_words[num]) %>% 
    top_n(1) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 2)) %>%
    as.character() -> out
  ifelse(out =="character(0)", "?", return(out))
}

# The function to get the most frequent trigrams
trigram <- function(input_words){
  num <- length(input_words)
  filter(triwords, 
         word1==input_words[num-1], 
         word2==input_words[num])  %>% 
    top_n(1) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 3)) %>%
    as.character() -> out
  ifelse(out=="character(0)", bigram(input_words), return(out))
}

# The function to get the most frequent quadgrams
quadgram <- function(input_words){
  num <- length(input_words)
  filter(quadwords, 
         word1==input_words[num-2], 
         word2==input_words[num-1], 
         word3==input_words[num])  %>% 
    top_n(1) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 4)) %>%
    as.character() -> out
  ifelse(out=="character(0)", trigram(input_words), return(out))
}


# Our Main Function which will take the input and format it according to our needs
# and then call the matching function to find the most frequent ngram and give 
# prediction.

predict <- function(input){
  # Create a dataframe
  input <- tibble(text = input)
  # Clean the Input
  replace_reg <- "[^[:alpha:][:space:]]*"
  input <- input %>%
    mutate(text = str_replace_all(text, replace_reg, ""))
  # Find word count, separate words, lower case
  input_count <- str_count(input, boundary("word"))
  input_words <- unlist(str_split(input, boundary("word")))
  input_words <- tolower(input_words)
  # Call the matching functions
  out <- ifelse(input_count == 1, bigram(input_words), 
                ifelse (input_count == 2, trigram(input_words), quadgram(input_words)))
  # Output
  return(out)
}
