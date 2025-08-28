import socket

s = socket.socket()
try:
    s.bind(('0.0.0.0', 9000))
    s.close()
    print("Port 9000 free")
except OSError:
    print("Port 9000 in use")
