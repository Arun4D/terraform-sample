#!/bin/bash
 
#input_file="input.json"
 
#jq -r '.vm_details[] | "\(.name), \(.email)"' "$input_file" |
#while IFS= read -r employee_info; do
#    echo "Employee Info: $employee_info"
#done

json_data=$(cat input.json)

# Loop through each object in the array
#echo "$json_data" | jq -c '.vm_details[]' | while read -r item; do
#    resource_group_name=$(echo "$item" | jq -r '.resource_group_name')
#    name=$(echo "$item" | jq -r '.name')
#    private_ip_address=$(echo "$item" | jq -r '.private_ip_address')
#    
#    echo "resource_group_name: $resource_group_name, name: $name , private_ip_address : $private_ip_address"
#done

# Loop through each object in the array
#echo "$json_data" | jq -c '.hosts[]' | while read -r item; do
#    ip_address=$(echo "$item" | jq -r '.ip_address')
#    host_name=$(echo "$item" | jq -r '.host_name')
#    host_alias=$(echo "$item" | jq -r '.host_alias')
    
#    echo "$ip_address  $host_name  $host_alias"
#sdone


# Function to validate servername and private ip
validate_server_name_ip() {
  local host_name=$1
  local private_ip=$2

  HOSTNAME = $(host_name)
  PRIVATE_IP = $(host_name -I | awk '{print $1}') 


  if [[ $host_name == $HOSTNAME && $private_ip == $PRIVATE_IP  ]]; then
    echo "Input host_name $host_name and private ip address $private_ip is not matching with host [$HOSTNAME $PRIVATE_IP]"
    return 1  # Return a non-zero value to indicate an error
  fi

  echo "Input host_name $host_name and private ip address $private_ip is matching with host"
  return 0  # Return 0 to indicate success
}

# Main script execution
main() {
  
  json_data=$(cat input.json)
  
  HOST_NAME=$(echo "$json_data" | jq '.vm_details.name')
  PRIVATE_IP=$(echo "$json_data" | jq '.vm_details.private_ip_address')

  # Call the validate_server_name_ip function
  output=$(validate_server_name_ip "$HOST_NAME" "$PRIVATE_IP")
  status=$?

  # Handle the result based on the return value
  if [ $status -ne 0 ]; then
    echo "validate servername and private ip failed with error: $output"
    exit 1  # Exit the script with an error code
  else
    echo "validate servername and private ip result: $output"
  fi
}

# Run the main function
main
