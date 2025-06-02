export def main [--received (-r)] {
    const path = 'C:\Users\mhixon\OneDrive - eBay Inc\Documents\_CollectPC\qr_exports\qrs.csv'
    let rmas = open $path
    let names = clipboard get | split row -r '\r\n|\n'
    if $received {
        return ($rmas | where {|i| $i.Customer in $names and $i.Status == 'Received'})
    } else {
        return ($rmas | where {|i| $i.Customer in $names})
    }

}