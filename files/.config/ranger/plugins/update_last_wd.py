import ranger.api
import os
from shutil import copyfile

old_hook_init = ranger.api.hook_init




def hook_init(fm):
    def on_cd(s):
        os.system("lwd save '" + s.new.path + "'")

    def on_execute_before():
        cwd = fm.thisdir
        selected_files = cwd.get_selection()

        for file in selected_files:
            os.system("lwd save '" + file.path + "'")


    fm.signal_bind("cd", on_cd)
    fm.signal_bind("execute.before", on_execute_before)
    # fm.notify("Hello World")
    return old_hook_init(fm)

ranger.api.hook_init = hook_init



