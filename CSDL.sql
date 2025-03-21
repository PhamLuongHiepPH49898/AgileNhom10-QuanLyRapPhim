CREATE DATABASE QuanLyRapPhim;
GO

USE QuanLyRapPhim;
GO

-- Bảng Phim
CREATE TABLE phim (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    ten_phim NVARCHAR(255) NOT NULL,
    the_loai NVARCHAR(100),
    dao_dien NVARCHAR(255),
    dien_vien NVARCHAR(MAX),
    thoi_luong INT,
    mo_ta NVARCHAR(MAX),
    ngay_khoi_chieu DATE,
    ngay_ket_thuc DATE,
    trang_thai NVARCHAR(50) DEFAULT N'Sắp chiếu' CHECK (trang_thai IN (N'Đang chiếu', N'Sắp chiếu', N'Ngừng chiếu'))
);

-- Bảng Rạp Phim
CREATE TABLE rap_phim (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    ten_rap NVARCHAR(255) NOT NULL,
    dia_chi NVARCHAR(MAX) NOT NULL,
    so_dien_thoai NVARCHAR(15)
);

-- Bảng Phòng Chiếu
CREATE TABLE phong_chieu (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    ten_phong NVARCHAR(50) NOT NULL,
    rap_id BIGINT NOT NULL,
    so_ghe INT NOT NULL,
    FOREIGN KEY (rap_id) REFERENCES rap_phim(id) ON DELETE CASCADE
);

-- Bảng Ghế
CREATE TABLE ghe (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    phong_id BIGINT NOT NULL,
    so_ghe NVARCHAR(10) NOT NULL,
    loai_ghe NVARCHAR(50) DEFAULT N'Thường' CHECK (loai_ghe IN (N'Thường', N'VIP', N'Đôi')),
    trang_thai NVARCHAR(50) DEFAULT N'Trống' CHECK (trang_thai IN (N'Trống', N'Đã đặt')),
    FOREIGN KEY (phong_id) REFERENCES phong_chieu(id) ON DELETE CASCADE
);

-- Bảng Suất Chiếu
CREATE TABLE suat_chieu (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    phim_id BIGINT NOT NULL,
    phong_id BIGINT NOT NULL,
    ngay_chieu DATE NOT NULL,
    gio_bat_dau TIME NOT NULL,
    gio_ket_thuc TIME NOT NULL,
    gia_ve DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (phim_id) REFERENCES phim(id) ON DELETE CASCADE,
    FOREIGN KEY (phong_id) REFERENCES phong_chieu(id) ON DELETE CASCADE
);

-- Bảng Người Dùng
CREATE TABLE nguoi_dung (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    ho_ten NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    mat_khau NVARCHAR(255) NOT NULL,
    so_dien_thoai NVARCHAR(15),
    vai_tro NVARCHAR(50) DEFAULT N'Khách hàng' CHECK (vai_tro IN (N'Khách hàng', N'Quản trị viên'))
);

-- Bảng Vé
CREATE TABLE ve (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    suat_chieu_id BIGINT NOT NULL,
    ghe_id BIGINT NOT NULL,
    nguoi_dung_id BIGINT NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Đã đặt' CHECK (trang_thai IN (N'Đã đặt', N'Đã thanh toán', N'Hủy')),
    FOREIGN KEY (suat_chieu_id) REFERENCES suat_chieu(id) ON DELETE CASCADE,
    FOREIGN KEY (ghe_id) REFERENCES ghe(id) ON DELETE NO ACTION,
    FOREIGN KEY (nguoi_dung_id) REFERENCES nguoi_dung(id) ON DELETE NO ACTION
);

-- Bảng Giao Dịch
CREATE TABLE giao_dich (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nguoi_dung_id BIGINT NOT NULL,
    ve_id BIGINT NOT NULL,
    ngay_thanh_toan DATETIME DEFAULT GETDATE(),
    phuong_thuc NVARCHAR(50) DEFAULT N'Thẻ ngân hàng' CHECK (phuong_thuc IN (N'Tiền mặt', N'Thẻ ngân hàng', N'Ví điện tử')),
    so_tien DECIMAL(10,2) NOT NULL,
    trang_thai NVARCHAR(50) DEFAULT N'Đang xử lý' CHECK (trang_thai IN (N'Thành công', N'Thất bại', N'Đang xử lý')),
    FOREIGN KEY (nguoi_dung_id) REFERENCES nguoi_dung(id) ON DELETE CASCADE,
    FOREIGN KEY (ve_id) REFERENCES ve(id) ON DELETE CASCADE
);

-- Thêm dữ liệu mẫu
INSERT INTO rap_phim (ten_rap, dia_chi, so_dien_thoai) VALUES
(N'Rạp CGV Hà Nội', N'123 Đường ABC, Hà Nội', '0123456789'),
(N'Rạp Lotte TP HCM', N'456 Đường XYZ, TP HCM', '0987654321');

INSERT INTO phong_chieu (ten_phong, rap_id, so_ghe) VALUES
(N'Phòng 1', 1, 100),
(N'Phòng 2', 1, 80),
(N'Phòng 1', 2, 120);

INSERT INTO ghe (phong_id, so_ghe, loai_ghe) VALUES
(1, N'A1', N'Thường'),
(1, N'A2', N'VIP'),
(2, N'B1', N'Thường'),
(2, N'B2', N'Đôi'),
(3, N'C1', N'Thường'),
(3, N'C2', N'VIP');

INSERT INTO phim (ten_phim, the_loai, dao_dien, dien_vien, thoi_luong, mo_ta, ngay_khoi_chieu, ngay_ket_thuc, trang_thai) VALUES
(N'Avengers: Endgame', N'Hành động', N'Anthony Russo', N'Robert Downey Jr., Chris Evans', 181, N'Phim siêu anh hùng Marvel', '2025-04-01', '2025-06-01', N'Đang chiếu'),
(N'Frozen 2', N'Hoạt hình', N'Jennifer Lee', N'Kristen Bell, Idina Menzel', 103, N'Phim hoạt hình Disney', '2025-05-01', '2025-07-01', N'Sắp chiếu');

INSERT INTO suat_chieu (phim_id, phong_id, ngay_chieu, gio_bat_dau, gio_ket_thuc, gia_ve) VALUES
(1, 1, '2025-04-05', '18:00', '20:30', 100000),
(1, 2, '2025-04-06', '20:00', '22:30', 120000),
(2, 3, '2025-05-10', '15:00', '16:45', 80000);

INSERT INTO nguoi_dung (ho_ten, email, mat_khau, so_dien_thoai, vai_tro) VALUES
(N'Nguyễn Văn A', 'nguyenvana@example.com', 'password123', '0901234567', N'Khách hàng'),
(N'Trần Thị B', 'tranthib@example.com', 'password456', '0912345678', N'Khách hàng');

INSERT INTO ve (suat_chieu_id, ghe_id, nguoi_dung_id) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1);

select * from rap_phim