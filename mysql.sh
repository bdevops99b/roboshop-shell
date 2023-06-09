script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1
if [ -z "$mysql_root_password" ]; then
  echo Input mysql root password missing
 exit 1
fi
func_print_head " our application needs MySQL 5.7. So lets disable MySQL 8 version"
dnf module disable mysql -y &>>$log_file
func_stat_check $?
func_print_head "Copy mysql repos file "
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_stat_check $?
func_print_head "Install mysql "
yum install mysql-community-server -y &>>$log_file
func_stat_check $?
func_print_head "Start mysql services  "
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
func_stat_check $?
mysql_secure_installation --set-root-pass $mysql_root_password &>>$log_file
func_stat_check $?