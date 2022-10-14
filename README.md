# DockerSecurity

## Security Audit
1. Host security
    * Using Lynis
2. Docker Security
    * Using Docker Bench Security

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
        - iptables-persistent so the rules would still applied after a server reboot
    * implement a fail2ban
    * Install a malware scanner
        - clamAV
3. Kernel security
    * Install and configure SELinux/AppArmor
4. Snapchot the host configuration
* Installer Watchtower pour les mise à jour

## Image Provenance
* Enable Docker Content Trust (DCT). Utilize The Update Framework (TUF) with notary server to prevents user to work with unsigned images.

## Monitor Containers
* Serveur de log
   - Fluentd syslog

## Container security
1. Run containers with unprivileged user
    * Add an unprivileged user within the docker images
        - When creating the user (within the Dockerfile): RUN groupadd -r basic && useradd -r -g user basic
        - When running the image: docker run -u user -it image /bin/bash
    * Create a root password or disable root within the docker images to prevent privilege escalation from a simple user
        - Prevent root access by changing its shell to nologin (within the Dockerfile): RUN chsh -s /usr/sbin/nologin root
2. Special permissions SUID
    * Prevent privilege escalation (for example using the setUID binary) by specifying security options when running the image
        - docker run -it image --security-opt=no-new-privileges
3. Run the containers that shouldn't be modified in read only mode
    * docker run --read-only -it image /bin/bash
4. Isolate containers by creating networks
