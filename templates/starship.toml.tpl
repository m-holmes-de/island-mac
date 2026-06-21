format = """
$username\
$directory\
$git_branch\
$git_status\
$fill\
$python\
$lua\
$nodejs\
$golang\
$haskell\
$rust\
$ruby\
$aws\
$docker_context\
$jobs\
$cmd_duration\
$line_break\
$character"""

add_newline = false
palette = "island"

[directory]
style = 'bold fg:blue'
format = '[  $path ]($style)'
truncation_length = 3
truncation_symbol = '…/'
truncate_to_repo = false

[directory.substitutions]
'Documents' = '󰈙'
'Downloads' = ' '
'Music' = ' '
'Pictures' = ' '

[git_branch]
style = 'fg:green'
symbol = ' '
format = '[on](white) [$symbol$branch ]($style)'

[git_status]
style = 'fg:red'
format = '([$all_status$ahead_behind]($style) )'

[fill]
symbol = ' '

[python]
style = 'teal'
symbol = ' '
format = '[${symbol}${pyenv_prefix}(${version} )(\($virtualenv\) )]($style)'
pyenv_version_name = true
pyenv_prefix = ''

[lua]
format = '[$symbol($version )]($style)'
symbol = ' '

[nodejs]
style = 'blue'
symbol = ' '

[golang]
style = 'blue'
symbol = ' '

[haskell]
style = 'blue'
symbol = ' '

[rust]
style = 'fg:red'
symbol = ' '

[ruby]
style = 'blue'
symbol = ' '

[package]
symbol = '󰏗 '

[aws]
symbol = ' '
style = 'yellow'
format = '[$symbol($profile )(\[$duration\] )]($style)'

[docker_context]
symbol = ' '
style = 'fg:teal'
format = '[$symbol]($style) $path'
detect_files = ['docker-compose.yml', 'docker-compose.yaml', 'Dockerfile']
detect_extensions = ['Dockerfile']

[jobs]
symbol = ' '
style = 'red'
number_threshold = 1
format = '[$symbol]($style)'

[cmd_duration]
min_time = 500
style = 'fg:gray'
format = '[$duration]($style)'

[username]
show_always = true
style_user = 'fg:mauve'
style_root = 'bold fg:red'
format = '[ $user](bold $style) [in](white) '

[hostname]
ssh_only = false
style = 'fg:blue'
format = '[@$hostname ]($style)'

[palettes.island]
red = "{{THEME_ERROR}}"
green = "{{THEME_ACCENT}}"
blue = "{{THEME_FOAM}}"
yellow = "{{THEME_GOLD}}"
teal = "{{THEME_FOAM}}"
mauve = "{{THEME_IRIS}}"
gray = "{{THEME_FG_MUTED}}"
white = "{{THEME_FG}}"
