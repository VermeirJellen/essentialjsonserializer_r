Sys.setenv(tz="UTC")

#' JSON serialization of complex R-objects \cr
#'
#' The intention of the package fuctionality is to (de)serialize language specific complex objects towards generic 
#' JSON-datatype objects. The JSON conversion allows for flexible cross language communication when the package is implemented
#' in different languages. This package provides an R implementation of the (de)serialization functionality.
#' 
#' 
#' Currently, 6 generic complex JSON-datatypes are provided. Corresponding R-mappings are defined as follows:
#' 
#' \itemize{
#'  \item JSON datetime         - maps to POSIXct objects
#'  \item JSON timeseries       - maps to 1-dimensional xts objects
#'  \item JSON timeseries_n_dim - maps to n-dimensional xts objects (n > 1)
#'  \item JSON series:          - maps to 1-dimensional dataframe objects
#'  \item JSON dataframe:       - maps to n-dimensional dataframe objects (n > 1)
#'  \item JSON matrix:          - maps to matrix objects
#' }
#'
#' The package provides the user with the EssentialJSONSerializer reference class. Following functions
#' are provided:
#' \itemize{
#'  \item RToList: Convert complex R structures to a generic datatype list structure.
#'  \item RToJSON: Convert complex R structures to a generic datatype JSON structure.
#'  \item RFromList: Convert generic datatype list structure to complex R-specific objects.
#'  \item RFromJSON: Convert generic datatype JSON structure to complex R-specific objects.
#' }
#'
#' Examples: \cr
#'  - https://github.com/VermeirJellen/essentialjsonserializer_r \cr
#'  - http://EssentialDataScience.com/blog/essentialjsonserializer \cr
#'
#' @docType package
#' @name essentialjsonserializer
NULL

#' EssentialJSONSerializer
#'
#' Provides functions for (de)serialization of R-specific objects to generic JSON datatype objects.
#'
#' Following functions are provided:
#' 
#' \itemize{
#'  \item RToList: Convert complex R structures to a generic datatype list structure.
#'  \item RToJSON: Convert complex R structures to a generic datatype JSON structure.
#'  \item RFromList: Convert generic datatype list structure to complex R-specific objects.
#'  \item RFromJSON: Convert generic datatype JSON structure to complex R-specific objects.
#' }
#' 
#' @examples
#
#' essential.serializer <- EssentialJSONSerializer$new()
#' list.input <- list(c(1, 2, 3, 4, 5), 
#'                    c(6, 7, 8), list(c(1, 2, 3)))
#' 
#' list.list <- essential.serializer$RToList(list.input)
#' list.json <- essential.serializer$RToJSON(list.input)
#' list.list.revert <- essential.serializer$RFromList(list.list)
#' list.json.revert <- essential.serializer$RFromJSON(list.json)
#' 
#' print(list.input)
#' print(list.json)
#' 
#' # datetime
#' datetime.input  <- as.POSIXct(Sys.time(), tz="UTC")
#' 
#' datetime.list    <- essential.serializer$RToList(datetime.input)
#' datetime.json    <- essential.serializer$RToJSON(datetime.input)
#' datetime.list.revert  <- essential.serializer$RFromList(datetime.list)
#' datetime.json.revert <- essential.serializer$RFromJSON(datetime.json)
#' 
#' print(datetime.input)
#' print(datetime.json)
#' 
#' # datetime nested
#' datetime.nested.input <- list(input.1 = datetime.input, 
#'                               input.2 = as.POSIXct(Sys.Date(), tz="UTC"))
#' 
#' datetime.nested.list    <- essential.serializer$RToList(datetime.nested.input)
#' datetime.nested.json    <- essential.serializer$RToJSON(datetime.nested.input)
#' datetime.nested.list.revert  <- essential.serializer$RFromList(datetime.nested.list)
#' datetime.nested.json.revert <- essential.serializer$RFromJSON(datetime.nested.json)
#' 
#' print(datetime.nested.input)
#' print(datetime.nested.json)
#' 
#' # timeseries
#' timeseries.input  <- xts::xts(matrix(c(5, 7, 9), ncol=1), 
#'                               order.by = c(as.POSIXct("2017-01-01", tz="UTC"),
#'                                            as.POSIXct("2017-01-02", tz="UTC"),
#'                                            as.POSIXct("2017-01-03", tz="UTC")))
#' names(timeseries.input) <- "name_series"
#' 
#' timeseries.list    <- essential.serializer$RToList(timeseries.input)
#' timeseries.json    <- essential.serializer$RToJSON(timeseries.input)
#' timeseries.list.revert  <- essential.serializer$RFromList(timeseries.list)
#' timeseries.json.revert <- essential.serializer$RFromJSON(timeseries.json)
#' 
#' print(timeseries.input)
#' print(timeseries.json)
#' 
#' 
#' # timeseries_n_dim
#' timeseriesndim.input  <- xts:::xts(matrix(c(5, 7, 9, 12, 15, 19), ncol=2), 
#'                                    order.by = c(as.POSIXct("2017-01-01", tz="UTC"),
#'                                                 as.POSIXct("2017-01-02", tz="UTC"),
#'                                                 as.POSIXct("2017-01-03", tz="UTC")))
#' names(timeseriesndim.input) <- c("name_series_1", "name_series_2")
#' 
#' timeseriesndim.list    <- essential.serializer$RToList(timeseriesndim.input)
#' timeseriesndim.json    <- essential.serializer$RToJSON(timeseriesndim.input)
#' timeseriesndim.list.revert  <- essential.serializer$RFromList(timeseriesndim.list)
#' timeseriesndim.json.revert <- essential.serializer$RFromJSON(timeseriesndim.json)
#' 
#' print(timeseriesndim.input)
#' print(timeseriesndim.json)
#' 
#' 
#' # nested timeseries
#' timeseries.nested.input <- list(ts1 = timeseries.input, 
#'                                 ts2 = timeseriesndim.input)
#' 
#' timeseries.nested.list    <- essential.serializer$RToList(timeseries.nested.input)
#' timeseries.nested.json    <- essential.serializer$RToJSON(timeseries.nested.input)
#' timeseries.nested.list.revert  <- essential.serializer$RFromList(timeseries.nested.list)
#' timeseries.nested.json.revert <- essential.serializer$RFromJSON(timeseries.nested.json)
#' 
#' print(timeseries.nested.input)
#' print(timeseries.nested.json)
#' 
#' # series
#' series.input        <- data.frame(c(1, 2, 3, 4), 
#'                                   row.names = c("one", "two", "three", "four"))
#' names(series.input) <- "only_column"
#' 
#' series.list    <- essential.serializer$RToList(series.input)
#' series.json    <- essential.serializer$RToJSON(series.input)
#' series.list.revert  <- essential.serializer$RFromList(series.list)
#' series.json.revert <- essential.serializer$RFromJSON(series.json)
#' 
#' print(series.input)
#' print(series.json)
#' 
#' 
#' # dataframe
#' dataframe.input        <- data.frame(c(1, 2, 3, 4), c(4, 5, 6, 7),
#'                                      row.names = c("one", "two", "three", "four"))
#' names(dataframe.input) <- c("first_col", "second_col")
#' 
#' dataframe.list <- essential.serializer$RToList(dataframe.input)
#' dataframe.json <- essential.serializer$RToJSON(dataframe.input)
#' dataframe.list.revert <- essential.serializer$RFromList(dataframe.list)
#' dataframe.json.revert <- essential.serializer$RFromJSON(dataframe.json)
#' 
#' print(dataframe.input)
#' print(dataframe.json)
#' print(dataframe.json.revert)
#' 
#' # matrix
#' matrix.input  <- matrix(c(1, 2, 3, 4, 5, 6), ncol = 2, byrow = TRUE)
#' 
#' matrix.list        <- essential.serializer$RToList(datetime.input)
#' matrix.json        <- essential.serializer$RToJSON(datetime.input)
#' matrix.list.revert <- essential.serializer$RFromList(datetime.list)
#' matrix.json.revert <- essential.serializer$RFromJSON(datetime.json)
#' 
#' print(matrix.input)
#' print(matrix.json)
#' 
#' 
#' # Complex input
#' to.convert <- list(list.input           = list.input,
#'                 datetime.input       = datetime.input,
#'                 datetime.nested      = datetime.nested.input,
#'                 timeseries.input     = timeseries.input,
#'                 timeseriesndim.input = timeseriesndim.input,
#'                 series.input         = series.input,
#'                 dataframe.input      = dataframe.input,
#'                 matrix.input         = matrix.input,
#'                 timeseries.nested    = timeseries.nested.input)
#' 
#' 
#' r.list   <- essential.serializer$RToList(to.convert)
#' r.json   <- essential.serializer$RToJSON(to.convert)
#' r.list.revert <- essential.serializer$RFromList((r.list))
#' r.json.revert <- essential.serializer$RFromJSON(r.json)
#' 
#' #print(to.convert)
#' print(r.json)
#' 
#' @import xts
#' @export EssentialJSONSerializer
EssentialJSONSerializer <- setRefClass("EssentialJSONSerializer",
   
   methods = list(
     
     RToList = function(to.convert){
       
       # convert R POSIXct to datetime list
       if(.DatetimeTypecheck(to.convert)){
         to.convert <- .DatetimeToList(to.convert, "datetime")
       }
       
       # convert R xts (1-dim) to timeseries list
       else if(.TimeseriesTypecheck(to.convert)){
         to.convert <- .TimeseriesToList(to.convert, "timeseries")
       }
       
       # Convert R xts (n-dim) to timeseries-n-dim list
       else if(.TimeseriesNDimTypecheck(to.convert)){
         to.convert <- .TimeseriesNDimToList(to.convert, "timeseries_n_dim")
       }
       
       # Convert R dataframe (1-dim) to series list
       else if(.SeriesTypecheck(to.convert)){
         to.convert <- .SeriesToList(to.convert, "series")
       }
       
       # Convert R dataframe (n-dim) to dataframe list
       else if(.DataframeTypecheck(to.convert)){
         to.convert <- .DataframeToList(to.convert, "dataframe")
       }
       
       # Convert R matrix to matrix list
       else if(.MatrixTypecheck(to.convert)){
         to.convert <- .MatrixToList(to.convert, "matrix")
       }
       else if(is(to.convert, "list") & length(to.convert) != 0){
         for(key in seq(1, length(to.convert))){
           if(!is.null(to.convert[[key]])){
            to.convert[[key]] <- RToList(to.convert[[key]])
           }
         }
       }
       return(to.convert)
     },
     
     RToJSON = function(to.convert){
       return(as.character(jsonlite::toJSON(RToList(to.convert), 
                               auto_unbox=TRUE, digits = 8, na = "null", null = "null")))
     },
     
     RFromList = function(to.convert){
    
        # Convert datetime list to R POSIXct
        if(.TypeCheckFromList(to.convert, "datetime")){
          to.convert <- .DatetimeFromList(to.convert)
        }
           
        # Convert timeseries list to R XTS (1-dim)
        else if(.TypeCheckFromList(to.convert, "timeseries")){
          to.convert <- .TimeseriesFromList(to.convert)
        }
       
        # Convert timeseries_n_dim list to R XTS (n-dim)
        else if(.TypeCheckFromList(to.convert, "timeseries_n_dim")){
          to.convert <- .TimeseriesNDimFromList(to.convert)
        }
       
        # Convert series list to R dataframe (1-dim)
        else if(.TypeCheckFromList(to.convert, "series")){
          to.convert <- .SeriesFromList(to.convert)
        }
       
        # Convert datetime list to R dataframe (n-dim)
        else if(.TypeCheckFromList(to.convert, "dataframe")){
           to.convert <- .DataframeFromList(to.convert)
        }
       
        # Convert datetime list to R Matrix
        else if(.TypeCheckFromList(to.convert, "matrix")){
          to.convert <- .MatrixFromList(to.convert)
        }
     
        # recursion
        else if(is(to.convert, "list") & length(to.convert) > 0){
          
          for(key in seq(1, length(to.convert))){
            if(!is.null(to.convert[[key]])){
              to.convert[[key]] <- RFromList(to.convert[[key]])
            }
          }
        }
       
       return(to.convert)
     },
     
     RFromJSON = function(to.convert){
       return(RFromList(jsonlite::fromJSON(to.convert, simplifyMatrix = FALSE)))
     },
     
     #Check from custom type
     .TypeCheckFromList = function(input.values, custom.type.name){
       if(is(input.values, "list") & "_type" %in% names(input.values)){
         if(input.values$'_type' == custom.type.name){
           return(TRUE)
         }
       }
       return(FALSE)
     },
     
     ##########################
     ###### datetime ##########
     ##########################
     
     # check language specific datetime format
     .DatetimeTypecheck = function(input.values){
       return(is(input.values, "POSIXct"))
     },
     
     # Convert lanugage specific datetime object to datetime dict
     .DatetimeToList = function(datetime.r, custom.type.name){
       datetime.list <- list("_type" = custom.type.name, 
                             "_data" = strftime(datetime.r, format="%Y-%m-%dT%H:%M:%OS"))
       return(datetime.list)
     },
     
     # convert datetime dict to language specific datetime object
     .DatetimeFromList = function(input.values){
       return(as.POSIXct(input.values$`_data`, format = "%Y-%m-%dT%H:%M:%OS", tz="UTC"))
     },
     
     
     
     ##########################
     ###### timeseries ########
     ##########################
     
     # check language specific timeseries format
     .TimeseriesTypecheck = function(input.values){
       
       if(!is(input.values, "xts")){
         return(FALSE)
       }
       if(!(ncol(input.values) == 1)){
         return(FALSE)
       }
       
       return(TRUE)
     },
     
     # Convert language specific timeseries object to timeseries dict
     .TimeseriesToList = function(timeseries.r, custom.type.name){
       
       series.name       <- names(timeseries.r)
       series.timestamps <- strftime(zoo::index(timeseries.r), format="%Y-%m-%dT%H:%M:%OS")
       series.values     <- as.vector(zoo::coredata(timeseries.r))
       
       timeseries.data <- list("_timestamps"     = series.timestamps,
                               series.name = series.values)
       # update column name
       names(timeseries.data) <- c("_timestamps", series.name)
       
       timeseries.list <- list("_type" = custom.type.name, 
                               "_data" = timeseries.data)
       return(timeseries.list)
     },
     
     # Convert timeseries dict to language specific timeseries object
     .TimeseriesFromList = function(input.values){
       
       timeseries.list  <- input.values$`_data`
       
       # Extract timeindex
       xts.index <- as.POSIXct(timeseries.list$`_timestamps`, 
                               format = "%Y-%m-%dT%H:%M:%OS", tz="UTC")
       
       # Extract values
       list.names            <- names(timeseries.list)
       xts.key               <- list.names[which(list.names != "_timestamps")]
       xts.values            <- as.matrix(timeseries.list[[xts.key]], ncol=1)
       
       xts.timeseries        <- xts::xts(xts.values, order.by = xts.index)
       names(xts.timeseries) <- xts.key
       
       return(xts.timeseries)
     },
     
     
     
     ##################################
     ###### timeseries_n_dim ##########
     ##################################
     
     # check language specific timeseries_n_dim format
     .TimeseriesNDimTypecheck = function(input.values){
       if(!is(input.values, "xts")){
         return(FALSE)
       }
       if(!(ncol(input.values) > 1)){
         return(FALSE)
       }
       
       return(TRUE)
     },
     
     # Convert language specific timeseries object to timeseries dict
     .TimeseriesNDimToList = function(timeseries.r, custom.type.name){
       
       series.names      <- names(timeseries.r)
       series.timestamps <- strftime(zoo::index(timeseries.r), format="%Y-%m-%dT%H:%M:%OS")
       series.values     <- zoo::coredata(timeseries.r)
       
       timeseries.data <- list("_timestamps"     = series.timestamps)
       
       for(i in seq(1, ncol(series.values))){
         timeseries.data[[i+1]] <- series.values[,i]
       }
       
       # update column name
       names(timeseries.data) <- c("_timestamps", series.names)
       
       timeseries.list <- list("_type" = custom.type.name, 
                               "_data" = timeseries.data)
       return(timeseries.list)
     },
     
     # Convert timeseries dict to language specific timeseries object
     .TimeseriesNDimFromList = function(input.values){
       
       timeseries.list  <- input.values$`_data`
       
       # Extract timeindex
       xts.index <- as.POSIXct(timeseries.list$`_timestamps`, 
                               format = "%Y-%m-%dT%H:%M:%OS", tz="UTC")
       
       # Extract values
       xts.timeseries <- xts::xts(, order.by = xts.index)
       list.names     <- names(timeseries.list)
       xts.keys       <- list.names[which(list.names != "_timestamps")]
       
       for(key in xts.keys){
         xts.values.key <- as.matrix(timeseries.list[[key]], ncol=1)
         xts.timeseries <- cbind(xts.timeseries, xts.values.key)
       }
       
       names(xts.timeseries) <- xts.keys
       
       return(xts.timeseries)
     },
     
     
     
     ##################################
     ###### series ####################
     ##################################
     
     # check language specific series format
     .SeriesTypecheck = function(input.values){
       if(!is(input.values, "data.frame")){
         return(FALSE)
       }
       if(!(ncol(input.values) == 1)){
         return(FALSE)
       }
       return(TRUE)
     },
     
     # Convert language specific timeseries object to timeseries dict
     .SeriesToList = function(df.r, custom.type.name = "series"){
       
       # Extract series name
       df.name   <- names(df.r)
       # Extract series values
       df.values <- df.r[,1]
       # Extract series index
       df.index  <- rownames(df.r)
       
       # Construct data list
       list.data        <- list("_index" = df.index,
                                values   = df.values)
       names(list.data) <- c("_index", df.name)
       
       # Consstruct series list
       df.list <- list("_type" = custom.type.name,
                       "_data" = list.data)
       
       return(df.list)
     },
     
     # Convert series dict to language specific timeseries object
     .SeriesFromList = function(input.values){
       
       list.data <- input.values$`_data`
       
       # Extract index
       df.index  <- list.data$`_index`
       
       # Extract values
       list.names            <- names(list.data)
       df.name               <- list.names[which(list.names != "_index")]
       df.values             <- list.data[[df.name]]
       
       # Construct dataframe
       df.series             <- data.frame(df.values, row.names = df.index)
       names(df.series)      <- df.name
       
       return(df.series)
     },
     
     
     
     ##################################
     ###### dataframe #################
     ##################################
     
     # check language specific datetime format
     .DataframeTypecheck = function(input.values){
       if(!is(input.values, "data.frame")){
         return(FALSE)
       }
       if(!(ncol(input.values) > 1)){
         return(FALSE)
       }
       return(TRUE)
     },
     
     # Convert language specific dataframe object to dataframe dict
     .DataframeToList = function(df.r, custom.type.name = "dataframe"){
       
       # Extract series name
       df.names  <- names(df.r)
       df.index  <- rownames(df.r)
       
       # Construct data list
       list.data <- list("_index" = df.index)
       
       # Construct 
       for(i in seq(1, ncol(df.r))){
         list.data[[i+1]] <- df.r[,i]
       }
       
       names(list.data) <- c("_index", df.names)
       
       # Consstruct series list
       df.list <- list("_type" = custom.type.name,
                       "_data" = list.data)
       
       return(df.list)
     },
     
     # Convert dataframe dict to language specific dataframe object
     .DataframeFromList = function(input.values){
       
       list.data <- input.values$`_data`
       
       # Extract index
       df.index  <- list.data$`_index`
       
       # empty dataframe
       if(length(df.index) == 0)
         return(data.frame())
       
       # Extract values
       list.names <- names(list.data)
       df.names   <- list.names[which(list.names != "_index")]
       
       # Construct dataframe
       df.series             <- data.frame(list.data[[df.names[1]]], row.names = df.index)
       for(i in seq(2, length(df.names))){
         df.series <- cbind(df.series, list.data[[df.names[i]]])
       }
       names(df.series) <- df.names
       
       return(df.series)
     },
     
     
     
     ##################################
     ###### matrix ####################
     ##################################
     
     # check language specific datetime format
     .MatrixTypecheck = function(input.values){
       return(is(input.values, "matrix"))
     },
     
     
     .MatrixToList = function(matrix.r, custom.type.name = "matrix"){
       
       list.data <- list(matrix.r[1, ])
       for(i in seq(2, nrow(matrix.r))){
         list.data[[i]] <- matrix.r[i,]
       }
       
       matrix.list <- list("_type" = custom.type.name, 
                           "_data" = list.data)
       return(matrix.list)
     },
     
     .MatrixFromList = function(input.values){
       return(do.call("rbind", input.values$`_data`))
     }
     
   ))