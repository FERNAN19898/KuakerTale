Param([string]$imagePath)

Add-Type @"
using System.Runtime.InteropServices;
public class NativeMethods {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

[NativeMethods]::SystemParametersInfo(20, 0, $imagePath, 3)
