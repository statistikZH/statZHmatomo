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
#'
#' @param apiModule A character vector of an API Module from the
#'   \href{https://developer.matomo.org/api-reference/reporting-api#api-method-list}{Reporting
#'    API Method List}
#'
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
#'
#' @return The output will be a dataframe of the selected format
#' @export
#'
#' @examples
#'
#' read_matomo_data(
#' apiModule = "Actions", apiAction = "getPageUrls"
#' )
#'
#' \dontrun{
#' read_matomo_data()
#' }
#'

# Function ----------------------------------------------------------------

read_matomo_data <- function(

  # API Method List https://developer.matomo.org/api-reference/reporting-api#api-method-list
  # API Method can be added to function

  apiModule = NULL,
  apiAction = NULL,

  date = "yesterday",
  period = "day",
  format = "csv",
  processed_report = FALSE

) {

  # use usethis::edit_r_environ to add token to .Renviron
  # format: token = "&token_auth=YOUR_TOKEN"
  # DB example: managing credentials, best practices: https://db.rstudio.com/best-practices/managing-credentials/

  token_auth = paste0("&token_auth=", Sys.getenv("token"))

  # combine apiModule and apiAction into method. useful as some methods require a modules and actions to be used separately in query
  method = paste0(apiModule, ".", apiAction)

  # basic URL
  url = "https://sa.abx-net.net/"

  # standard module API
  module = "?module=API"

  # id of the website: https://www.zh.ch/de/politik-staat/statistik-daten/datenkatalog.html
  idSite = "&idSite=4"

  # set filter_limit to -1 to return all rows
  filter_limit = "&filter_limit=-1"

  # methods with different query

  if (processed_report == TRUE) {

    method = "&method=API.getProcessedReport"
    format = "json"
    query <- paste0(url, module, method, idSite, paste0("&date=", date), paste0("&period=", period), paste0("&apiModule=", apiModule), paste0("&apiAction=", apiAction), paste0("&format=", format), token_auth)

  } else {
    query <- paste0(url, module, paste0("&method=", method), idSite, paste0("&date=", date), paste0("&period=", period), paste0("&format=", format), token_auth)
  }

  # build query


  if (format == "csv") {

    print(query)
    utils::read.csv(query, encoding = "UTF-8", skipNul = TRUE, check.names = FALSE)

  } else if (format == "json") {

    print(query)
    jsonlite::fromJSON(txt = query)


  } else if (format == "xml") {

    print(query)
    xml2::read_xml(query)

  } else {

    stop("Please define data format as 'csv', 'json' or 'xml'")

  }
}

