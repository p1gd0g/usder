# Copilot Instructions — USDer

## Project Overview

USDer 是一个 Flutter Web 应用，用于美元/人民币理财收益对比计算。主目标平台为 Web。

## Tech Stack

- **UI**: [ForUI](https://forui.dev) (`forui`) — 不是 Material，使用 `FScaffold`、`FTextField`、`FCard` 等组件
- **State**: Riverpod + riverpod_generator 代码生成（`@riverpod` / `@Riverpod(keepAlive: true)`）
- **HTTP**: `http` 包通过 CORS 代理 `https://cors.p1gd0g.cc?url=...` 调外部 API
- **Logging**: `logger` 包，全局实例 `appLogger`（见 `lib/app_logger.dart`）
- **Theme**: `FThemes.zinc.dark`，中文优先 (`Locale('zh')`)
- **Analytics**: PostHog + Google AdSense

## Key Files

```
lib/
  main.dart          # 入口 + HomePage (ConsumerWidget)
  controller.dart    # Con — 主控制器 (@Riverpod keepAlive)，管理输入和计算
  conn.dart          # 网络请求 + rfxSpQuotProvider / usdRateProvider
  result.dart        # Result — 显示计算结果 (ConsumerWidget)
  app_logger.dart    # 全局 appLogger 实例
```

## Commands

```powershell
# 安装依赖
flutter pub get

# Riverpod 代码生成（修改 @riverpod 注解后必须运行）
dart run build_runner build --delete-conflicting-outputs

# 构建 Web
$ENV:build_vsn='0.3.3'
flutter build web --build-name=$ENV:build_vsn --dart-define=vsn=$ENV:build_vsn --output=public

# 生成图标
dart run flutter_launcher_icons
```

## Conventions

- Provider 使用 `riverpod_generator` 注解生成，不手写 `Provider(...)`
- 异步数据用 `@riverpod Future<T>` + `Consumer` + `asyncValue.when()`，不用 `FutureBuilder`
- 所有 `TextEditingController` 集中在 `Con` 控制器中管理，不在 widget 内创建
- `.g.dart` 文件由 build_runner 自动生成，不要手动编辑
- 响应式布局通过 `MediaQuery` 判断横竖屏 (`size.width > size.height`)
- API 错误时降级为手动输入，不弹错误提示
