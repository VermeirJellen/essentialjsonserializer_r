EssentialJSONSerializer (R package)
================
Jellen Vermeir
March 20, 2019

The intention of the package fuctionality is to (de)serialize language specific complex objects towards generic JSON-datatype objects. The JSON conversion allows for flexible cross language communication when the package is implemented across different languages. This package provides an R implementation of the (de)serialization functionality.

the package can be installed from github by using the `devtools` utility:

``` r
# install.packages("devtools") # if devtools currently not installed
devtools::install_github("VermeirJellen/essentialjsonserializer_r")
```

JSON (de)serialization of complex R-objects.
--------------------------------------------

Currently, 6 generic complex JSON-datatypes are provided. Corresponding R-mappings are defined as follows:

-   JSON **datetime** - maps to R `POSIXct` objects
-   JSON **timeseries** - maps to R 1-dimensional `xts` objects
-   JSON **timeseries\_n\_dim** - maps to R n-dimensional `xts` objects (n &gt; 1)
-   JSON **series** - maps to R 1-dimensional `dataframe` objects
-   JSON **dataframe** - maps to R n-dimensional `dataframe` objects (n &gt; 1)
-   JSON **matrix** - maps to R `matrix` objects

The package provides the user with the `EssentialJSONSerializer` reference class. Following functions are provided:

-   `RToList`: Convert complex R structures to a generic datatype list structure.
-   `RToJSON`: Convert complex R structures to a generic datatype JSON structure.
-   `RFromList`: Convert generic datatype list structure to complex R-specific objects.
-   `RFromJSON`: Convert generic datatype JSON structure to complex R-specific objects.

Examples
--------

#### **EssentialJSONSerializer Object Construction**

``` r
Sys.setenv(tz="UTC")
library(essentialjsonserializer)
essential.serializer <- EssentialJSONSerializer$new()
```

#### **list**

Serialize:

``` r
list.input <- list(c(1, 2, 3, 4, 5), 
                   c(6, 7, 8), list(c(1, 2, 3)))
list.json <- essential.serializer$RToJSON(list.input)
cat(list.json)
```

    ## [[1,2,3,4,5],[6,7,8],[[1,2,3]]]

Deserialize:

``` r
list.json.revert <- essential.serializer$RFromJSON(list.json)
```

#### **datetime**

Serialize:

``` r
datetime.input  <- as.POSIXct(Sys.time(), tz="UTC")
datetime.json   <- essential.serializer$RToJSON(datetime.input)
cat(datetime.json)
```

    ## {"_type":"datetime","_data":"2019-03-20T15:33:28"}

Deserialize:

``` r
datetime.json.revert <- essential.serializer$RFromJSON(datetime.json)
datetime.json.revert
```

    ## [1] "2019-03-20 15:33:28 UTC"

#### **datetime (nested)**

Serialize:

``` r
datetime.nested.input <- list(input.1 = datetime.input, 
                              input.2 = as.POSIXct(Sys.Date(), tz="UTC"))

datetime.nested.json    <- essential.serializer$RToJSON(datetime.nested.input)
cat(datetime.nested.json)
```

    ## {"input.1":{"_type":"datetime","_data":"2019-03-20T15:33:28"},"input.2":{"_type":"datetime","_data":"2019-03-20T00:00:00"}}

Deserialize:

``` r
datetime.nested.json.revert <- essential.serializer$RFromJSON(datetime.nested.json)
datetime.nested.json.revert
```

    ## $input.1
    ## [1] "2019-03-20 15:33:28 UTC"
    ## 
    ## $input.2
    ## [1] "2019-03-20 UTC"

#### **timeseries**

Serialize:

``` r
timeseries.input  <- xts::xts(matrix(c(5, 7, 9, NA), ncol=1), 
                              order.by = c(as.POSIXct("2017-01-01", tz="UTC"),
                                        as.POSIXct("2017-01-02", tz="UTC"),
                                        as.POSIXct("2017-01-03", tz="UTC"),
                                        as.POSIXct("2017-01-04", tz="UTC")))
names(timeseries.input) <- "name_series"

timeseries.json    <- essential.serializer$RToJSON(timeseries.input)
cat(timeseries.json)
```

    ## {"_type":"timeseries","_data":{"_timestamps":["2017-01-01T00:00:00","2017-01-02T00:00:00","2017-01-03T00:00:00","2017-01-04T00:00:00"],"name_series":[5,7,9,null]}}

Deserialize:

``` r
timeseries.json.revert <- essential.serializer$RFromJSON(timeseries.json)
timeseries.json.revert
```

    ##            name_series
    ## 2017-01-01           5
    ## 2017-01-02           7
    ## 2017-01-03           9
    ## 2017-01-04          NA

#### **timeseries\_n\_dim**

Serialize:

``` r
timeseriesndim.input  <- xts:::xts(matrix(c(5, 7, 9, 12, 15, 19), ncol=2), 
                             order.by = c(as.POSIXct("2017-01-01", tz="UTC"),
                                          as.POSIXct("2017-01-02", tz="UTC"),
                                          as.POSIXct("2017-01-03", tz="UTC")))
names(timeseriesndim.input) <- c("name_series_1", "name_series_2")

timeseriesndim.json <- essential.serializer$RToJSON(timeseriesndim.input)
cat(timeseriesndim.json)
```

    ## {"_type":"timeseries_n_dim","_data":{"_timestamps":["2017-01-01T00:00:00","2017-01-02T00:00:00","2017-01-03T00:00:00"],"name_series_1":[5,7,9],"name_series_2":[12,15,19]}}

Deserialize:

``` r
timeseriesndim.json.revert <- essential.serializer$RFromJSON(timeseriesndim.json)
timeseriesndim.json.revert
```

    ##            name_series_1 name_series_2
    ## 2017-01-01             5            12
    ## 2017-01-02             7            15
    ## 2017-01-03             9            19

#### **timeseries\_n\_dim (nested)**

Serialize:

``` r
timeseries.nested.input <- list(ts1 = timeseries.input, 
                                ts2 = timeseriesndim.input)
timeseries.nested.json <- essential.serializer$RToJSON(timeseries.nested.input)
cat(timeseries.nested.json)
```

    ## {"ts1":{"_type":"timeseries","_data":{"_timestamps":["2017-01-01T00:00:00","2017-01-02T00:00:00","2017-01-03T00:00:00","2017-01-04T00:00:00"],"name_series":[5,7,9,null]}},"ts2":{"_type":"timeseries_n_dim","_data":{"_timestamps":["2017-01-01T00:00:00","2017-01-02T00:00:00","2017-01-03T00:00:00"],"name_series_1":[5,7,9],"name_series_2":[12,15,19]}}}

Deserialize:

``` r
timeseries.nested.json.revert <- essential.serializer$RFromJSON(timeseries.nested.json)
timeseries.nested.json.revert
```

    ## $ts1
    ##            name_series
    ## 2017-01-01           5
    ## 2017-01-02           7
    ## 2017-01-03           9
    ## 2017-01-04          NA
    ## 
    ## $ts2
    ##            name_series_1 name_series_2
    ## 2017-01-01             5            12
    ## 2017-01-02             7            15
    ## 2017-01-03             9            19

#### **series**

Serialize:

``` r
series.input        <- data.frame(c(1, 2, 3, 4), 
                                  row.names = c("one", "two", "three", "four"))
names(series.input) <- "only_column"

series.json  <- essential.serializer$RToJSON(series.input)
cat(series.json)
```

    ## {"_type":"series","_data":{"_index":["one","two","three","four"],"only_column":[1,2,3,4]}}

Deserialize:

``` r
series.json.revert <- essential.serializer$RFromJSON(series.json)
series.json.revert
```

    ##       only_column
    ## one             1
    ## two             2
    ## three           3
    ## four            4

#### **dataframe**

Serialize:

``` r
dataframe.input        <- data.frame(c(1, 2, 3, 4), c(4, 5, 6, 7),
                                     row.names = c("one", "two", "three", "four"))
names(dataframe.input) <- c("first_col", "second_col")

dataframe.json <- essential.serializer$RToJSON(dataframe.input)
cat(dataframe.json)
```

    ## {"_type":"dataframe","_data":{"_index":["one","two","three","four"],"first_col":[1,2,3,4],"second_col":[4,5,6,7]}}

Deserialize:

``` r
dataframe.json.revert <- essential.serializer$RFromJSON(dataframe.json)
dataframe.json.revert
```

    ##       first_col second_col
    ## one           1          4
    ## two           2          5
    ## three         3          6
    ## four          4          7

#### **matrix**

Serialize:

``` r
matrix.input <- matrix(c(1, 2, 3, 4, 5, 6), ncol = 2, byrow = TRUE)

matrix.json <- essential.serializer$RToJSON(matrix.input)
cat(matrix.json)
```

    ## {"_type":"matrix","_data":[[1,2],[3,4],[5,6]]}

Deserialize:

``` r
matrix.json.revert <- essential.serializer$RFromJSON(matrix.json)
matrix.json.revert
```

    ##      [,1] [,2]
    ## [1,]    1    2
    ## [2,]    3    4
    ## [3,]    5    6

#### **nested structure**

Serialize:

``` r
r.input <- list(list.input           = list.input,
                datetime.input       = datetime.input,
                datetime.nested      = datetime.nested.input,
                timeseries.input     = timeseries.input,
                timeseriesndim.input = timeseriesndim.input,
                series.input         = series.input,
                dataframe.input      = dataframe.input,
                matrix.input         = matrix.input,
                timeseries.nested    = timeseries.nested.input)

                
r.json <- essential.serializer$RToJSON(r.input)
cat(r.json)
```

    ## {"list.input":[[1,2,3,4,5],[6,7,8],[[1,2,3]]],"datetime.input":{"_type":"datetime","_data":"2019-03-20T15:33:28"},"datetime.nested":{"input.1":{"_type":"datetime","_data":"2019-03-20T15:33:28"},"input.2":{"_type":"datetime","_data":"2019-03-20T00:00:00"}},"timeseries.input":{"_type":"timeseries","_data":{"_timestamps":["2017-01-01T00:00:00","2017-01-02T00:00:00","2017-01-03T00:00:00","2017-01-04T00:00:00"],"name_series":[5,7,9,null]}},"timeseriesndim.input":{"_type":"timeseries_n_dim","_data":{"_timestamps":["2017-01-01T00:00:00","2017-01-02T00:00:00","2017-01-03T00:00:00"],"name_series_1":[5,7,9],"name_series_2":[12,15,19]}},"series.input":{"_type":"series","_data":{"_index":["one","two","three","four"],"only_column":[1,2,3,4]}},"dataframe.input":{"_type":"dataframe","_data":{"_index":["one","two","three","four"],"first_col":[1,2,3,4],"second_col":[4,5,6,7]}},"matrix.input":{"_type":"matrix","_data":[[1,2],[3,4],[5,6]]},"timeseries.nested":{"ts1":{"_type":"timeseries","_data":{"_timestamps":["2017-01-01T00:00:00","2017-01-02T00:00:00","2017-01-03T00:00:00","2017-01-04T00:00:00"],"name_series":[5,7,9,null]}},"ts2":{"_type":"timeseries_n_dim","_data":{"_timestamps":["2017-01-01T00:00:00","2017-01-02T00:00:00","2017-01-03T00:00:00"],"name_series_1":[5,7,9],"name_series_2":[12,15,19]}}}}

Deserialize:

``` r
r.json.revert <- essential.serializer$RFromJSON(r.json)
r.json.revert
```

    ## $list.input
    ## $list.input[[1]]
    ## [1] 1 2 3 4 5
    ## 
    ## $list.input[[2]]
    ## [1] 6 7 8
    ## 
    ## $list.input[[3]]
    ## $list.input[[3]][[1]]
    ## [1] 1 2 3
    ## 
    ## 
    ## 
    ## $datetime.input
    ## [1] "2019-03-20 15:33:28 UTC"
    ## 
    ## $datetime.nested
    ## $datetime.nested$input.1
    ## [1] "2019-03-20 15:33:28 UTC"
    ## 
    ## $datetime.nested$input.2
    ## [1] "2019-03-20 UTC"
    ## 
    ## 
    ## $timeseries.input
    ##            name_series
    ## 2017-01-01           5
    ## 2017-01-02           7
    ## 2017-01-03           9
    ## 2017-01-04          NA
    ## 
    ## $timeseriesndim.input
    ##            name_series_1 name_series_2
    ## 2017-01-01             5            12
    ## 2017-01-02             7            15
    ## 2017-01-03             9            19
    ## 
    ## $series.input
    ##       only_column
    ## one             1
    ## two             2
    ## three           3
    ## four            4
    ## 
    ## $dataframe.input
    ##       first_col second_col
    ## one           1          4
    ## two           2          5
    ## three         3          6
    ## four          4          7
    ## 
    ## $matrix.input
    ##      [,1] [,2]
    ## [1,]    1    2
    ## [2,]    3    4
    ## [3,]    5    6
    ## 
    ## $timeseries.nested
    ## $timeseries.nested$ts1
    ##            name_series
    ## 2017-01-01           5
    ## 2017-01-02           7
    ## 2017-01-03           9
    ## 2017-01-04          NA
    ## 
    ## $timeseries.nested$ts2
    ##            name_series_1 name_series_2
    ## 2017-01-01             5            12
    ## 2017-01-02             7            15
    ## 2017-01-03             9            19

Donations
---------

If you find this software useful and/or you would like to see additional extensions, feel free to donate some btc:

-   BTC: 3NmxUnuK8ZqAszzFzcpBerKsy4ajQpb8mi

Licensing
---------

Copyright 2019 Essential Data Science Consulting ltd. ([EssentialDataScience.com](http://essentialdatascience.com "EssentialDataScience") / <jellenvermeir@essentialdatascience.com>). This software is copyrighted under the MIT license: View added [LICENSE](./LICENSE) file.
