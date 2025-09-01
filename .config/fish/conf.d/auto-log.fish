# Auto-log all fish sessions (interactive or not) with util-linux 'script'
# Used for persistent history in Neovim terminals
# Opt-in: enable by exporting FISH_ENABLE_AUTOLOG=1 before starting fish
# Logs: /tmp/term-logs-<uid>/<user>.<host>.<tty>.<timestamp>.log

# Only run when explicitly enabled
if not set -q FISH_ENABLE_AUTOLOG
    return
end

# Prevent recursion when child fish is started under 'script'
if set -q FISH_UNDER_SCRIPT
    return
end

# Require util-linux 'script'
if not command -sq script
    return
end

# Private per-user dir in /tmp
set uid (id -u)
set logdir "/tmp/term-logs-$uid"
command mkdir -p "$logdir"
command chmod 700 "$logdir" 2>/dev/null

# Descriptive, unique name
set ts (date +"%Y%m%d-%H%M%S")
set host (string split -m1 . -- (uname -n 2>/dev/null))[1]
test -z "$host"; and set host unknownhost

set ttyname notty
set ttyraw (tty 2>/dev/null)
if test $status -eq 0 -a -n "$ttyraw"
    set ttyname (string replace -r '^/dev/' '' -- $ttyraw | string replace -a '/' '_')
end

set log "$logdir/$USER.$host.$ttyname.$ts.log"

# New files should be private (0600)
umask 077

# Mark recursion guard for the child shell and exec into 'script'
set -gx FISH_UNDER_SCRIPT 1
exec script -q -a -f "$log" -c "fish -i"
