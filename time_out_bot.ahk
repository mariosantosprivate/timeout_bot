
#CommentFlag Create actions loop
simulate_actions(WindowTitle, Interval){
	Loop
	{
		Sleep, 1000 * 1
		ifwinactive %WindowTitle%
		{
			WinActivate  ; Automatically uses the window found above.
			WinMaximize  ; same
			Sleep, 2000
			MouseClick, left, 1750, 250, 1, 30
			Send, {WheelDown 10}
			Send, {WheelDown 20}
			send, {PgDn 2}
			MouseClick, left, 1750, 500, 1, 30
			send, {PgUp 4}
			send, {PgDn 8}
		}
		else{
			user_simulator(WindowTitle, Interval)
		}
		Sleep, Interval
	}
}

user_simulator(WindowTitle, Interval){
    loop{
        #CommentFlag Make sure browser is running
        Process, Exist, msedge.exe
        EdgePID = %ErrorLevel%

        if(!EdgePID)
        {
            MsgBox, Edge is not running
            return
        }                
        else{ 
            WinActivate, ahk_pid %EdgePID%
            SetTitleMatchMode, 2
            SearchedTab := WindowTitle
            ifwinactive %SearchedTab%
                {
                    #CommentFlag in the correct tab, do what you want
                    simulate_actions(WindowTitle, Interval)
                }
            WinGetTitle, StartingTitle, ahk_pid %EdgePID%
            #CommentFlag loop through tabs
            loop 
            {
                send {Control down}{Tab}{Control Up}
                Sleep 400
                ifwinactive %SearchedTab%
                {
                    #CommentFlag in the correct tab, do what you want
                    simulate_actions(WindowTitle, Interval)
                }
                WinGetTitle, CurrentTabTitle, ahk_pid %EdgePID%
                if (CurrentTabTitle == StartingTitle)
                {
                    MsgBox, , Halt : Couldn't find tab %WindowTitle%
                    return
                }
            }
        }
    Sleep, Interval
    }   
}

#CommentFlag Get webpage name
InputBox, WindowName, Prevent Time Out Bot, Enter the webpage name
WindowTitle := WindowName

#CommentFlag Get time interval
InputBox, Interval, Prevent Time Out Bot : %WindowTitle%, Enter an interval (in minutes) to emulate mouse and keyboard behaviour :
        if Interval is not integer
        {
            MsgBox, , Halt : Bad Type, Enter an Integer for the Interval
            Return
        }
        else{
            MsgBox, , Interval Set, interval set for %Interval% minutes.
            Interval := 1000 * 60 * Interval
        }

user_simulator(WindowTitle,Interval)