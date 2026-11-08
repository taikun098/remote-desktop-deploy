# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"; PW="1"

class KBHandler(paramiko.auth_handler.AuthHandler):
    pass

def handler(title, instructions, prompt_list):
    # answer each prompt with the password
    return [PW for _ in prompt_list]

t = paramiko.Transport((HOST,22))
try:
    t.connect()
    try:
        t.auth_interactive(USER, handler)
        print("INTERACTIVE_AUTH_OK")
    except Exception as e:
        print("interactive fail:", type(e).__name__, str(e))
    t.close()
except Exception as e:
    print("transport error:", repr(e))
