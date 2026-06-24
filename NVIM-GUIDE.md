# Làm quen với Neovim hiện tại

## Cấu hình đang sử dụng

- Neovim `0.12.3`
- LazyVim 8
- Giao diện Catppuccin Mocha
- Snacks dùng cho file explorer, tìm kiếm và terminal
- `Space` là phím Leader
- Chưa có phím tắt cá nhân trong `lua/config/keymaps.lua`
- Chưa bật gói hỗ trợ riêng cho từng ngôn ngữ lập trình

Mở một dự án bằng:

```bash
cd du-an
nvim .
```

## 1. Các chế độ của Neovim

Neovim không nhập chữ liên tục như các trình soạn thảo thông thường.

| Chế độ | Công dụng | Cách vào |
|---|---|---|
| Normal | Di chuyển và chạy lệnh | `Esc` |
| Insert | Nhập văn bản | `i` |
| Visual | Chọn văn bản | `v` |
| Command | Lưu, thoát và chạy lệnh | `:` |

Nếu không biết mình đang ở chế độ nào, hãy nhấn `Esc`.

## 2. Di chuyển

Các phím sau được dùng trong Normal mode:

| Phím | Công dụng |
|---|---|
| `h` `j` `k` `l` | Trái, xuống, lên, phải |
| `w` / `b` | Sang từ kế tiếp / trước |
| `0` / `$` | Đầu / cuối dòng |
| `gg` / `G` | Đầu / cuối file |
| `Ctrl-d` / `Ctrl-u` | Xuống / lên nửa trang |
| `5j` | Đi xuống 5 dòng |

Không cần tránh phím mũi tên bằng mọi giá. Dùng `hjkl` dần dần khi đã quen.

## 3. Chỉnh sửa văn bản

| Phím | Công dụng |
|---|---|
| `i` | Nhập trước con trỏ |
| `a` | Nhập sau con trỏ |
| `o` / `O` | Tạo dòng mới bên dưới / trên |
| `x` | Xóa một ký tự |
| `dd` | Xóa một dòng |
| `yy` | Sao chép một dòng |
| `p` | Dán |
| `u` | Hoàn tác |
| `Ctrl-r` | Làm lại |
| `.` | Lặp lại thao tác gần nhất |

Một vài tổ hợp hữu ích:

| Phím | Công dụng |
|---|---|
| `3dd` | Xóa 3 dòng |
| `ciw` | Thay nội dung từ hiện tại |
| `di"` | Xóa nội dung bên trong dấu ngoặc kép |
| `viw` | Chọn từ hiện tại |
| `ggVG` | Chọn toàn bộ file |

## 4. Tìm kiếm trong file

| Phím | Công dụng |
|---|---|
| `/tu-khoa` | Tìm về phía dưới |
| `n` / `N` | Kết quả kế tiếp / trước |
| `*` | Tìm từ đang nằm dưới con trỏ |
| `Esc` | Xóa phần đánh dấu kết quả tìm kiếm |

## 5. Lưu và thoát

| Phím hoặc lệnh | Công dụng |
|---|---|
| `Ctrl-s` | Lưu file |
| `:w` | Lưu file |
| `:q` | Đóng cửa sổ hiện tại |
| `:wq` | Lưu rồi thoát |
| `:q!` | Thoát và bỏ thay đổi |
| `Space q q` | Thoát toàn bộ Neovim |

## 6. Phím Leader của LazyVim

Phím Leader trong cấu hình này là `Space`.

Nhấn `Space` rồi chờ một chút. WhichKey sẽ hiện những phím có thể nhấn tiếp theo.

Các nhóm chính:

| Nhóm | Công dụng |
|---|---|
| `Space f` | File và tìm file |
| `Space s` | Tìm kiếm |
| `Space b` | Buffer |
| `Space c` | Thao tác với code |
| `Space g` | Git |
| `Space w` | Window |
| `Space x` | Diagnostics và quickfix |
| `Space u` | Bật/tắt tùy chọn giao diện |
| `Space q` | Thoát và session |

Nếu quên một phím, dùng:

```text
Space s k
```

Lệnh này mở danh sách và cho phép tìm kiếm toàn bộ keymap.

## 7. Mở và tìm file

| Phím | Công dụng |
|---|---|
| `Space e` | Mở hoặc đóng cây thư mục |
| `Space f f` | Tìm file trong dự án |
| `Space f g` | Tìm file do Git quản lý |
| `Space f r` | Mở file gần đây |
| `Space s g` | Tìm nội dung trong dự án |
| `Space s w` | Tìm từ đang nằm dưới con trỏ |
| `Space /` | Tìm nội dung trong dự án |

Trong cửa sổ tìm kiếm:

- Gõ để lọc kết quả.
- Dùng `Ctrl-j` và `Ctrl-k` hoặc phím mũi tên để chọn.
- Nhấn `Enter` để mở.
- Nhấn `Esc` để đóng.

## 8. Buffer

Buffer là file đang được Neovim giữ trong bộ nhớ. Buffer không hoàn toàn giống tab.

| Phím | Công dụng |
|---|---|
| `Shift-h` | Buffer trước |
| `Shift-l` | Buffer kế tiếp |
| `Space f b` | Tìm trong các buffer đang mở |
| `Space b d` | Đóng buffer hiện tại |
| `Space b o` | Đóng các buffer khác |
| `Space b b` | Quay lại buffer trước đó |

Thông thường nên dùng `Space b d` để đóng file thay vì `:q`, vì `:q` đóng cửa sổ.

## 9. Window và terminal

| Phím | Công dụng |
|---|---|
| `Space \|` | Chia cửa sổ theo chiều dọc |
| `Space -` | Chia cửa sổ theo chiều ngang |
| `Ctrl-h` | Sang cửa sổ bên trái |
| `Ctrl-j` | Sang cửa sổ bên dưới |
| `Ctrl-k` | Sang cửa sổ bên trên |
| `Ctrl-l` | Sang cửa sổ bên phải |
| `Space w d` | Đóng cửa sổ hiện tại |
| `Ctrl-/` | Mở hoặc ẩn terminal |

Trong terminal, nhấn `Ctrl-/` để quay lại cửa sổ code.

## 10. Các thao tác với code

Những phím này hoạt động khi LSP của ngôn ngữ đã được cài và kết nối:

| Phím | Công dụng |
|---|---|
| `gd` | Đi tới định nghĩa |
| `gr` | Xem các nơi tham chiếu |
| `K` | Xem tài liệu của symbol |
| `Space c a` | Code action |
| `Space c r` | Đổi tên symbol |
| `Space c f` | Format code |
| `[d` / `]d` | Diagnostic trước / kế tiếp |
| `[e` / `]e` | Lỗi trước / kế tiếp |
| `Space c d` | Xem diagnostic tại dòng hiện tại |
| `Space x x` | Mở danh sách diagnostic |

Nếu các phím như `gd` hoặc `K` không hoạt động, nguyên nhân thường là chưa cài LSP cho ngôn ngữ đó.

## 11. Git

| Phím | Công dụng |
|---|---|
| `Space g g` | Mở Lazygit tại thư mục gốc dự án |
| `Space g b` | Xem Git blame của dòng hiện tại |
| `Space g l` | Xem Git log |
| `Space g f` | Lịch sử của file hiện tại |

`Space g g` cần chương trình `lazygit` được cài trên hệ thống.

## 12. Quản lý plugin và công cụ

| Lệnh | Công dụng |
|---|---|
| `:Lazy` | Xem và quản lý plugin |
| `:Mason` | Xem LSP, formatter và linter |
| `:LazyExtras` | Bật hỗ trợ cho ngôn ngữ hoặc tính năng bổ sung |
| `:checkhealth` | Kiểm tra lỗi môi trường Neovim |

Không nên cập nhật hoặc cài nhiều plugin ngay trong tuần đầu. Trước tiên hãy làm quen với workflow hiện tại.

## 13. Bài tập 10 phút

Mở repo dotfiles:

```bash
cd ~/dotfiles
nvim .
```

Sau đó thực hiện lần lượt:

1. Nhấn `Space f f`, tìm `keymaps.lua`, rồi nhấn `Enter`.
2. Dùng `j`, `k`, `w`, `b` để di chuyển.
3. Nhấn `o`, nhập một dòng comment.
4. Nhấn `Esc`, sau đó nhấn `u` để hoàn tác.
5. Nhấn `Space s g`, tìm `catppuccin`.
6. Mở vài kết quả rồi dùng `Shift-h` và `Shift-l` để chuyển buffer.
7. Dùng `Space b d` để đóng một buffer.
8. Dùng `Ctrl-/` để mở terminal, sau đó dùng lại `Ctrl-/` để đóng.
9. Nhấn `Space s k` và tìm `diagnostic`.
10. Nhấn `Space q q` để thoát Neovim.

## 14. Những phím cần nhớ trong tuần đầu

Nếu chỉ học một nhóm nhỏ, hãy nhớ các phím sau:

```text
Esc             về Normal mode
i               nhập văn bản
h j k l         di chuyển
w b             di chuyển theo từ
dd / yy / p     xóa, sao chép, dán
u / Ctrl-r      hoàn tác, làm lại
/               tìm trong file
Ctrl-s          lưu
Space e         cây thư mục
Space f f       tìm file
Space s g       tìm nội dung
Space b d       đóng buffer
Space s k       tra cứu keymap
Space q q       thoát Neovim
```

Mục tiêu ban đầu không phải ghi nhớ mọi phím. Mục tiêu là biết cách dùng `Space` và `Space s k` để tự tìm phím khi cần.
