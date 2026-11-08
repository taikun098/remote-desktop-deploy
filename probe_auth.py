# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
candidates=["1","一","user","user","123","123456","admin"]
t=paramiko.Transport((HOST,22))
try:
    t.connect()
    print("banner ok, server:", t.remote_version)
    for pw in candidates:
        try:
            t.auth_password(USER,pw)
            print("SUCCESS password="******
            break
        except Exception as e:
            print("fail",pw, type(e).__name__)
    t.close()
except Exception as e:
    print("transport error",repr(e))
