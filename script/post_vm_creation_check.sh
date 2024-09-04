#!/bin/bash
 
json_data=$(cat input.json)

# Function to send email
send_email() {
  subject=$1
  body_file=$2
  recipient=$3
  
  subject=$(echo "$subject" | tr -d '"')
  recipient=$(echo "$recipient" | tr -d '"')
  body_file=$(echo "$body_file" | tr -d '"')
  # Send email with attachment
  # sudo apt-get install mailutils 
  # sudo apt install ssmtp
  # sudo yum install mailx 
  mail -s "$subject" "$recipient" < "$body_file"
}

# Function to check if a filesystem is mounted
is_mounted() {
  mount_point=$1
  mount_point=$(echo "$mount_point" | tr -d '"')
  if mount | grep "on $mount_point " > /dev/null; then
    return 0  # Mounted
  else
    return 1  # Not mounted
  fi
}

# Function to ensure all filesystems from /etc/fstab are mounted
check_and_mount_filesystems() {
  echo "Checking all filesystems in /etc/fstab..."

  while read -r line; do
    # Ignore comments and empty lines
    if [[ "$line" =~ ^# ]] || [[ -z "$line" ]]; then
      continue
    fi

    # Extract the filesystem type (third column) and mount point (second column) from /etc/fstab
    fs_type=$(echo "$line" | awk '{print $3}')
    mount_point=$(echo "$line" | awk '{print $2}')

    fs_type=$(echo "$fs_type" | tr -d '"')
    mount_point=$(echo "$mount_point" | tr -d '"')

    # Skip 'none' filesystem types
    if [[ "$mount_point" == "none" ]]; then
      echo "Skipping 'none' filesystem type for mount point $mount_point."
      continue
    fi

    # Check if the filesystem is mounted
    if is_mounted "$mount_point"; then
      echo "Filesystem $mount_point is already mounted."
    else
      echo "Filesystem $mount_point is not mounted. Attempting to mount it..."
      # Attempt to mount the filesystem
      #if sudo mount "$mount_point"; then
      #  echo "Successfully mounted $mount_point."
      #else
      #  echo "Failed to mount $mount_point."
      #fi
    fi
  done < /etc/fstab
}

# Function to check Oracle instance status
check_oracle_status() {
  echo "Checking Oracle instance status..."
  
  # Execute SQL query to check Oracle status
  status=$(sqlplus -s / as sysdba <<EOF
SET HEADING OFF;
SET FEEDBACK OFF;
SELECT status FROM v\$instance;
EXIT;
EOF
  )

  # Remove any leading or trailing whitespace
  status=$(echo "$status" | xargs)

  # Return the status
  echo "Oracle instance status: $status"
  if [[ "$status" == "OPEN" ]]; then
    return 0  # Instance is running
  else
    return 1  # Instance is not running
  fi
}

# Function to start Oracle instance if it's not running
start_oracle_instance() {
  echo "Starting Oracle instance..."
  
  # Start the Oracle instance using SQL*Plus
  sqlplus -s / as sysdba <<EOF
STARTUP;
EXIT;
EOF

  echo "Oracle instance started."
}

validate_oracle_status() {

  oracle_output=$(check_oracle_status)
  oracle_status=$?

  if [[ $oracle_status -ne 0 ]]; then
    echo "Oracle instance is not running. Starting it now..."
    
    start_oracle_output=$(start_oracle_instance)
    start_oracle_status=$?
    # Handle the result based on the return value
    if [ $start_oracle_status -ne 0 ]; then
      echo "Start oracle instance failed with error: $start_oracle_output"
      #exit 1  # Exit the script with an error code
    else
      echo "Start oracle instance  result: $start_oracle_output"
    fi

  else
    echo "Oracle instance is already running."
  fi

}

add_host_entries() {
  ip_address="$1"
  hostname="$2"
  aliases="$3"
  ip_address=$(echo "$ip_address" | tr -d '"')
  hostname=$(echo "$hostname" | tr -d '"')
  aliases=$(echo "$aliases" | tr -d '"')
  echo "Adding entry for IP: $ip_address, Hostname: $hostname, Aliases: $aliases"

  # Backup the current /etc/hosts file
  sudo cp /home/arun/etc_hosts /home/arun/etc_hosts.bak

  # Check if the IP address already exists in the file
  if grep -q "$ip_address" /home/arun/etc_hosts; then
    echo "IP address $ip_address already exists in /home/arun/etc_hosts. Skipping..."
  else
    # Add the new entry (IP, hostname, and aliases) to /etc/hosts
    echo "$ip_address $hostname $aliases" | sudo tee -a /home/arun/etc_hosts > /dev/null
    echo "Entry added successfully."
  fi
}

# Function to generate a random password
generate_password() {
  # Use OpenSSL to generate a random 12-character password
  openssl rand -base64 12
}


# Create a new user with a generated password
create_new_user() {
  NEW_USER=$1

  if [[ -z "$NEW_USER" ]]; then
    echo "Error: NEW_USER must be provided."
    return 1  # Error: Arguments are missing
  fi

  NEW_USER=$(echo "$NEW_USER" | tr -d '"')
  # Generate a random password
  PASSWORD=$(generate_password)

  # Check if the user already exists
  if id "$NEW_USER" &>/dev/null; then
    echo "User $NEW_USER already exists."
    return 1
  fi

  # Create the new user
  sudo useradd -m "$NEW_USER"

  # Set the user's password
  echo "$NEW_USER:$PASSWORD" | sudo chpasswd

  # Force the user to change the password on first login
  sudo chage -d 0 "$NEW_USER"

  # Print the new user's credentials
  echo "User $NEW_USER has been created."
  echo "Username: $NEW_USER"
  echo "Password: $PASSWORD"
}

# Function to validate servername and private ip
validate_server_name_ip() {
  L_HOST_NAME=$1
  L_PRIVATE_IP=$2

  if [[ -z "$L_HOST_NAME" || -z "$L_PRIVATE_IP" ]]; then
    echo "Error: Hostname and Private IP must be provided."
    return 1  # Error: Arguments are missing
  fi

  # Strip any quotes from L_HOST_NAME and L_PRIVATE_IP
  L_HOST_NAME=$(echo "$L_HOST_NAME" | tr -d '"')
  L_PRIVATE_IP=$(echo "$L_PRIVATE_IP" | tr -d '"')

  HOSTNAME=$(hostname)
  PRIVATE_IP=$(hostname -I | awk '{print $1}')

  echo "Input: Hostname = $L_HOST_NAME, Private IP = $L_PRIVATE_IP"
  echo "Actual: Hostname = $HOSTNAME, Private IP = $PRIVATE_IP"

  # Use AND (&&) to ensure both the hostname and IP must match
  if [[ "$L_HOST_NAME" == "$HOSTNAME" && "$L_PRIVATE_IP" == "$PRIVATE_IP" ]]; then
    echo "Success: Input hostname and private IP match the actual host."
    return 0  # Success
  else
    echo "Error: Input hostname and private IP do not match the actual host [$HOSTNAME, $PRIVATE_IP]."
    return 1  # Failure
  fi
}




# Main script execution
main() {
  
  EMAIL_BODY_FILE="./rrt.log"
  echo "Execution Start" > "$EMAIL_BODY_FILE"

  json_data=$(cat input.json)
  
  HOST_NAME=$(echo "$json_data" | jq '.vm_details.name')
  PRIVATE_IP=$(echo "$json_data" | jq '.vm_details.private_ip_address')

  # Call the validate_server_name_ip function
  validate_server_output=$(validate_server_name_ip "$HOST_NAME" "$PRIVATE_IP")
  validate_server_status=$?

  # Handle the result based on the return value
  if [ $validate_server_status -ne 0 ]; then
    echo "validate servername and private ip failed with error: $validate_server_output" >> "$EMAIL_BODY_FILE"
    #exit 1  # Exit the script with an error code
  else
    echo "validate servername and private ip result: $validate_server_output" >> "$EMAIL_BODY_FILE"
  fi

  #NEW_USER=$(echo "$json_data" | jq '.default_user_name')
  #create_new_user_output=$(create_new_user "$NEW_USER")
  #create_new_user_status=$?

  #if [ $create_new_user_status -ne 0 ]; then
  #  echo "Create user failed with error: $create_new_user_output" >> "$EMAIL_BODY_FILE"
  #  #exit 1
  #else
  #  echo "Create user result: $create_new_user_output" >> "$EMAIL_BODY_FILE"
  #fi

  # Loop through each object in the array
  echo "$json_data" | jq -c '.dns_hosts[]' | while read -r item; do
      ip_address=$(echo "$item" | jq -r '.ip_address')
      host_name=$(echo "$item" | jq -r '.host_name')
      host_alias=$(echo "$item" | jq -r '.host_alias')
      
      echo "$ip_address  $host_name  $host_alias"
      # Call the function to add the entry
      dns_entry_output=$(add_host_entries "$ip_address" "$host_name" "$host_alias")
      dns_entry_status=$?

      # Handle the result based on the return value
      if [ $dns_entry_status -ne 0 ]; then
        echo "DNS entry failed with : $dns_entry_output" >> "$EMAIL_BODY_FILE"
        #exit 1  # Exit the script with an error code
      else
        echo "DNS entry result: $dns_entry_output" >> "$EMAIL_BODY_FILE"
      fi
  done

  #export ORACLE_HOME=$(echo "$json_data" | jq '.oracle_home')
  #export ORACLE_SID=$(echo "$json_data" | jq '.oracle_sidss')
  #export PATH=$ORACLE_HOME/bin:$PATH
  #validate_oracle_status

  
  filesystem_output=$(check_and_mount_filesystems)
  filesystem_status=$?

  # Handle the result based on the return value
  if [ $filesystem_status -ne 0 ]; then
    echo "Check and Mount filesystem failed with : $filesystem_output" >> "$EMAIL_BODY_FILE"
    #exit 1  # Exit the script with an error code
  else
    echo "Check and Mount filesystem result: $filesystem_output" >> "$EMAIL_BODY_FILE"
  fi


  echo "Execution End before mail" > "$EMAIL_BODY_FILE"
  EMAIL_SUBJECT=$(echo "$json_data" | jq '.email_subject')
  EMAIL_TO=$(echo "$json_data" | jq '.email_to')
  EMAIL_BODY_FILE="./rrt.log"
  # Send the email with the log file content
  send_email "$EMAIL_SUBJECT" "$EMAIL_BODY_FILE" "$EMAIL_TO"

}

# Run the main function
main
