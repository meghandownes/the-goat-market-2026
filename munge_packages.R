#Basic Installs
#install.packages("devtools")


#munging packages
data_pkgs <- c("datasets", "data.table", "tidycensus", "ggfortify",
               "broom", "DT")

#scales has currency formats for plots
format_pkgs <- c("formattable","scales", "chron", "xts", "tools") 

#nice themes and plot insetting
plot_pkgs <- c("ggpmisc", "ggpubr", "dygraphs", "RColorBrewer", 
               "threejs", "r2d3", "gganimate", "gifski", "gapminder",
               "ggraph", "igraph", "data.tree", "packcircles", "treemap",
               "ggrepel", "ggthemes") 

#map interactions and functions
geospatial_pkgs <- c("leaflet", "raster", "tmap", "rmapshaper",
                     "tmaptools", "sf", "ggmap", "geosphere", "KernSmooth",
                     "stars", "terra") 

devtools::install_github("rsbivand/sp@evolution")
Sys.setenv("_SP_EVOLUTION_STATUS_"=2)
#CRS("+proj=longlat")
#sf::st_crs()

#shiny
shiny_pkgs <- c("shiny", "shinydashboard", "flexdashboard", "shinyjs", "V8")

#---Load Function

#This checks if installed first   
#Only installs missing

using<-function(...) {
  libs<-unlist(list(...))
  req<-unlist(lapply(libs,require,character.only=TRUE))
  need<-libs[req==FALSE]
  if(length(need)>0){ 
    install.packages(need)
    lapply(need,require,character.only=TRUE)
  }
}

#---Now apply to lists of packages
install.packages("tidyverse")
#using(tidyverse_pkgs)
using(data_pkgs)
using(format_pkgs)
using(plot_pkgs)
using(geospatial_pkgs)
using(shiny_pkgs)

install.packages("chron")
install.packages("formattable")
install.packages("xts")
install.packages("zoo")

install.packages("leaflet")
install.packages("raster")
install.packages("tmap")
install.packages("rmapshaper")
install.packages("ggmap")
install.packages("geosphere")
install.packages("stars")
install.packages("terra")










