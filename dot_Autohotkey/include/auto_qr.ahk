::]1qr::
{
  clipboardContent := A_Clipboard

  content := jsongo.Parse(clipboardContent)
  ; peep(content)

  Send(content["user"]["dv_first_name"])
  Send("{Tab}")
  Send(content["user"]["dv_last_name"])
  Send("{Tab}")
  Send(content["task_u_vars"]["street_address"])
  Send("{Tab}")
  Send("{Tab}")
  Send(content["task_u_vars"]["city"])
  Send("{Tab}")
  Send("{Enter}")
  Sleep(500)
  Send(State_Abbr_To_Name(content["task_u_vars"]["v_state"]))
  Send("{Enter}")
  Send("{Tab}")
  Send("{Tab}")
  Send(content["task_u_vars"]["zip"])
  Send("{Tab}")
  Send(content["task_u_vars"]["contact_number"])
  Send("{Tab}")
  Send(content["task_u_vars"]["contact_email"])
  Send("{Tab}")
}

::]3qr::
{
  ; Retrieve the current contents of the clipboard
  clipboardContent := A_Clipboard

  content := jsongo.Parse(clipboardContent)

  Send(content["task"]["dv_number"])
  Send("{Tab}")
  Send(content["user"]["dv_cost_center"])
  Send("{Tab}")
  Send(content["user"]["dv_user_name"])
  Send("{Tab}")
  serials := ""
  first := true
  for key, value in content["assets"]["records"] {
    ; peep(value)
    if(first and value["dv_substatus"] = "Unreturned") {
      serials := value["dv_serial_number"]
    } else if(value["dv_substatus"] = "Unreturned"){
      serials := serials . " & " . value["dv_serial_number"]
    }
    first := false
  }
  Send(serials)
  Send("{Tab}")
  Send("1000")
  Send("{Tab}{Enter}{Enter}{Tab}{Tab}{Tab}")
}




State_Abbr_To_Name(abbr)
{

  static states := Map(
        "AL", "Alabama",
        "AK", "Alaska",
        "AZ", "Arizona",
        "AR", "Arkansas",
        "CA", "California",
        "CO", "Colorado",
        "CT", "Connecticut",
        "DE", "Delaware",
        "FL", "Florida",
        "GA", "Georgia",
        "HI", "Hawaii",
        "ID", "Idaho",
        "IL", "Illinois",
        "IN", "Indiana",
        "IA", "Iowa",
        "KS", "Kansas",
        "KY", "Kentucky",
        "LA", "Louisiana",
        "ME", "Maine",
        "MD", "Maryland",
        "MA", "Massachusetts",
        "MI", "Michigan",
        "MN", "Minnesota",
        "MS", "Mississippi",
        "MO", "Missouri",
        "MT", "Montana",
        "NE", "Nebraska",
        "NV", "Nevada",
        "NH", "New Hampshire",
        "NJ", "New Jersey",
        "NM", "New Mexico",
        "NY", "New York",
        "NC", "North Carolina",
        "ND", "North Dakota",
        "OH", "Ohio",
        "OK", "Oklahoma",
        "OR", "Oregon",
        "PA", "Pennsylvania",
        "RI", "Rhode Island",
        "SC", "South Carolina",
        "SD", "South Dakota",
        "TN", "Tennessee",
        "TX", "Texas",
        "UT", "Utah",
        "VT", "Vermont",
        "VA", "Virginia",
        "WA", "Washington",
        "WV", "West Virginia",
        "WI", "Wisconsin",
        "WY", "Wyoming",
        "DC", "District of Columbia"
    )

    if states.Has(StrUpper(abbr))
        return states[StrUpper(abbr)]
    else
        return "" ; return empty string if not found
}
