Adam's tmux setup
=================
Keybindings, status bar and some misc. behavioural changes to make tmux more
awesome for development and server ops without going too far.

Installation
------------
1. git clone into ~/.tmux-config
2. ln -s ~/.tmux-config/tmux.conf .tmux.conf

If you are looking for an example script for firing up tmux as a ruby dev environment, my example one is [over here](http://github.com/AdamWhittingham/pastebit/blob/master/develop.sh)

Key bindings
------------
``Ctrl+a`` Command prefix (<prefix> from here on)

### Mutliplexing
* ``<prefix> c`` Create window
* ``<prefix> s`` Split into horizontal panes
* ``<prefix> S`` Split into vertical panes

### Window Movement
* ``<prefix> n`` next window
* ``<prefix> b`` back a window
* ``<prefix> 1-9`` go to window #1-9
* ``<prefix> -`` previously selected window

### Pane Movement
* ``<prefix> h`` move to the pane left
* ``<prefix> j`` move to the pane down
* ``<prefix> k`` move to the pane up
* ``<prefix> l`` move to the pane right

### Pane Resizing
*These can be repeated with a single press of the prefix to resize quickly*
* ``<prefix> H`` resize to the pane left
* ``<prefix> J`` resize to the pane down
* ``<prefix> K`` resize to the pane up
* ``<prefix> L`` resize to the pane right

### Misc
* ``<prefix><prefix>`` send the prefix through tmux to the terminal or app inside
* ``Shift + Left Click`` highlight text for copying
* ``<prefix> R`` reload the ~/.tmux.conf config file
