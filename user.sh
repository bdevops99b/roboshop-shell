script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
echo -e "\e[36m>>>>>>>>> Configuring NodeJS repos <<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<\e[0m"
yum install nodejs -y
echo -e "\e[36m>>>>>>>>> Add Application User <<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
echo -e "\e[36m>>>>>>>>> Unzip App Content <<<<<<<<\e[0m"
unzip /tmp/user.zip
echo -e "\e[36m>>>>>>>>> Install NodeJS Dependencies <<<<<<<<\e[0m"
npm install
echo -e "\e[36m>>>>>>>>> Copy user SystemD file <<<<<<<<\e[0m"
cp $script_path/user.service /etc/systemd/system/user.service
echo -e "\e[36m>>>>>>>>> Start user service   <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user

cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y
mongo --host mongod.panda4u.online </app/schema/user.js
