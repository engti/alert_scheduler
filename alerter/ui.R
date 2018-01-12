#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(googleAuthR)

## header ####
header <- dashboardHeader()

## sidebar ####
sidebar <- dashboardSidebar(collapsed = T,
                            googleAuthUI("loginButton"),
                            textInput("api_id","Enter API ID",value = ""),
                            textInput("api_key","Enter API Passphrase",value = ""),
                            actionButton("button_api","Validate")
                            )

## body ####
body <- dashboardBody(
  tabsetPanel(
    tabPanel("Schedule",
             fluidRow(
               column(width=2,selectInput("select_rsid","Select Report Suite",choices = c("","UK","US","DE"),selected = "",multiple = F,selectize = T)),
               column(width=2,
                      actionButton("set_rsid","Fetch Metadata")
                      ),
               tags$style(type='text/css', ".col-sm-2 { vertical-align- middle; height- 50px; width- 100%; font-size- 30px;}")
             )),
    tabPanel("Task Tracker"),
    tabPanel("Info")
  )
)

## stich ####
ui <- dashboardPage(header, sidebar, body)

