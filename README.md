# vZeroReclaim
This is a PowerShell script intended to support conversion of virtual disks attached to Windows VMware guests from thick to thin provisioning. 

Background:
----------------
In order to reclaim space when converting a VMDK volume from thick to thin provisioning, it is often necessary to use the Microsoft Sysinternals sdelete.exe utility to "zero out" disk space previously occupied by files that have been deleted or moved. 

In general, this process is carried out prior to completing a storage vMotion whereby Thick Provisioned virtual disks will be converted to Thin Provisioned virtual disks.

Overview:
----------------
This is a PowerShell script that performs the following functions:
1.) Retrieves sdelete.exe from a network SMB/CIFS share
2.) Automatically accepts the sdelete.exe EULA
3.) Retrieves a list of local volumes attached to the guest
4.) Runs the command: sdelete.exe -z <volume> for every local volume attached to the guest, cycling through each volume in turn.

Usage:
----------------
This script assumes that you have already procured sdelete.exe from a trusted source, and that it is available on an SMB/CIFS network share somewhere. Alternatively, you may comment out the portions of the script related to copying sdelete.exe to the local host, and simply place sdelete.exe a directory specified within the script. This script further assumes that it runs with sufficient permissions to modify a registry key that signals to sdelete.exe that its EULA is accepted. 

You should take care to review the script's contents and ensure that it is altered to meet the specific needs for your use case. At the very least, you may want to alter the source and destination for sdelete.exe. 

Once modified to meet your needs, the script should not require anything else. 

Other remarks:
-----------------
This script is published under the GNU General Public License v3. 

This script includes no promise of support or any kind of warranty. It is available for your reference and usage at your own risk. 

The contents of this script, my GitHub repository, or any other information or content I publish do not in any way represent the views of my employer.
