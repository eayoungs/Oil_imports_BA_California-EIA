# __author__ = "Eric Allen Youngson"
# __email__ = "eric@gmail.com"
# __copyright__ = "Copyright Dec. 2015, Succession Ecological Services"
# __license__ = "GNU Affero (GPLv3)"


#install.packages("reshape2")
library("reshape2")

function_name <- function(csv_file_in, num_years, head_skip, end){
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
    dat_var = melt(dat) # TODO eayoungs@gmail.com: Remove extraneous rows
    dat_var = dat_var$value

    # Create variable: origin
    origins_raw = imports[(head_skip+1):end, 1]
    origins = origins_raw[grepl("[[:lower:]]", origins_raw)] # Only countries of origin have lowercase letters
    origin_locs = which(grepl("[[:lower:]]", origins_raw)) # Row numbers of ^
    origin_locs = append(origin_locs, length(origins_raw)) # Add terminus of list for final repetition
    origin_diff = (diff(origin_locs)-1)*8 # Vector of differences between row numbers
    origin_var = rep.int(origins, times = origin_diff)

    # Create variable : destination
    destinations = imports[!grepl("[[:lower:]]", imports[,1]),1]
    destination_var = rep(destinations, each=num_years) # Repeat rows for each year available

    # Create variable : years
    years = melt(imports[5, 2:(num_years+1)]) # TODO eayoungs@gmail.com: Add argument to find row
    years_var = rep(years, nrow(dat)) # Repeat list of years for each permutation of origin & destination
    years_var = unlist(years_var, use.names = FALSE)

    # TODO eayoungs@gmail.com: Fix dimensions of data frame
    df = data.frame(destination_var, years_var, dat_var)#origin_var, destination_var, years_var, dat_var)

    return(df)
}
