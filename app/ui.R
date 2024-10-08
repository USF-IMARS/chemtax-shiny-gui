source("modules/quartoReport/quartoReport.R")

ui <- fluidPage(
  # App title ----
  titlePanel(markdown(paste0(
    "# Phytoplankton-From-Pigments GUI v0.0.5 \n",
    "This tool uses the [phytoclass R library](",
    "https://cran.r-project.org/web/packages/phytoclass/index.html",
    ") to estimate phytoplankton community composition from pigment data. \n",
    "\n",
    "## How to Cite \n",
    "TODO \n",
    "\n",
    "## Feedback \n",
    "Share your thoughts and report bugs by creating a new issue in the ",
    "[issue tracker](https://github.com/USF-IMARS/chemtax-shiny-gui/issues). \n",
    "Questions about phytoclass can also be directed to `phytoclass@outlook.com`."
  ))),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      img(src='img/vertical_collage.jpg', width="100%"),
      width = 2
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Tabset  ----
      tabsetPanel(type = "tabs",
        tabPanel("Upload Data Files",
          markdown(paste0(
            "Pigment samples (S matrix) and expected taxa lists (F matrix) ",
            "can be uploaded here. Defaults will be used if you do not upload."
          )),
          tabsetPanel(type = "tabs",
            tabPanel("Pigment Samples",
              markdown(paste0(
                "# Pigment Sample Matrix \n",
                "Select a pigment concentrations file to supply the ",
                "`Sample Matrix` (aka `S matrix`) of pigment samples. \n",
                "[See here for details]",
                "(https://github.com/USF-IMARS/chemtax-shiny-gui/blob/main/rmd/pigment_matrix.md)"
              )),
              fileInput("pigments_file", "Pigments .csv file.",
                multiple = FALSE,
                accept = c("text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv"
                )
              )
              # TODO: toggle pigments on/off
            ),
            tabPanel("Taxa List",
              markdown(paste(
                "# Taxa list",
                "List of taxa expected in the sample.",
                sep = "\n"
              )),
              # TODO: OPTIONAL section
              # csv upload to customize ratios and|or add rows to userMinMax
              #       allow download the default table, allow edits
              # `Ratio Matrix` (aka `F matrix`) is the ratio of pigments
              #       relative to chlorophyll a.
              # TODO: select preset dropdown (region)
              selectInput("taxaPreset", "Taxa Preset", list("all")),#, "antarctic")),
              # TODO: or custom preset upload
              fileInput("taxalist_file", "List of taxa .csv file.",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv"
                )
              )
              # TODO: ability to customize - uncheck groups in the preset
              #       example removal:
              #       Sm2 <- Sm[, -4]
            )
          )
        ),
          tabPanel("Run Clustering",
            markdown(paste0(
              'Clustering is applied across all pigment samples to ',
              'differentiate between samples taken under different conditions. ',
              'A "dynamic tree cut" algorithm is applied to generate the tree.'
            )),
            quartoReportUI("cluster",
              defaultSetupCode = paste(
                "inputFile <- 'pigments.rds'",
                "outputFile <- 'clusters.rds'",
                sep="\n"
              )
            )
            # TODO: save clusters .csv
          ),
          tabPanel("Inspect a Cluster",
            markdown(paste0(
              "Details about the selected cluster are shown here."
            )),
            quartoReportUI("inspectCluster",
              defaultSetupCode = "selectedCluster <- 1"
            )
          ),
          tabPanel("Run Annealing on a Cluster",
            markdown(paste0(
              "Simulated annealing is run to solve the least squares ",
              "minimization problem to determine the most likely taxa in the ",
              "pigment samples selected."
            )),
            quartoReportUI("anneal",
              # TODO: fill these to match .qmd
              defaultSetupCode = paste(
                "inputFile <- 'clusters.rds'",
                "taxaFile <- 'taxa.rds'",
                "outputFile <- 'annealing.rds'",
                "seed <- 0",
                "selected_cluster <- 1",
                "niter <- 10",
                sep="\n"
              )
            )
          )
        ),
      width = 10
      )
    )
)
