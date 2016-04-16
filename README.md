支付订单业务处理网关，支持支付宝免签约收款。

`api/pay.php` 用于接收订单详细信息并处理 API 请求

`library/medoo.php` 是 pay.php 依赖的数据库处理模块

安装步骤：

 1. 拷贝代码到虚拟主机目录，导入 pay.sql 至数据库，依赖 PHP PDO MySQL 扩展
 2. 编辑 `api/pay.php` 中定义 $database 及 $key 的代码

这样支付网关就架构完成了，但是尚未实现支付网关的后台功能，如果希望添加实际的应用，需要向 `application` 表添加行与 API KEY。当然，如果希望能使用支付宝收款，需要额外安装 GitHub 仓库 [https://github.com/ss098/payment-script](https://github.com/ss098/payment-script)。

用户在充值的时候服务器向支付网关发一个请求，例如：

`http://pay.qiyichao.cn/api/pay.php?application=2&apikey=yXuSRIRl6viMbVyTJQpkv2h7cf0jEt8B&method=check_order&update=1&tradeNo=20150821200040011100610039833339`

如果该订单有效，则可以得到一个 JSON 数据响应：

`{"error":false,"message_id":5,"message":"Order used with this request","data":{"tradeNo":"20150821200040011100610039833339","payname":"\u8f6c\u8d26","time":"2015.08.21 00:33","username":"cenegd","userid":"","amount":"0.01","status":"\u4ea4\u6613\u6210\u529f","use_timestamp":null,"use_appid":null}}`
