# __author__ = "Eric Allen Youngson"
# __email__ = "eric@scneco.com"
# __copyright__ = "Copyright Dec. 2015, Succession Ecological Services"
# __license__ = "GNU Affero (GPLv3)"

cleanStateImportsEIA <- function(csv_file_in, csv_file_out, num_years, head_skip, start, end, skip){
  # Description:
  #   This function takes data in .CSV format from the US Energy
  #   Informormation Administration (EIA) and cleans it for visulization
  #   https://www.eia.gov/petroleum/imports/browser/#/?sid=PET_IMPORTS.WORLD-US-ALL.M~PET_IMPORTS.WORLD-RP_1-ALL.M~PET_IMPORTS.WORLD-RP_2-ALL.M~PET_IMPORTS.WORLD-RP_3-ALL.M~PET_IMPORTS.WORLD-RP_4-ALL.M~PET_IMPORTS.WORLD-RP_5-ALL.M~PET_IMPORTS.WORLD-RP_6-ALL.M&vs=PET_IMPORTS.WORLD-US-ALL.A
  # 
  # Args:
  #   csv_file_in:  Name of file to be read
  #   csv_file_out: Name of file to be written
  #   start:        Line number to begin reading
  #   end:          Line number to stop reading
  #   skip:         Number of lines to skip while reading
  # 
  # Returns:
  #   File: DataFrame written to .CSV

  imports <-read.csv(csv_file_in, stringsAsFactors = FALSE, header = FALSE)

  imports[imports == '--'] <- 0
  dat = sapply(imports[seq(start,end,skip),2:num_years+1], as.numeric)
  row.names(dat) <- imports[seq(start-1,end-1,skip),1]
  colnames(dat) <- imports[head_skip+1,2:num_years]
  imports_clean <- data.frame(dat)
  
  write.csv(imports_clean, file = csv_file_out)
}


#install.packages("reshape2")
library("reshape2")

tidyRefineryImportsEIA <- function(csv_file_in, csv_file_out, num_years, head_skip, end){
    # Description:
    #   
    # 
    # Args:
    #   
    # 
    # Returns:
    #   

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

