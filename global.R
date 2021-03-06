# Validation ####
library(MedfateValidation)
library(dplyr)
library(tidyr)
library(purrr)
library(ggplot2)
library(DT)
library(shiny)

old_wd <- getwd()

setwd('/home/miquel/MedfateValidation')
# setwd('/home/malditobarbudo/Documentos/00_Trabajo/CTFC/calibration_validation_medfate/work_structure/Validation')

data <- load_rdatas()

# swc
data %>%
  purrr::map(function(x) {
    res <- x[['SWC_stats']]
    res[['Site']] <- x[['code']]
    return(res)
  }) %>%
  bind_rows() %>%
  dplyr::select(Site, Layer, everything()) -> swc_table_raw

# etot
data %>%
  purrr::map(function(x) {
    res <- x[['Eplanttot_stats']]
    res <- purrr::flatten(res)
    res[['Site']] <- x[['code']]
    return(res)
  }) %>%
  bind_rows() %>%
  dplyr::select('Site', c(2, 3, 1, 5, 6, 4, 8, 9, 7)) -> etot_table_raw

setwd(old_wd)

################################################################################
theme_medfate <- function(base_size = 12, base_family = "") {
  half_line <- base_size/2
  theme(line = element_line(colour = "black", size = 0.5, linetype = 1,
                            lineend = "butt"),
        rect = element_rect(fill = NA,
                            colour = "black", size = 0.5, linetype = 1),
        text = element_text(family = base_family,
                            face = "plain", colour = "black", size = base_size,
                            lineheight = 0.9, hjust = 0.5, vjust = 0.5,
                            angle = 0, margin = margin(), debug = FALSE),
        title = element_text(),
        axis.line = element_line(),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        axis.text = element_text(size = rel(0.8)),
        axis.text.x = element_text(margin = margin(t = 0.8 * half_line),
                                   vjust = 1),
        axis.text.y = element_text(margin = margin(r = 0.8 * half_line),
                                   hjust = 1),
        axis.ticks = element_line(colour = "black"),
        axis.ticks.length = unit(half_line, "pt"),
        axis.title.x = element_text(margin = margin(t = 0.8 * half_line,
                                                    b = 0.8 * half_line),
                                    hjust = 0.85),
        axis.title.y = element_text(angle = 90,
                                    margin = margin(r = 1.1 * half_line, l = 0.8 * half_line),
                                    hjust = 0.85),
        legend.background = element_rect(colour = NA),
        legend.margin = margin(t = half_line/4, r = half_line/4,
                               b = 0, l = half_line/4, unit = "pt"),
        legend.key = element_rect(colour = NA),
        legend.key.size = unit(1.2, "lines"),
        legend.key.height = NULL,
        legend.key.width = NULL,
        legend.text = element_text(size = rel(0.8)),
        legend.text.align = NULL,
        legend.title = element_text(hjust = 0),
        legend.title.align = NULL,
        legend.position = "top",
        legend.direction = "horizontal",
        legend.justification = c(0.9,1),
        legend.box = NULL,
        # legend.spacing = unit(0.2, 'mm'),
        # legend.spacing.x = unit(0.2, 'mm'),
        # legend.spacing.y = NULL,
        panel.background = element_rect(color = NA),
        panel.border = element_rect(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.spacing = unit(half_line, "pt"),
        panel.ontop = FALSE,
        strip.background = element_rect(colour = NA),
        strip.placement = 'inside',
        strip.text = element_text(colour = "black", size = rel(0.8)),
        strip.text.x = element_text(margin = margin(t = half_line, b = half_line)),
        strip.text.y = element_text(angle = -90,
                                    margin = margin(l = half_line, r = half_line)),
        strip.switch.pad.grid = unit(0.1, "cm"),
        strip.switch.pad.wrap = unit(0.1, "cm"),
        plot.background = element_rect(colour = NA),
        plot.title = element_text(size = rel(1.2),
                                  margin = margin(b = half_line/2),
                                  hjust = 0.1),
        plot.subtitle = element_text(size = rel(0.8), hjust = 0.1,
                                     margin = margin(b = half_line/2)),
        plot.margin = margin(half_line, half_line, half_line, half_line),
        complete = TRUE)
}
