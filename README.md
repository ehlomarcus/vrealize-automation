# vra
vRealize Automation

Repo for scripts used by vRA during provisioning

### Guest Agent

* gugent_puppet_facts : Load workitem.xml payload in to puppet facts. Intended to be run before puppet agent bootstrap.

### vSphere

* Set-vRealizeProxyAgentRolePrivileges.ps1 : Used for setting vCenter privileges on the role used by vSphere Proxy Agent.