# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
def run(cmd, t=60):
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=t)
    print(so.read().decode("utf-8","replace").rstrip(), flush=True)
    e=se.read().decode("utf-8","replace")
    if e.strip(): print("[e] "+e.rstrip(), flush=True)
# 1) 免密 sudo：user 无需密码执行任何命令
run("echo 1 | sudo -S bash -c 'echo \"user ALL=(ALL) NOPASSWD: ******" > /etc/sudoers.d/user && chmod 0440 /etc/sudoers.d/user && visudo -c'")
run("echo '===sudoers==='; echo 1 | sudo -S cat /etc/sudoers.d/user")
# 2) polkit：桌面管理操作免授权
run("echo 1 | sudo -S bash -c 'printf \"polkit.addRule(function(action, subject) {\\n    if (subject.user == \\\"user\\\") {\\n        return polkit.Result.YES;\\n    }\\n});\\n\" > /etc/polkit-1/rules.d/49-nopasswd-user.rules && chmod 0644 /etc/polkit-1/rules.d/49-nopasswd-user.rules'")
run("echo '===polkit==='; echo 1 | sudo -S cat /etc/polkit-1/rules.d/49-nopasswd-user.rules")
# 3) 验证免密 sudo 生效（不再要密码）
run("echo '===verify sudo -n==='; sudo -n true && echo NOPASSWD_OK || echo NOPASSWD_FAIL; id")
c.close()
