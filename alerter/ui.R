# App to help user schedule anomaly reports
# user needs to have their api key


library(shiny)
library(shinydashboard)
library(googleAuthR)

## header ####
header <- dashboardHeader(title = "Anomaly Scheduler")

## sidebar ####
sidebar <- dashboardSidebar(collapsed = F,
                            googleAuthUI("loginButton"),
                            conditionalPanel(
                              condition = "input.button_api == 0",
                              textInput("api_id","Enter API ID",value = ""),
                              passwordInput("api_key",label = "Enter API Passphrase",value = ""),
                              actionButton("button_api","Validate")
                            ),
                            conditionalPanel(
                              condition = "input.button_api == 1",
                              column(width = 12,
                                     uiOutput("controlsRSID")
                              )
                            ),
                            conditionalPanel(
                              condition = "input.selectRSID != ''",
                              column(width = 12,
                                     uiOutput("select_rsid")
                              )
                            )
                            )

## body ####
body <- dashboardBody(
  tabsetPanel(
    tabPanel("Schedule",
             fluidRow(
               conditionalPanel(
                 condition = "input.selected_rsid != ''",
                 column(width = 6,
                        uiOutput("select_events")
                 )
               ),
               conditionalPanel(
                 condition = "input.selected_rsid != ''",
                 column(width = 6,
                        uiOutput("select_reports")
                 )
               )
             ),
             fluidRow(
               conditionalPanel(
                 condition = "input.selected_rsid != ''",
                 column(width = 3,
                        uiOutput("select_frequency")
                 ),
                 column(width = 3,
                        uiOutput("select_startdate"),
                        uiOutput("select_enddate")
                 )
               )
             )
             ## end of 1 fluid panel
             ),
    tabPanel("Task Tracker"),
    tabPanel("Info")
  )
)

## stich ####
ui <- dashboardPage(header, sidebar, body)

