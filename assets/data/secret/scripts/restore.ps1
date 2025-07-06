$hwnd = (Get-Process -Name "KuakerTale").MainWindowHandle;
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@;
[WinAPI]::ShowWindow($hwnd, 1)  # SW_SHOWNORMAL
