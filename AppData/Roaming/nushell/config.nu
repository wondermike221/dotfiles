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
    clipboard get
}

# Get the system clipboard contents using pwsh
def "clipboard get" [] {
    ^pwsh.exe -NoP -c 'Get-Clipboard'
}

# Set the system clipboard contents using pwsh
def "clipboard set" [content:string] {
    ^pwsh.exe -NoP -c $"Set-Clipboard -Value @\"\n($content)\n\"@"
}

def "clipboard paste" [] {
    ^pwsh.exe -NoP -c 'Get-Clipboard'
}

def "clipboard copy" [] : any -> nothing {
    ^pwsh.exe -NoP -c $"Set-Clipboard -Value @\"\n($in)\n\"@"
}

def "to xltext" [] : table -> string {
    let table = $in
    if ($table | describe | str starts-with "table") {
        let result = $table | each {|row| $row | to csv --noheaders --separator "\t" | str trim } | str join "\n"
        $result
    } else {
        # Error handling for non-table input
        error "Input is not a table"
    }
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

use 'C:\Users\mhixon\OneDrive - eBay Inc\Documents\_CollectPC\scripts\cpc.nu' 

use 'C:/Users/mhixon/OneDrive - eBay Inc/Documents/_CollectPC/scripts/search-qrs.nu'
