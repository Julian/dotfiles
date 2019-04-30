from __future__ import with_statement

import os
import sys


def _pprint_displayhook(value):
    """
    Pretty print things by default in the REPL.

    """

    import pprint

    if value is not None:
        try:
            import __builtin__
            __builtin__._ = value
        except ImportError:
            import builtins
            builtins._ = value

        pprint.pprint(value)

sys.displayhook = _pprint_displayhook


def edit(editor=None, *args, **kwargs):
    """
    Open a file in a preferred editor and execute it after the editor exits.

    Arguments:

        editor (str):

            the editor to invoke. If unspecified, the default is to
            infer it from the :envvar:`$EDITOR` environment variable.

        *args (`str`s):

            additional positional arguments, passed to the editor's
            process as argv.

        content (str):

            an initial set of lines to include in the
            created file (default: None)

        delete (bool):

            Delete the file after it is executed. If `False`,
            deletes the file when the interpreter is exited.
            (default: `True`)

        retry (bool):

            Prompt to re-edit the file if an exception is raised
            on execution (default: `False`)

        write_globals (bool):

            whether to write out a commented-out series of lines
            containing the globals to the created file (useful for
            tab completion, default: `True`)

        filter_globals (callable):

            used to filter the globals when outputted. The default is
            to exclude any name that starts with an underscore.

        add_history (callable):

            called for each line in the edited file after it is
            written to add the line to the history. If `None`,
            turns this feature off. (default: `readline.add_history`)

        globals (dict):

            a dict containing the globals in which to execute
            the file (default: ``globals()``)
    """

    import atexit
    import os
    import subprocess
    import tempfile
    import traceback
    global __last_edited_file__

    try:
        from readline import add_history
    except ImportError:
        add_history = kwargs.get("add_history")
    else:
        add_history = kwargs.get("add_history", add_history)

    editor = editor or os.environ.get("EDITOR")
    content = kwargs.get("content", "")
    delete = kwargs.get("delete", True)
    globals_ = kwargs.get("globals", globals())
    write_globals = kwargs.get("write_globals", True)
    retry = kwargs.get("retry", False)
    matches = kwargs.get("filter_globals", lambda n : not n.startswith("_"))

    try:
        editing, deleted_already = __last_edited_file__
        if editing is None:
            raise NameError()
    except NameError:
        with tempfile.NamedTemporaryFile(delete=False, suffix=".py") as tmp:
            if content:
                tmp.writelines(content)
            if globals_ and write_globals:
                tmp.write("\n\n# Globals:\n")
                matching = (g for g in globals_ if matches(g))
                tmp.writelines("#    {}\n".format(g) for g in matching)

        editing, deleted_already = __last_edited_file__ = tmp.name, False

    while True:
        subprocess.call((editor, editing,) + args)

        if add_history is not None:
            with open(editing) as f:
                for line in f:
                    add_history(line.rstrip())

        try:
            execfile(editing, globals_)
        except Exception:
            if retry:
                traceback.print_exc()
                answer = raw_input("Continue editing? [y]: ")
                if not answer or answer.lower() == "y":
                    continue
            raise

        break

    if delete:
        os.remove(editing)
        __last_edited_file__ = None, None
    else:
        if not deleted_already:
            atexit.register(os.remove, editing)
            __last_edited_file__ = editing, True


try:
    import readline
except ImportError:
    sys.stdout.write("Module readline not available.\n")
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")
    del readline, rlcompleter


del os, sys, _pprint_displayhook
