#!/usr/bin/env python3
"""Summarize and compare Nmap XML reports; standard-library only."""
import sys
import xml.etree.ElementTree as ET
from collections import Counter
from pathlib import Path

RISK_PORTS = {
    21: ("FTP", "Prefer encrypted file transfer; verify anonymous access is disabled."),
    23: ("Telnet", "Clear-text remote login; replace with SSH where possible."),
    445: ("SMB", "Restrict file-sharing access and verify patching/firewall rules."),
    3389: ("RDP", "Restrict remote desktop exposure; use VPN/MFA and strong access controls."),
    5900: ("VNC", "Restrict remote desktop exposure and require strong encryption/authentication."),
    3306: ("MySQL", "Database ports should normally be limited to trusted application hosts."),
    5432: ("PostgreSQL", "Database ports should normally be limited to trusted application hosts."),
    6379: ("Redis", "Restrict access; verify authentication and network binding."),
    27017: ("MongoDB", "Restrict database access and verify authentication."),
}

def load(path):
    root = ET.parse(path).getroot()
    hosts = {}
    for host in root.findall("host"):
        status = host.find("status")
        if status is not None and status.get("state") != "up":
            continue
        addresses = [x.get("addr", "") for x in host.findall("address") if x.get("addrtype") in ("ipv4", "ipv6")]
        key = addresses[0] if addresses else f"host-{len(hosts) + 1}"
        names = [x.get("name", "") for x in host.findall("./hostnames/hostname")]
        ports = {}
        for node in host.findall("./ports/port"):
            state = node.find("state")
            if state is None or state.get("state") != "open":
                continue
            service = node.find("service")
            ports[f'{node.get("portid")}/{node.get("protocol")}'] = (
                service.get("name", "unknown") if service is not None else "unknown"
            )
        hosts[key] = {"name": names[0] if names else key, "ports": ports}
    finished = root.find("runstats/finished")
    timestamp = finished.get("timestr", "Unknown") if finished is not None else "Unknown"
    return {"hosts": hosts, "timestamp": timestamp}

def dashboard(directory):
    files = sorted(Path(directory).glob("*.xml"), key=lambda p: p.stat().st_mtime, reverse=True)
    if not files:
        print("No XML scan reports yet. Run a scan first.")
        return 0
    scans = []
    for path in files:
        try:
            data = load(path)
            scans.append((path, data))
        except (ET.ParseError, OSError) as exc:
            print(f"Skipped unreadable report {path.name}: {exc}")
    if not scans:
        print("No readable XML scan reports.")
        return 1
    total_hosts = sum(len(data["hosts"]) for _, data in scans)
    unique_hosts = set()
    port_counts = Counter()
    for _, data in scans:
        unique_hosts.update(data["hosts"])
        for host in data["hosts"].values():
            port_counts.update(host["ports"].keys())
    print("=" * 58)
    print("NMAP PRO DASHBOARD")
    print("=" * 58)
    print(f"Readable scans       : {len(scans)}")
    print(f"Hosts across scans   : {total_hosts}")
    print(f"Unique host addresses: {len(unique_hosts)}")
    print(f"Open-port observations: {sum(port_counts.values())}")
    print("\nRecent scans:")
    for path, data in scans[:10]:
        opened = sum(len(h["ports"]) for h in data["hosts"].values())
        print(f"  {path.name} | {len(data['hosts'])} hosts | {opened} open ports")
    print("\nMost frequently observed open ports:")
    for port, count in port_counts.most_common(10):
        print(f"  {port:<12} {count} observations")
    return 0

def analyze(path):
    data = load(path)
    print(f"EXPOSURE REVIEW: {Path(path).name}")
    print(f"Scan finished: {data['timestamp']}")
    print(f"Hosts up: {len(data['hosts'])}")
    findings = []
    for address, host in data["hosts"].items():
        for port_proto, service in host["ports"].items():
            try:
                number = int(port_proto.split("/")[0])
            except ValueError:
                continue
            if number in RISK_PORTS:
                label, advice = RISK_PORTS[number]
                findings.append((address, port_proto, label, service, advice))
    if not findings:
        print("\nNo ports in the built-in exposure review list were found open.")
        print("This does not prove the hosts are secure; review all services and scan scope.")
        return 0
    print(f"\nReview items: {len(findings)}")
    for address, port, label, service, advice in findings:
        print(f"\n[REVIEW] {address} - {port} ({label}; detected: {service})")
        print(f"  {advice}")
    print("\nImportant: these are exposure indicators, not confirmed vulnerabilities.")
    return 0

def compare(old_path, new_path):
    old, new = load(old_path), load(new_path)
    old_hosts, new_hosts = set(old["hosts"]), set(new["hosts"])
    old_ports = {(host, port) for host, item in old["hosts"].items() for port in item["ports"]}
    new_ports = {(host, port) for host, item in new["hosts"].items() for port in item["ports"]}
    print("SCAN COMPARISON")
    print(f"Older: {Path(old_path).name} ({old['timestamp']})")
    print(f"Newer: {Path(new_path).name} ({new['timestamp']})")
    print(f"Hosts: {len(old_hosts)} -> {len(new_hosts)}")
    print(f"New hosts: {', '.join(sorted(new_hosts - old_hosts)) or 'None'}")
    print(f"Missing hosts: {', '.join(sorted(old_hosts - new_hosts)) or 'None'}")
    added, removed = new_ports - old_ports, old_ports - new_ports
    print(f"Newly open ports: {len(added)}")
    for host, port in sorted(added):
        print(f"  + {host} {port}")
    print(f"No-longer-open ports: {len(removed)}")
    for host, port in sorted(removed):
        print(f"  - {host} {port}")
    print("\nA missing host/port may reflect scan scope or filtering, not necessarily a device or service being removed.")
    return 0

def main(argv):
    if len(argv) < 3:
        print("Usage: report_tools.py dashboard REPORT_DIR | analyze REPORT.xml | compare OLD.xml NEW.xml")
        return 2
    action = argv[1]
    try:
        if action == "dashboard" and len(argv) == 3:
            return dashboard(argv[2])
        if action == "analyze" and len(argv) == 3:
            return analyze(argv[2])
        if action == "compare" and len(argv) == 4:
            return compare(argv[2], argv[3])
    except (ET.ParseError, OSError) as exc:
        print(f"Report error: {exc}", file=sys.stderr)
        return 1
    print("Invalid command or arguments.")
    return 2

if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
