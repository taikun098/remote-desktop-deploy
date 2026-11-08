# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
def run(script, timeout=60):
    c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
    sftp=c.open_sftp(); sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\\"+script,"/tmp/"+script); sftp.close()
    c.get_transport().set_keepalive(15)
    _,so,se=c.exec_command("bash /tmp/"+script, timeout=timeout)
    out=so.read().decode("utf-8","replace")
    print(out.replace("\x00",""))
    c.close()
for _ in range(20):
    run("fcsteam_pll2.sh")
    # 检查是否装完
    import subprocess
    c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
    c.get_transport().set_keepalive(15)
    _,so,_=c.exec_command("systemctl is-active fcsteam-install", timeout=30)
    st=so.read().decode().strip()
    c.close()
    if st != "active":
        print("单元状态: "+st+"（安装已结束）")
        break
    time.sleep(20)
