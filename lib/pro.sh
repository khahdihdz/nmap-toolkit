#!/data/data/com.termux/files/usr/bin/bash
# Nmap Toolkit Pro features. Loaded by nmap-toolkit.sh.

pro_auto_lan() {
    banner
    printf '%s\n' "$(msg pro_auto_title)"
    local subnet
    subnet="$(ip -o -f inet addr show scope global 2>/dev/null | awk '$4 !~ /^127\./ {print $4; exit}')"
    if [[ -z "$subnet" ]]; then
        printf '%b%s%b\n' "$C_RED" "$(msg pro_no_subnet)" "$C_RESET"
        pause
        return
    fi
    printf '%b%s%b\n' "$C_GREEN" "$(msg pro_auto_ok "$subnet")" "$C_RESET"
    run_scan "pro_lan" -sn -n "$subnet"
    pause
}

pro_deep_scan() {
    banner
    printf '%s\n' "$(msg pro_deep_title)"
    ask_target || { pause; return; }
    run_scan "pro_deep" -sT -sV --top-ports 1000 -T3 "$TARGET"
    pause
}

pro_safe_nse() {
    banner
    printf '%s\n' "$(msg pro_nse_title)"
    ask_target || { pause; return; }
    printf '%s\n' "NSE category: safe | TCP top 100 ports"
    run_scan "pro_safe_nse" -sT -sV --top-ports 100 --script safe -T3 "$TARGET"
    pause
}

pro_export_html() {
    banner
    printf '%s\n' "$(msg pro_html_title)"
    local xml output
    xml="$(find "$REPORT_DIR" -maxdepth 1 -type f -name '*.xml' -printf '%T@ %p\\n' 2>/dev/null | sort -nr | head -n 1 | cut -d' ' -f2-)"
    if [[ -z "$xml" || ! -f "$xml" ]]; then
        printf '%s\n' "$(msg pro_html_none)"
        pause
        return
    fi
    output="${xml%.xml}.html"
    if command -v python >/dev/null 2>&1 && python "$APP_DIR/lib/xml_to_html.py" "$xml" "$output"; then
        printf '%b%s%b\n' "$C_GREEN" "$(msg pro_html_done "$output")" "$C_RESET"
    else
        printf '%b%s%b\n' "$C_RED" "$(msg pro_html_error)" "$C_RESET"
    fi
    pause
}
