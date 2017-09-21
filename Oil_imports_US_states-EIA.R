# __author__ = "Eric Allen Youngson"
# __email__ = "eric@scneco.com"
# __copyright__ = "Copyright Dec. 2015, Succession Ecological Services"
# __license__ = "GNU Affero (GPLv3)"

cleanImportsEIA <- function(csv_file_in, csv_file_out, num_years, head_skip, start, end, skip){
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
