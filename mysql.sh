script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
dnf module disable mysql -y
echo -e "\e[36m>>>>>>>>> Copy mysql repos file <<<<<<<<\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
echo -e "\e[36m>>>>>>>>> Install mysql <<<<<<<<\e[0m"
yum install mysql-community-server -y
echo -e "\e[36m>>>>>>>>> Start mysql services <<<<<<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld
mysql_secure_installation --set-root-pass RoboShop@1