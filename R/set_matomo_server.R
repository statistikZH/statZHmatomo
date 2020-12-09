# header ------------------------------------------------------------------
# Establish connection to Matomo API
# Christian Ruiz
# 2020-10-08 2020-10-12
# MIT License

# Function description ----------------------------------------------------

#' Set Connection to Matomo API
#' @description \code{set_matomo_server} This command is required to set the specifications to connect to the server
#' @param server A character vector specifying which server to access. Currently it supports
#' the three possibilities openzh (the open data websites), webzh-dk (the data catalogue of webzh) and webzh (the websites of webzh). By default it will access webzh-dk if nothign was provided.
#'
#' @param tokenString A character vector specifying which token to access. It is an optional argument overriding the default strings. These are token_openzh, token_webzh-dk and token_webzh.
#'
#' @return The output is a connection object, that is actually a list object containing the three needed parameters to set up the connection.
#' @export
#'
#' @examples
#' conObj<-set_matomo_server(server="openzh")
#'


# Function ----------------------------------------------------------------

set_matomo_server <- function(

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
    } else if (server == "webzh-dk") {
      token_auth = paste0("&token_auth=", Sys.getenv("token_webzh-dk"))
    } else if (server == "webzh") {
      token_auth = paste0("&token_auth=", Sys.getenv("token_webzh"))
    } else if (server == "ftpzh"){
      token_auth = paste0("&token_auth=", Sys.getenv("token_ftpzh"))
    } else {

      stop("Please specify one of the three supported servers: openzh, webzh-dk, webzh or ftpzh")

    }
  }else{
    token_auth = paste0("&token_auth=", Sys.getenv(tokenString))
  }

  #set the basic urls and the idSites according to the chosen server
  if (server == "openzh") {
    url="https://piwik.opendata.swiss"
    idSite="&idSite=1"
  } else if (server == "webzh-dk") {
    url = "https://sa.abx-net.net/"
    # id of the website: https://www.zh.ch/de/politik-staat/statistik-daten/datenkatalog.html
    idSite = "&idSite=4"
  } else if (server == "webzh") {
    url = "https://www.myaspectra.ch/webstats/zhw/index.php"
    idSite = "&idSite=112"
  } else if (server == "ftpzh") {
    url="https://web-analytics-test.labs.abraxas.ch/"
    idSite="&idSite=6"
  }

  return(list=c(token_auth=token_auth,url=url,idSite=idSite))


}
