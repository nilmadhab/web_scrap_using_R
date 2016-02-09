library(rvest)

url="http://www.amazon.in/s?marketplaceID=A21TJRUUN4KGV&me=ADRSR1T7JUIYC&merchant=ADRSR1T7JUIYC&redirect=true"
id=sub(".+&me=(.+)&m.+","\\1",url)

s_feedhist=c()
s_products=c()
s_about=c()
l=1

for(i in 1:300)
{
  print(i)
Table = tryCatch(read_html(s_url[i])%>% html_node(".feedbackTable")%>% html_table(),error=function(e) NA)
if(!is.na(Table)){
X1 = Table$X1[1:length(Table$X1) - 1]
X2 = Table$X2[1:length(Table$X2) - 1]
X3 = Table$X3[1:length(Table$X3) - 1]
X4 = Table$X4[1:length(Table$X4) - 1]

rm(Table)
Table = data.frame(X1,X2,X3,X4)
}

Next_Page = tryCatch(read_html(s_url[i])%>%
  html_node(".aag_storefront a")%>%
  html_attr("href"),error=function(e) NA)

n_url[i]=gsub(id,s_id[i],url)


Items_Info=NA
while(is.na(Items_Info)){
  if(s_url[i]=="http://www.amazon.in"){break}
Items_Info = tryCatch(read_html(n_url[i])%>% html_node(".s-first-column h2")%>% html_text(),error=function(e) NA)
}
read_html(s_url[i])
Sys.sleep(1)
Next_Page2=tryCatch(read_html(s_url[i]) %>% html_node(".aag_hdr_legalInfo a")%>%html_attr("href"),error=function(e) NA)
Next_Page2=paste0("http://www.amazon.in",Next_Page2)
aboutseller=tryCatch(read_html(Next_Page2)%>%html_nodes("#aag_detailsAbout p")%>%html_text(),error=function(e) NA)
print(Items_Info)
s_feedhist[[l]]=Table
s_products[l]=Items_Info
s_about[l]=aboutseller
l=l+1
}
feed=data.frame(Seller_ID=s_id,No_Of_Products=s_products,About_Seller=s_about)
feedHistory=data.frame(Table=s_feedhist)