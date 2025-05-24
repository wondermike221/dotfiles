# Main script
export def main [] {
    print "This is the main command use a subcommand"
    print "e.g. cpc px 1"
}

export def mailto [email: string, params?: record, signature = "\nMichael Hixon\nL2 Onsite Support | ITSS Asset Management\nIT Services & Solutions (ITSS)\neBay"] {
  if $params == null { return $'mailto:($email)' }
  mut p = $params

  #if $params.body != null { $p.body = $p.body + $signature}
  if $params.body != null { $p.body = $p.body}

  let paramstr = $p 
    | url encode ...($p | columns) 
    | items {|k, v| [$k, $v] | str join '=' } 
    | str join '&'
  
  $'mailto:($email)?' + $paramstr
}

export def wd [email = "CHANGE"] {
  const headersPattern = "{ord}\t{template}\t{lastEmail}\t{task}\t{location}\t{name}\t{nt}\t{source}\t{vendor}\t{managerName}\t{managerEmail}\t{assetTag}\t{serial}\t{assetState}\t{substate}\t{model}\t{terminationDate}\t{costCenter}\t{qid}"
  let tickets = clipboard get | parse $headersPattern
  # print $tickets
  let subject = $"Request for Returned Equipment - ($tickets.0.name)"
  let cc = $"itreturns@ebay.com;($tickets.0.managerEmail)"
  # Format the assets
  let formattedAssets = $tickets | reduce --fold '' { |it, acc| $" - ($it.model) [SN: ($it.serial), Tag: ($it.assetTag)]\n($acc)"}
    
  # Format the email body
  let emailBody = $"Dear ($tickets.0.name),\n\nI hope this message finds you well. I am writing to request the return of company equipment that was assigned to you. Per our records, the following items were issued and have not been returned:\n\n($formattedAssets)\nWe kindly ask these items to be returned promptly after leaving the company. A FedEx QR code has been sent to your personal email address on file . This code will allow FedEx to package and ship these items to us and makes returning items seamless and quickly and free of charge for you. This email will come directly from FedEx – not ebay. If you do not see this, please check your junk\\spam folder.\n\nThank you for your prompt attention to this matter.  If you have any questions or require further information, please feel free to contact us directly at itreturns@ebay.com.\n\nBest regards,\n"

  start (mailto $email {subject:$subject, body:$emailBody cc:$cc})
}

export def px [] {
  const headersPattern = "{ord}\t{template}\t{lastEmail}\t{task}\t{location}\t{name}\t{nt}\t{source}\t{vendor}\t{managerName}\t{managerEmail}\t{assetTag}\t{serial}\t{assetState}\t{substate}\t{model}\t{terminationDate}\t{costCenter}\t{qid}"
  let tickets = clipboard get | parse $headersPattern

  let subject = $"Request for Returned Equipment - ($tickets.0.name)"

  # Format the assets
  let formattedAssets = $tickets | reduce --fold '' { |it, acc| $" - ($it.model) [SN: ($it.serial), Tag: ($it.assetTag)]\n($acc)"}
    
  # Format the email body
  let emailBody = $"Hi ($tickets.0.managerName),\n\nYour exited employee ($tickets.0.name) has not returned their equipment.\n\n($formattedAssets)\nIT can handle the return but since they were onboarded directly via peoplex we need your help to get the information necessary to start the process.\nPlease reply with the following information. If they have already returned their equipment, please let me know when and where so we may follow up with the local site.\n-	Personal Email\n-	Phone Number\n-	Address\n\nThanks!"
  
  start (mailto $"($tickets.0.managerEmail);itreturns@ebay.com" { subject:$subject, body:$emailBody })
}

export def fg [] {
  const headersPattern = "{ord}\t{template}\t{lastEmail}\t{task}\t{location}\t{name}\t{nt}\t{source}\t{vendor}\t{managerName}\t{managerEmail}\t{assetTag}\t{serial}\t{assetState}\t{substate}\t{model}\t{terminationDate}\t{costCenter}\t{qid}"
  let tickets = clipboard get | parse $headersPattern

  let subject = "Exited Employee Information Request"

  # Format the users/usernames/vendors
  let formattedUsers = $tickets | reduce --fold '' { |it, acc| $"($it.name)\t($it.nt)\t($it.vendor)\n($acc)"}
    
  # Format the email body
  let emailBody = $"Hi Team,\n\nI have the following exited employees who have not returned their IT equipment and we need their vendor contacts.\n\nName	Username	Vendor\n($formattedUsers)\nThanks!\n"

  start (mailto "awf-advisors@ebay.com" { subject:$subject, body:$emailBody })
}
