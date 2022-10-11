# DockerSecurity
## Host Security
This section will focus solely on ensuring that the host (in this case Linux Ubuntu) is secured. 
1. Ensure the host is up to date
    * sudo apt update && sudo apt upgrade
    * automatic updates ? the version should probably be reviewed properly first ?
2. Server hardening
    * secure access
        - SSH key authentication only
        - create a limited user
        - disable root login
        - no password
        - change default SSH port (22)
    * implement a firewall
    * implement a fail2ban
3. Kernel security
    * Install and configure SELinux/AppArmor
4. Snapchot the host configuration
* Installer Watchtower pour les mise à jour
## Image Provenance
* Enable Docker Content Trust (DCT). Utilize The Update Framework (TUF) with notary server to prevents user to work with unsigned images.
## Monitor Containers
* Fluentd syslog
