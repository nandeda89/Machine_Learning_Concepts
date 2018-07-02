#Define Working Directory, where files would be saved
setwd('F:\\Stock analytics\\BSE')

dir.create('', showWarnings = TRUE, recursive = FALSE, mode = "0777")

#Define start and end dates, and convert them into date format
startDate = as.Date("2011-05-26", order="ymd")
endDate = as.Date("2011-06-06", order="ymd")

#work with date, month, year for which data has to be extracted
myDate = startDate
zippedFile <- tempfile() 

while (myDate <= endDate){
    filenameDate = paste(as.character(myDate, "%y%m%d"), ".csv", sep = "")
    downloadfilename=paste("eq", as.character(myDate, "%d%m%y"), "_csv.zip", sep = "")
    monthfilename=paste(as.character(myDate, "%y%m"),".csv", sep = "")
    temp =""
    
    #Generate URL
    myURL = paste("http://www.bseindia.com/bhavcopy/", downloadfilename, sep = "")
    
    #retrieve Zipped file
    tryCatch({
        #Download Zipped File
        download.file(myURL,zippedFile, quiet=TRUE, mode="wb")
        
        #Unzip file and save it in temp 
        temp <- read.csv(unzip(zippedFile)) 
        
        #Rename Columns Volume and Date
        colnames(temp)[1] <- "SYMBOL"
        colnames(temp)[2] <- "NAME"
        colnames(temp)[12] <- "VOLUME"
        #Define Date format
        temp$DATE <- as.Date(myDate, format="%d-%b-%Y")
        
        #Reorder Columns and Select relevant columns
        temp<-subset(temp,select=c("DATE","SYMBOL","NAME","OPEN","HIGH","LOW","CLOSE","LAST","VOLUME"))
        
        #Write the BHAVCOPY csv - datewise
        write.csv(temp,file=filenameDate,row.names = FALSE)
        
        #Write the csv in Monthly file
        if (file.exists(monthfilename))
        {
            write.table(temp,file=monthfilename,sep=",", eol="\n", row.names = FALSE, col.names = FALSE, append=TRUE)
        }else
        {
            write.table(temp,file=monthfilename,sep=",", eol="\n", row.names = FALSE, col.names = TRUE, append=FALSE)
        }
        
        #Write the file Symbol wise
        
        
        #Print Progress
        #print(paste (myDate, "-Done!", endDate-myDate, "left"))
    }, error=function(err){
        #print(paste(myDate, "-No Record"))
    }
    )
    myDate <- myDate+1
    #print(paste(myDate, "Next Record"))
}

#Delete temp file - Bhavcopy
junk <- dir(pattern="EQ")
file.remove(junk)
