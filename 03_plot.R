library(dplyr)
library(geobr)
library(sf)
library(edgebundle)
library(igraph)
library(ggplot2)

sih_flow_geral <- readRDS("sih_flow_geral.rds")

seats <- read_municipal_seat() |>
  mutate(code_muni = substr(code_muni, 0, 6))

seats <- seats |>
  mutate(code_muni = substr(code_muni, 0, 6)) |>
  mutate(longitude = st_coordinates(seats)[,1],
         latitude = st_coordinates(seats)[,2]) |>
  st_drop_geometry() |>
  select(code_muni, longitude, latitude)

states <- read_state()

res <- sih_flow_geral |>
  filter(cod_res %in% seats$code_muni & cod_int %in% seats$code_muni) |>
  filter(year == 2023 & month == 6) |>
  select(3:5)


g <- graph_from_data_frame(d = res, directed = TRUE, vertices = seats)


xy <- cbind(V(g)$longitude, V(g)$latitude)
verts <- data.frame(x = V(g)$longitude, y = V(g)$latitude)

fbundle <- edge_bundle_force(g, xy, compatibility_threshold = 0.6)
# sbundle <- edge_bundle_stub(g, xy)
# hbundle <- edge_bundle_hammer(g, xy, bw = 0.7, decay = 0.5)
pbundle <- edge_bundle_path(g, xy, max_distortion = 12, weight_fac = 2, segments = 50)


ggplot() +
  geom_sf(
    data = states,
    col = "white", size = 0.1, fill = NA
  ) +
  geom_path(
    data = fbundle, aes(x, y, group = group),
    col = "#9d0191", size = 0.05
  ) +
  geom_path(
    data = fbundle, aes(x, y, group = group),
    col = "white", size = 0.005
  ) +
  geom_point(
    data = verts, aes(x, y),
    col = "#9d0191", size = 0.25
  ) +
  geom_point(
    data = verts, aes(x, y),
    col = "white", size = 0.25, alpha = 0.5
  ) +
  geom_point(
    data = verts[verts$name != "", ],
    aes(x, y), col = "white", size = 3, alpha = 1
  ) +
  labs(title = "Force Directed Edge Bundling") +
  ggraph::theme_graph(background = "black") +
  theme(plot.title = element_text(color = "white"))


ggplot() +
  geom_sf(
    data = states,
    col = "white", size = 0.1, fill = NA
  ) +
  geom_path(
    data = pbundle, aes(x, y, group = group),
    col = "#9d0191", size = 0.05
  ) +
  geom_path(
    data = pbundle, aes(x, y, group = group),
    col = "white", size = 0.005
  ) +
  geom_point(
    data = verts, aes(x, y),
    col = "#9d0191", size = 0.25
  ) +
  geom_point(
    data = verts, aes(x, y),
    col = "white", size = 0.25, alpha = 0.5
  ) +
  geom_point(
    data = verts[verts$name != "", ], aes(x, y),
    col = "white", size = 3, alpha = 1
  ) +
  labs(title = "Edge-Path Bundling") +
  ggraph::theme_graph(background = "black") +
  theme(plot.title = element_text(color = "white"))
