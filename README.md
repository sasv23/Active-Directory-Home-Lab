# Active Directory Home Lab

A hands-on home lab built to simulate an enterprise Active Directory environment using Windows Server, PowerShell automation, and Group Policy management.

---

## Domain

`LAB.local`

---

## Technologies Used

- Windows Server (Domain Controller)
- Active Directory Domain Services (AD DS)
- Active Directory Users and Computers (ADUC)
- Group Policy Management
- Active Directory Certificate Services (AD CS)
- PowerShell
- VirtualBox
- Windows 11 (Workstation — WS01)

---

## Architecture / OU Structure

```
LAB.local
├── Engineering
├── IT
├── Management
└── Administrators
```

---

## What I Built

### Active Directory Deployment
- Installed AD DS and promoted a Windows Server to Domain Controller
- Created and configured the `LAB.local` domain

### User & Computer Management
- Created and managed user accounts across OUs
- Joined workstation `WS01` to the domain and verified membership

### Group Policy
- Created and linked Group Policy Objects (GPOs)
- Configured an Engineering-specific desktop background policy
- Verified policy deployment on domain-joined machines

### Active Directory Certificate Services
- Installed and configured AD CS to support certificate-based authentication

### PowerShell Automation
- Wrote `Create-ADUser.ps1` to automate user provisioning:
  - Accepts user information as input
  - Generates passwords meeting domain complexity requirements
  - Converts passwords to `SecureString`
  - Creates users with `New-ADUser`
  - Places users into the correct OU automatically

---

## PowerShell Script

See [`Create-ADUser.ps1`](./Create-ADUser.ps1)

---

## Troubleshooting

| Issue | Root Cause | Fix |
|---|---|---|
| Script not found | File saved as `.ps1.code-workspace` | Resaved correctly as `.ps1` |
| Scripts disabled | PowerShell execution policy | `Set-ExecutionPolicy -Scope Process Bypass` |
| Password rejected by AD | Generator missing special characters | Added special character range to password generator |

---

## Lessons Learned

- **ASCII ranges in PowerShell** — used hex ranges (`0x30..0x39`, `0x41..0x5A`, etc.) to build character sets for password generation; learned that `[char]116` returns `t`
- **SIDs** — Windows uses Security Identifiers (SIDs), not usernames, for permissions and access control
- **Execution Policies** — scoped policies allow flexibility without permanently weakening system security
- **AD Password Complexity** — domain policies require uppercase, lowercase, numbers, and special characters

---

## Screenshots

> *Coming soon — AD structure, GPO configuration, and PowerShell output*

---

## Future Improvements

- Additional Group Policy controls (screensaver timeout, USB restrictions, etc.)
- Active Directory permissions and delegation
- Shared folders with NTFS permissions
- DNS and DHCP configuration
- Expanded PowerShell automation (user lifecycle, offboarding)
- User lifecycle management workflows

---

I'm excited to continue building on this lab, deepen my understanding of Windows Server administration and Active Directory, and gain more hands-on experience with automation and enterprise system management.
