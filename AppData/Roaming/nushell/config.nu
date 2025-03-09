$env.config = {
  show_banner: false

  completions: {
    case_sensitive: false # set to true to enable case-sensitive completions
    quick: true    # set this to false to prevent auto-selecting completions when only one remains
    partial: true    # set this to false to prevent partial filling of the prompt
    algorithm: "prefix"    # prefix or fuzzy
    external: {
      enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up may be very slow
      max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
      completer: null # check 'carapace_completer' above as an example
    }
    use_ls_colors: true # set this to true to enable file/path/directory completions using LS_COLORS
    }

    cursor_shape: {
      emacs: inherit 
      vi_insert: line
      vi_normal: block
    }

    buffer_editor: "nvim"
    edit_mode: vi

}

alias n = nvim
alias cls = clear
alias ll = ls -a 
alias cdh = cd ~

let YEAR = 31557600sec
def clipboard [] {
    help clipboard
}

def "clipboard get" [] {
    ^pwsh.exe -NoP -c "Get-Clipboard"
}

def "clipboard set" [text: string] {
    ^pwsh.exe -NoP -c "Set-Clipboard -Value $text"
}

def "clipboard copy" [text: string] {
    ^powershell.exe -NoP -Command "Set-Clipboard -Value $text"
}

def "clipboard paste" [] {
    ^powershell.exe -NoP -Command "Get-Clipboard"
}

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

#use 'C:\Users\mhixon\OneDrive - eBay Inc\Documents\_CollectPC\scripts\cpc.nu' 
