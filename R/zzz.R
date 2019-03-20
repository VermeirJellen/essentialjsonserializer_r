.onAttach <- function(libname = find.package("essentialjsonserializer"),
                      pkgname = "essentialjsonserializer") {
  packageStartupMessage(
    "EssentialJSONSerializer - Provided by Essential Data Science Consulting ltd."
  )
  packageStartupMessage(
    "  Author      - Jellen Vermeir (jellenvermeir@essentialdatascience.com)"
  )
  packageStartupMessage(
    "  Github      - https://github.com/VermeirJellen/essentialjsonserializer_r"
  )
  packageStartupMessage(
    "  Examples    - http://EssentialDataScience.com/blog/EssentialJSONSerializer"
  )
  packageStartupMessage(
    "BTC Donations - 3NmxUnuK8ZqAszzFzcpBerKsy4ajQpb8mi"
  )
}

.onLoad <- function(libname, pkgname) {
  op <- options()
  op.essentialjsonserializer <- list( essentialjsonserializer.path = "~/R-dev",
                                      essentialjsonserializer.install.args = "",
                                      essentialjsonserializer.name = "essentialjsonserializer",
                                      essentialjsonserializer.desc.author = 'person("Jellen", "Vermeir",
                                                              "jellenvermeir@essentialdatascience.com", role = c("aut", "cre"))',
                                      essentialjsonserializer.desc.license = "MIT",
                                      essentialjsonserializer.desc.suggests = NULL,
                                      essentialjsonserializer.desc = list() )
  toset <- !(names(op.essentialjsonserializer) %in% names(op))
  if (any(toset)) options(op.essentialjsonserializer[toset])
  invisible()
}