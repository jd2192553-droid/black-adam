import sys
import time
import json
import random

def stream_log(message):
    print(message)
    sys.stdout.flush()
    time.sleep(random.uniform(0.3, 0.8))

def run_mock_scan(target):
    stream_log(f"[+] Starting security audit for target: {target}")
    stream_log("[*] Initializing mock audit environment...")
    stream_log("[*] Performing DNS resolution and host discovery...")
    
    # Simulate port scanning
    stream_log(f"[+] Host resolved successfully. Target IP: 192.168.1.{random.randint(10, 254)}")
    stream_log("[*] Launching port discovery scan (ports: 22, 80, 443, 8080)...")
    
    ports = [
        {"port": 22, "service": "SSH", "version": "OpenSSH 8.2p1", "status": "Open"},
        {"port": 80, "service": "HTTP", "version": "Apache httpd 2.4.41", "status": "Open"},
        {"port": 443, "service": "HTTPS", "version": "Apache httpd 2.4.41", "status": "Open"},
        {"port": 8080, "service": "HTTP-ALT", "version": "Werkzeug/2.0.3", "status": "Closed"}
    ]
    
    for p in ports:
        stream_log(f"  └─ Port {p['port']}/tcp: {p['status']} ({p['service']} - {p['version']})")
    
    # Simulate vulnerability assessment
    stream_log("[*] Analyzing service versions and configuration...")
    
    findings = [
        {
            "id": "SEC-01",
            "severity": "High",
            "title": "Out-of-date Apache Web Server Version",
            "description": "Apache HTTP Server version 2.4.41 is installed. This version is affected by multiple security vulnerabilities, including CVE-2021-40438 (Server-Side Request Forgery).",
            "remediation": "Upgrade Apache HTTP Server to version 2.4.52 or newer, or apply the official security patches."
        },
        {
            "id": "SEC-02",
            "severity": "Medium",
            "title": "Missing Security Headers",
            "description": "The web server on port 80/443 does not return standard security headers: X-Frame-Options, Content-Security-Policy, and Strict-Transport-Security.",
            "remediation": "Configure the web server to send 'X-Frame-Options: SAMEORIGIN', set a restrictive 'Content-Security-Policy', and enable 'Strict-Transport-Security' (HSTS)."
        },
        {
            "id": "SEC-03",
            "severity": "Low",
            "title": "SSH Password Authentication Enabled",
            "description": "The SSH server on port 22 allows password authentication, which is vulnerable to brute-force attempts.",
            "remediation": "Disable password authentication in /etc/ssh/sshd_config (PasswordAuthentication no) and enforce SSH Key-based authentication."
        }
    ]
    
    for f in findings:
        stream_log(f"[!] [{f['severity']}] Finding {f['id']}: {f['title']}")
        stream_log(f"    Description: {f['description']}")
        stream_log(f"    Remediation: {f['remediation']}")
        
    stream_log("[*] Compiling structured audit report...")
    
    # Output the final structured JSON results wrapped in a special block so dashboard can parse it
    report = {
        "target": target,
        "ports": [p for p in ports if p["status"] == "Open"],
        "findings": findings,
        "summary": {
            "critical": 0,
            "high": 1,
            "medium": 1,
            "low": 1
        }
    }
    
    # We write a JSON string at the very end
    print(f"REPORT_JSON:{json.dumps(report)}")
    sys.stdout.flush()
    stream_log("[+] Security audit completed successfully.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python workflow_engine.py <target_host_or_yaml>")
        sys.exit(1)
        
    target_input = sys.argv[1]
    
    # If a yaml file is passed, we can extract the target from it, or just use it as target name
    target = "example-target.local"
    if target_input.endswith(".yaml") or target_input.endswith(".yml"):
        try:
            with open(target_input, 'r') as f:
                content = f.read()
                # Simple parser to find target: value
                for line in content.splitlines():
                    if line.strip().startswith("target:"):
                        target = line.split(":", 1)[1].strip()
                        break
        except Exception:
            pass
    else:
        target = target_input
        
    run_mock_scan(target)
