from unittest import TestCase
import time
import pty
import subprocess


class TestDotfiles(TestCase):
    def test_git(self):
        """
        By now, we should have access to zsh, git, an alias for git, and git
        aliases.

        """

        g_d = subprocess.check_output(["zsh", "-i", "-c", "g d --help"])
        self.assertIn(
            "`git d' is aliased to "
            "`diff --ignore-all-space --ignore-blank-lines --word-diff=color'",
            g_d,
        )

    def test_vim_plugins_are_installed(self):
        _, slave = pty.openpty()
        vim = subprocess.Popen(
            [
                "vim", "-T", "dumb", "-E",
                "-c", "set nomore",
                "-c", "NeoBundleList",
                "-c", "quit",
            ],
            stdin=slave,
            stdout=subprocess.PIPE,
        )
        plugins, _ = vim.communicate()
        self.assertTrue(plugins.split())
        self.assertIn("neobundle.vim", plugins.split())

    def test_vim_and_zsh_are_not_slow_as_hell(self):
        _, slave = pty.openpty()

        start = time.time()
        subprocess.call(
            ["zsh", "-l", "-c", "vim +quit"],
            stdin=slave,
            stdout=open("/dev/null", "w"),
        )
        dotfiles_elapsed = time.time() - start

        start = time.time()
        subprocess.call(
            ["zsh", "-l", "-c", "vim -u NONE +quit"],
            stdin=slave,
            stdout=open("/dev/null", "w"),
            env={"RCS" : ""},
        )
        vanilla_elapsed = time.time() - start

        self.assertLess(dotfiles_elapsed, vanilla_elapsed)
