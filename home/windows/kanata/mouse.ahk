#Requires AutoHotkey v2.0
#NoTrayIcon

; Trigger: Shift + Mouse Wheel Down
#MButton:: {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x)
    
    ; Automatically grab the boundaries of both monitors
    MonitorGet(1, &L1, &T1, &R1, &B1)
    MonitorGet(2, &L2, &T2, &R2, &B2)
    
    ; If mouse is on the right (Primary) screen, teleport to the center of the left screen
    if (x >= 0) {
        centerX := L2 + (R2 - L2) / 2
        centerY := T2 + (B2 - T2) / 2
        MouseMove(centerX, centerY, 0)
    } 
    ; If mouse is on the left screen, teleport to the center of the right screen
    else {
        centerX := L1 + (R1 - L1) / 2
        centerY := T1 + (B1 - T1) / 2
        MouseMove(centerX, centerY, 0)
    }
}


#!t:: {
    static toggle := false
    
    if !toggle {
        ; First press: Run the SHOW command
        Run("nircmd/nircmd.exe win show class Shell_TrayWnd")
        toggle := true
    } else {
        ; Second press: Run the HIDE command
        Run("nircmd/nircmd.exe win hide class Shell_TrayWnd")
        toggle := false
    }
}

+#h::
#WheelUp::Send("#^{Left}")

; Win + Alt + L -> Move to Right Virtual Desktop
+#l::
#WheelDown::Send("#^{Right}")