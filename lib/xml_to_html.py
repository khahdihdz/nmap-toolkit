#!/usr/bin/env python3
"""Convert an Nmap XML report into a self-contained, mobile-friendly HTML file."""
import html
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


def text(value):
    return html.escape(value or "", quote=True)


def main():
    if len(sys.argv) != 3:
        print("Usage: xml_to_html.py input.xml output.html", file=sys.stderr)
        return 2
    source, destination = map(Path, sys.argv[1:])
    try:
        root = ET.parse(source).getroot()
    except (OSError, ET.ParseError) as exc:
        print(f"Cannot read Nmap XML: {exc}", file=sys.stderr)
        return 1

    hosts = []
    for host in root.findall("host"):
        status = host.find("status")
        state = status.get("state", "unknown") if status is not None else "unknown"
        addresses = [a.get("addr", "") for a in host.findall("address")]
        names = [n.get("name", "") for n in host.findall("./hostnames/hostname")]
        label = names[0] if names else (addresses[0] if addresses else "Unknown host")
        ports = []
        for port in host.findall("./ports/port"):
            state_node = port.find("state")
            service = port.find("service")
            ports.append({
                "port": f'{port.get("portid", "?")}/{port.get("protocol", "?")}',
                "state": state_node.get("state", "unknown") if state_node is not None else "unknown",
                "service": service.get("name", "") if service is not None else "",
                "product": service.get("product", "") if service is not None else "",
                "version": service.get("version", "") if service is not None else "",
            })
        hosts.append((label, state, ", ".join(addresses), ports))

    run = root.find("runstats/finished")
    finished = run.get("timestr", "Unknown") if run is not None else "Unknown"
    rows = []
    for label, state, addresses, ports in hosts:
        port_rows = "".join(
            "<tr><td>{}</td><td>{}</td><td>{}</td><td>{}</td></tr>".format(
                text(p["port"]), text(p["state"]), text(p["service"]),
                text(" ".join(x for x in (p["product"], p["version"]) if x))
            ) for p in ports
        ) or '<tr><td colspan="4">No port details in this report</td></tr>'
        rows.append(
            '<section class="host"><h2>{}</h2><p>State: {} · Address: {}</p>'
            '<div class="table-wrap"><table><thead><tr><th>Port</th><th>State</th>'
            '<th>Service</th><th>Product / Version</th></tr></thead><tbody>{}</tbody></table></div></section>'
            .format(text(label), text(state), text(addresses), port_rows)
        )

    document = """<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Nmap scan report</title><style>
:root{color-scheme:dark}*{box-sizing:border-box}body{margin:0;padding:20px;font:15px system-ui,sans-serif;background:#101827;color:#e5edf8}
main{max-width:1000px;margin:auto}h1{color:#65d6c4}h2{font-size:18px;margin:0 0 8px}
.meta,.host{background:#1b293b;border:1px solid #34445b;border-radius:12px;padding:16px;margin:14px 0}
.table-wrap{overflow-x:auto}table{width:100%;border-collapse:collapse;min-width:520px}th,td{text-align:left;padding:9px;border-bottom:1px solid #34445b}
th{color:#8de1d2}p{color:#b9c8dc}.empty{padding:18px}
</style></head><body><main><h1>Nmap scan report</h1>
<div class="meta">Source: """ + text(source.name) + """<br>Finished: """ + text(finished) + """<br>Hosts in report: """ + str(len(hosts)) + """</div>
""" + ("".join(rows) if rows else '<p class="empty">No hosts were recorded in this report.</p>') + """
</main></body></html>"""
    try:
        destination.write_text(document, encoding="utf-8")
    except OSError as exc:
        print(f"Cannot write HTML report: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
