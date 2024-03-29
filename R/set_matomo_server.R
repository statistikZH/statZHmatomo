# header ------------------------------------------------------------------
# Establish connection to Matomo API
# Christian Ruiz
# 2020-10-08 2020-10-12
# MIT License

# Function description ----------------------------------------------------

#' Set Connection to Matomo API
#' @description \code{set_matomo_server} This command is required to set the specifications to connect to the server
#' @param server A character vector specifying which server to access. Currently it supports
#' the four standard possibilities openzh (the open data websites), webzh-dk (the data catalogue of webzh), webzh (the websites of webzh), and ftpzh.
#' If nne of those is given, it expects another server in the form of url.server.com&idSite=33
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


      stop("Please specify either one of the supported servers: openzh, webzh-dk, webzh or ftpzh, or provide as well a different tokenString")

    }
  }else{
    print(paste0("token_auth given. Assuming that, ",server, " is a url with idSite"))
    token_auth = paste0("&token_auth=", Sys.getenv(tokenString))
  }

  #set the basic urls and the idSites according to the chosen server
  if (server == "openzh") {
    url="https://opendata.opsone-analytics.ch"
    idSite="&idSite=1"
  } else if (server == "webzh-dk") {
    url = "https://sa.abx-net.net/"
    # id of the website: https://www.zh.ch/de/politik-staat/statistik-daten/datenkatalog.html
    idSite = "&idSite=13"
  } else if (server == "webzh") {
    #url = "https://www.myaspectra.ch/webstats/zhw/index.php"
    #url = "https://webstatistik-zhw-api.myaspectra.ch"
    url = "https://webstatistik-zhw-api.myaspectra.ch/webstats/zhw/index.php"
    idSite = "&idSite=112"
  } else if (server == "ftpzh") {
    url="https://web-analytics-test.labs.abraxas.ch/"
    idSite="&idSite=6"
  }else{
    url<-strsplit(server,"&idSite")[[1]][1]
    idSite=paste0("&idSite",strsplit(server,"&idSite")[[1]][2])
  }

  return(list=c(token_auth=token_auth,url=url,idSite=idSite))


}
