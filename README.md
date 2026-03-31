# 🚀 SkyDevOps Toolkit

**SkyDevOps Toolkit** là một công cụ tự động hóa (Automation Tool) mạnh mẽ được viết bằng Bash, giúp các SysAdmin và DevOps Engineer quản lý, cài đặt và tối ưu hóa hạ tầng máy chủ Linux chỉ với một vài thao tác đơn giản.

![SkyDevOps Preview](https://via.placeholder.com/800x400/1a1a1a/00eeff?text=SKYDEVOPS+TOOLKIT+PREVIEW)

## ✨ Tính năng nổi bật

- 🖥️ **Giao diện CLI Hiện đại**: Hệ thống UI được đóng khung chuyên nghiệp, hỗ trợ responsive hoàn hảo trên mọi kích thước Terminal.
- 📦 **Cài đặt Thông minh**: Hỗ trợ cài đặt Nginx, MariaDB, Docker... phiên bản chính thức từ các Repository gốc.
- 🐧 **Đa hệ điều hành & Kiến trúc**: Tương thích tốt trên cả Ubuntu và CentOS, hỗ trợ tự động nhận diện kiến trúc CPU (x86_64 và ARM/Apple Silicon).
- 🛠️ **Hệ thống Plugin Modular**: Kiến trúc plug-and-play giúp bạn dễ dàng mở rộng thêm các phần mềm và tính năng mới.
- ⚡ **Tối ưu UX**: Hiệu ứng thanh tiến trình (progress bar), vòng quay tải (spinner) và các thông báo màu sắc sinh động (ANSI Colors).
- 🛡️ **Tự động vá lỗi**: Cơ chế thông minh giúp tự động phát hiện và sửa các lỗi phổ biến như hỏng Repository, xung đột phiên bản hoặc thiếu thư viện.

## 📂 Cấu trúc dự án

```text
.
├── main.sh             # Điểm khởi đầu của ứng dụng
├── core/               # Thư viện lõi (UI, OS detection, Utils)
│   ├── ui.sh           # Xử lý hiển thị giao diện, khung viền
│   ├── os.sh           # Nhận diện hệ điều hành và phiên bản
│   └── utils.sh        # Các tiện ích spinner, progress bar
├── plugins/            # Các tính năng phần mềm mở rộng
│   └── nginx/          # Plugin quản trị và cài đặt Nginx
└── .agent/             # Cấu hình Agent và Scripts cài đặt chi tiết
```

## 🚀 Hướng dẫn bắt đầu

### 1. Yêu cầu hệ thống
- Hệ điều hành: Ubuntu 20.04+ hoặc CentOS 7/8/Stream.
- Quyền: Cần quyền `sudo` để thực hiện các thao tác hệ thống.

### 2. Cách chạy công cụ
Chỉ cần thực hiện lệnh sau tại thư mục dự án:

```bash
chmod +x main.sh
./main.sh
```

## 🛠️ Các lệnh quản trị Nginx
Công cụ hỗ trợ quản trị Nginx nâng cao:
- Cài đặt bản Stable / Mainline official.
- Tự động gỡ bỏ bản cũ nếu có xung đột.
- Tự động fallback về repository mặc định nếu đang chạy trên kiến trúc ARM (Mac M1/M2/M3).

## 🤝 Đóng góp
Dự án được phát triển bởi **thanhnh**. Mọi ý kiến đóng góp hoặc báo lỗi vui lòng liên hệ qua địa chỉ website: [https://thanhnh.id.vn](https://thanhnh.id.vn).

---
*Phát triển bởi ❤️ dành cho cộng đồng DevOps Việt Nam.*
