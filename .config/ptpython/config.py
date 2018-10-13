_MISSING = object()


def _set(repl, name, value):
    # Sigh...
    if getattr(repl, name, _MISSING) is _MISSING:
        message = "ptpython REPL didn't have a {} attribute. Something's up.\n"
        import sys
        sys.stderr.write(message.format(name))
    setattr(repl, name, value)


def configure(repl):
    for name, value in [
        ("confirm_exit", False),
        ("enable_auto_suggest", True),
        ("enable_mouse_support", False),
        ("enable_open_in_editor", True),
        ("highlight_matching_parenthesis", True),
        ("show_docstring", True),
        ("show_signature", True),
        ("show_status_bar", False),
        ("true_color", True),
        ("vi_mode", True),
    ]:
        _set(repl=repl, name=name, value=value)

    repl.use_code_colorscheme("monokai")
