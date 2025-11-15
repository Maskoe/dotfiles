# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

export ELECTRON_OZONE_PLATFORM_HINT=wayland
export ELECTRON_DISABLE_GPU=1
export PATH="$PATH:$HOME/.dotnet/tools"

# wow that is fucking sick. so now i can run "cld"" from any terminal and just talk to claude. I can also have multiple conversations in multiple tabs by going "cld lmao".
cld() {
  local conversation_name=${1:-"cool"}
  dotnet run --project ~/projects/ClaudeFileEnjoyer/ClaudeFileEnjoyer/ClaudeFileEnjoyer.csproj &>/dev/null &
  nvim "${conversation_name}.claude"
}
# alias cld='dotnet run --project ~/projects/ClaudeFileEnjoyer/ClaudeFileEnjoyer/ClaudeFileEnjoyer.csproj &> /dev/null & nvim cool.claude'

alias ml='nvim ~/projects/MediaLib'
alias ml-dump='pg_dump --verbose -h localhost -p 8878 -U postgres -d ml-db -Fc -f ~/dev/backup.dump'
alias ml-restore='pg_restore --verbose -h localhost -p 6788 -U postgres -d prodcopy0 -c ~/dev/backup.dump'
alias ml-ssh='ssh -L 8878:localhost:6788 root@49.12.64.29'

# Makes the screenshot tool work I think. I also installed drivers maybe. Im not sure
export LIBVA_DRIVER_NAME=iHD
export DRI_PRIME=0
