Adam's tmux setup
=================
Keybindings, status bar and some misc. behavioural changes to make tmux more
awesome for development and server ops without going too far.

Installation
------------
1. ``git clone https://github.com/AdamWhittingham/tmux-config.git ~/.tmux-config``
2. ``ln -s ~/.tmux-config/tmux.conf ~/.tmux.conf``

## Quick notes
1. My example script for firing up tmux as a ruby dev environment is [over here](http://github.com/AdamWhittingham/pastebit/blob/master/develop.sh)
2. If you want to share between user accounts on the same box, read the ``setup_socket_sharing.sh`` script for details

Key bindings
------------
``Ctrl+a`` Command prefix (``<prefix>`` from here on)

### Mutliplexing
* ``<prefix> c`` Create new window
* ``<prefix> n`` Create new window
* ``<prefix> s`` Split into horizontal panes
* ``<prefix> S`` Split into vertical panes

### Window Movement
* ``<prefix> ,`` switch to back window
* ``<prefix> .`` switch to next window
* ``<prefix> -`` previously selected window
* ``<prefix> 1-9`` go to window #1-9
* ``<prefix> w`` list windows and select which to switch to

### Window Control
* ``<prefix> r`` rename window
* ``<prefix> <`` move window left
* ``<prefix> >`` move window right

### Pane Focus
* ``<prefix> h`` move focus to the pane left
* ``<prefix> j`` move focus to the pane down
* ``<prefix> k`` move focus to the pane up
* ``<prefix> l`` move focus to the pane right
* ``<prefix> q n`` Show pane numbers, then jump focus to pane n

### Pane Resizing
*These can be repeated after a single press of the prefix to resize quickly*
* ``<prefix> H`` resize to the pane left
* ``<prefix> J`` resize to the pane down
* ``<prefix> K`` resize to the pane up
* ``<prefix> L`` resize to the pane right

### Pane Movement
* ``<prefix> {`` move this pane to the location of the previous pane
* ``<prefix> }`` move this pane to the location of the next pane
* ``<prefix> Up`` Temporarily maximise the current pane in a new window
* ``<prefix> Down`` Minimise the maximised pane back where it came from

### Pane Control
* ``<prefix> x`` close pane
* ``<prefix> q`` Kill the pane (kills everything the pane is running, careful!)
* ``<prefix> !`` turn pane into window

### Session Control
* ``<prefix> d`` detach from session
* ``tmux attach -t <session-name>`` reattach to session
* ``tmux ls`` list sessions

### Copy & Paste
* ``<prefix> ESC`` enter copy mode
In copy mode you can then use vi selection bindings (w,e,t,etc)
* ``v`` to visually select
* ``y`` to yank to a buffer
* ``<prefix> p`` paste
* ``<prefix> P`` pick what to paste when there are multiple things copied

##### System clipboard copy & paste (requires xclip)
* ``<prefix> Ctrl+c`` Copy buffer to clipboard
* ``<prefix> Ctrl+v`` Paste from clipboard

### Advanced Session Control
* ``<prefix> (`` switch into the next tmux session
* ``<prefix> )`` switch into the previous tmux session
* ``<prefix> Ctrl+q`` Kill the whole session- use with care!

### Misc
* ``<prefix><prefix>`` send the prefix through tmux to the terminal or app inside
* ``Shift + Left Click`` highlight text for copying with the mouse
* ``<prefix> R`` reload the ~/.tmux.conf config file
