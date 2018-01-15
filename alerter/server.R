#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(RSiteCatalyst)
##
# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
   
  ############## Auth and get Data ###########################
  ## auth with SC & get rsids
  report_suites <- eventReactive(input$button_api, {
    SCAuth(input$api_id, input$api_key)
    GetReportSuites()
  })
  
  ## create selector for RSID
  output$controlsRSID <- renderUI({
    validate(
      need(input$button_api == TRUE,"Authenticating now")
    )
    df1 <- report_suites()
    selectizeInput("selectRSID","Choose RSID",choices = c("",df1$site_title), selected = "",multiple = FALSE)
  })
  
  output$select_rsid <- renderUI({
    validate(
      need((!is.null(report_suites()) && input$selectRSID != ""),"Select Report Suite")
    )
    actionButton("selected_rsid","Fetch Settings")
  })
  
  ## on selection of report suite, get evars and traffic report
  report_names <- eventReactive(input$selected_rsid, {
    GetEvars(report_suites()$rsid[report_suites()$site_title==input$selectRSID])
  })
  report_events <- eventReactive(input$selected_rsid, {
    GetSuccessEvents(report_suites()$rsid[report_suites()$site_title==input$selectRSID])
  })
  
  ## create a drop down with report names
  output$select_events <- renderUI({
    validate(
      need((!is.null(report_names())),"")
    )
    isolate(input$selected_rsid)
    selectizeInput("select_event","Select Events to watch",choices = report_events()$name, selected = "",multiple = TRUE)
  })
  
  output$select_reports <- renderUI({
    validate(
      need((!is.null(report_names())),"")
    )
    isolate(input$selected_rsid)
    selectizeInput("select_report","Select Breakdown Reports",choices = report_names()$name, selected = "",multiple = TRUE)
  })
  
  ## get scheduling frequency
  output$select_frequency <- renderUI({
    validate(
      need((!is.null(report_names())),"")
    )
    radioButtons("schedule_frequency", label = p(strong("Schedule Frequency")),
                 choices = list("Once" = 1, "Hourly" = 2 ,"Daily" = 3,"Weekly" = 4, "Monthly" = 5), 
                 selected = 1)
  })
  
  output$select_startdate <- renderUI({
    validate(
      need((!is.null(report_names())),"")
    )
    dateInput("date_start", label = p(strong("Start Date")), value = Sys.Date(),min = Sys.Date())
  })
  
  output$select_enddate <- renderUI({
    validate(
      need((!is.null(report_names())),"")
    )
    dateInput("date_end", label = p(strong("End Date")), value = Sys.Date()+1,min = Sys.Date()+1)
  })
  
  
})
