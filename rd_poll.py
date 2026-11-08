# -*- coding: utf-8 -*-
import paramiko, time, subprocess, sys
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
def ping():
    try:
        r=subprocess.run(["ping","-n","1","-w","2000",HOST],capture_output=True,text=True)
        return ("ttl=" in r.stdout.lower() or "bytes=" in r.stdout.lower())
    except: return False
last_ping=last_ssh=None
for i in range(30):
    up=ping()
    sshup=False
    if up:
        try:
            c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            c.connect(HOST,username=USER,key_filename=KEY,timeout=8)
            _,so,_=c.exec_command("uptime -s",timeout=10)
            sshup=True
            print(f"[{i}] SSH 通了! 开机时间={so.read().decode().strip()}")
            c.close()
            print("READY")
            sys.exit(0)
        except Exception as e:
            sshup=False
    st="ping通" if up else "ping不通"
    st+=", ssh通" if sshup else (", ssh不通" if up else "")
    print(f"[{i}] {st}")
    time.sleep(10)
print("轮询结束，仍未连上")
