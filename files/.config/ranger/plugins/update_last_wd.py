import ranger.api
import os
from shutil import copyfile

old_hook_init = ranger.api.hook_init

def on_cd(s):
    os.system("lwd save '" + s.new.path + "'")
    # f = open(os.getenv("last_wd_file"), "w")
    # f.write(s.new.path)
    # f.close()

def hook_init(fm):
    fm.signal_bind("cd", on_cd)
    # fm.notify("Hello World")
    return old_hook_init(fm)

ranger.api.hook_init = hook_init



