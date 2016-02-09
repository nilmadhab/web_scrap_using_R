library(rvest)

k=1
s_name=c()
s_url=c()
s_star=c()
s_rat=c()
p_name=c()
s_price=c()
s_shipinfo=c()
s_cod=c()
s_positive=c()
s_amful=c()

fst_url="http://www.amazon.in/gp/bestsellers/kitchen/ref=zg_bs_kitchen_pg_2?ie=UTF8&pg=3"
#fst_url="http://www.amazon.in/gp/bestsellers/kitchen/4294807031/ref=zg_bs_4294807031_pg_2?ie=UTF8&pg=2"
#fst_url="http://www.amazon.in/gp/bestsellers/kitchen/4286640031/ref=zg_bs_4286640031_pg_1?ie=UTF8&pg=1"

for(v in 1:1){
  fst_url=substr(fst_url,1,nchar(fst_url)-1)
  fst_url=sprintf("%s%d",fst_url,v)
  
  main_url=read_html(fst_url) %>%
    html_nodes(".zg_title a") %>%
    html_attr("href")
  main_url=gsub("\n","",main_url)
  main_url=gsub(" ","",main_url)
  
  product=read_html(fst_url) %>%
    html_nodes(".zg_title a") %>%
    html_text()
  
  for(i in 1:length(main_url)){
    
    url=tryCatch(read_html(main_url[i]) %>%
                   html_node("#olp_feature_div a") %>%
                   html_attr("href"), error=function(e) NA)
    url=paste0("http://www.amazon.in",url)
    url=paste0(url,"&startIndex=00")
    
    url_sellers=tryCatch(read_html(main_url[i]) %>%
                           html_node("#olp_feature_div a") %>%
                           html_text(),error=function(e) NA)
    z=gregexpr('[0-9]+',url_sellers)
    url_sellers=regmatches(url_sellers,z)
    url_sellers=as.numeric(url_sellers)
    if(url!="http://www.amazon.inNA&startIndex=00"){
      x=as.integer((url_sellers-1)/10)+1
      for(y in 1:x){
        seller=c()
        seller_url=c()
        price=c()
        codt=c()
        cod=c()
        shipinfo=c()
        pos=c()
        amful=c()
        z=NA
        
        print(y)
        url=substr(url,1,nchar(url)-2)
        url=sprintf("%s%d0",url,y-1)
        
        while(is.na(z))
        {
          z=read_html(url)
        }
        Sys.sleep(5)
        while(length(seller_url)==0){
          seller_url=read_html(url) %>% html_nodes(".olpSellerColumn .a-spacing-small a") %>% html_attr("href")
        }
        seller_url=paste0("http://www.amazon.in",seller_url)
        
        Sys.sleep(3)
        while(length(seller)==0){
          seller=read_html(url) %>% html_nodes(".olpSellerName") %>% html_text()
        }
        seller=gsub("  ","",seller)
        seller=gsub("\n","",seller)
        h=1
        s=c()
        for(w in 1:length(seller)){
          if(nchar(seller[w])==0){
            s=read_html(url) %>% html_nodes(".olpSellerName img") %>% html_attr("alt")
            seller[w]=s[h]
            print(s[h])
            h=h+1
          }
        }
        
        while(length(price)==0){
          price=read_html(url) %>% html_nodes(".a-text-bold > span") %>% html_text()
        }
        while(length(shipinfo)==0){
          shipinfo=read_html(url) %>% html_nodes(".olpShippingInfo") %>% html_text()
        }
        shipinfo=gsub("  ","",shipinfo)
        shipinfo=gsub("\n\n"," ",shipinfo)

        while(length(codt)==0){
          codt=read_html(url) %>% html_nodes(".a-span2") %>% html_text()
        }
        j=4
        for(g in 1:10){
          cod[g]=codt[j]
          j=j+3
        }
        while(length(pos)==0){
          pos=read_html(url) %>% html_nodes(".a-spacing-small b") %>% html_text()
        }
        while(length(amful)==0){
          amful=sub(".+isAmazonFulfilled=(.+)&se.+","\\1",seller_url)
        }
        print(product[i])
        print(seller)
        
        seller_star=c()
        seller_rat=c()
        Sys.sleep(2)        
        for(j in 1:length(seller_url)){
          a=read_html(seller_url[j]) %>% html_nodes("div.feedbackMeanRating b") %>% html_text()
          seller_star[j] <- a[1]
          seller_rat[j] <- a[2]
        }
        
        for(j in 1:length(seller_url)){
          p_name[k]=product[i]
          s_name[k]=seller[j]
          s_url[k]=seller_url[j]
          s_star[k]=seller_star[j]
          s_rat[k]=seller_rat[j]
          s_price[k]=price[j]
          s_shipinfo[k]=shipinfo[j]
          s_cod[k]=cod[j]
          s_positive[k]=pos[j]
          s_amful[k]=amful[j]
          k=k+1
        }
      }
    }
  }
}
ref_db=data.frame(Product=p_name,Seller=s_name,Star=s_star,No.ofRatings=s_rat,Price=s_price,Shipping_Info=s_shipinfo,COD=s_cod,Positive=s_positive,Amazon_Fulfilled=s_amful,URL=s_url)

s_id=str_sub(s_url,-14,-1)
s_id=gsub("/www.amazon.in","NA",s_id)
s_id=gsub("=","",s_id)
s_id=gsub("r=","",s_id)
ref_db=cbind(Seller_ID=s_id,ref_db)
rurl="http://www.amazon.in/gp/aag/ajax/paginatedFeedback.html?seller=A2E4FLA5VMHWJQ&isAmazonFulfilled=1&isCBA=&marketplaceID=A21TJRUUN4KGV&asin=B00IAPD2X4&ref_=aag_m_fb&&currentPage=1"
id=sub(".+seller=(.+)&isA.+","\\1",rurl)
s_rurl=c()
for(j in 1:length(s_url)){
  s_rurl[j]=gsub(id,s_id[j],rurl)
}
ref_db=cbind(ref_db,Rev_URL=s_rurl)
