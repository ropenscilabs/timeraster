# parseit()  turns a text string into a structured description of what to do
parseit <- function(textsub) {
  #show is on - need to parse this
  textsub <- gsub("^ *|(?<= ) | *$", "", textsub, perl = TRUE) #remove double spaces
  toks <- strsplit(textsub," ")[[1]]
  startdate<-enddate<-aggup<-agglevel<-aggfunc<-aggkeepna<-acrosslevel<-acrossfunc<-acrosskeepna<-NA
  while (length(toks) > 0) {
    thetok <- toupper(toks[[1]])
    #DOIT - allow no start date or enddate
    if (grepl("^[0-9]{4}",thetok)) {
      #DOITHERE - ALLOW no start or end date with TO
      if (is.na(startdate)) {
        startdate <- thetok
        if (length(toks) > 2 && toupper(toks[[2]]) == "TO" ) {
          if (!grepl("^[0-9]{4}", toks[[3]])) {
            stop("Syntax error: invalid 2nd date ", toks[[3]], call. = FALSE)
          }
          enddate <- toks[[3]]
          print(toks)
          toks <- toks[-1]
          toks <- toks[-1] #eat start date & TO token
        } #end process enddate
      } else {#end working on date
        stop("Syntax error: more than one date", call. = FALSE)
      }
    } else if (grepl("UPTO|DOWNTO", thetok)) {#end dates
      if (length(toks) > 1 && grepl("WEEKS|MONTHS|QUARTERS|YEARS", toupper(toks[[2]]))) {
        aggup <- thetok == "UPTO"
        agglevel <- toks[[2]]
        aggfunc <- "SUM"
        aggkeepna <- FALSE
        if (length(toks) > 3 && toks[[3]] == "BY") {
          if (grepl("SUM|MEAN|MIN|MAX|VAR|STD|COUNT|MEDIAN", toupper(toks[[4]]))) {
            aggfunc <- toks[[4]]
            toks <- toks[-1] #eat two more to account for BY SUM
            toks <- toks[-1]
            cat("About check KEEPNA: t1=", toks[[1]], "t2=", toks[[2]], "t3=", toks[[3]], "\n")
            if (length(toks) > 2 && toks[[3]] == "KEEPNA") {
              cat("Doing KEEPNA TRUE\n")
              aggkeepna <- TRUE
              toks <- toks[-1]
            }
          } else {
            stop("Syntax error near aggregation BY", call. = FALSE)
          }
        } #end if BY
        toks <- toks[-1]
      } else {
        stop("Syntax error on aggregation - valid periods are WEEKS, MONTHS, QUARTERS, YEARS", call. = FALSE)
      }
    } else if (grepl("ACROSS",thetok)) {
      if (length(toks) > 1 && grepl("YEAR|MONTH", toks[[2]])) {
        acrosslevel <- toks[[2]]
        acrossfunc <- "SUM"
        acrosskeepna <- FALSE
        if (length(toks) > 3 && toks[[3]] == "BY") {
          if (grepl("SUM|MEAN|MIN|MAX|VAR|STD|COUNT|MEDIAN", toupper(toks[[4]]))) {
            acrossfunc <- toks[[4]]
            toks <- toks[-1] #eat two more to account for BY SUM
            toks <- toks[-1]
            if (length(toks) > 2 && toks[[3]] == "KEEPNA") {
              acrosskeepna <- TRUE
              toks <- toks[-1]
            }
          } else {
            stop("Syntax error near across BY", call. = FALSE)
          }
        } #end if BY
        toks <- toks[-1]
      } else {
        stop("Syntax error near ACROSS", call. = FALSE)
      }
    } else {
      stop("Syntax error: near ", thetok, call. = FALSE)
    }
    toks <- toks[-1] #eat the token
  }#end while
  args <- list(startdate = startdate, enddate = enddate, aggup = aggup,
               agglevel = agglevel, aggfunc = aggfunc, aggkeepna = aggkeepna,
               acrosslevel = acrosslevel, acrossfunc = acrossfunc,
               acrosskeepna = acrosskeepna)
  return(args)
}
