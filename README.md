
<!-- README.md is generated from README.Rmd. Please edit that file -->

![](man/figures/kt_zh.png)

# statZHmatomo

<!-- badges: start -->

[![Lifecycle:
experimental](man/figures/lifecycle-experimental.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

## Project description

The goal of `{statZHmatomo}` is to provide functions for access to the
[Matomo Reporting
API](https://developer.matomo.org/api-reference/reporting-api).

Currently, the package supports:

  - ZHWeb [Daten- und
    Publikationskatalog](https://www.zh.ch/de/politik-staat/statistik-daten/datenkatalog.html#/home)
  - ZHWeb [zh.ch](https://www.zh.ch/de.html)
  - Portal [opendata.swiss](https://opendata.swiss/de/)

The package currently contains two function: `read_matomo_data()` and
`set_matomo_server()`.

## Installation

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

## Prerequisites

Your Matomo API Token needs to be added to the `.Renviron` file before
the functions can be used. The token is then called via
`Sys.getenv("token")`. This ensures that tokens are do not need to be
pasted into scripts.

To add your token, follow these steps:

1.  Install R Package {usethis} by executing
    `install.packages("usethis")` in R Console.

2.  Execute `usethis::edit_r_environ()` in R Console.

3.  Replace YOUR\_TOKEN with your token. One line per token and with the
    following names:
    
    \# ZHweb Datenkataliog Matomo token  
    token\_webzh-dk = “YOUR\_TOKEN”
    
    \# opendata.swiss Matomo token  
    token\_openzh = “YOUR\_TOKEN”
    
    \# ZHWeb Token  
    token\_webzh = “YOUR\_TOKEN”

4.  Save `.Renviron` file via “File -\> Save” or “Ctrl / Cmd + S”

5.  Restart R via “Session -\> Restart R” or “Ctrl / Cmd + Shift +
    Enter”

## Example

This is a basic example using the API module ‘Action’ and the API action
‘getPageUrls’. More detailed information is available in the vignette
[“Getting
started”](https://statistikzh.github.io/statZHmatomo/articles/read_matamo_data.html).

``` r
# Load packages
library(statZHmatomo)
library(magrittr)

# Establish connection to one of the three servers
con_webzhdk <- set_matomo_server(server = "webzh-dk")

# Store data for yesterday (preset) as object dat
dat <- read_matomo_data(connection = con_webzhdk,
        apiModule = "Actions", 
        apiAction = "getPageUrls"
        )
        
# Call object dat and produce a table with the first 8 variables
dat %>% 
  tibble::as_tibble() %>% 
  janitor::clean_names() %>% 
  dplyr::select(1:8) %>% 
  knitr::kable()
```

| label  | nb\_visits | nb\_hits | sum\_time\_spent | nb\_hits\_following\_search | nb\_hits\_with\_time\_generation | min\_time\_generation | max\_time\_generation |
| :----- | ---------: | -------: | ---------------: | --------------------------: | -------------------------------: | --------------------: | --------------------: |
| openZH |        220 |      253 |            26957 |                         221 |                              241 |                 0.001 |                 9.455 |
| search |         35 |       48 |             3384 |                          15 |                               48 |                 0.007 |                 2.183 |
| data   |         17 |       21 |             1551 |                           6 |                               21 |                 0.005 |                 0.495 |
| de     |         11 |       13 |              514 |                           6 |                               13 |                 0.001 |                 0.218 |
| ogd    |          3 |        3 |                0 |                           2 |                                3 |                 0.193 |                 1.499 |

## Contributors

  - [ruizcpr](https://github.com/ruizcrp)
  - [larnsce](https://github.com/larnsce)

## Contact

Christian Ruiz  
<christian.ruiz@statistik.ji.zh.ch>  
\+41 (0)43 259 7500

## License

[Copyright (c) \<2019\>
<Statistisches Amt Kanton Zürich>](https://github.com/statistikZH/STAT_Schablone/blob/master/LICENSE_code)

## Richtlinien für Beiträge

Wir begrüßen Beiträge. Bitte lesen Sie unsere
[CONTRIBUTING.md](https://github.com/statistikZH/STAT_Schablone/blob/master/CONTRIBUTING.md)
Datei, wenn sie daran interessiert sind. Hier finden Sie Informationen
die zeigen wie Sie beitragen können.

Bitte beachten Sie, dass dieses Projekt mit einem
[Verhaltenskodex](https://github.com/statistikZH/STAT_Schablone/blob/master/CodeOfConduct.md)
veröffentlicht wird. Mit Ihrer Teilnahme an diesem Projekt erklären Sie
sich mit dessen Bedingungen einverstanden.
