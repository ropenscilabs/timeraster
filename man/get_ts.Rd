% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_ts.R
\name{get_ts}
\alias{get_ts}
\alias{get_ts.TimeRaster}
\alias{get_ts.default}
\title{Get time series}
\usage{
get_ts(x, long, lat)

\method{get_ts}{TimeRaster}(x, long, lat)

\method{get_ts}{default}(x, long, lat)
}
\arguments{
\item{x}{An object of class \code{\link{TimeRaster-class}}}

\item{long}{(numeric) a longitude value}

\item{lat}{(numeric) a latitude value}
}
\value{
An \code{xts} object
}
\description{
Get time series
}
\examples{
\dontrun{
zip <- system.file("examples", "prismrain.zip", package = "timeraster")
dir <- paste0(tempdir(), "/prismrain")
dir <- "prismrain"
dir.create(dir)
unzip(zip, exdir = dir)
files <- list.files(dir, full.names = TRUE, pattern = ".tif$", all.files = TRUE)

# Create raster stack from file paths
rf <- raster::stack(files)

# Create a time series object
library("xts")
ts <- xts(1:365, as.Date("2014-01-01") + 0:364)

# Create TimeRaster object
res <- time_raster(files, ts)

# Pull out xts object
get_ts(res, -67, 45)
}
}

