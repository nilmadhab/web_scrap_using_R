library(rvest)

fst_url="http://www.amazon.in/gp/bestsellers/kitchen/ref=zg_bs_kitchen_pg_2?ie=UTF8&pg=1"
fst_url


main_url=read_html(fst_url) %>%
  html_nodes(".zg_title a") %>%
  html_attr("href")

#go to the url, find all nodes with class zg_title and find the href tag, convert it into a list

main_url
#print the list

main_url=gsub("\n","",main_url) # remove '\n'
main_url=gsub(" ","",main_url) # remove space


main_url

product=read_html(fst_url) %>%
  html_nodes(".zg_title a") %>%
  html_text()

# similarly extarct the text of the class


product
