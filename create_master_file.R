library(tidyverse)

yh <- read_csv('processed_data/yahoo_nfl_2016_2018.csv',
               col_types = 
                 cols(gid = col_character()))
yh <- mutate(yh, platform = 'yh')

dk <- read_csv('processed_data/draftkings_nfl_2014_2018.csv',
               col_types = 
                 cols(gid = col_character()))
dk <- mutate(dk, platform = 'dk')

fd <- read_csv('processed_data/fanduel_nfl_2011_2018.csv', 
               col_types = 
                 cols(gid = col_character()))
fd <- mutate(fd, platform = 'fd')

yh %>% 
  bind_rows(dk) %>% 
  bind_rows(fd) %>% 
  arrange(platform, desc(year), week) %>% 
  write_csv('processed_data/nfl_pts_history.csv')
  



