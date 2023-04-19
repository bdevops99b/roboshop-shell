script_path=$(dirname $0)
#source ${script_path}/common.sh

#echo $app_user
# source ${script_path}/common.sh

  echo $script_path


exit
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd ${app_user}
mkdir /app
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
npm install
cp /root/roboshop-shell/user.service /etc/systemd/system/user.service
systemctl daemon-reload
systemctl enable user
systemctl start user

cp /root/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y
mongo --host mongod.panda4u.online </app/schema/user.js
