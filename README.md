# Nmap Toolkit

A beginner-friendly Nmap menu toolkit for **Termux on Android**. Designed for non-root devices and uses TCP connect scans where raw-packet privileges are unavailable.

## Features

- Discover live hosts on a LAN subnet
- Scan the 100 most common TCP ports
- Scan a custom TCP port list or range
- Detect service versions
- Run a quick TCP scan
- View and open saved scan reports
- Save each scan in Nmap normal, XML, and grepable formats
- Vietnamese interactive menu

## Requirements

- Android with Termux installed (use a current Termux build)
- Internet access for initial package installation
- Nmap and Git (the installer installs these)

## Install

Run in Termux:

```bash
pkg update -y
pkg install -y curl
curl -fsSL https://raw.githubusercontent.com/khahdihdz/nmap-toolkit/main/install.sh | bash
```

Then launch:

```bash
nmaptool
```

Alternatively, clone the repository and run `bash nmap-toolkit.sh`.

## Menu

1. LAN host discovery (`-sn`)
2. Top 100 TCP ports (`-sT --top-ports 100`)
3. Custom TCP ports
4. Service/version detection (`-sT -sV`)
5. Quick TCP scan (`-sT -F`)
6. View saved reports
7. Update Nmap
0. Exit

## Reports

Reports are stored under:

```
$HOME/nmap-toolkit/reports/
```

Every scan writes Nmap normal, XML, and grepable output. XML is useful for later processing and HTML report generation.

## Notes and safe use

- Only scan networks and devices you own or have explicit permission to assess.
- On non-root Android/Termux, TCP connect scan (`-sT`) is the practical default. SYN scan and some OS-detection features require raw-packet privileges and may not work.
- LAN discovery may be affected by Wi-Fi client isolation, VPNs, firewalls, or Android network restrictions.
- The toolkit deliberately does not run aggressive scripts, vulnerability checks, stealth scans, or internet-wide scans.

## Update / uninstall

Run `nmaptool` and choose **7** to update Nmap packages. To update the toolkit itself, rerun the install command.

Remove the toolkit:

```bash
rm -rf "$HOME/nmap-toolkit"
rm -f "$PREFIX/bin/nmaptool"
```

## License

MIT
