# Nmap Toolkit

**Nmap Toolkit** is a beginner-friendly, bilingual (Tiếng Việt / English) Nmap menu for **Termux on Android**. It is designed for non-root devices and uses TCP connect scans where raw-packet privileges are unavailable.

**Nmap Toolkit** là bộ công cụ Nmap có menu song ngữ (Tiếng Việt / English), dành cho người mới bắt đầu sử dụng **Termux trên Android**. Công cụ ưu tiên TCP Connect Scan để tương thích thiết bị không root.

## Features / Tính năng

- Vietnamese and English menu; language preference is saved between launches.
- Menu tiếng Việt và tiếng Anh; tự lưu ngôn ngữ đã chọn.
- LAN host discovery / Tìm thiết bị trong mạng LAN (`-sn`)
- Top 100 common TCP ports / Quét 100 cổng TCP phổ biến
- Custom TCP port list or range / Quét cổng tùy chọn
- Service and version detection / Nhận diện dịch vụ và phiên bản
- Quick TCP scan / Quét TCP nhanh
- View scan history / Xem lịch sử báo cáo
- Delete all saved scan reports with confirmation / Xóa toàn bộ báo cáo đã lưu sau khi xác nhận
- Pro: auto-detect LAN, 1,000-port TCP scan, safe NSE checks, mobile-friendly HTML reports / Pro: tự nhận diện LAN, quét 1.000 cổng TCP, NSE an toàn, báo cáo HTML
- Normal, XML, and grepable reports / Lưu báo cáo Nmap dạng TXT, XML và GNMAP

## Requirements / Yêu cầu

- Android with a current Termux installation / Android có cài Termux phiên bản hiện hành
- Internet for initial package installation / Có Internet khi cài đặt lần đầu
- Nmap, Git, iproute2 and Python are installed by the installer / Trình cài đặt tự cài Nmap, Git, iproute2 và Python

## Install / Cài đặt

Run in Termux / Chạy trong Termux:

```bash
pkg update -y
pkg install -y curl
curl -fsSL https://raw.githubusercontent.com/khahdihdz/nmap-toolkit/main/install.sh | bash
```

Launch / Khởi chạy:

```bash
nmaptool
```

Choose menu item **8** to switch language. The choice is saved in `~/.config/nmap-toolkit/language`.

Chọn mục **8** để đổi ngôn ngữ. Tùy chọn được lưu tại `~/.config/nmap-toolkit/language`.

## Menu / Danh mục

| Option | Tiếng Việt | English |
|---|---|---|
| 1 | Quét thiết bị LAN | LAN host discovery |
| 2 | Quét 100 cổng TCP phổ biến | Top 100 TCP ports |
| 3 | Quét cổng tùy chọn | Custom TCP ports |
| 4 | Nhận diện dịch vụ/phiên bản | Service/version detection |
| 5 | Quét nhanh | Quick scan |
| 6 | Lịch sử báo cáo | Scan report history |
| 7 | Cập nhật Nmap | Update Nmap |
| 8 | Đổi ngôn ngữ | Change language |
| 9 | Xóa lịch sử báo cáo (có xác nhận) | Delete report history (confirmation required) |
| 10 | Tự nhận diện LAN | Auto-detect LAN |
| 11 | Quét chuyên sâu 1.000 cổng | Deep scan, top 1,000 ports |
| 12 | Kiểm tra NSE nhóm safe | Safe NSE checks |
| 13 | Xuất XML sang HTML | Export XML to HTML |
| 0 | Thoát | Exit |

## Reports / Báo cáo

Reports are stored in `$HOME/nmap-toolkit/reports/`. Each scan creates Nmap normal (`.nmap`), XML (`.xml`), and grepable (`.gnmap`) files.

Báo cáo được lưu trong `$HOME/nmap-toolkit/reports/`. Mỗi lần quét tạo ba định dạng: Nmap thường (`.nmap`), XML (`.xml`) và GNMAP (`.gnmap`). Chọn mục **9** để xóa toàn bộ báo cáo; Toolkit sẽ hỏi xác nhận trước khi xóa. Mục **13** chuyển báo cáo XML mới nhất thành HTML để mở bằng trình duyệt.

Reports are stored in `$HOME/nmap-toolkit/reports/`. Each scan creates Nmap normal (`.nmap`), XML (`.xml`), and grepable (`.gnmap`) files. Choose menu item **9** to delete all saved reports; the toolkit asks for confirmation first. Option **13** converts the latest XML report to HTML for viewing in a browser.

## Safe use / Sử dụng an toàn

- Only scan networks and devices you own or have explicit permission to assess.
- Chỉ quét mạng và thiết bị thuộc quyền sở hữu hoặc được cho phép kiểm tra.
- On non-root Android/Termux, TCP connect scan (`-sT`) is the practical default. SYN scan and some OS-detection features require raw-packet privileges and may not work.
- Trên Android/Termux không root, TCP Connect Scan (`-sT`) là lựa chọn phù hợp. SYN Scan và một số tính năng nhận diện hệ điều hành cần quyền raw-packet nên có thể không hoạt động.
- LAN discovery may be affected by Wi-Fi client isolation, VPNs, firewalls, or Android restrictions.
- Quét LAN có thể bị ảnh hưởng bởi cô lập thiết bị Wi-Fi, VPN, tường lửa hoặc giới hạn Android.

## Update / uninstall / Cập nhật và gỡ bỏ

Rerun the install command to update the toolkit. Choose menu option **7** to update Nmap.

Chạy lại lệnh cài đặt để cập nhật Toolkit. Chọn mục **7** để cập nhật Nmap.

Remove / Gỡ bỏ:

```bash
rm -rf "$HOME/nmap-toolkit"
rm -rf "$HOME/.config/nmap-toolkit"
rm -f "$PREFIX/bin/nmaptool"
```

## License

MIT
