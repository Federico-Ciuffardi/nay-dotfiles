# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import (absolute_import, division, print_function)

from ranger.container.file import File
# You can import any python module as needed.
import os
import subprocess
# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command
from ranger.core.loader import CommandLoader

class lwd_fzf(Command):
    def execute(self):
        import subprocess
        import os.path
        # match only directories
        command="lwd history"
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            self.fm.cd(fzf_file)


class fzf_select(Command):
    def execute(self):
        import subprocess
        import os.path
        # match only directories
        command="find -L . -maxdepth 5 \\( -path '*/' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
                 -o -type f -print \
                 -o -type d -print \
                 -o -type l -print 2> /dev/null | cut -b3- | fzf +m --height=100%"
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                for comp in str.split(fzf_file,'/'):
                    if len(comp) > 0 and comp[0] == '.':
                        self.fm.set_option('show_hidden', True)
                self.fm.select_file(fzf_file)
                self.fm.execute_file(File(os.path.expanduser(fzf_file)))

class extract(Command):
    def execute(self):
        """ Extract %s files to current directory """
        cwd = self.fm.thisdir
        selected_files = cwd.get_selection()

        if not selected_files:
            return

        original_path = cwd.path
        au_flags = ['-X', cwd.path]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        cmd = args=['aunpack'] + au_flags + [f.path for f in selected_files]

        ecode=self.fm.execute_command(cmd).wait()
        if ( ecode == 0):
            self.fm.notify("Extracted succesfuly!")
        else:
            self.fm.notify("Extraction failed with errror code " + str(ecode),bad=True)

        cwd = self.fm.get_directory(original_path)
        cwd.load_content()

class compress(Command):

    def execute(self):
        """ Compress %s to current directory """
        cwd = self.fm.thisdir
        selected_files = cwd.get_selection()

        if not selected_files:
            selected_files = [self.fm.thisfile]

        original_path = cwd.path
        parts = self.line.split()
        if len(parts) < 2 :
            au_flags = [selected_files[0].path + ".tar.gz"]
        else:
            au_flags = parts[1:]
            if len(au_flags[0].split('.')) < 2:
                au_flags[0] += ".tar.gz"  

        cmd = ['apack'] + au_flags + [os.path.relpath(f.path, cwd.path) for f in selected_files]

        ecode=self.fm.execute_command(cmd).wait()
        if ( ecode == 0):
            self.fm.notify("Compressed succesfuly!")
        else:
            self.fm.notify("Compression failed with errror code " + str(ecode),bad=True)

        cwd = self.fm.get_directory(original_path)
        cwd.load_content()

    def tab(self, tabnum):
        """ Complete with current folder name """

        extension = ['.zip', '.tar.gz', '.rar', '.7z']
        return ['compress ' + os.path.basename(self.fm.thisdir.path) + ext for ext in extension]
