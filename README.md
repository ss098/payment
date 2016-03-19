在使用前需要理解，我不会对由于该脚本造成的业务损失负责。

支付宝免签约第三方个人支付网关

`payment.py` 登录到支付宝网站检测支付宝订单并通知 API 服务器

`api/pay.php` 用于接收订单详细信息并处理 API 请求

`library/medoo.php` 是 pay.php 依赖的数据库处理模块

安装步骤：

 1. 下载源码得到 script/main.py 文件，依赖 BeautifulSoup 4 以及 requests 模块。
 2. 修改 PUSH_STATE_URL 以及 PUSH_STATE_KEY 为实际使用的值。
 3. 安装支付网关，导入 pay.sql（如果不采用支付网关的话请自行阅读源码理解如何处理数据），依赖 PHP PDO MySQL 扩展。
 4. 修改 `library/medoo.php` 为自己的数据库信息。
 5. 修改 `api/pay.php` 中的 $key 为在脚本中定义的 PUSH_STATE_KEY。
 6. 在命令行下执行 `python main.py`，输入你的支付宝访问 https://consumeprod.alipay.com/record/advanced.htm 页面的 document.cookie，这里需要自己使用浏览器完成，请注意该页面是支付宝交易记录高级版，直接访问会跳转到普通版。

请注意，在获取 Cookie 的时候需要在支付宝的全部账单的**高级版**而不是标准版，直接输入 URL 会导致跳转。

这样支付网关就架构完成了，但是希望添加实际的应用，需要向 `application` 表添加行与 API KEY。

用户在充值的时候服务器向支付网关发一个请求，例如：

`http://pay.qiyichao.cn/api/pay.php?application=2&apikey=yXuSRIRl6viMbVyTJQpkv2h7cf0jEt8B&method=check_order&update=1&tradeNo=20150821200040011100610039833339`

如果该订单有效，则可以得到一个 JSON 数据响应：

`{"error":false,"message_id":5,"message":"Order used with this request","data":{"tradeNo":"20150821200040011100610039833339","payname":"\u8f6c\u8d26","time":"2015.08.21 00:33","username":"cenegd","userid":"","amount":"0.01","status":"\u4ea4\u6613\u6210\u529f","use_timestamp":null,"use_appid":null}}`
