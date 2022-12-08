## vanilla plot
library(tidy)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)
## library(ggrepel)
## library(magick)

world <- ne_countries(scale = "medium", returnclass = "sf")

str(mapdata)

p <- ggplot(world) +
    geom_sf(color = "gray",
            fill= "white",
            size = 0.6,
            ## expand = TRUE,
            ## clip = "off"
            ) +
    theme(panel.grid.major = element_line(
              color = "NA"),
          panel.background = element_rect(fill = "#d9e6f2")) +
    geom_point(data = mapdata, aes(x = longitude,
                                   y = latitude,
                                   ## color = no_agr
                                   ),
               ## shape = 18,
               size = 5, 
               color="#3d5c5c",
               position = "jitter") +
    ## geom_text_repel(data = df3, aes(label = language,
    ##                                 x = longitude,
    ##                                     y = latitude),
    ##                 color = "#538cc6",
    ##                 max.overlaps = Inf) +
    ## scale_color_manual(values = c("#3d5c5c", "#ff9999")) +
    ylab("") +    
    xlab("") +
    theme(legend.position = "none")


p

str(mapdata)

table(mapdata$macroarea)

ggsave(filename = "map-with-agr.png",
       width = 40, height = 20, units = "cm",
       plot = p)


## hack for pacific centered view

xlims = c(-30, 330) # these are the limits you want to change
ylims = c(-80,80)

mapWorld <- map_data('world', wrap=xlims, ylim=ylims)%>%
    filter(region!= "Antarctica") 

mapdata <- mydata %>%
    mutate(longitude2 = ifelse(
               longitude < -25,
               longitude + 360,
               longitude
           )) %>%
    as.data.frame

iudata <- iu %>%
  mutate(longitude2 = ifelse(
    longitude < -25,
    longitude + 360,
    longitude
  )) %>%
  as.data.frame

groupdata <- grouping %>%
  mutate(longitude2 = ifelse(
    longitude < -25,
    longitude + 360,
    longitude
  )) %>%
  as.data.frame

gramdata <- grammatical %>%
  mutate(longitude2 = ifelse(
    longitude < -25,
    longitude + 360,
    longitude
  )) %>%
  as.data.frame

p <- ggplot() +
    geom_polygon(data = mapWorld, aes(x=long,
                                      y = lat,
                                      group = group),
                 fill = "white",
                 color = "gray") +
    geom_point(data = iudata, aes(x = longitude2,
                                   y = latitude),
                                   color = "#563280",
               size = 8) +
    geom_point(data = gramdata, aes(x = longitude2,
                                   y = latitude),
             color = "#f9c60e",
             size = 10) +
    geom_point(data = groupdata, aes(x = longitude2,
                                   y = latitude),
             color = "#317b22",
             size = 10) +
#    scale_color_manual(values = c("#000000", "#317b22", "#f9c60e")) +
    theme_void() +
    theme(legend.position = "none",
          panel.background = element_rect(fill = "#ababab")
          ## panel.border = element_rect(colour = "#d1e0e0", fill=NA, size=1)
          ) 
p

ggsave(filename = "map.png",
       width = 84, height = 41, units = "cm",
       plot = p)

