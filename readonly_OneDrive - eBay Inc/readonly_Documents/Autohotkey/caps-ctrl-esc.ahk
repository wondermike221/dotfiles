; Disable CapsLock
SetCapsLockState("AlwaysOff")

; Map CapsLock + H to Left Arrow
CapsLock & h::SendInput("{Left}")

; Map CapsLock + J to Down Arrow
CapsLock & j::SendInput("{Down}")

; Map CapsLock + K to Up Arrow
CapsLock & k::SendInput("{Up}")

; Map CapsLock + L to Right Arrow
CapsLock & l::SendInput("{Right}")

CapsLock & f::SendInput("{PgDn}")

CapsLock & b::SendInput("{PgUp}")

; Map CapsLock alone to Escape when tapped
~CapsLock Up::{
  if (A_PriorKey = "CapsLock") {
      SendInput("{Esc}")
  }
}
; Function to trigger the original Capslock behaviour.
; This is needed because by default, AHK turns CapsLock off before doing Send
ToggleCaps(){
    SetStoreCapsLockMode(False)
    Send("{CapsLock}")
    SetStoreCapsLockMode(True)
}

; When both shift keys are pressed, act like Capslock
LShift & RShift::ToggleCaps()
RShift & LShift::ToggleCaps()


