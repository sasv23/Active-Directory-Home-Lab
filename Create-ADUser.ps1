# Create-ADUser.ps1
# Automates Active Directory user creation for the LAB.local domain
# Usage: .\Create-ADUser.ps1

# Import the Active Directory module
Import-Module ActiveDirectory

# --- Configuration ---
$Domain = "LAB.local"
$DomainDN = "DC=LAB,DC=local"

# OU map — maps department name to its Distinguished Name
$OUMap = @{
    "Engineering" = "OU=Engineering,$DomainDN"
    "IT"          = "OU=IT,$DomainDN"
    "Management"  = "OU=Management,$DomainDN"
    "Administrators" = "OU=Administrators,$DomainDN"
}

# --- Password Generator ---
function New-RandomPassword {
    param([int]$Length = 14)

    # Character sets — covers uppercase, lowercase, digits, and special chars
    $CharSets = @(
        (0x41..0x5A | ForEach-Object { [char]$_ }),   # A-Z
        (0x61..0x7A | ForEach-Object { [char]$_ }),   # a-z
        (0x30..0x39 | ForEach-Object { [char]$_ }),   # 0-9
        ('!','@','#','$','%','^','&','*','(',')')      # Special characters
    )

    $AllChars = $CharSets | ForEach-Object { $_ }

    # Guarantee at least one character from each set
    $Password = @(
        $CharSets[0] | Get-Random
        $CharSets[1] | Get-Random
        $CharSets[2] | Get-Random
        $CharSets[3] | Get-Random
    )

    # Fill the rest randomly
    for ($i = $Password.Count; $i -lt $Length; $i++) {
        $Password += $AllChars | Get-Random
    }

    # Shuffle and return as string
    return (-join ($Password | Sort-Object { Get-Random }))
}

# --- User Creation Function ---
function New-ADLabUser {
    param(
        [string]$FirstName,
        [string]$LastName,
        [string]$Department
    )

    # Validate department
    if (-not $OUMap.ContainsKey($Department)) {
        Write-Warning "Unknown department '$Department'. Valid options: $($OUMap.Keys -join ', ')"
        return
    }

    # Build username (first initial + last name, lowercase)
    $Username = ($FirstName[0] + $LastName).ToLower()
    $FullName  = "$FirstName $LastName"
    $TargetOU  = $OUMap[$Department]

    # Generate and convert password
    $PlainPassword  = New-RandomPassword
    $SecurePassword = ConvertTo-SecureString $PlainPassword -AsPlainText -Force

    # Create the user
    try {
        New-ADUser `
            -Name            $FullName `
            -GivenName       $FirstName `
            -Surname         $LastName `
            -SamAccountName  $Username `
            -UserPrincipalName "$Username@$Domain" `
            -Path            $TargetOU `
            -AccountPassword $SecurePassword `
            -Enabled         $true `
            -PasswordNeverExpires $false `
            -ChangePasswordAtLogon $true

        Write-Host "Created user: $Username | Department: $Department | Password: $PlainPassword" -ForegroundColor Green

        # Verify creation
        $User = Get-ADUser $Username
        Write-Host "Verified — SamAccountName: $($User.SamAccountName) | SID: $($User.SID)" -ForegroundColor Cyan

    } catch {
        Write-Error "Failed to create user '$Username': $_"
    }
}

# --- Example Users ---
New-ADLabUser -FirstName "Sarah"  -LastName "Venkatesh" -Department "Engineering"
New-ADLabUser -FirstName "James"  -LastName "Okonkwo"   -Department "IT"
New-ADLabUser -FirstName "Maria"  -LastName "Santos"     -Department "Management"
