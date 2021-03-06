% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/EssentialJSONSerializer.R
\docType{class}
\name{EssentialJSONSerializer-class}
\alias{EssentialJSONSerializer-class}
\alias{EssentialJSONSerializer}
\title{EssentialJSONSerializer}
\description{
Provides functions for (de)serialization of R-specific objects to generic JSON datatype objects.
}
\details{
Following functions are provided:

\itemize{
 \item RToList: Convert complex R structures to a generic datatype list structure.
 \item RToJSON: Convert complex R structures to a generic datatype JSON structure.
 \item RFromList: Convert generic datatype list structure to complex R-specific objects.
 \item RFromJSON: Convert generic datatype JSON structure to complex R-specific objects.
}
}

\examples{
essential.serializer <- EssentialJSONSerializer$new()
list.input <- list(c(1, 2, 3, 4, 5), 
                   c(6, 7, 8), list(c(1, 2, 3)))

list.list <- essential.serializer$RToList(list.input)
list.json <- essential.serializer$RToJSON(list.input)
list.list.revert <- essential.serializer$RFromList(list.list)
list.json.revert <- essential.serializer$RFromJSON(list.json)

print(list.input)
print(list.json)

# datetime
datetime.input  <- as.POSIXct(Sys.time(), tz="UTC")

datetime.list    <- essential.serializer$RToList(datetime.input)
datetime.json    <- essential.serializer$RToJSON(datetime.input)
datetime.list.revert  <- essential.serializer$RFromList(datetime.list)
datetime.json.revert <- essential.serializer$RFromJSON(datetime.json)

print(datetime.input)
print(datetime.json)

# datetime nested
datetime.nested.input <- list(input.1 = datetime.input, 
                              input.2 = as.POSIXct(Sys.Date(), tz="UTC"))

datetime.nested.list    <- essential.serializer$RToList(datetime.nested.input)
datetime.nested.json    <- essential.serializer$RToJSON(datetime.nested.input)
datetime.nested.list.revert  <- essential.serializer$RFromList(datetime.nested.list)
datetime.nested.json.revert <- essential.serializer$RFromJSON(datetime.nested.json)

print(datetime.nested.input)
print(datetime.nested.json)

# timeseries
timeseries.input  <- xts::xts(matrix(c(5, 7, 9), ncol=1), 
                              order.by = c(as.POSIXct("2017-01-01", tz="UTC"),
                                           as.POSIXct("2017-01-02", tz="UTC"),
                                           as.POSIXct("2017-01-03", tz="UTC")))
names(timeseries.input) <- "name_series"

timeseries.list    <- essential.serializer$RToList(timeseries.input)
timeseries.json    <- essential.serializer$RToJSON(timeseries.input)
timeseries.list.revert  <- essential.serializer$RFromList(timeseries.list)
timeseries.json.revert <- essential.serializer$RFromJSON(timeseries.json)

print(timeseries.input)
print(timeseries.json)


# timeseries_n_dim
timeseriesndim.input  <- xts:::xts(matrix(c(5, 7, 9, 12, 15, 19), ncol=2), 
                                   order.by = c(as.POSIXct("2017-01-01", tz="UTC"),
                                                as.POSIXct("2017-01-02", tz="UTC"),
                                                as.POSIXct("2017-01-03", tz="UTC")))
names(timeseriesndim.input) <- c("name_series_1", "name_series_2")

timeseriesndim.list    <- essential.serializer$RToList(timeseriesndim.input)
timeseriesndim.json    <- essential.serializer$RToJSON(timeseriesndim.input)
timeseriesndim.list.revert  <- essential.serializer$RFromList(timeseriesndim.list)
timeseriesndim.json.revert <- essential.serializer$RFromJSON(timeseriesndim.json)

print(timeseriesndim.input)
print(timeseriesndim.json)


# nested timeseries
timeseries.nested.input <- list(ts1 = timeseries.input, 
                                ts2 = timeseriesndim.input)

timeseries.nested.list    <- essential.serializer$RToList(timeseries.nested.input)
timeseries.nested.json    <- essential.serializer$RToJSON(timeseries.nested.input)
timeseries.nested.list.revert  <- essential.serializer$RFromList(timeseries.nested.list)
timeseries.nested.json.revert <- essential.serializer$RFromJSON(timeseries.nested.json)

print(timeseries.nested.input)
print(timeseries.nested.json)

# series
series.input        <- data.frame(c(1, 2, 3, 4), 
                                  row.names = c("one", "two", "three", "four"))
names(series.input) <- "only_column"

series.list    <- essential.serializer$RToList(series.input)
series.json    <- essential.serializer$RToJSON(series.input)
series.list.revert  <- essential.serializer$RFromList(series.list)
series.json.revert <- essential.serializer$RFromJSON(series.json)

print(series.input)
print(series.json)


# dataframe
dataframe.input        <- data.frame(c(1, 2, 3, 4), c(4, 5, 6, 7),
                                     row.names = c("one", "two", "three", "four"))
names(dataframe.input) <- c("first_col", "second_col")

dataframe.list <- essential.serializer$RToList(dataframe.input)
dataframe.json <- essential.serializer$RToJSON(dataframe.input)
dataframe.list.revert <- essential.serializer$RFromList(dataframe.list)
dataframe.json.revert <- essential.serializer$RFromJSON(dataframe.json)

print(dataframe.input)
print(dataframe.json)
print(dataframe.json.revert)

# matrix
matrix.input  <- matrix(c(1, 2, 3, 4, 5, 6), ncol = 2, byrow = TRUE)

matrix.list        <- essential.serializer$RToList(datetime.input)
matrix.json        <- essential.serializer$RToJSON(datetime.input)
matrix.list.revert <- essential.serializer$RFromList(datetime.list)
matrix.json.revert <- essential.serializer$RFromJSON(datetime.json)

print(matrix.input)
print(matrix.json)


# Complex input
to.convert <- list(list.input           = list.input,
                datetime.input       = datetime.input,
                datetime.nested      = datetime.nested.input,
                timeseries.input     = timeseries.input,
                timeseriesndim.input = timeseriesndim.input,
                series.input         = series.input,
                dataframe.input      = dataframe.input,
                matrix.input         = matrix.input,
                timeseries.nested    = timeseries.nested.input)


r.list   <- essential.serializer$RToList(to.convert)
r.json   <- essential.serializer$RToJSON(to.convert)
r.list.revert <- essential.serializer$RFromList((r.list))
r.json.revert <- essential.serializer$RFromJSON(r.json)

#print(to.convert)
print(r.json)

}
