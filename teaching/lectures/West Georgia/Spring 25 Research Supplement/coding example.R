# Optional: Clear the current R environment (remove all objects).
rm(list=ls())

# set working directory where your data is located
## for Mac OS try something like this: setwd("/Users/yourusername/Downloads")  
setwd("C:/Users/jmart/Downloads")

##### FOOTBALL DATASET #####

# Read in the RDS file containing the football dataset.
f <- readRDS("football data with contracts.RDS")

# Standardize the 'productivity' variable:
# (value - mean) / standard deviation.
f$std_prod <- (f$productivity - mean(f$productivity, na.rm = TRUE)) / 
  sd(f$productivity, na.rm = TRUE)

# Calculate annual earnings in millions of dollars.
f$ann_earn <- f$total / f$length / 1000000

# Aggregate (average) the standardized productivity by 'id'.
agg_prod <- aggregate(std_prod ~ id, data = f, mean, na.rm = TRUE)

# Aggregate (average) the annual earnings by 'id'.
agg_earn <- aggregate(ann_earn ~ id, data = f, mean, na.rm = TRUE)

# Match the 'ann_earn' column from agg_earn to agg_prod by matching their 'id' columns.
agg_prod$ann_earn <- agg_earn$ann_earn[ match(agg_prod$id, agg_earn$id) ]

# Assign the aggregated data to a new data frame 'x'.
x <- agg_prod

# Order 'x' by the standardized productivity column (std_prod).
x <- x[order(x$std_prod), ]

# Create a percentile column ('pctl') that goes from 0 to 100 
# (rounded to 1 decimal place, then multiplied by 100).
x$pctl <- round((1:nrow(x)) / nrow(x), 1) * 100

# Aggregate annual earnings by the percentile column, taking the mean of 'ann_earn'.
agg_x <- aggregate(ann_earn ~ pctl, data = x, mean, na.rm = TRUE)

# Adjust plot margins (bottom, left, top, right).
par(mar = c(4.5, 4.5, 1, 1))

# Create a plot of percentile vs. mean annual earnings.
plot(agg_x$pctl, agg_x$ann_earn,
     ylab = "Mean Annual Earnings",
     xlab = "Mean Productivity Pctl.",
     cex.lab = 1.5,
     cex.axis = 1.25)

# Add a vertical line at the 50% mark, colored 'aliceblue'.
abline(v = 50, lwd = 5000000, col = "aliceblue")

# Add vertical lines at every 20% mark, colored 'white'.
abline(v = seq(0, 100, 20), lwd = 4, col = "white")

# Add horizontal lines at every 1 from 0 to 6, colored 'white'.
abline(h = seq(0, 6, 1), lwd = 4, col = "white")

# Re-draw the points to place them on top (darkblue, circles).
points(agg_x$pctl, agg_x$ann_earn,
       pch = 19,
       col = "darkblue",
       cex = 1.25)

##### HOCKEY DATASET #####

# Read in the RDS file containing the hockey dataset.
h <- readRDS("hockey data with contracts.RDS")

# Standardize 'productivity' for hockey.
h$std_prod <- (h$productivity - mean(h$productivity, na.rm = TRUE)) / 
  sd(h$productivity, na.rm = TRUE)

# Calculate annual earnings in millions of dollars for hockey.
h$ann_earn <- h$total / h$length / 1000000

# Aggregate (average) standardized productivity by 'id'.
agg_prod <- aggregate(std_prod ~ id, data = h, mean, na.rm = TRUE)

# Aggregate (average) annual earnings by 'id'.
agg_earn <- aggregate(ann_earn ~ id, data = h, mean, na.rm = TRUE)

# Match the aggregated earnings to the aggregated productivity.
agg_prod$ann_earn <- agg_earn$ann_earn[ match(agg_prod$id, agg_earn$id) ]

# Assign to a new data frame 'y'.
y <- agg_prod

# Order by standardized productivity.
y <- y[order(y$std_prod), ]

# Create percentile column for hockey data.
y$pctl <- round((1:nrow(y)) / nrow(y), 1) * 100

# Aggregate annual earnings by percentile.
agg_y <- aggregate(ann_earn ~ pctl, data = y, mean, na.rm = TRUE)

# Add hockey data points to the existing plot (plum color, triangles).
points(agg_y$pctl, agg_y$ann_earn,
       pch = 17,
       col = "plum",
       cex = 1.25)

# Add a legend to distinguish Football vs. Hockey data.
legend("topleft",
       legend = c("Football", "Hockey"),
       pch = c(19, 17),
       col = c("darkblue", "plum"),
       bty = "n",
       cex = 1.25)
