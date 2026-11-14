#!/usr/bin/env python3
"""Pick a Tailscale exit node by city/country name (Mullvad-friendly), or print status."""
import json, re, subprocess, sys

def nodes():
    out = subprocess.run(["tailscale", "exit-node", "list"], capture_output=True, text=True).stdout
    for line in out.splitlines():
        cols = re.split(r"\s{2,}", line.strip())
        if len(cols) >= 4 and re.match(r"\d+\.\d+", cols[0]):
            ip, host, country, city = cols[:4]
            yield {"ip": ip, "host": host, "country": country, "city": city}

def label(n):
    if n["country"] in ("-", ""):
        return n["host"].split(".")[0]
    return f"{n['country']} (recommended)" if n["city"] == "Any" else f"{n['city']}, {n['country']}"

def status():
    st = json.loads(subprocess.run(["tailscale", "status", "--json"], capture_output=True, text=True).stdout or "{}")
    if st.get("BackendState") != "Running":
        return print("Tailscale: off")
    ex = st.get("ExitNodeStatus")
    if not ex:
        return print("Tailscale: on · no exit node")
    ip = (ex.get("TailscaleIPs") or [""])[0].split("/")[0]
    names = [label(n) for n in nodes() if n["ip"] == ip and n["city"] != "Any"]
    print(f"Tailscale: on · exit {names[0] if names else ip}")

def choose(q):
    q = q.strip().lower()
    if q in ("", "off", "none", "clear"):
        subprocess.run(["tailscale", "set", "--exit-node="], check=True)
        return print("Exit node off")
    ns = list(nodes())
    pick = (next((n for n in ns if n["country"].lower() == q and n["city"] == "Any"), None)
            or next((n for n in ns if n["city"].lower() == q), None)
            or next((n for n in ns if q in label(n).lower() or q in n["host"].lower()), None))
    if not pick:
        return print(f"No exit node matches '{q}'")
    subprocess.run(["tailscale", "set", f"--exit-node={pick['ip']}"], check=True)
    print(f"Exit node: {label(pick)}")

if __name__ == "__main__":
    status() if sys.argv[1:] == ["--status"] else choose(" ".join(sys.argv[1:]))
