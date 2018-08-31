#登录
set timeout -1
spawn ssh ubuntu@10.12.5.223
set password [lindex $argv 0]
expect { 
"yes/no" { send "yes\n";  exp_continue } 
"*password:*" {
	send "$password\n"
	expect @
	}
}
#完成登录

#提升权限
send "su\n"
expect {
"Password: "
}
send "$password\n"
expect #
#完成提升权限

#构建并进入文件夹
send "cd /home/\n"
expect #

send "cd panshi\n"
expect {
	"*No such file or directory*" {
		send "mkdir panshi\n"
		send "cd panshi\n"
		expect "#" {}
	}
	"#" {}
}

send "cd local\n"
expect {
	"*No such file or directory*" {
	send "mkdir local\n"
	send "cd local\n"
	}
	"#" {}
}

send "cd ..\n"
expect "#"

send "sudo chmod -R 777 local\n"
expect {
	"assword" {
		send "$password\n"
		expect "#" {}
	}
	"#" {}
}
interact
#完成构建并进入文件夹

#退回到本机
send "exit\n"
expect "ubuntu@tegra-ubuntu"
send "exit\n"
expect "ubuntu@tegra-ubuntu"
#完成退回到本机

#拷贝文件到远程
send "scp -r /home/panshi/mnt/reference/myexpect/bin/linux/arm_64/node_proc ubuntu@10.12.5.223:/home/panshi/local\n"
expect { 
	"yes/no" {send "yes\n"; exp_continue}
	"password:" {
		send "$password\n"
		expect {
			"denied" {}
			"#"
		}
	}
	"#" {}
}
interact
#完成考本文件到远程

#把上面的步骤再来一遍，找到拷贝的文件，执行
