####
# Connect to an OMERO server and import a CSV file
####

# Connect to the server
server <- OMEROServer(credentialsFile = "examples/login_credentials.txt")
server <- connect(server)

# Load the CSV with the original file ID 1
df <- loadCSV(server, 1)

# Load the image the data belongs to, image  with id 1
image <- loadObject(server, "ImageData", 1)

# Create a summary of the data
summary(df)

# Add the summary as attachment to the image
tmpfile <- "/tmp/summary.txt"
sink(tmpfile)
summary(df)
sink()
attachFile(image, tmpfile)

# Create a simple plot
plot(sqrt(df$Area)~df$Width)

# Add the plot as attachment to the image
tmpfile <- "/tmp/boxplot.png"
png(tmpfile)
plot(sqrt(df$Area)~df$Width)
dev.off()
attachFile(image, tmpfile)

# Disconnect again from the server
disconnect(server)

