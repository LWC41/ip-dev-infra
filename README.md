# IP开发平台 - 基础设施

Docker Compose 配置、部署脚本和 Nginx 配置。

## 快速部署

### Windows

```bash
deploy.bat
```

### Linux/macOS

```bash
chmod +x deploy.sh
./deploy.sh
```

## 服务架构

```
┌─────────────┐
│   Nginx     │ 端口 80/443
└──────┬──────┘
       │
   ┌───┴───┐
   │       │
┌──┴──┐ ┌──┴──┐
│前端  │ │后端 │ 端口 3000   端口 8000
└──┬──┘ └──┬──┘
   │       │
   │    ┌──┴──┐
   │    │Redis │
   │    └─────┘
   │       │
   │    ┌──┴──┐
   │    │Celery│
   │    └─────┘
   │
┌──┴──┐
│ PG  │
└─────┘
```

## 目录结构

```
infra/
├── docker-compose.yml   # Docker 编排配置
├── .env.example         # 环境变量示例
├── deploy.bat          # Windows 部署脚本
├── deploy.sh           # Linux/macOS 部署脚本
├── nginx/
│   └── nginx.conf      # Nginx 配置
│   └── ssl/            # SSL 证书目录
└── README.md
```

## 环境变量

复制 `.env.example` 为 `.env` 并配置：

- `MESHY_API_KEY` - Meshy AI API 密钥
- `SECRET_KEY` - 应用密钥
- `DATABASE_URL` - PostgreSQL 连接字符串
- `REDIS_URL` - Redis 连接字符串

## 常用命令

```bash
# 启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f
docker-compose logs -f backend
docker-compose logs -f celery-worker

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 重新构建
docker-compose build --no-cache
```
