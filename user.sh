script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
component=user
func_nodejs

echo -e "\e[36m>>>>>>>>> Copy repos  file <<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>>> Install mongodb client <<<<<<<<\e[0m"
yum install mongodb-org-shell -y
echo -e "\e[36m>>>>>>>>> Load schema <<<<<<<<\e[0m"
mongo --host mongod.panda4u.online </app/schema/user.js
