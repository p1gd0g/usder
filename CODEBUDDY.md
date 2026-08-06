# CODEBUDDY.md This file provides guidance to CodeBuddy when working with code in this repository.

## Commands

- `flutter pub get` — install dependencies after pubspec changes.
- `flutter analyze` — static analysis / lint (config in `analysis_options.yaml`, uses flutter_lints).
- `dart run build_runner watch -d` — generate/update Riverpod `.g.dart` part files (needed after editing `@riverpod` annotations in `conn.dart` / `controller.dart`). Run once before building if generated files are stale.
- `flutter test` — run all tests. `flutter test test/<file>.dart` — run a single test file.
- `flutter build web --build-name=<vsn> --dart-define=vsn=<vsn> --output=public` — build web target into `public/` (see README for the `$ENV:build_vsn` flow).
- `dart run flutter_launcher_icons:generate` then `dart run flutter_launcher_icons` — (re)generate app launcher icons from `flutter_launcher_icons.yaml`.

## Architecture

A Flutter web app (package `myapp`) that compares USD vs RMB wealth-management returns. Built on **Riverpod 3** (code-generated providers) and the **ForUI** widget kit (`forui`), with Firebase/PostHog analytics.

### Provider / data layer (`lib/conn.dart`)
`Conn` is a thin HTTP client wrapping a single shared `dio` instance. It does NOT call foreign APIs directly — every request goes through a CORS reverse-proxy at `https://cors.p1gd0g.cc` with the real target URL passed as a `?url=` query param (`_corsHost`). Two fetch methods return parsed scalars:
- `getRfxSpQuot()` → USD/CNY spot bid from `chinamoney.com.cn`.
- `getUsdRate()` → 7-day annualized USD rate from `bocwm.cn`.

Both swallow errors and return `''` on failure (the UI falls back to manual text input). JSON model classes (`UsdRateJson`, `RfxSpQuotJson`/`Records`) are hand-rolled, not codegen.

`@riverpod` exposes `connProvider`, plus async `rfxSpQuotProvider` / `usdRateProvider` (returning `Future<String>`) that the UI consumes via `ref.watch(...).when(...)`.

### State layer (`lib/controller.dart`)
`Ctrl` is a `@Riverpod(keepAlive: true)` **notifier class** holding all input state. It owns `TextEditingController`s (asset amount, exchange rate, RMB/USD annual rates, days/date), a ForUI slider controller for the projected end-of-term exchange rate, and a `ScrollController`. `state` is an `int` counter (`build()` returns `0`); `incrementCalc()` / `refreshCalc()` bump it to trigger rebuilds. All financial math lives here as getters/methods:
- `usdAsset` (RMB ÷ rate), `rmbProfit`, `usdProfitWithExchange`, `usdExchangePnL`, `breakEvenExchangeRate`.
- `profitDays` switches between "by days" tab and "by maturity date" tab (`tabIndex`).
- `finalExchangeFromSlider` maps slider 0..1 to a 6.0–8.0 exchange-rate range.

Note: controllers are stored on the notifier instance (not Riverpod state), so they survive rebuilds; the int `state` is only a change signal.

### UI layer
- `lib/main.dart` — `main()` wires `ProviderScope` + ForUI `FTheme` (dark, touch vs desktop variant by platform), `PosthogObserver`, Chinese locale. `HomePage` is a `ConsumerWidget` building the input form: two network-backed fields (`rfxSpQuotProvider` / `usdRateProvider`) auto-fill the exchange-rate and USD-rate inputs, the rest are manual `FTextField`s, an `FTabs` toggles days-vs-date, and a calculate button calls `con.incrementCalc()`. On landscape (`size.width > size.height`) layouts switch to a horizontal row.
- `lib/result.dart` — `Result` (`ConsumerWidget`) renders the comparison: RMB profit card vs USD total P&L card, with 🏆 badge on the winner. It also renders the end-rate `FSlider` whose mark is the computed break-even rate; sliding calls `refreshCalc()` to update. `_InfoCard` is a shared `FCard` wrapper.

### CORS proxy (`script/cors.js`)
A Cloudflare-style edge function (Workers `fetch` event model). It reads `?url=`, re-issues the request with the original headers but rewrites `Host` to the target and **strips `Origin`/`Referer`** (target sites reject the proxy's own origin with 403 "Invalid Origin/Referer Header"). It adds permissive `Access-Control-Allow-*` headers and short-circuits `OPTIONS` preflights with 204. This file is deployed independently of the Flutter app — changes here do not affect `flutter build`.

### Conventions / gotchas
- Generated files `conn.g.dart`, `controller.g.dart` use `part` directives; never edit them by hand — rerun `build_runner`.
- Logger is a single global `appLogger` from the `logger` package (`lib/app_logger.dart`).
- The proxy must keep stripping `Origin`/`Referer`; if a new target site returns 403 "Invalid X Header", delete that header in `cors.js` too.
