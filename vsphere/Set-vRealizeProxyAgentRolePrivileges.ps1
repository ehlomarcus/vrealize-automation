<#
.SYNOPSIS
  Assign privileges to the 'vRealize Proxy Agent Role'
.DESCRIPTION
  Use this script to create or update role with new Privileges.
.INPUTS
  vcsa (string): fqdn on vCenter Server
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Marcus Feltsen
  Creation Date:  2020-03-31
  Purpose/Change: Initial script development
  
.EXAMPLE
  ./Set-vRealizeProxyAgentRolePrivileges.ps1 -vcsa vcsa.domain.internal
#>
param(
  [string] $vcsa
)
Import-Module VMware.PowerCLI

$RoleName = "vRealize Proxy Agent Role"

Connect-VIServer -server $vcsa

$ReqPriv = @(
    "Datastore.AllocateSpace",
    "Datastore.Browse",
    "Datastore.FileManagement",
    "Datastore.UpdateVirtualMachineFiles",
    "Datastore.UpdateVirtualMachineMetadata",
    "Network.Assign",
    "Resource.AssignVMToPool",
    "System.Anonymous",
    "System.Read",
    "System.View",
    "VirtualMachine.Config.AddExistingDisk",
    "VirtualMachine.Config.AddNewDisk",
    "VirtualMachine.Config.AddRemoveDevice",
    "VirtualMachine.Config.AdvancedConfig",
    "VirtualMachine.Config.Annotation",
    "VirtualMachine.Config.CPUCount",
    "VirtualMachine.Config.ChangeTracking",
    "VirtualMachine.Config.DiskExtend",
    "VirtualMachine.Config.DiskLease",
    "VirtualMachine.Config.EditDevice",
    "VirtualMachine.Config.HostUSBDevice",
    "VirtualMachine.Config.ManagedBy",
    "VirtualMachine.Config.Memory",
    "VirtualMachine.Config.MksControl",
    "VirtualMachine.Config.QueryFTCompatibility",
    "VirtualMachine.Config.QueryUnownedFiles",
    "VirtualMachine.Config.RawDevice",
    "VirtualMachine.Config.ReloadFromPath",
    "VirtualMachine.Config.RemoveDisk",
    "VirtualMachine.Config.Rename",
    "VirtualMachine.Config.ResetGuestInfo",
    "VirtualMachine.Config.Resource",
    "VirtualMachine.Config.Settings",
    "VirtualMachine.Config.SwapPlacement",
    "VirtualMachine.Config.ToggleForkParent",
    "VirtualMachine.Config.UpgradeVirtualHardware",
    "VirtualMachine.GuestOperations.Execute",
    "VirtualMachine.GuestOperations.Modify",
    "VirtualMachine.GuestOperations.ModifyAliases",
    "VirtualMachine.GuestOperations.Query",
    "VirtualMachine.GuestOperations.QueryAliases",
    "VirtualMachine.Interact.AnswerQuestion",
    "VirtualMachine.Interact.Backup",
    "VirtualMachine.Interact.ConsoleInteract",
    "VirtualMachine.Interact.CreateScreenshot",
    "VirtualMachine.Interact.CreateSecondary",
    "VirtualMachine.Interact.DefragmentAllDisks",
    "VirtualMachine.Interact.DeviceConnection",
    "VirtualMachine.Interact.DisableSecondary",
    "VirtualMachine.Interact.DnD",
    "VirtualMachine.Interact.EnableSecondary",
    "VirtualMachine.Interact.GuestControl",
    "VirtualMachine.Interact.MakePrimary",
    "VirtualMachine.Interact.Pause",
    "VirtualMachine.Interact.PowerOff",
    "VirtualMachine.Interact.PowerOn",
    "VirtualMachine.Interact.PutUsbScanCodes",
    "VirtualMachine.Interact.Record",
    "VirtualMachine.Interact.Replay",
    "VirtualMachine.Interact.Reset",
    "VirtualMachine.Interact.SESparseMaintenance",
    "VirtualMachine.Interact.SetCDMedia",
    "VirtualMachine.Interact.SetFloppyMedia",
    "VirtualMachine.Interact.Suspend",
    "VirtualMachine.Interact.TerminateFaultTolerantVM",
    "VirtualMachine.Interact.ToolsInstall",
    "VirtualMachine.Interact.TurnOffFaultTolerance",
    "VirtualMachine.Inventory.Create",
    "VirtualMachine.Inventory.CreateFromExisting",
    "VirtualMachine.Inventory.Delete",
    "VirtualMachine.Inventory.Move",
    "VirtualMachine.Inventory.Register",
    "VirtualMachine.Inventory.Unregister",
    "VirtualMachine.Provisioning.Clone",
    "VirtualMachine.Provisioning.CloneTemplate",
    "VirtualMachine.Provisioning.CreateTemplateFromVM",
    "VirtualMachine.Provisioning.Customize",
    "VirtualMachine.Provisioning.DeployTemplate",
    "VirtualMachine.Provisioning.DiskRandomAccess",
    "VirtualMachine.Provisioning.DiskRandomRead",
    "VirtualMachine.Provisioning.FileRandomAccess",
    "VirtualMachine.Provisioning.GetVmFiles",
    "VirtualMachine.Provisioning.MarkAsTemplate",
    "VirtualMachine.Provisioning.MarkAsVM",
    "VirtualMachine.Provisioning.ModifyCustSpecs",
    "VirtualMachine.Provisioning.PromoteDisks",
    "VirtualMachine.Provisioning.PutVmFiles",
    "VirtualMachine.Provisioning.ReadCustSpecs",
    "VApp.ResourceConfig",
    "VApp.InstanceConfig",
    "VApp.ApplicationConfig",
    "VApp.ManagedByConfig",
    "VApp.ExtractOvfEnvironment"
)
$PrivObj = @()
$PrivObj = Get-VIPrivilege -Id $ReqPriv # Retrieve object representing required privileges

if(Get-VIRole -Name $RoleName -ErrorAction SilentlyContinue){
  # Removes all privileges to add them again.
  Set-VIRole -Role $RoleName -RemovePrivilege (get-virole $RoleName | Get-VIPrivilege)
  Set-VIRole -Role $RoleName -AddPrivilege  $PrivObj.Name
}else{
  New-VIRole -Name $RoleName -Privilege $PrivObj.Name
}