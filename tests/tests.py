from subprocess import check_output
from unittest import TestCase


class TestDotfiles(TestCase):
    def test_git(self):
        """
        By now, we should have access to zsh, git, an alias for git, and git
        aliases.

        """

        output = check_output(["zsh", "-i", "-c", "g d --help"]).splitlines()
        self.assertIn(
            "`git d' is aliased to "
            "`diff --ignore-all-space --ignore-blank-lines --word-diff=color'",
            output,
        )
