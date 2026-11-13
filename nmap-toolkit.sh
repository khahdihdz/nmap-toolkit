#!/data/data/com.termux/files/usr/bin/bash
# Nmap Toolkit - bilingual (Vietnamese/English) Termux frontend.
set -uo pipefail

APP_DIR="${HOME}/nmap-toolkit"
REPORT_DIR="${APP_DIR}/reports"
CONFIG_DIR="${HOME}/.config/nmap-toolkit"
LANG_FILE="${CONFIG_DIR}/language"
mkdir -p "$REPORT_DIR" "$CONFIG_DIR"

C_RESET='\033[0m'
C_CYAN='\033[0;36m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_RED='\033[0;31m'

LANGUAGE="vi"
if [[ -f "$LANG_FILE" ]]; then
    IFS= read -r LANGUAGE < "$LANG_FILE" || LANGUAGE="vi"
fi
[[ "$LANGUAGE" == "en" ]] || LANGUAGE="vi"

msg() {
    local key="$1"
    if [[ "$LANGUAGE" == "en" ]]; then
        case "$key" in
            pause) printf '%s' 'Press Enter to continue...' ;;
            nmap) printf '%s' 'Nmap' ;;
            reports) printf '%s' 'Reports' ;;
            install_missing) printf '%s' 'Nmap is missing. Installing...' ;;
            install_failed) printf '%s' 'Could not install Nmap.' ;;
            scanning) printf '%s' 'Scanning...' ;;
            saved) printf '%s' 'Reports saved:' ;;
            scan_error) printf 'Nmap exited with error code %s.' "$2" ;;
            target_prompt) printf '%s' 'Target IP/hostname (only systems you are authorized to test): ' ;;
            target_invalid) printf '%s' 'Invalid target.' ;;
            lan_title) printf '%s' 'LAN HOST DISCOVERY' ;;
            route_info) printf '%s' 'Current route information:' ;;
            subnet_hint) printf '%s' 'Example subnet: 192.168.1.0/24 (replace with your actual subnet).' ;;
            subnet_prompt) printf '%s' 'Enter subnet: ' ;;
            subnet_invalid) printf '%s' 'Invalid IPv4/CIDR subnet format.' ;;
            top_title) printf '%s' 'TOP 100 COMMON TCP PORTS' ;;
            custom_title) printf '%s' 'CUSTOM TCP PORT SCAN' ;;
            ports_prompt) printf '%s' 'Enter ports (e.g. 22,80,443 or 1-1024): ' ;;
            ports_invalid) printf '%s' 'Invalid port list.' ;;
            service_title) printf '%s' 'SERVICE AND VERSION DETECTION' ;;
            quick_title) printf '%s' 'QUICK TCP SCAN' ;;
            history_title) printf '%s' 'SCAN REPORT HISTORY' ;;
            no_reports) printf '%s' 'No reports yet.' ;;
            file_prompt) printf '%s' 'Enter a .nmap filename to view (Enter to go back): ' ;;
            file_invalid) printf '%s' 'Invalid filename or file does not exist.' ;;
            update_title) printf '%s' 'UPDATE NMAP' ;;
            choose) printf '%s' 'Choose an option: ' ;;
            invalid_choice) printf '%s' 'Invalid choice.' ;;
            goodbye) printf '%s' 'Goodbye!' ;;
            menu_title) printf '%s' 'NMAP TOOLKIT' ;;
            menu_subtitle) printf '%s' 'TERMUX / ANDROID' ;;
            menu1) printf '%s' 'Discover devices on LAN' ;;
            menu2) printf '%s' 'Scan top 100 TCP ports' ;;
            menu3) printf '%s' 'Scan custom TCP ports' ;;
            menu4) printf '%s' 'Detect services/versions' ;;
            menu5) printf '%s' 'Quick scan' ;;
            menu6) printf '%s' 'View scan reports' ;;
            menu7) printf '%s' 'Update Nmap' ;;
            menu8) printf '%s' 'Change language / Ngôn ngữ' ;;
            menu9) printf '%s' 'Delete report history' ;;
            del_title) printf '%s' 'DELETE SCAN REPORT HISTORY' ;;
            del_confirm) printf '%s' 'Delete all saved .nmap, .xml and .gnmap reports? (y/N): ' ;;
            del_cancelled) printf '%s' 'Deletion cancelled.' ;;
            del_done) printf 'Deleted %s report files.' "$2" ;;
            pro_auto_title) printf '%s' 'AUTO-DETECT LAN AND DISCOVER HOSTS' ;;
            pro_auto_ok) printf 'Detected subnet: %s' "$2" ;;
            pro_no_subnet) printf '%s' 'Could not detect an IPv4 subnet. Connect to Wi-Fi or enter a subnet using option 1.' ;;
            pro_deep_title) printf '%s' 'PRO DEEP TCP SCAN - TOP 1000 PORTS' ;;
            pro_nse_title) printf '%s' 'SAFE NSE SECURITY CHECK' ;;
            pro_html_title) printf '%s' 'EXPORT HTML REPORT' ;;
            pro_html_none) printf '%s' 'No XML scan report found.' ;;
            pro_html_done) printf 'HTML report created: %s' "$2" ;;
            pro_html_error) printf '%s' 'Could not generate HTML report. Check Python installation.' ;;
            pro_menu10) printf '%s' 'Auto-detect LAN and discover hosts [PRO]' ;;
            pro_menu11) printf '%s' 'Deep TCP scan - top 1000 ports [PRO]' ;;
            pro_menu12) printf '%s' 'Safe NSE checks [PRO]' ;;
            pro_menu13) printf '%s' 'Export latest XML report to HTML [PRO]' ;;
            pro_menu14) printf '%s' 'Pro dashboard - scan statistics' ;;
            pro_menu15) printf '%s' 'Analyze latest scan exposure' ;;
            pro_menu16) printf '%s' 'Compare latest two scans' ;;
            security_baseline_title) printf '%s' 'ADVANCED SECURITY EXPOSURE BASELINE' ;;
            security_tls_title) printf '%s' 'TLS CERTIFICATE REVIEW' ;;
            security_http_title) printf '%s' 'HTTP SECURITY HEADERS REVIEW' ;;
            security_review_title) printf '%s' 'LATEST SECURITY EXPOSURE REVIEW' ;;
            security_menu17) printf '%s' 'Security baseline - common sensitive ports' ;;
            security_menu18) printf '%s' 'TLS certificate inspection (443/8443)' ;;
            security_menu19) printf '%s' 'HTTP security headers review' ;;
            security_menu20) printf '%s' 'Review latest scan for exposure indicators' ;;
            menu0) printf '%s' 'Exit' ;;
            lang_title) printf '%s' 'LANGUAGE / NGÔN NGỮ' ;;
            lang_vi) printf '%s' 'Vietnamese' ;;
            lang_en) printf '%s' 'English' ;;
            lang_saved) printf '%s' 'Language preference saved.' ;;
            lang_prompt) printf '%s' 'Select language (1/2): ' ;;
            *) printf '%s' "$key" ;;
        esac
    else
        case "$key" in
            pause) printf '%s' 'Nhấn Enter để tiếp tục...' ;;
            nmap) printf '%s' 'Nmap' ;;
            reports) printf '%s' 'Báo cáo' ;;
            install_missing) printf '%s' 'Chưa có Nmap. Đang cài đặt...' ;;
            install_failed) printf '%s' 'Không thể cài Nmap.' ;;
            scanning) printf '%s' 'Đang quét...' ;;
            saved) printf '%s' 'Đã lưu báo cáo:' ;;
            scan_error) printf 'Nmap kết thúc với mã lỗi %s.' "$2" ;;
            target_prompt) printf '%s' 'Nhập IP/hostname mục tiêu (chỉ thiết bị được phép kiểm tra): ' ;;
            target_invalid) printf '%s' 'Mục tiêu không hợp lệ.' ;;
            lan_title) printf '%s' 'QUÉT TÌM THIẾT BỊ TRONG LAN' ;;
            route_info) printf '%s' 'Thông tin route hiện tại:' ;;
            subnet_hint) printf '%s' 'Ví dụ subnet: 192.168.1.0/24 (hãy thay bằng subnet thực tế của bạn).' ;;
            subnet_prompt) printf '%s' 'Nhập subnet: ' ;;
            subnet_invalid) printf '%s' 'Định dạng subnet IPv4/CIDR không hợp lệ.' ;;
            top_title) printf '%s' 'QUÉT 100 CỔNG TCP PHỔ BIẾN' ;;
            custom_title) printf '%s' 'QUÉT CỔNG TCP TÙY CHỌN' ;;
            ports_prompt) printf '%s' 'Nhập cổng (vd: 22,80,443 hoặc 1-1024): ' ;;
            ports_invalid) printf '%s' 'Danh sách cổng không hợp lệ.' ;;
            service_title) printf '%s' 'NHẬN DIỆN DỊCH VỤ VÀ PHIÊN BẢN' ;;
            quick_title) printf '%s' 'QUÉT NHANH' ;;
            history_title) printf '%s' 'LỊCH SỬ BÁO CÁO' ;;
            no_reports) printf '%s' 'Chưa có báo cáo.' ;;
            file_prompt) printf '%s' 'Nhập tên file .nmap để xem (Enter để quay lại): ' ;;
            file_invalid) printf '%s' 'Tên file không hợp lệ hoặc không tồn tại.' ;;
            update_title) printf '%s' 'CẬP NHẬT NMAP' ;;
            choose) printf '%s' 'Chọn chức năng: ' ;;
            invalid_choice) printf '%s' 'Lựa chọn không hợp lệ.' ;;
            goodbye) printf '%s' 'Tạm biệt!' ;;
            menu_title) printf '%s' 'NMAP TOOLKIT' ;;
            menu_subtitle) printf '%s' 'TERMUX / ANDROID' ;;
            menu1) printf '%s' 'Quét tìm thiết bị trong LAN' ;;
            menu2) printf '%s' 'Quét 100 cổng TCP phổ biến' ;;
            menu3) printf '%s' 'Quét cổng TCP tùy chọn' ;;
            menu4) printf '%s' 'Nhận diện dịch vụ/phiên bản' ;;
            menu5) printf '%s' 'Quét nhanh' ;;
            menu6) printf '%s' 'Xem lịch sử báo cáo' ;;
            menu7) printf '%s' 'Cập nhật Nmap' ;;
            menu8) printf '%s' 'Đổi ngôn ngữ / Language' ;;
            menu9) printf '%s' 'Xóa lịch sử báo cáo' ;;
            del_title) printf '%s' 'XÓA LỊCH SỬ BÁO CÁO QUÉT' ;;
            del_confirm) printf '%s' 'Xóa toàn bộ báo cáo .nmap, .xml và .gnmap đã lưu? (y/N): ' ;;
            del_cancelled) printf '%s' 'Đã hủy thao tác xóa.' ;;
            del_done) printf 'Đã xóa %s tệp báo cáo.' "$2" ;;
            pro_auto_title) printf '%s' 'TỰ NHẬN DIỆN MẠNG LAN VÀ TÌM THIẾT BỊ' ;;
            pro_auto_ok) printf 'Đã nhận diện subnet: %s' "$2" ;;
            pro_no_subnet) printf '%s' 'Không nhận diện được subnet IPv4. Hãy kết nối Wi-Fi hoặc nhập subnet ở mục 1.' ;;
            pro_deep_title) printf '%s' 'QUÉT TCP CHUYÊN SÂU - 1.000 CỔNG' ;;
            pro_nse_title) printf '%s' 'KIỂM TRA AN TOÀN BẰNG NSE' ;;
            pro_html_title) printf '%s' 'XUẤT BÁO CÁO HTML' ;;
            pro_html_none) printf '%s' 'Chưa tìm thấy báo cáo XML.' ;;
            pro_html_done) printf 'Đã tạo báo cáo HTML: %s' "$2" ;;
            pro_html_error) printf '%s' 'Không thể tạo báo cáo HTML. Hãy kiểm tra Python đã được cài đặt.' ;;
            pro_menu10) printf '%s' 'Tự nhận diện LAN và tìm thiết bị [PRO]' ;;
            pro_menu11) printf '%s' 'Quét TCP chuyên sâu - 1.000 cổng [PRO]' ;;
            pro_menu12) printf '%s' 'Kiểm tra an toàn NSE [PRO]' ;;
            pro_menu13) printf '%s' 'Xuất báo cáo XML mới nhất sang HTML [PRO]' ;;
            pro_menu14) printf '%s' 'Pro Dashboard - thống kê quét' ;;
            pro_menu15) printf '%s' 'Phân tích mức độ phơi lộ lần quét mới nhất' ;;
            pro_menu16) printf '%s' 'So sánh hai lần quét gần nhất' ;;
            security_baseline_title) printf '%s' 'ĐÁNH GIÁ BỀ MẶT TẤN CÔNG CƠ BẢN' ;;
            security_tls_title) printf '%s' 'KIỂM TRA CHỨNG CHỈ TLS' ;;
            security_http_title) printf '%s' 'KIỂM TRA HTTP SECURITY HEADERS' ;;
            security_review_title) printf '%s' 'ĐÁNH GIÁ BẢO MẬT BÁO CÁO MỚI NHẤT' ;;
            security_menu17) printf '%s' 'Rà soát cổng/dịch vụ nhạy cảm' ;;
            security_menu18) printf '%s' 'Kiểm tra chứng chỉ TLS (443/8443)' ;;
            security_menu19) printf '%s' 'Rà soát HTTP Security Headers' ;;
            security_menu20) printf '%s' 'Phân tích dấu hiệu phơi lộ từ báo cáo mới nhất' ;;
            menu0) printf '%s' 'Thoát' ;;
            lang_title) printf '%s' 'NGÔN NGỮ / LANGUAGE' ;;
            lang_vi) printf '%s' 'Tiếng Việt' ;;
            lang_en) printf '%s' 'Tiếng Anh' ;;
            lang_saved) printf '%s' 'Đã lưu tùy chọn ngôn ngữ.' ;;
            lang_prompt) printf '%s' 'Chọn ngôn ngữ (1/2): ' ;;
            *) printf '%s' "$key" ;;
        esac
    fi
}

pause() {
    printf '\n%s' "$(msg pause)"
    read -r _
}

banner() {
    clear
    printf '%b\n' "$C_CYAN"
    printf '%s\n' '========================================'
    printf '          %s\n' "$(msg menu_title)"
    printf '          %s\n' "$(msg menu_subtitle)"
    printf '%s\n' '========================================'
    printf '%b\n' "$C_RESET"
    printf '%s: %s\n' "$(msg nmap)" "$(nmap --version 2>/dev/null | head -n 1)"
    printf '%s: %s\n\n' "$(msg reports)" "$REPORT_DIR"
}

require_nmap() {
    if ! command -v nmap >/dev/null 2>&1; then
        printf '%b%s%b\n' "$C_YELLOW" "$(msg install_missing)" "$C_RESET"
        pkg install -y nmap || return 1
    fi
}

valid_target() {
    [[ "$1" =~ ^[A-Za-z0-9._:-]+$ ]]
}

valid_ports() {
    [[ "$1" =~ ^[0-9,-]+$ ]] || return 1
    [[ "$1" != -* && "$1" != *- && "$1" != *,*,,* ]]
}

run_scan() {
    local label="$1"
    shift
    local stamp base status
    stamp="$(date +%Y%m%d_%H%M%S)"
    base="$REPORT_DIR/${stamp}_${label}"
    printf '\n%b%s%b\n' "$C_YELLOW" "$(msg scanning)" "$C_RESET"
    nmap "$@" -oA "$base"
    status=$?
    printf '\n'
    if [[ $status -eq 0 ]]; then
        printf '%b%s%b\n%s.nmap\n%s.xml\n%s.gnmap\n' "$C_GREEN" "$(msg saved)" "$C_RESET" "$base" "$base" "$base"
    else
        printf '%b%s%b\n' "$C_RED" "$(msg scan_error "$status")" "$C_RESET"
    fi
}

ask_target() {
    local value
    read -r -p "$(msg target_prompt)" value
    if [[ -z "$value" ]] || ! valid_target "$value"; then
        printf '%b%s%b\n' "$C_RED" "$(msg target_invalid)" "$C_RESET"
        return 1
    fi
    TARGET="$value"
}

scan_lan() {
    banner
    printf '%s\n' "$(msg lan_title)"
    printf '\n%s\n' "$(msg route_info)"
    ip route 2>/dev/null || true
    printf '\n%s\n' "$(msg subnet_hint)"
    read -r -p "$(msg subnet_prompt)" subnet
    if [[ ! "$subnet" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/([0-9]|[12][0-9]|3[0-2])$ ]]; then
        printf '%b%s%b\n' "$C_RED" "$(msg subnet_invalid)" "$C_RESET"
        pause
        return
    fi
    run_scan "lan" -sn -n "$subnet"
    pause
}

scan_top() {
    banner
    printf '%s\n' "$(msg top_title)"
    ask_target || { pause; return; }
    run_scan "top100" -sT -sV --top-ports 100 "$TARGET"
    pause
}

scan_custom() {
    banner
    printf '%s\n' "$(msg custom_title)"
    ask_target || { pause; return; }
    read -r -p "$(msg ports_prompt)" ports
    if ! valid_ports "$ports"; then
        printf '%b%s%b\n' "$C_RED" "$(msg ports_invalid)" "$C_RESET"
        pause
        return
    fi
    run_scan "custom" -sT -p "$ports" "$TARGET"
    pause
}

scan_services() {
    banner
    printf '%s\n' "$(msg service_title)"
    ask_target || { pause; return; }
    run_scan "services" -sT -sV --version-light "$TARGET"
    pause
}

scan_quick() {
    banner
    printf '%s\n' "$(msg quick_title)"
    ask_target || { pause; return; }
    run_scan "quick" -sT -F -T3 "$TARGET"
    pause
}

show_reports() {
    banner
    printf '%s\n' "$(msg history_title)"
    local files file
    files="$(find "$REPORT_DIR" -maxdepth 1 -type f \( -name '*.nmap' -o -name '*.xml' -o -name '*.gnmap' \) -print 2>/dev/null | sort -r)"
    if [[ -z "$files" ]]; then
        printf '%s\n' "$(msg no_reports)"
        pause
        return
    fi
    printf '%s\n' "$files"
    printf '\n'
    read -r -p "$(msg file_prompt)" file
    if [[ -n "$file" ]]; then
        if [[ "$file" == */* || ! -f "$REPORT_DIR/$file" || "$file" != *.nmap ]]; then
            printf '%b%s%b\n' "$C_RED" "$(msg file_invalid)" "$C_RESET"
        else
            cat "$REPORT_DIR/$file"
        fi
    fi
    pause
}

delete_reports() {
    banner
    printf '%s\n' "$(msg del_title)"
    local confirm count=0 file
    local -a reports=()
    while IFS= read -r -d '' file; do
        reports+=("$file")
    done < <(find "$REPORT_DIR" -maxdepth 1 -type f \( -name '*.nmap' -o -name '*.xml' -o -name '*.gnmap' \) -print0 2>/dev/null)

    count=${#reports[@]}
    if [[ "$count" -eq 0 ]]; then
        printf '%s\n' "$(msg no_reports)"
        pause
        return
    fi

    read -r -p "$(msg del_confirm)" confirm
    case "$confirm" in
        y|Y|yes|YES|Yes)
            rm -f -- "${reports[@]}"
            printf '%b%s%b\n' "$C_GREEN" "$(msg del_done "$count")" "$C_RESET"
            ;;
        *)
            printf '%s\n' "$(msg del_cancelled)"
            ;;
    esac
    pause
}

update_nmap() {
    banner
    printf '%s\n' "$(msg update_title)"
    pkg update -y && pkg upgrade nmap -y
    pause
}

change_language() {
    banner
    printf '%s\n' "$(msg lang_title)"
    printf '1. %s\n' "$(msg lang_vi)"
    printf '2. %s\n' "$(msg lang_en)"
    read -r -p "$(msg lang_prompt)" lang_choice
    case "$lang_choice" in
        1) LANGUAGE="vi" ;;
        2) LANGUAGE="en" ;;
        *) printf '%s\n' "$(msg invalid_choice)"; pause; return ;;
    esac
    printf '%s\n' "$LANGUAGE" > "$LANG_FILE"
    printf '%s\n' "$(msg lang_saved)"
    pause
}

main() {
    require_nmap || { printf '%s\n' "$(msg install_failed)"; exit 1; }
    while true; do
        banner
        printf '1. %s\n' "$(msg menu1)"
        printf '2. %s\n' "$(msg menu2)"
        printf '3. %s\n' "$(msg menu3)"
        printf '4. %s\n' "$(msg menu4)"
        printf '5. %s\n' "$(msg menu5)"
        printf '6. %s\n' "$(msg menu6)"
        printf '7. %s\n' "$(msg menu7)"
        printf '8. %s\n' "$(msg menu8)"
        printf '9. %s\n' "$(msg menu9)"
        printf '10. %s\n' "$(msg pro_menu10)"
        printf '11. %s\n' "$(msg pro_menu11)"
        printf '12. %s\n' "$(msg pro_menu12)"
        printf '13. %s\n' "$(msg pro_menu13)"
        printf '14. %s\n' "$(msg pro_menu14)"
        printf '15. %s\n' "$(msg pro_menu15)"
        printf '16. %s\n' "$(msg pro_menu16)"
        printf '17. %s\n' "$(msg security_menu17)"
        printf '18. %s\n' "$(msg security_menu18)"
        printf '19. %s\n' "$(msg security_menu19)"
        printf '20. %s\n' "$(msg security_menu20)"
        printf '0. %s\n\n' "$(msg menu0)"
        read -r -p "$(msg choose)" choice
        case "$choice" in
            1) scan_lan ;;
            2) scan_top ;;
            3) scan_custom ;;
            4) scan_services ;;
            5) scan_quick ;;
            6) show_reports ;;
            7) update_nmap ;;
            8) change_language ;;
            9) delete_reports ;;
            10) pro_auto_lan ;;
            11) pro_deep_scan ;;
            12) pro_safe_nse ;;
            13) pro_export_html ;;
            14) pro_dashboard ;;
            15) pro_analyze_latest ;;
            16) pro_compare_latest ;;
            17) security_baseline_scan ;;
            18) security_tls_check ;;
            19) security_http_headers ;;
            20) security_review_latest ;;
            0) printf '%s\n' "$(msg goodbye)"; exit 0 ;;
            *) printf '%b%s%b\n' "$C_RED" "$(msg invalid_choice)" "$C_RESET"; sleep 1 ;;
        esac
    done
}

# Load optional Pro features after core functions are defined.
if [[ -f "$APP_DIR/lib/pro.sh" ]]; then
    # shellcheck source=lib/pro.sh
    source "$APP_DIR/lib/pro.sh"
fi
if [[ -f "$APP_DIR/lib/security.sh" ]]; then
    # shellcheck source=lib/security.sh
    source "$APP_DIR/lib/security.sh"
fi

main "$@"
