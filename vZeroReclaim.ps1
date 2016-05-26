#Title: vZeroReclaim.ps1
#Purpose: Downloads sdelete.exe from a file share, saves it to a local drive, then executes sdelete.exe -z against all drive letters. This is intended to zero out unused disk space to faciliate more efficient use of thin virtual disk provisioning. 

#See https://github.com/brandonwardlaw/vZeroReclaim/ for more information

#Author: Brandon Wardlaw | https://github.com/brandonwardlaw/

#Variables and such
$sdelPath  = "C:\sdel\" #Change this if you want to use a different directory!
$sdelRegPath = "HKCU:\Software\Sysinternals\SDelete"
$sdelRegName = "EulaAccepted"
$sdelRegVal = "1"

[array]$rootDrives
#create sdelete directory
IF(!(Test-Path $sdelPath)){
	New-Item -ItemType directory -Path $sdelPath
}
ELSE
{
	echo "sdel dir already exists!"
}

#grab sdelete.exe from share
Copy-Item \\<PUT YOUR SHARE HERE>\sdelete.exe $sdelPath #make sure to put your share location here!


#registry hack to bypass popup sdelete.exe EULA
IF(!(Test-Path $sdelRegPath)){

	New-Item -Path $sdelRegPath -Force | Out-Null
	
	New-Item -Path $sdelRegPath -Name $sdelRegName -Value $sdelRegVal -PropertyType DWORD -Force | Out-Null
	}
ELSE {

	New-ItemProperty -Path $sdelRegPath -Name $sdelRegName -Value $sdelRegVal -PropertyType DWORD -Force | Out-Null
}

#Get list of all local drives, store in array
[array]$drives = Get-WmiObject -Query "SELECT * from win32_logicaldisk where DriveType = '3'" | Select DeviceID

echo "The following local drives have been identified"
$drives 

#loop through the array of drives and run sdelete.exe -z

 

#echo "Starting sdelete process"


for($i=0; $i -lt $drives.length; $i++){
	
	$drv = ([string]([string]$drives[$i]).Replace("@{DeviceID=","").Replace("}",""));
	
	echo "Zeroing space on drive $drv"
	
	& "$sdelPath\sdelete.exe" -z $drv
}
