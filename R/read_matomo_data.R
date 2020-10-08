# header ------------------------------------------------------------------

# Establish connection to Matomo API
# Lars Schoebitz
# 2020-07-13
# MIT License

# Function description ----------------------------------------------------

#' Read data from Matomo API
#'
#' @description \code{read_matomo_data} reads data from
#'   \href{https://developer.matomo.org/api-reference/reporting-api}{Matomo
#'   Reporting HTTP API} for available methods.
#'
#'   A method is a combined API Module and API Action.
#' @param connection A connection object created by the setMatomoServer() function.
#'
#' @param apiModule A character vector of an API Module from the
#'   \href{https://developer.matomo.org/api-reference/reporting-api#api-method-list}{Reporting
#'    API Method List}
#'
#' @param idDimension A numeric vector of the Custom Dimension
#'
#' @param apiAction A character vector of an API Action for the selected API
#'   Module
#' @param date A date in standard ISO 8601 format YYYY-MM-DD. Magic character
#'   vector keywords are "today" or "yesterday".
#' @param period Period you request the statistics for. Can be any of: day,
#'   week, month, year or range. All reports are returned for the dates based on
#'   the website's time zone.
#' @param format A character vector to define the output format as CSV, XML or
#'   JSON
#' @param processed_report A logical that controls whether the method
#'   "getProcessedReport" is used for the API Action and Module. The method will
#'   return a human readable version of any other report, and include the
#'   processed metrics such as conversion rate, time on site, etc. which are not
#'   directly available in other methods.
#' @param idSubtable A numeric vector to identify a subtable. Only valid when
#' processed_report = TRUE.
#'@param pageUrl A character vector to identify the target url of a page. Only required for certain actions (documented in the Matomo API reference).
#'@param pageTitle A character vector to identify the target title of a page. Only required for certain actions (documented in the Matomo API reference).
#'
#' @return The output will be a data of the selected format
#' @export
#'
#' @examples
#'
#' read_matomo_data(
#' connection = conObj,
#' apiModule = "Actions", apiAction = "getPageUrls"
#' )
#'
#' \dontrun{
#' read_matomo_data()
#' }
#'
#'#' @description \code{setMatomoServer} This command is required to set the specifications to connect to the server
#'#' @param server A character vector specifying which server to access. Currently it supports
#' the three possibilities openzh (the open data websites), webzh-dk (the data catalogue of webzh) and webzh (the websites of webzh). By default it will access webzh-dk if nothign was provided.
#'
#'@param tokenString A character vector specifying which token to access. It is a voluntary argument overriding the default strings. These are token_openzh, token_webzh-dk and token_webzh.
#'
#'#' @return The output is a connection object, that is actually a list object containing the three needed parameters to set up the connection..
#' @export
#'
#' @examples
#' #' conObj<-setMatomoServer(server="openzh")
#'

# Function ----------------------------------------------------------------

setMatomoServer <- function(

  # Which of the three servers (openzh,webzh-dk,webzh) shall be accessed?
  server="webzh-dk",
  # Is the token string to be overriden?
  tokenString=NULL

){
  # use usethis::edit_r_environ to add tokens to .Renviron
  # format: token = "&token_auth=YOUR_TOKEN"
  # DB example: managing credentials, best practices: https://db.rstudio.com/best-practices/managing-credentials/

  #If the tokenString is not overriden, then the default tokens are used.
  if(is.null(tokenString)){
    if (server == "openzh") {
      token_auth = paste0("&token_auth=", Sys.getenv("token_openzh"))
    }else if (server == "webzh-dk") {
      token_auth = paste0("&token_auth=", Sys.getenv("token_webzh-dk"))
    }else if (server == "webzh") {
      token_auth = paste0("&token_auth=", Sys.getenv("token_webzh"))
    } else {

      stop("Please specify one of the three supported servers: openzh, webzh-dk or webzh")

    }
  }

  #set the basic urls and the idSites according to the chosen server
  if (server == "openzh") {
    url="https://piwik.opendata.swiss"
    idSite="&idSite=1"
  }else if (server == "webzh-dk") {
    url = "https://sa.abx-net.net/"
    # id of the website: https://www.zh.ch/de/politik-staat/statistik-daten/datenkatalog.html
    idSite = "&idSite=4"
  }else if (server == "webzh") {
    url=""
    idSite=""
  }

  return(list=c(token_auth=token_auth,url=url,idSite=idSite))


}


read_matomo_data <- function(

  connection = NULL,

  # API Method List https://developer.matomo.org/api-reference/reporting-api#api-method-list
  # API Method can be added to function

  apiModule = NULL,
  apiAction = NULL,

  # Custom Dimensions

  idDimension = NULL,

  # Parameters

  date = "yesterday",
  period = "day",
  format = "csv",
  processed_report = FALSE,
  idSubtable = NULL,
  pageUrl=NULL,
  pageTitle=NULL

) {
  if(is.null(connection)){
    stop("Please run conObj<-setMatomoServer(server='openzh|webzh-dk|webzh') and create a connection object first to use as an argument like connection=conObj")
  }
  token_auth<-connection[["token_auth"]]
  url<-connection[["url"]]
  idSite<-connection[["idSite"]]




  # combine apiModule and apiAction into method. useful as some methods require a modules and actions to be used separately in query
  method = paste0(apiModule, ".", apiAction)


  # standard module API
  module = "?module=API"


  # set filter_limit to -1 to return all rows
  filter_limit = "&filter_limit=-1"

  # set expanded to 1 as needed for Actions Module
  expanded = "&expanded=1"

  # methods with different query

  if (processed_report == TRUE) {

    method = "&method=API.getProcessedReport"
    format = "json"

    query <- paste0(
      url, module, method, idSite, paste0("&date=", date),
      paste0("&period=", period), paste0("&apiModule=", apiModule),
      paste0("&idDimension=", idDimension),
      paste0("&apiAction=", apiAction), paste0("&idSubtable=", idSubtable),
      paste0("&format=", format), token_auth
    )

  } else {
    query <- paste0(
      url, module, paste0("&method=", method), idSite,
      paste0("&idDimension=", idDimension),
      paste0("&date=", date), paste0("&period=", period),
      expanded, paste0("&format=", format), token_auth
    )
  }
  #The following adds the parameters pageUrl and idSite if provided
  if (!is.null(pageUrl)){
    query <- paste0(query,"&pageUrl=",pageUrl)
  }
  if (!is.null(pageTitle)){
    query <- paste0(query,"&pageTitle=",pageTitle)
  }


  # build query


  if (format == "csv") {

    #print(query)
    utils::read.csv(query, encoding = "UTF-8", skipNul = TRUE, check.names = FALSE)

  } else if (format == "json") {

    #print(query)
    jsonlite::fromJSON(txt = url(query, open = "rb"))


  } else if (format == "xml") {

    #print(query)
    xml2::read_xml(x = url(query, open = "rb"))

  } else {

    stop("Please define data format as 'csv', 'json' or 'xml'")

  }
}
