#!/bin/bash

# Exit on any error
set -e

# Variables
HIVE_VERSION="3.1.3"
HADOOP_VERSION="3.4.0"
HIVE_TAR="apache-hive-${HIVE_VERSION}-bin.tar.gz"
HIVE_URL="https://downloads.apache.org/hive/hive-${HIVE_VERSION}/${HIVE_TAR}"
HIVE_HOME="/home/$USER/apache-hive-${HIVE_VERSION}-bin"
HADOOP_HOME="/home/$USER/hadoop-${HADOOP_VERSION}"

# File to be edited
FILE="${HIVE_HOME}/conf/hive-site.xml"

# XML configuration to be added
XML_CONFIG='
<property>
  <name>system:java.io.tmpdir</name>
  <value>/tmp/hive/java</value>
</property>
<property>
  <name>system:user.name</name>
  <value>${user.name}</value>
</property>
'

# Step 1: Download and Untar Hive
echo "Downloading Hive ${HIVE_VERSION}..."
# Remove any existing tar files to prevent corruption issues
rm -f /tmp/$HIVE_TAR
wget $HIVE_URL -P /tmp

# Verify the downloaded file size
EXPECTED_SIZE=326940667
ACTUAL_SIZE=$(stat -c%s /tmp/$HIVE_TAR)
if [ "$ACTUAL_SIZE" -ne "$EXPECTED_SIZE" ]; then
  echo "Downloaded file size does not match expected size. Exiting."
  exit 1
fi

echo "Extracting Hive..."
tar xzf /tmp/$HIVE_TAR -C /home/$USER

# Step 2: Configure Hive Environment Variables
echo "Configuring environment variables..."
echo "export HIVE_HOME=${HIVE_HOME}" >> ~/.bashrc
echo "export PATH=\$PATH:\$HIVE_HOME/bin" >> ~/.bashrc
source ~/.bashrc

# Step 3: Edit hive-config.sh file
echo "Configuring hive-config.sh..."
echo "export HADOOP_HOME=${HADOOP_HOME}" | sudo tee -a ${HIVE_HOME}/bin/hive-config.sh > /dev/null

# Step 4: Start Hadoop Services
echo "Starting Hadoop services..."
# Check if NameNode is already running
if ! jps | grep -q NameNode; then
    echo "NameNode is not running. Starting Hadoop services..."
    start-dfs.sh
else
    echo "NameNode is already running."
fi

# Check if ResourceManager is already running
if ! jps | grep -q ResourceManager; then
    echo "ResourceManager is not running. Starting YARN..."
    start-yarn.sh
else
    echo "ResourceManager is already running."
fi

# Step 5: Verify Hadoop Services
echo "Verifying Hadoop services..."
jps

# Check if NameNode is running
if ! jps | grep -q NameNode; then
    echo "NameNode is not running. Please check Hadoop installation."
    exit 1
fi

# Step 6: Create Hive Directories in HDFS
echo "Creating Hive directories in HDFS..."
# Check if /tmp directory exists and delete if it does
if hdfs dfs -test -d /tmp; then
    echo "Deleting existing /tmp directory in HDFS..."
    hdfs dfs -rm -r /tmp
fi
hdfs dfs -mkdir /tmp
hdfs dfs -chmod g+w /tmp

# Create and set permissions for /user/hive/warehouse
if ! hdfs dfs -test -d /user/hive/warehouse; then
    hdfs dfs -mkdir -p /user/hive/warehouse
fi
hdfs dfs -chmod g+w /user/hive/warehouse

# Step 7: Configure hive-site.xml File (Optional)
echo "Configuring hive-site.xml..."
cd ${HIVE_HOME}/conf

cp hive-default.xml.template hive-site.xml

# Backup the original file
cp hive-site.xml hive-site.xml.bak

# Verify that the file exists and is writable
if [ ! -w "$FILE" ]; then
  echo "File $FILE does not exist or is not writable. Exiting."
  exit 1
fi



# mv ${HIVE_HOME}/conf/hive-site.tmp.xml ${HIVE_HOME}/conf/hive-site.xml


cd ${HIVE_HOME}/conf
chmod +w ${HIVE_HOME}/conf/hive-site.xml


# Proceed with inserting XML configuration into hive-site.xml
echo "Inserting XML configuration into hive-site.xml..."
awk -v config="$XML_CONFIG" '/<configuration>/ {print; print config; next}1' hive-site.xml.bak > hive-site.xml

# Replace specific text in hive-site.xml
echo "Replacing incorrect characters in hive-site.xml..."

# chmod +w ${HIVE_HOME}/conf/hive-site.xml

sed -i 's/&#8;/ /g' hive-site.xml
# save the file
# chmod -w ${HIVE_HOME}/conf/hive-site.xml

# Verify the replacement
if ! grep '&#8;' ${HIVE_HOME}/conf/hive-site.xml; then
    echo "hive-site.xml was updated successfully."
else
    echo "Failed to update hive-site.xml. Please check the file."
    exit 1
fi

# Fixing guava incompatibility error
echo "Fixing guava incompatibility error..."
GUAVA_VERSION="27.0-jre"
HADOOP_GUAVA_JAR="$HADOOP_HOME/share/hadoop/hdfs/lib/guava-${GUAVA_VERSION}.jar"
HIVE_GUAVA_JAR="$HIVE_HOME/lib/guava-19.0.jar"

# Remove incompatible guava jar from Hive lib directory
if [ -f "$HIVE_GUAVA_JAR" ]; then
    echo "Removing incompatible guava jar from Hive lib directory..."
    rm "$HIVE_GUAVA_JAR"
fi

# Copy compatible guava jar to Hive lib directory
if [ -f "$HADOOP_GUAVA_JAR" ]; then
    echo "Copying compatible guava jar to Hive lib directory..."
    cp "$HADOOP_GUAVA_JAR" "$HIVE_HOME/lib/"
else
    echo "Guava jar not found in Hadoop lib directory. Please check the path."
    exit 1
fi

# Re-initiate Derby database
echo "Re-initiating Derby database..."
${HIVE_HOME}/bin/schematool -dbType derby -initSchema

# Add Hive to path
echo "Adding Hive to PATH..."
# Define the environment variable exports
HIVE_EXPORTS="export HIVE_CONF_DIR=\$HIVE_HOME/conf"

# Append to .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
    echo "$HIVE_EXPORTS" >> "$HOME/.zshrc"
    echo "Appended Hive exports to ~/.zshrc"
else
    echo "No ~/.zshrc file found."
fi

# Append to .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    echo "$HIVE_EXPORTS" >> "$HOME/.bashrc"
    echo "Appended Hive exports to ~/.bashrc"
else
    echo "No ~/.bashrc file found."
fi


# Launch Hive Client Shell
echo "Launching Hive client shell..."
${HIVE_HOME}/bin/hive

echo "Hive installation and configuration completed successfully."
