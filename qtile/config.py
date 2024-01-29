# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import json
import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from pathlib import Path
from libqtile import qtile

show_wlan = False

mod = "mod4"
terminal = guess_terminal()

# Get home path
home = str(Path.home())

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Apps
    Key([mod, "shift"], "w", lazy.spawn("bash -x '~/scripts/wallpaper.sh'"), desc="Update Theme and Wallpaper"),

]

# --------------------------------------------------------
# Pywal Colors
# --------------------------------------------------------

colors = os.path.expanduser('~/.cache/wal/colors.json')
colordict = json.load(open(colors))
Color0=(colordict['colors']['color0'])
Color1=(colordict['colors']['color1'])
Color2=(colordict['colors']['color2'])
Color3=(colordict['colors']['color3'])
Color4=(colordict['colors']['color4'])
Color5=(colordict['colors']['color5'])
Color6=(colordict['colors']['color6'])
Color7=(colordict['colors']['color7'])
Color8=(colordict['colors']['color8'])
Color9=(colordict['colors']['color9'])
Color10=(colordict['colors']['color10'])
Color11=(colordict['colors']['color11'])
Color12=(colordict['colors']['color12'])
Color13=(colordict['colors']['color13'])
Color14=(colordict['colors']['color14'])
Color15=(colordict['colors']['color15'])

# --------------------------------------------------------
# Setup Layout Theme
# --------------------------------------------------------

layout_theme = { 
    "border_width": 3,
    "margin": 6,
    "border_focus": Color2,
    "border_normal": "FFFFFF",
    "single_border_width": 3
}

# --------------------------------------------------------
# Layouts
# --------------------------------------------------------

layouts = [
    layout.Max(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Floating()
]

# --------------------------------------------------------
# Setup Widget Defaults
# --------------------------------------------------------

widget_defaults = dict(
    font="Fira Sans SemiBold",
    fontsize=14,
    padding=3
)
extension_defaults = widget_defaults.copy()

# --------------------------------------------------------
# Widgets
# --------------------------------------------------------

widget_list = [
    widget.TextBox(
        # **decor_left, 
        background=Color1+".4",
        text='Apps',
        #foreground='ffffff',
        foreground='ff0000',
        desc='',
        padding=10,
        mouse_callbacks={"Button1": lambda: qtile.spawn("rofi -show drun")},
    ),
    widget.TextBox(
        # **decor_left,
        background="#ffffff.4",
        text="  ",
        foreground="000000.6",
        fontsize=18,
        mouse_callbacks={"Button1": lambda: qtile.spawn(home + "/dotfiles/qtile/scripts/wallpaper.sh select")},
    ),
    widget.GroupBox(
        # **decor_left,
        background="#ffffff.7",
        highlight_method='block',
        highlight='ffffff',
        block_border='ffffff',
        highlight_color=['ffffff','ffffff'],
        block_highlight_text_color='000000',
        #foreground='ffffff',
        foreground='ff0000',
        rounded=False,
        this_current_screen_border='ffffff',
        active='ffffff'
    ),
    widget.TextBox(
        # **decor_left,
        background="#ffffff.4",
        text=" ",
        #foreground="000000.6",
        foreground='ff0000',
        fontsize=18,
        mouse_callbacks={"Button1": lambda: qtile.spawn("firefox")},
    ),
    widget.TextBox(
        # **decor_left,
        background="#ffffff.4",
        text=" ",
        #foreground="000000.6",
        foreground='ff0000',
        fontsize=18,
        mouse_callbacks={"Button1": lambda: qtile.spawn("thunar")}
    ),
    
    widget.WindowName(
        # **decor_left,
        max_chars=50,
        background=Color2+".4",
        width=400,
        padding=10
    ),
    widget.Spacer(),
    widget.Spacer(
        length=30
    ),
    widget.TextBox(
        # **decor_right,
        background="#000000.3"      
    ),    
    widget.Memory(
        # **decor_right,
        background=Color10+".4",
        padding=10,        
        measure_mem='G',
        format="{MemUsed:.0f}{mm} ({MemTotal:.0f}{mm})"
    ),
    widget.Volume(
        # **decor_right,
        background=Color12+".4",
        padding=10, 
        fmt='Vol: {}',
    ),
    widget.DF(
        # **decor_right,
        padding=10, 
        background=Color8+".4",        
        visible_on_warn=False,
        format="{p} {uf}{m} ({r:.0f}%)"
    ),
    widget.Bluetooth(
        # **decor_right,
        background=Color2+".4",
        padding=10,
        mouse_callbacks={"Button1": lambda: qtile.spawn("blueman-manager")},
    ),
    # widget.Wlan(
    #     # **decor_right,
    #     background=Color2+".4",
    #     padding=10,
    #     format='{essid} {percent:2.0%}',
    #     mouse_callbacks={"Button1": lambda: qtile.spawn("alacritty -e nmtui")},
    # ),
    widget.Clock(
        # **decor_right,
        background=Color4+".4",   
        padding=10,      
        format="%Y-%m-%d / %I:%M %p",
    ),
    widget.TextBox(
        # **decor_right,
        background=Color2+".4",     
        padding=5,    
        text=" ",
        fontsize=20,
        mouse_callbacks={"Button1": lambda: qtile.spawn(home + "/dotfiles/qtile/scripts/powermenu.sh")},
    ),
]

# groups = [Group(i) for i in "123456789"]

groups = [
    Group("1", layout='monadtall'),
    Group("2", layout='monadtall'),
    Group("3", layout='monadtall'),
    Group("4", layout='monadtall'),
    Group("5", layout='monadtall'),
]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

# layouts = [
#     layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
#     layout.Max(),
#     # Try more layouts by unleashing below layouts.
#     # layout.Stack(num_stacks=2),
#     # layout.Bsp(),
#     # layout.Matrix(),
#     # layout.MonadTall(),
#     # layout.MonadWide(),
#     # layout.RatioTile(),
#     # layout.Tile(),
#     # layout.TreeTab(),
#     # layout.VerticalTile(),
#     # layout.Zoomy(),
# ]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

# --------------------------------------------------------
# Screens
# --------------------------------------------------------

screens = [
    Screen(
        top=bar.Bar(
            widget_list,
            30,
            padding=20,
            opacity=1,
            border_width=[0, 0, 0, 0],
            margin=[0,0,0,0],
            background="#000000.3" 
        ),
    ),
]


# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

# --------------------------------------------------------
# Hooks
# --------------------------------------------------------

# HOOK startup
@hook.subscribe.startup_once
def autostart():
    autostartscript = "~/.config/qtile/autostart.sh"
    home = os.path.expanduser(autostartscript)
    subprocess.Popen(['bash', '-x', home])