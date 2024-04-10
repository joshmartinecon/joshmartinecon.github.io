
rm(list = ls())

'%ni%' <- Negate('%in%')

setwd("C:/Users/jmart/Downloads")

x <- read.csv("adoption data.csv")

z <- aggregate(x$adoptions, list(x$year), sum)
par(mar = c(5, 5, 1, 1))
plot(z$Group.1, z$x, type = "l", ylab = "Number of Adoptions of Children from Foster Care",
     xlab = "Year", cex.axis = 1.5, cex.lab = 1.5, lwd = 4)
abline(v = seq(2000, 2015, 5), lwd = 1000, col = "aliceblue")
abline(v = seq(2000, 2015, 5), lwd = 4, col = "white")
abline(h = seq(90000, 105000, 5000), lwd = 4, col = "white")
lines(z$Group.1, z$x, lwd = 6, col = "darkblue")

z <- aggregate(x$foster_care, list(x$year), sum)
par(mar = c(5, 5, 1, 1))
plot(z$Group.1, z$x, type = "l", ylab = "Number of Children in the Foster Care System",
     xlab = "Year", cex.axis = 1.5, cex.lab = 1.5, lwd = 4)
abline(v = seq(2000, 2015, 5), lwd = 1000, col = "aliceblue")
abline(v = seq(2000, 2015, 5), lwd = 4, col = "white")
abline(h = seq(380000, 480000, 20000), lwd = 4, col = "white")
lines(z$Group.1, z$x, lwd = 6, col = "darkblue")

z <- aggregate(x$adoptions / x$foster_care, list(x$year), mean)
par(mar = c(5, 5, 1, 1))
plot(z$Group.1, z$x, type = "l", ylab = "Mean Adoptions per Child in the Foster Care System",
     xlab = "Year", cex.axis = 1.5, cex.lab = 1.5, lwd = 4)
abline(v = seq(2000, 2015, 5), lwd = 1000, col = "aliceblue")
abline(v = seq(2000, 2015, 5), lwd = 4, col = "white")
abline(h = seq(0.2, 0.28, 0.02), lwd = 4, col = "white")
lines(z$Group.1, z$x, lwd = 6, col = "darkblue")


ma <- x[x$year < 2006,]
ma$treatment <- ifelse(ma$state == "massachusetts" & ma$year > 2003, 1, 0)
ma$treated <- ifelse(ma$state == "massachusetts", 1, 0)
ma$event_time <- ifelse(ma$state == "massachusetts", as.numeric(ma$year) - 2004, -1)
iplot(feols(adoptions ~ i(event_time, treated, ref = -1) + foster_care | state + year, ma))
feols(adoptions ~ treatment + foster_care | state + year, ma)
feols(adoptions ~ treatment | state + year, ma)

vt <- x[x$year > 2004 & x$year < 2012,]
vt <- vt[vt$state %ni% c("massachusetts", "connecticut", "iowa", "district of columbia", "new hampshire", "new york"),]
vt$treatment <- ifelse(vt$state == "vermont" & vt$year > 2008, 1, 0)
vt$treated <- ifelse(vt$state == "vermont", 1, 0)
vt$event_time <- ifelse(vt$state == "vermont", as.numeric(vt$year) - 2009, -1)
iplot(feols(adoptions ~ i(event_time, treated, ref = -1) + foster_care | state + year, vt))
iplot(feols(adoptions ~ i(event_time, treated, ref = -1) | state + year, vt))
feols(adoptions ~ treatment + foster_care | state + year, vt)
feols(adoptions ~ treatment | state + year, vt)


