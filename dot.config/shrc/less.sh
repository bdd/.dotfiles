# shellcheck shell=bash

export LESS="-iMFXR --mouse --wheel-lines=3"
# -i smart case search
# -M long prompt
# -F quit if one screen
# -X no termcap init/deinit so it doesn't clear the screen
# -R some raw control chars: ANSI SGR (color), OSC 8 hyperlinks, and some other OSC seqs.
