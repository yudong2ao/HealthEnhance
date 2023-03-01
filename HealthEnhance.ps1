Add-Type @'
using System;
using System.Runtime.InteropServices;

namespace Win32_API
{
    internal struct LASTINPUTINFO 
    {
        public uint cbSize;
        public uint dwTime;
    }

    public class Win32
    {
        [DllImport("User32.dll")]
        public static extern bool LockWorkStation();

        [DllImport("User32.dll")]
        private static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);        

        [DllImport("Kernel32.dll")]
        private static extern uint GetLastError();

        public static uint GetIdleTime()
        {
            LASTINPUTINFO lastInPut = new LASTINPUTINFO();
            lastInPut.cbSize = (uint)System.Runtime.InteropServices.Marshal.SizeOf(lastInPut);
            GetLastInputInfo(ref lastInPut);
            return ( (uint)Environment.TickCount - lastInPut.dwTime);
        }

        public static long GetTickCount()
        {
            return Environment.TickCount;
        }

        public static long GetLastInputTime()
        {
            LASTINPUTINFO lastInPut = new LASTINPUTINFO();
            lastInPut.cbSize = (uint)System.Runtime.InteropServices.Marshal.SizeOf(lastInPut);
            if (!GetLastInputInfo(ref lastInPut))
            {
                throw new Exception(GetLastError().ToString());
            }                           
            return lastInPut.dwTime;
        }
    }
}
'@
#定义空闲时间返回函数，以秒为单位
function RecordIdleTime { 
    return [Win32_API.Win32]::GetIdleTime() / 1000 
}

# 初始化变量
$IdleTime = 0 # 空闲时间（秒）
$WorkTime = 0 # 工作时间（秒）
$IdleLimit = 300 # 空闲时间限制（秒）
$WorkLimit = 3600 # 工作时间限制（秒）

# 循环检查空闲时间和工作时间，每5秒一次
while ($true) {
    Start-Sleep -Seconds 5 # 暂停5秒
    $IdleTime = RecordIdleTime # 获取空闲时间

    # 如果空闲时间小于限制
    if ($IdleTime -lt $IdleLimit) {
        $WorkTime += 5 # 工作时间累加5秒

        # 如果工作时间达到限制
        if ($WorkTime -ge $WorkLimit) {
            New-BurntToastNotification -AppLogo "C:\Users\yudon\AppData\Local\Programs\HealthEnhance\HealthEnhance.png" -Text "提醒", '已连续工作1小时，休息一下吧！'# 弹出提醒“休息一下吧”，持续5秒后消失
            Start-Sleep -Seconds 5 # 暂停5秒，等待弹窗通知消失
            $WorkTime = 0 #工作时间清零
        }
    }
    # 如果空闲时间大于等于限制
    else {
        $WorkTime = 0 # 工作时间清零
    }
    #打印空闲时间和工作时间
    ls variable:IdleTime
    ls variable:WorkTime
}