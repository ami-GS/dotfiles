import os, sys
import subprocess

args = sys.argv
protocol, s = args[1].split("://")
url, port = s.split(":")

yum = "/etc/yum.conf"
if os.path.exists(yum):
    with open(yum, "a") as f:
        f.write("proxy = " + args[1])
        subprocess.call(["sudo", "yum", "install", "git", "-y"])

apt = "/etc/apt/apt.conf"
if os.path.exists(apt):
    with open(apt, "a") as f:
        f.write("Acquire::http::proxy " + args[1] + "/")
        f.write("Acquire::https::proxy " + args[1] + "/")
        subprocess.call(["sudo", "apt-get", "install", "git", "-y"])

with open("/etc/wgetrc", "a") as f:
    f.write("use_proxy = on")
    f.write("http_proxy = " + args[1])
    f.write("https_proxy = " + args[1])

with open("/etc/curlrc", "a") as f:
    f.write("proxy = " + args[1])

with open("./.zshrc", "a") as f:
    f.write("export http_proxy=" + args[1])
    f.write("export https_proxy=" + args[1])
    f.write("export HTTP_PROXY=" + args[1])
    f.write("export HTTPS_PROXY=" + args[1])
    f.write('alias pip="pip --proxy=' + url + ":" + port)

subprocess.call(["git", "config", "--global", "http.proxy", args[1]])
subprocess.call(["git", "config", "--global", "https.proxy", args[1]])