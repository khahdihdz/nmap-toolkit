#!/data/data/com.termux/files/usr/bin/bash
# Defensive, non-exploit security review helpers for authorized targets.

security_baseline_scan() {
    banner
    printf '%s\n' "$(msg security_baseline_title)"
    ask_target || { pause; return; }
    printf '%s\n' "Scope: common administration, file-sharing, database and web ports."
    printf '%s\n' "This is an exposure review, not a vulnerability verdict."
    run_scan "security_baseline" -sT -sV -T3 -p 21,22,23,25,53,80,110,139,143,443,445,3306,3389,5432,5900,6379,8080,8443,27017 "$TARGET"
    pause
}

security_tls_check() {
    banner
    printf '%s\n' "$(msg security_tls_title)"
    ask_target || { pause; return; }
    printf '%s\n' "Checks the presented TLS certificate on TCP 443 and 8443."
    run_scan "security_tls" -sT -p 443,8443 --script ssl-cert -T3 "$TARGET"
    pause
}

security_http_headers() {
    banner
    printf '%s\n' "$(msg security_http_title)"
    ask_target || { pause; return; }
    if ! command -v curl >/dev/null 2>&1; then
        printf '%s\n' "curl is missing. Install it with: pkg install curl"
        pause
        return
    fi
    local scheme url code
    for scheme in http https; do
        url="${scheme}://${TARGET}"
        printf '\n===== %s =====\n' "$url"
        code="$(curl -sS -I -L --max-time 12 -o /dev/null -w '%{http_code}' "$url" 2>/dev/null || true)"
        if [[ -z "$code" || "$code" == "000" ]]; then
            printf '%s\n' "No HTTP response received."
            continue
        fi
        printf 'HTTP status: %s\n' "$code"
        curl -k -sS -I -L --max-time 12 "$url" 2>/dev/null | tr -d '\r' | awk 'BEGIN{IGNORECASE=1} /^HTTP\// || /^strict-transport-security:/ || /^content-security-policy:/ || /^x-content-type-options:/ || /^x-frame-options:/ || /^referrer-policy:/ || /^permissions-policy:/ {print}'
        printf '%s\n' "Review missing security headers manually; proxy/CDN behavior may affect results."
    done
    pause
}

security_review_latest() {
    banner
    printf '%s\n' "$(msg security_review_title)"
    local xml
    xml="$(find "$REPORT_DIR" -maxdepth 1 -type f -name '*.xml' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n 1 | cut -d' ' -f2-)"
    if [[ -z "$xml" || ! -f "$xml" ]]; then
        printf '%s\n' "$(msg pro_html_none)"
    elif ! command -v python >/dev/null 2>&1; then
        printf '%s\n' "Python is required. Install with: pkg install python"
    elif ! python "$APP_DIR/lib/report_tools.py" analyze "$xml"; then
        printf '%s\n' "Could not review the latest report."
    fi
    pause

# Register security menu items; future modules can self-register here.
register_menu_item 17 security_menu17 security_baseline_scan
register_menu_item 18 security_menu18 security_tls_check
register_menu_item 19 security_menu19 security_http_headers
register_menu_item 20 security_menu20 security_review_latest
}
