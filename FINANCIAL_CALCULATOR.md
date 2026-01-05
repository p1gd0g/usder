# 理财收益计算器 (Financial Investment Calculator)

## 功能概述 (Feature Overview)

这是一个用于计算人民币和美元理财产品收益的金融工具。用户可以输入理财产品的相关参数，系统会自动计算并显示两种货币的预期收益。

This is a financial tool for calculating the returns of RMB and USD financial products. Users can input the relevant parameters of financial products, and the system will automatically calculate and display the expected returns for both currencies.

## 功能特点 (Features)

### 输入参数 (Input Parameters)

1. **本金金额 (Principal Amount)**: 投资的本金金额（人民币）
2. **人民币理财年化利率 (RMB Annual Interest Rate)**: 人民币理财产品的年化收益率（百分比）
3. **美元理财年化利率 (USD Annual Interest Rate)**: 美元理财产品的年化收益率（百分比）
4. **人民币/美元汇率 (RMB/USD Exchange Rate)**: 当前的人民币兑美元汇率
5. **理财到期日 (Maturity Date)**: 理财产品的到期日期

### 计算结果 (Calculation Results)

- **人民币理财收益 (RMB Investment Return)**: 基于人民币理财产品的预期收益
- **美元理财收益 (USD Investment Return)**: 基于美元理财产品的预期收益
- **理财期限 (Investment Duration)**: 从今天到到期日的天数

## 计算公式 (Calculation Formula)

### 人民币收益 (RMB Profit)
```
人民币收益 = 本金 × 年化利率 × (天数 / 365)
RMB Profit = Principal × Annual Rate × (Days / 365)
```

### 美元收益 (USD Profit)
```
美元本金 = 人民币本金 / 汇率
美元收益 = 美元本金 × 年化利率 × (天数 / 365)

USD Principal = RMB Principal / Exchange Rate
USD Profit = USD Principal × Annual Rate × (Days / 365)
```

## 使用方法 (How to Use)

1. 打开应用后，会直接进入理财收益计算器页面
2. 填写所有必需的信息：
   - 输入本金金额
   - 输入人民币理财年化利率
   - 输入美元理财年化利率
   - 输入人民币/美元汇率（默认值：7.2）
   - 选择理财到期日期
3. 点击"计算收益"按钮
4. 查看计算结果，包括两种货币的预期收益和投资期限

## 技术实现 (Technical Implementation)

### 架构 (Architecture)

- **状态管理 (State Management)**: 使用 GetX 进行状态管理
- **UI 框架 (UI Framework)**: Flutter with Material Design 3
- **日期处理 (Date Handling)**: intl package for date formatting

### 文件结构 (File Structure)

```
lib/
├── controllers/
│   └── financial_calculator_controller.dart  # 计算逻辑控制器
├── screens/
│   └── financial_calculator_screen.dart      # UI 界面
└── main.dart                                  # 应用入口
```

### 核心组件 (Core Components)

1. **FinancialCalculatorController**: 
   - 管理所有输入字段
   - 实现收益计算逻辑
   - 处理日期选择和验证

2. **FinancialCalculatorScreen**: 
   - 提供用户界面
   - 显示输入表单和计算结果
   - 实现响应式设计

## 测试 (Testing)

项目包含完整的单元测试，覆盖：
- 基本计算功能
- 边界条件处理
- 错误输入处理
- 日期验证

运行测试：
```bash
flutter test test/financial_calculator_test.dart
```

## 示例场景 (Example Scenario)

假设：
- 本金：10,000 CNY
- 人民币年化利率：3.5%
- 美元年化利率：4.2%
- 汇率：7.2
- 投资期限：365 天

结果：
- 人民币收益：350.00 CNY
- 美元收益：58.33 USD

## 未来改进 (Future Improvements)

- [ ] 添加历史记录功能
- [ ] 支持多种货币对比
- [ ] 添加图表可视化
- [ ] 支持复利计算
- [ ] 添加收益预测曲线
