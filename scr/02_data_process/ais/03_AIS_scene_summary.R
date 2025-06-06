#------------------------------------------------------------------------------
# 05. Summary AIS data per each scene analyzed
#------------------------------------------------------------------------------

library(dplyr)
library(sf)

# load ais position interpolated in the different scenes analyzed

ais <- read.csv("data/output/ais_scenes_interpolated.csv")

# obtain total number of ships per scene
ais_results <- ais |> group_by(img_ID) |> 
  summarize(ais_ships = n_distinct(mmsi),
            ais_length_mean = mean(length),
            ais_length_sd   = sd  (length),
            ais_width_mean  = mean(width),
            ais_width_sd    = sd  (width))


# Combine with scene dataset previously created (join, merge) (left join)
# scene info and spatial data
df_gpkg <- st_read("data/output/scene_data.gpkg")

# Combine with scene dataset previously created (join, merge) (left join)
cmb <- left_join(df_gpkg, ais_results, by = "img_ID")
# export spatial data
st_write(cmb, "data/output/scene_ais_data.gpkg", append = FALSE)

# remove geom fields from ais data
cmb <- cmb %>% st_drop_geometry()
# save df as csv
write.csv(cmb, "data/output/scene_ais_data.csv")









