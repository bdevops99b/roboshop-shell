app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
 echo -e "\e[35m>>>>>>>> $1 <<<<<<\e[0m"
}
func_nodejs()
{
print head "Configuring NodeJS repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

 print head "Installing NodeJS"
yum install nodejs -y
 print head "Add Application User"
print head "useradd ${app_user}"
print head  "Create Application Directory"
mkdir /app
print head  "Download App Content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app
print head  "Unzip App Content"
unzip /tmp/${component}.zip
print head  "Install NodeJS Dependencies"
npm install
print head  "Copy Cart SystemD file"
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
 print head "Start Cart Service"
systemctl daemon-reload
systemctl enable cart
systemctl start cart
}

