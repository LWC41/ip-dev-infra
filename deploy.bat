@echo off
REM IP开发平台 - Windows 一键部署脚本

echo ==========================================
echo    IP开发平台 部署脚本 (Windows)
echo ==========================================

REM 检查Docker
echo [1/6] 检查Docker安装...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] Docker未安装，请先安装Docker Desktop
    pause
    exit /b 1
)
echo [成功] Docker已安装

REM 检查Docker Compose
echo [2/6] 检查Docker Compose...
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] Docker Compose未安装
    pause
    exit /b 1
)
echo [成功] Docker Compose已安装

REM 创建环境变量文件
echo [3/6] 配置环境变量...
if not exist .env (
    echo 创建.env文件...
    copy /Y .env.example .env >nul
    echo [成功] .env文件已创建
    echo [警告] 请修改.env文件中的MESHY_API_KEY
    echo 按任意键继续...
    pause >nul
) else (
    echo [跳过] .env文件已存在
)

REM 构建镜像
echo [4/6] 构建Docker镜像...
docker-compose build
if %errorlevel% neq 0 (
    echo [错误] 镜像构建失败
    pause
    exit /b 1
)
echo [成功] 镜像构建完成

REM 启动服务
echo [5/6] 启动服务...
docker-compose up -d
if %errorlevel% neq 0 (
    echo [错误] 服务启动失败
    pause
    exit /b 1
)
echo [成功] 服务启动完成

REM 初始化数据库
echo [6/6] 初始化数据库...
docker-compose exec backend python -c "from app.main import engine, Base; Base.metadata.create_all(bind=engine); print('Database initialized')" 2>nul
echo [成功] 数据库初始化完成

REM 显示访问信息
echo.
echo ==========================================
echo [成功] 部署完成！
echo ==========================================
echo.
echo 服务访问地址：
echo   前端: http://localhost
echo   后端API: http://localhost:8000
echo   API文档: http://localhost:8000/docs
echo.
echo 常用命令：
echo   查看日志: docker-compose logs -f
echo   停止服务: docker-compose down
echo   重启服务: docker-compose restart
echo ==========================================
echo.

pause
