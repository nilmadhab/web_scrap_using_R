library(rvest)
l=1
r_id=c()
r_rat=c()
r_rev=c()
r_rd=c()

s_rat=as.numeric(s_rat)

for(n in 60:length(s_url)){
  print(n)
  if(!is.na(s_rat[n])){
    
    {
      p=ifelse(s_rat[n]>100,15,as.integer(s_rat[n]/8)+1)
      for(m in 0:(p-1)){
        page=substr(s_rurl[n],1,nchar(s_rurl[n])-1)
        page=sprintf("%s%d",page,m)
        b=read_html(page) %>%
          html_nodes(".feedback-num") %>%
          html_text()
        c=read_html(page) %>%
          html_nodes(".feedback-comment") %>%
          html_text()
        d=read_html(page) %>%
          html_nodes(".feedback-rater-date") %>%
          html_text()
        
        if(length(b)>0){
          for(j in 1:length(b)){
            r_id[l]=s_id[n]
            r_rat[l]=b[j]
            r_rev[l]=c[j]
            r_rd[l]=d[j]
            l=l+1
            print(b[j])
          }
        }
      }
    }
  }
}

rev_db=data.frame(Seller_ID=r_id,Rating=r_rat,Review=r_rev,Reviewer_Date=r_rd)
