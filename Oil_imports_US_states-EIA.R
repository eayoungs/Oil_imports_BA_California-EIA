# __author__ = "Eric Allen Youngson"
# __email__ = "eric@scneco.com"
# __copyright__ = "Copyright Dec. 2015, Succession Ecological Services"
# __license__ = "GNU Affero (GPLv3)"

cleanImportsEIA <- function(csv_file_in, csv_file_out){
  # Description
  # 
  # 
  # Args:
  #   
  # 
  # Returns:
  #   

  imports <-read.csv(csv_file_in, stringsAsFactors = FALSE, header = FALSE)
  
  imports[imports == '--'] <- 0
  dat = sapply(imports[seq(16,82,2),2:9], as.numeric)
  row.names(dat) <- imports[seq(15,81,2),1]
  colnames(dat) <- imports[5,2:9]
  imports_clean <- data.frame(dat)
  
  write.csv(imports_clean, file = "csv_file_out")
}


cleanRefineEIA <- function(csv_file_in, csv_file_out){
  # Description
  # 
  # 
  # Args:
  #   
  # 
  # Returns:
  #   

  imports <-read.csv(csv_file_in, stringsAsFactors = FALSE, header = FALSE)
  
  imports[imports == '--'] <- 0
  dat = sapply(imports[seq(16,82,2),2:9], as.numeric)
  row.names(dat) <- imports[seq(15,81,2),1]
  colnames(dat) <- imports[5,2:9]
  imports_clean <- data.frame(dat)
  
  write.csv(imports_clean, file = "csv_file_out")
}
