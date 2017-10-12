library(reshape2)
library(rjson)
library(RCurl)
library(sqldf)
library(googleVis)


TidyRefineryImportsEIA <- function(csv_file_in, csv_file_out, num_years, head_skip, end){
  # Description:
  #   This function takes data from the Energy Information administration on international oil imports to US states and produces
  #   a data frame according to the tenants of tidy data.
  #
  # Args:
  #   csv_file_in:  A string containing the name of the CSV file to be read by the function
  #   csv_file_out: A string cointaining the name of the CSV file to be written by the function
  #   num_years:    An integer denoting the number of years for which data is available
  #   head_skip:    An integer specifying the number of lines at the top of the input CSV file to be ignored
  #   end:          An integer specfying the last line of data in the file
  # 
  # Returns:
  #   df: A 'long' data frame containing all of the original data reformatted according to the tidy data paradigm

  # Read file
  imports = read.csv(csv_file_in, stringsAsFactors = FALSE, header = FALSE, na.strings=c("","NA"))

  # Reshape numerical data
  dat = imports[(head_skip+1):end, 2:(num_years+1)] # Collect relvant numerical data, still in string format
  dat = dat[complete.cases(dat),] # Remove empty rows adjacent to country of origin marker
  dat[dat == '--'] = 0 # Correct null indicator with numerical value
  dat = sapply(dat, as.numeric)
  dat_var = melt(t(dat)) # TODO eayoungs@gmail.com: Remove extraneous rows
  dat_var = dat_var$value

  # Create variable: origin
  origins_raw = imports[(head_skip+1):end, 1]
  origins = origins_raw[grepl("[[:lower:]]", origins_raw)] # Only countries of origin have lowercase letters
  origin_locs = which(grepl("[[:lower:]]", origins_raw)) # Row numbers of ^
  origin_locs = append(origin_locs, length(origins_raw)+1) # Add terminus of list for final repetition
  origin_diff = (diff(origin_locs)-1)*8 # Vector of differences between row numbers
  origin_var = rep.int(origins, times = origin_diff)

  # Create variable : destination
  destinations = imports[!grepl("[[:lower:]]", imports[,1]),1]
  destination_var = rep(destinations, each=num_years) # Repeat rows for each year available

  # Create variable : years
  years = melt(imports[5, 2:(num_years+1)]) # TODO eayoungs@gmail.com: Add argument to find row
  years_var = rep(years, nrow(dat)) # Repeat list of years for each permutation of origin & destination
  years_var = unlist(years_var, use.names = FALSE)

  df = data.frame(origin_var, destination_var, years_var, dat_var)
  write.csv(df, file = csv_file_out)

  return(df)
}


SankeyRefineryImportsEIA <- function(csv_file_in){
  # Description:
  #   This function produces a Sankey Diagram from the tidy data frame produced by the TidyRefineryImportsEIA function above.
  #   
  # Args:
  #   csv_fle_in: A string containing the name of the file produced by the TidyRefineryImportsEIA fucntion above to produce a
  #   Sankey Diagram from the oil imports by refinery.
  # 
  # Returns:
  #   A Sankey Diagram connecting international oil imports to the United States by refinery facility in a specific state  

  imports = read.csv(csv_file_in, stringsAsFactors = FALSE, row.names = 1, na.strings=c("","NA"))
  imports$dat_var = sapply(imports$dat_var, as.numeric)

  # TODO: (eayoungs@gmail.com) - Replace list of facilities with a variable to be passed as a parameter to the function
  #                            - Set default value for parameter, test for parameter & assign all unique faciliies to list
  importsSankey = sqldf("SELECT origin_var, destination_var, dat_var AS BARRELS FROM imports
                        WHERE NOT origin_var='World' AND years_var='2009' AND destination_var IN
                        ('CHEVRON USA / RICHMOND / CA',
                        'PHILLIPS 66 CO / SAN FRANCISCO / CA',
                        'VALERO REFINING CO CALIFORNIA / BENICIA / CA',
                        'SHELL OIL PRODUCTS US / MARTINEZ / CA',
                        'TESORO CORP / GOLDEN EAGLE / CA') GROUP BY 1,2")

  # Sankey diagram using googleVis
  plot(gvisSankey(importsSankey, from="origin_var", to="destination_var", weight="dat_var",
    options=list(height=800, width=850,
    sankey="{
      link:{color:{fill: 'lightgray', fillOpacity: 0.7}},
      node:{nodePadding: 5, label:{fontSize: 12}, interactivity: true, width: 20},
    }")
    )
  )
}
