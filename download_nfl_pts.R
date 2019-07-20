library(rvest)
library(tidyverse)

get_pts_data <- function(df){
  pts_data <- df %>% 
    html_nodes('pre') %>% 
    html_text() %>% 
    read_delim(delim = ';') %>% 
    set_names(c('week', 'year', 'gid', 'name', 'pos', 'team', 'location', 'opp', 'pts', 'salary'))
  
  # Be nice to the site
  Sys.sleep(sample(seq(0,2,0.5), 1))
  
  pts_data %>% 
    mutate(gid = as.character(gid))
}

make_urls <- function(base_url, weeks, years, league){
  tmp <- expand.grid(base_url, weeks,'&year=', years,'&game=',league,'&scsv=1')
  paste0(tmp$Var1, tmp$Var2, tmp$Var3, tmp$Var4, tmp$Var5, tmp$Var6, tmp$Var7)
}

# Example URL below
# http://rotoguru1.com/cgi-bin/fyday.pl?week=17&year=2017&game=fd&scsv=1
base_url <- 'http://rotoguru1.com/cgi-bin/fyday.pl?week='
weeks <- 1:17 # only covers regular season

# fanduel goes back to 2011, draft kings to 2014, yahoo to 2016
# fd = fanduel, dk = draft kings, yh = yahoo
fd_urls <- make_urls(base_url, weeks, 2011:2018, 'fd')
dk_urls <- make_urls(base_url, weeks, 2014:2018, 'dk')
yh_urls <- make_urls(base_url, weeks, 2016:2018, 'yh')

fanduel_data <- map(fd_urls, ~read_html(.x) %>% get_pts_data())
draftkings_data <- map(dk_urls, ~read_html(.x) %>% get_pts_data())
yahoo_data <- map(yh_urls, ~read_html(.x) %>% get_pts_data())

fanduel_data %>% 
  bind_rows() %>% 
  write_csv('processed_data/fanduel_nfl_2011_2017.csv')

draftkings_data %>% 
  bind_rows() %>% 
  write_csv('processed_data/draftkings_nfl_2014_2017.csv')

yahoo_data %>% 
  bind_rows() %>% 
  write_csv('processed_data/yahoo_nfl_2016_2017.csv')
