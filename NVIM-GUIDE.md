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

---

## Phần nâng cao: Dùng Neovim như một IDE

### 15. Copilot

Copilot tự động gợi ý khi đang ở Insert mode. Ghost text sẽ hiện mờ ngay sau con trỏ.

| Phím | Công dụng |
|---|---|
| `Tab` | Chấp nhận toàn bộ gợi ý |
| `Alt-w` | Chấp nhận một từ tiếp theo |
| `Alt-l` | Chấp nhận một dòng tiếp theo |
| `Alt-]` | Gợi ý kế tiếp |
| `Alt-[` | Gợi ý trước đó |
| `Ctrl-]` | Bỏ qua gợi ý hiện tại |

Ghost text tự ẩn khi menu completion đang mở, lúc đó `Tab` dùng để chọn trong completion thay vì Copilot.

### 16. Completion (nvim-cmp)

Khi gõ code, menu completion tự xuất hiện. Không cần nhấn gì để kích hoạt.

| Phím | Công dụng |
|---|---|
| `Ctrl-n` / `Ctrl-p` | Chọn mục kế tiếp / trước |
| `Enter` | Xác nhận mục đang chọn |
| `Ctrl-e` | Đóng menu completion |
| `Ctrl-b` / `Ctrl-f` | Cuộn tài liệu trong menu |

### 17. Tìm kiếm và thay thế

#### Trong một file

| Phím hoặc lệnh | Công dụng |
|---|---|
| `:%s/cu/moi/g` | Thay toàn bộ `cu` bằng `moi` trong file |
| `:%s/cu/moi/gc` | Thay và hỏi xác nhận từng chỗ |
| `:s/cu/moi/g` | Thay trong dòng hiện tại |

#### Trong toàn bộ dự án

| Phím | Công dụng |
|---|---|
| `Space s g` | Tìm kiếm nội dung trong dự án (live grep) |
| `Space s w` | Tìm từ đang dưới con trỏ trong dự án |
| `Space s r` | Tìm và thay thế trong dự án (grug-far) |

Khi kết quả tìm kiếm được đưa vào quickfix list:

| Phím | Công dụng |
|---|---|
| `]q` / `[q` | Kết quả kế tiếp / trước trong quickfix |
| `Space x q` | Mở quickfix list |

### 18. Marks và Jumps

#### Marks (tích hợp)

Marks cho phép đánh dấu vị trí trong file để quay lại nhanh.

| Phím | Công dụng |
|---|---|
| `ma` | Đặt mark `a` tại dòng hiện tại |
| `'a` | Nhảy đến dòng chứa mark `a` |
| `` `a `` | Nhảy đến vị trí chính xác của mark `a` |
| `''` | Quay lại vị trí trước khi nhảy |
| `Space s m` | Xem toàn bộ marks trong picker |

Marks viết thường (`a`–`z`) chỉ có trong file hiện tại. Marks viết hoa (`A`–`Z`) dùng được xuyên file. Giới hạn 26 bookmark, tên chỉ là một ký tự.

#### Bookmarks có tên tùy ý (Grapple)

Grapple cho phép đặt tên bookmark dạng mô tả và nhảy tới bằng picker.

| Phím | Công dụng |
|---|---|
| `Space m a` | Thêm bookmark cho file hiện tại (hỏi tên) |
| `Space m m` | Mở danh sách bookmark, chọn để nhảy |
| `Space m d` | Xóa bookmark của file hiện tại |
| `Space m n` | Nhảy tới bookmark kế tiếp |
| `Space m p` | Nhảy tới bookmark trước đó |

Trong cửa sổ `Space m m`: nhấn `Enter` để nhảy, `r` để đổi tên, `d` để xóa. Bookmark được nhóm theo git project nên không bị lẫn giữa các dự án.

#### Jump list

Neovim tự lưu lịch sử các vị trí bạn đã nhảy tới.

| Phím | Công dụng |
|---|---|
| `Ctrl-o` | Quay lại vị trí trước |
| `Ctrl-i` | Tiến tới vị trí sau |

Dùng `Ctrl-o` thường xuyên sau khi `gd` để quay lại chỗ cũ.

### 19. Macro

Macro ghi lại chuỗi phím bấm để phát lại nhiều lần.

| Phím | Công dụng |
|---|---|
| `qa` | Bắt đầu ghi macro vào thanh ghi `a` |
| `q` | Dừng ghi macro |
| `@a` | Phát lại macro `a` một lần |
| `5@a` | Phát lại macro `a` năm lần |
| `@@` | Phát lại macro vừa chạy |

Ví dụ: Muốn thêm `;` vào cuối 10 dòng liên tiếp: đứng ở dòng đầu, nhấn `qa`, rồi `A`, `;`, `Esc`, `j`, `q`. Sau đó nhấn `9@a`.

### 20. Text objects của Treesitter

Treesitter cung cấp text objects theo cú pháp thực của ngôn ngữ. Dùng kết hợp với `v`, `d`, `c`, `y`.

| Phím | Công dụng |
|---|---|
| `vaf` | Chọn toàn bộ hàm (bao gồm signature) |
| `vif` | Chọn thân hàm (bên trong `{}`) |
| `vac` | Chọn toàn bộ class |
| `vic` | Chọn thân class |
| `]m` / `[m` | Đến đầu hàm kế tiếp / trước |
| `]f` / `[f` | Đến đầu hàm kế tiếp / trước |

Ví dụ: `daf` xóa toàn bộ hàm đang đứng trong đó. `yif` sao chép thân hàm.

### 21. Undotree

Undotree hiển thị lịch sử thay đổi dạng cây, không phải tuyến tính như `u` / `Ctrl-r`. Có thể quay lại bất kỳ trạng thái nào trong quá khứ, kể cả sau khi đã redo.

| Phím | Công dụng |
|---|---|
| `Space U` | Mở / đóng Undotree |

Trong cửa sổ Undotree dùng `j` / `k` để di chuyển giữa các trạng thái. Bên phải hiện diff của trạng thái đang chọn.

### 22. Hỗ trợ ngôn ngữ Go

Cấu hình này đã bật `lazyvim.plugins.extras.lang.go`, cài sẵn:

- **gopls** — LSP chính thức của Go
- **gofumpt** — formatter nghiêm ngặt hơn `gofmt`
- **golines** — tự động ngắt dòng dài

Các phím đặc thù khi viết Go:

| Phím | Công dụng |
|---|---|
| `Space c a` | Code action: import gói, generate interface, fill struct... |
| `gd` | Đi tới định nghĩa |
| `gi` | Đi tới implementation |
| `gt` | Đi tới định nghĩa kiểu |
| `K` | Hover: xem type và tài liệu |
| `Space c f` | Format file bằng gofumpt |

Để chạy test Go nhanh từ terminal tích hợp:

```bash
# Ctrl-/ để mở terminal, sau đó:
go test ./...
go test -run TestTenHam ./path/to/package
```

### 23. LSP nâng cao

| Phím | Công dụng |
|---|---|
| `gd` | Đi tới định nghĩa |
| `gD` | Đi tới khai báo |
| `gi` | Đi tới implementation |
| `gt` | Đi tới định nghĩa kiểu |
| `gr` | Xem tất cả reference |
| `K` | Hover: xem type và doc |
| `gK` | Xem signature của hàm hiện tại |
| `Space c r` | Rename symbol toàn dự án |
| `Space c a` | Code action tại vị trí con trỏ |
| `Space c A` | Code action cho toàn file |

Sau khi `Space c r` đổi tên, Neovim tự đổi ở mọi nơi tham chiếu trong dự án.

### 24. Session

LazyVim lưu session theo thư mục dự án.

| Phím | Công dụng |
|---|---|
| `Space q s` | Lưu session hiện tại |
| `Space q r` | Khôi phục session của thư mục này |
| `Space q l` | Mở session gần nhất |

Khi mở Neovim bằng `nvim .`, session trước của thư mục đó được khôi phục tự động nếu đã lưu.

### 25. Workflow IDE điển hình

Ví dụ một phiên làm việc thực tế với dự án Go:

```text
1. cd ~/du-an && nvim .
2. Space f f → tìm file cần sửa
3. gd → xem định nghĩa hàm được gọi
4. Ctrl-o → quay lại chỗ cũ
5. Space c a → thêm import còn thiếu
6. K → kiểm tra type của một biến
7. Space c r → đổi tên biến xuyên dự án
8. Ctrl-/ → mở terminal, chạy go test ./...
9. Ctrl-/ → đóng terminal
10. Space g g → mở Lazygit, commit
11. Space q s → lưu session
12. Space q q → thoát
```
