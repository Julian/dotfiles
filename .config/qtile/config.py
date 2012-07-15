import functools
import os
import subprocess

from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile.manager import Key, Click, Drag, Screen, Group


ALT = "mod1"
SUPER = "mod4"

LEFT_CLICK = "Button1"
MIDDLE_CLICK = "Button2"
RIGHT_CLICK = "Button3"


keys = [
    Key([SUPER], "Tab", lazy.layout.next()),
    Key([SUPER, "shift"], "Tab", lazy.layout.previous()),
    Key(["control"], "Left", lazy.group.prevgroup()),
    Key(["control"], "Right", lazy.group.nextgroup()),

    Key([], "XF86Launch5", lazy.spawn("urxvt")),
    Key([], "XF86Launch6", lazy.spawn(os.getenv("BROWSER"))),
    Key([], "XF86Launch7", lazy.spawn("gimp")),
    Key([], "XF86Launch8", lazy.spawn("vlc")),
    Key([], "XF86Launch9", lazy.spawn("vlc")),

    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 5%+")),
    Key([], "XF86AudioMute", lazy.spawn("amixer sset Master toggle")),
    Key([], "XF86AudioPlay", lazy.spawn("ncmpcpp play")),

    Key([ALT, "shift"], "q", lazy.spawn("sudo shutdown -h 0")),
    Key(["control", SUPER], "BackSpace", lazy.restart()),
    Key([ALT], "t", lazy.window.toggle_floating()),
]

mouse = [
    Drag([SUPER], LEFT_CLICK, lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([SUPER], RIGHT_CLICK, lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([SUPER], MIDDLE_CLICK, lazy.window.bring_to_front())
]

groups = [
     Group("Terminal"),
     Group("Browser"),
     Group("Mail"),
     Group("Extra"),
     Group("Extra"),
]

for index, group in enumerate(groups, 1):
    index = str(index)
    keys.extend([
        Key(["control"], index, lazy.group[group.name].toscreen()),
        Key(["control", "shift"], index, lazy.window.togroup(group.name)),
        Key([ALT, "shift"], index, lazy.group.swap_groups(group.name))
])


layouts = [
    layout.Max(),
    layout.Stack(stacks=2),
    layout.Tile(ratio=0.25),
]


# orange text on grey background
default_data = dict(fontsize=12,
                    foreground="FF6600",
                    background="1D1D1D",
                    font="ttf-droid")

screens = [
    Screen(bottom=bar.Bar([widget.GroupBox(**default_data),
                           widget.WindowName(**default_data),
                           widget.Clock(**default_data)],
                          27,))
]


@hook.subscribe.client_new
def dialogs(window):
    if(window.window.get_wm_type() == "dialog"
        or window.window.get_wm_transient_for()):
        window.floating = True


@hook.subscribe.startup
def on_startup():
    subprocess.Popen(["urxvt"])
    subprocess.Popen([os.getenv("BROWSER")])
    # TODO: Figure out how to catch the next window event only and have the
    #       browser window sent to another group.
    #       Also probably don't run these if they're open already.
