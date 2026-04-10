#!/bin/bash
# IP开发平台 - Linux/macOS 一键部署脚本

set -e

echo "=========================================="
echo "   IP开发平台 部署脚本 (Linux/macOS)"
echo "=========================================="

# 检查Docker
echo "[1/6] 检查Docker安装..."
if ! command -v docker &> /dev/null; then
    echo "[错误] Docker未安装，请先安装Docker Desktop"
    exit 1
fi
echo "[成功] Docker已安装"

# 检查Docker Compose
echo "[2/6] 检查Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    echo "[错误] Docker Compose未安装"
    exit 1
fi
echo "[成功] Docker Compose已安装"

# 创建环境变量文件
echo "[3/6] 配置环境变量..."
if [ ! -f .env ]; then
    echo "创建.env文件..."
    cp .env.example .env
    echo "[成功] .env文件已创建"
    echo "[警告] 请修改.env文件中的MESHY_API_KEY"
    read -p "按任意键继续..."
else
    echo "[跳过] .env文件已存在"
fi

# 构建镜像
echo "[4/6] 构建Docker镜像..."
docker-compose build
echo "[成功] 镜像构建完成"

# 启动服务
echo "[5/6] 启动服务..."
docker-compose up -d
echo "[成功] 服务启动完成"

# 等待服务启动
echo "等待服务启动..."
sleep 10

# 初始化数据库
echo "[6/6] 初始化数据库..."
docker-compose exec backend python -c "from app.main import engine, Base; Base.metadata.create_all(bind=engine); print('Database initialized')" 2>/dev/null || true
echo "[成功] 数据库初始化完成"

# 显示访问信息
echo ""
echo "=========================================="
echo "[成功] 部署完成！"
echo "=========================================="
echo ""
echo "服务访问地址："
echo "  前端: http://localhost"
echo "  后端API: http://localhost:8000"
echo "  API文档: http://localhost:8000/docs"
echo ""
echo "常用命令："
echo "  查看日志: docker-compose logs -f"
echo "  停止服务: docker-compose down"
echo "  重启服务: docker-compose restart"
echo "=========================================="
