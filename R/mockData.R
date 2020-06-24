# set up the basic data.table
library(data.table)
DT <- data.table(rep(1, length(moduleNames)))
DT <- transpose(DT)
moduleNames <- c("step",
                 "mining module",
                 "ore storage",
                 "processing module",
                 "refined storage",
                 "printing robot",
                 "manufacturing module",
                 "equipment storage",
                 "assembly robot",
                 "habitation module",
                 "life-support module")
names(DT) <- moduleNames
tempDT <- copy(DT)
for (i in 2:10000) {
  sel <- 0
  tempDT$step = i
  sel <- round(runif(1, 1, 11))
  tempDT[1, as.numeric(sel)] <- DT[i-1, as.numeric(sel)] + round(runif(1, 1, 5)*(i/20)) + 1
  DT <- rbind(DT, tempDT)
}

plot(DT$`mining module`, type = "l")
lines(DT$`ore storage`, col = "red")

write.csv(DT, file = "./mockData.csv")
