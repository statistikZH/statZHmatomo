
<!-- README.md is generated from README.Rmd. Please edit that file -->

# statZHmatomo - R Package to access Web Analytics of Matomo Analytics

<!-- badges: start -->

<!-- badges: end -->

The goal of {statZHmatomo} is to provide functions for access to the
[Matomo Reporting
API](https://developer.matomo.org/api-reference/reporting-api).

Currently, the package supports:

  - ZHWeb [Daten- und
    Publikationskatalog](https://www.zh.ch/de/politik-staat/statistik-daten/datenkatalog.html#/home)
  - ZHWeb [zh.ch](https://www.zh.ch/de.html)
  - Portal [opendata.swiss](https://opendata.swiss/de/)

The package currently contains two function: `read_matomo_data` and
`set_matomo_server`.

## Installation

As the repository is private, you first need to generate a personal
access token in <https://github.com/settings/tokens>. The token can then
be added to the .Renviron file.

Follow these steps:

1.  Generate personal access token in
    <https://github.com/settings/tokens>
2.  Click “Generate new token”
3.  Under “Select scopes”, select box “repo”
4.  Click “Generate token”
5.  Copy token to clipboard
6.  Open R and install R Package `usethis` by executing
    `install.packages("usethis")` in R Console
7.  Execute `usethis::edit_r_environ()` in R Console
8.  Copy the GitHub Token into the .Renviron file: GITHUB\_PAT =
    “YOUR\_TOKEN”
9.  Save the .Renviron file
10. Restart R via “Session -\> Restart R” or “Ctrl / Cmd + Shift +
    Enter”
11. Go for it:

<!-- end list -->

``` r
# install.packages("devtools")
devtools::install_github("statistikZH/statZHmatomo")
```

**Proxy Error?**

Follow these steps:

1.  In RStudio click “Tools -\> Global Options”
2.  Open pane “Git/SVN”
3.  Under SSH RSA key, click “Create RSA Key…”
4.  Passphrase is optional, click “Create”
5.  Click “Close” on the opened window
6.  Click “Apply” followed by “OK”

Try again:

``` r
devtools::install_github("statistikZH/statZHmatomo")
```

More info can be found on the help page for
[`remotes::install_github`](https://remotes.r-lib.org/reference/install_github.html)
or in the official [GitHub
documentation](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
on how to create a personal access token.

## Prerequisites

Your Matomo API Token needs to be added to the .Renviron file before the
function `read_matomo_data` can be used. The token is then called via
`Sys.getenv("token")`.

To add your token, follow these steps:

1.  If not already installed, call `install.packages("usethis")`.

2.  Call `usethis::edit_r_environ()`

3.  Add each of your tokens on a new line with the following names:
    
    \# ZHweb Datenkataliog Matomo token token\_webzh-dk = “YOUR\_TOKEN”
    
    \# opendata.swiss Matomo token token\_openzh = “YOUR\_TOKEN”
    
    \# ZHWeb Token token\_webzh = “YOUR\_TOKEN”

4.  Save the .Renviron file

5.  Restart R via “Session -\> Restart R” or “Ctrl / Cmd + Shift +
    Enter”

## Example

This is a basic example using the API module ‘Action’ and the API action
‘getPageUrls’.

``` r

library(statZHmatomo)
library(magrittr)

## Example

con_webzhdk <- set_matomo_server(server = "webzh-dk")

dat <- read_matomo_data(connection = con_webzhdk,
        apiModule = "Actions", 
        apiAction = "getPageUrls"
        )
        

dat %>% 
  tibble::as_tibble() %>% 
  janitor::clean_names() %>% 
  dplyr::select(1:8) %>% 
  knitr::kable()
```

| label  | nb\_visits | nb\_hits | sum\_time\_spent | nb\_hits\_following\_search | nb\_hits\_with\_time\_generation | min\_time\_generation | max\_time\_generation |
| :----- | ---------: | -------: | ---------------: | --------------------------: | -------------------------------: | --------------------: | --------------------: |
| openZH |        502 |      605 |            51014 |                         507 |                              573 |                 0.001 |                 4.322 |
| search |         53 |       79 |             2945 |                          24 |                               79 |                 0.001 |                 3.156 |
| de     |         18 |       25 |              653 |                          10 |                               25 |                 0.004 |                 0.111 |
| ogd    |         14 |       22 |             1176 |                           5 |                               21 |                 0.019 |                 0.438 |
| data   |          7 |        8 |              747 |                           2 |                                7 |                 0.005 |                 0.679 |
| awel   |          1 |        1 |                0 |                          NA |                                1 |                 0.012 |                 0.012 |
| record |          1 |        1 |             1410 |                           1 |                                1 |                 0.172 |                 0.172 |
