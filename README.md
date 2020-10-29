
<!-- README.md is generated from README.Rmd. Please edit that file -->

# statZHmatomo

<!-- badges: start -->

<!-- badges: end -->

The goal of statZHmatomo is to provide functions for easy access to the
ZHWeb Matomo Reporting API. Web Analystics data is available for the
[Daten- und
Publikationskatalog](https://www.zh.ch/de/politik-staat/statistik-daten/datenkatalog.html#/home)
which is maintained by Statistisches Amt Kanton Zürich.

The package currently contains only one function `read_matomo_data`.

## Installation

As the repository is private, you first need to generate a personal
access token in <https://github.com/settings/tokens>. The token can then
be added to the .Renviron file.

Follow these steps:

1.  Generate personal access token in
    <https://github.com/settings/tokens>
2.  Click “Generate new token”
3.  Select box “repo”
4.  Click “Generate token”
5.  Copy token to clipboard
6.  Call: `usethis::edit_r_environ()` in Console
7.  Save copied token on new line as GITHUB_PAT = "YOUR_TOKEN"
7.  Save the .Renviron file
8.  Restart R via “Session -\> Restart R” or “Ctrl / Cmd + Shift +
    Enter”
9.  Go for it:

<!-- end list -->

``` r
# install.packages("devtools")
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
`Sys.getenv("token")`. To add your token, follow these steps:

1.  If not already installed, call `install.packages("usethis")`.
2.  Call `usethis::edit_r_environ`
3.  Add your token on new line as “token = "YOUR_TOKEN”
4.  Save the .Renviron file
5.  Restart R via “Session -\> Restart R” or “Ctrl / Cmd + Shift +
    Enter”

## Example

This is a basic example using the API module ‘Action’ and the API action
‘getPageUrls’.

``` r

library(statZHmatomo)
library(magrittr)

## basic example code

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

| label   | nb\_visits | nb\_hits | sum\_time\_spent | nb\_hits\_following\_search | nb\_hits\_with\_time\_generation | min\_time\_generation | max\_time\_generation |
| :------ | ---------: | -------: | ---------------: | --------------------------: | -------------------------------: | --------------------: | --------------------: |
| search  |         23 |       34 |              136 |                           1 |                               34 |                 0.009 |                 0.539 |
| openZH  |         11 |       12 |               13 |                           5 |                               12 |                 0.003 |                 0.772 |
| content |          2 |        2 |                0 |                           2 |                                2 |                 0.424 |                 1.491 |
| awel    |          1 |        1 |                1 |                           1 |                                1 |                 0.279 |                 0.279 |
| data    |          1 |        1 |                0 |                           1 |                                1 |                 0.634 |                 0.634 |
| ogd     |          1 |        1 |                0 |                          NA |                                1 |                 0.283 |                 0.283 |
