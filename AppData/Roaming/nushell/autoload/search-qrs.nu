def search-qrs [--received (-r), --sort (-s), path = 'C:\Users\mhixon\Downloads\qrs.csv'] {
    let rmas = open $path
    let names = clipboard get | split row -r '\r\n|\n'
    if $sort {
      return ($rmas | where {|i| $i.Customer in $names} | sort-by Status)
    }
    if $received {
        return ($rmas | where {|i| $i.Customer in $names and $i.Status == 'Received'})
    } else {
        return ($rmas | where {|i| $i.Customer in $names})
    }

}
