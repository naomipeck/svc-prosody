library(tidyverse)
library(lingtypology)
# remotes::install_git("https://gitlab.com/laurabecker/lingtypr.git")
library(lingtypR)

full_glottolog <- lingtypology::glottolog
svc_prosody <- read.csv("svc-prosody.csv")
full_info <- merge(x=svc_prosody,y=full_glottolog,by="glottocode",all.x=TRUE)

mapping <- full_info %>%
  subset(select = -c(countries, affiliation, subclassification, area, level, iso, macroarea, family, language.x))

map.feature(mapping$language.y)

typr_full <- add_glottolog(svc_prosody, by="glottocode")
summary(typr_full)

countries <- typr_full %>%
  subset(is.na(iu) == TRUE) %>%
  subset(select = c(language, glottocode, family, macroarea.x, country_ids))

distinct <- countries %>%
  group_by(macroarea.x)

typr_mapping <- typr_full %>%
  subset(select = c(language.y, glottocode, iu, grouping, grammatical, latitude, longitude))
summary(typr_mapping)

make_map(data = typr_mapping, feature = "grouping", legend = TRUE)
make_map(data = typr_mapping, feature = "grammatical", legend = TRUE)

typr_test <- typr_mapping %>%
  mutate(coding =
           case_when(
             grouping == 1 ~ 1,
             grammatical == 1 ~ 2,
             TRUE ~ 0
           )) 
           
summary(typr_test)

typr_test$coding <- as.factor(typr_test$coding)

typr_test2 <- typr_mapping
summary(typr_test2)

typr_test2$iu[is.na(typr_test2$iu)] <- 1  
iu <- typr_test2 %>%
  subset(select = -c(grouping, grammatical))
summary(iu)
iu$iu <- as.factor(iu$iu)

typr_test2$grouping[typr_test2$grouping != "1"] <- NA
typr_test2$grouping <- as.factor(typr_test2$grouping)
grouping <- typr_test2 %>%
  subset(select = -c(iu, grammatical)) %>%
  drop_na()
summary(grouping)

typr_test2$grammatical[typr_test2$grammatical != "1"] <- NA
typr_test2$grammatical <- as.factor(typr_test2$grammatical)
grammatical <- typr_test2 %>%
  subset(select = -c(iu, grouping)) %>%
  drop_na()
summary(grammatical)
