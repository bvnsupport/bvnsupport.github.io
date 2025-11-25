#!/bin/bash

# ============================================
#  BVN FULL AUTO PUSH – Upload toàn bộ file
#  Author: BVNSUPPORT
#  Dành cho repo: bvnsupport.github.io
# ============================================

REPO_PATH="/var/mobile/Documents/.Repo/bvnsupport.github.io"
DEB_DIR="$REPO_PATH/debs"

cd "$REPO_PATH" || {
    echo "❌ Repo BVN không tìm thấy!"
    exit 1
}

echo "📁 Repo: $REPO_PATH"
echo "------------------------------------------"

# ============================
#  BUILD PACKAGES (nếu có đeb)
# ============================
if [ -d "$DEB_DIR" ]; then
    echo "🛠 Phát hiện thư mục debs → Build Packages..."

    dpkg-scanpackages -m "$DEB_DIR" > Packages
    gzip -c Packages > Packages.gz
    bzip2 -c Packages > Packages.bz2

    echo "✅ Build Packages hoàn tất!"
else
    echo "ℹ️ Không có thư mục debs, bỏ qua bước build Packages."
fi

# ============================
#  GIT ADD + COMMIT + PUSH
# ============================

echo "📦 Đang add toàn bộ file thay đổi..."
git add -A

if git diff --cached --quiet; then
    echo "❌ Không có file mới để push!"
    exit 0
fi

MSG="$1"
if [ -z "$MSG" ]; then
    MSG="Full auto push"
fi

echo "📝 Commit message: $MSG"
git commit -m "$MSG"

echo "🚀 Đang push lên GitHub..."
git push

echo ""
echo "🎉 SUCCESS! Repo BVN đã cập nhật đầy đủ!"
echo "------------------------------------------"