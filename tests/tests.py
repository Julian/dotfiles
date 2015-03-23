from unittest import TestCase
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
