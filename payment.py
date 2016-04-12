#!/usr/bin/env python
#coding=utf-8

__author__ = "cenegd<cenegd@live.com>"

import requests, time, hashlib, string, urllib, os
from bs4 import BeautifulSoup
requests.packages.urllib3.disable_warnings()

# 通知 Web 服务器 URL
PUSH_STATE_URL = "http://pay.qiyichao.cn/api/pay.php?application={0}&apikey={1}&method=new_order".format(os.getenv('PAYMENT_APPLICATION_ID'), os.getenv('PAYMENT_APIKEY'))

# 通知 Web 服务器验签名加密参数，不参与明文传输
PUSH_STATE_KEY = os.getenv('PAYMENT_SECERT')

# 将输入的 Cookie 转换为字典类型
def cookie_string_to_dict(cookiestring):
    cookie_dict = {}
    for line in cookiestring.split(";"):
        line_cache = line.split("=")
        cookie_key = line_cache[0]
        cookie_value = line_cache[1]
        if cookie_key != '':
            cookie_dict[cookie_key] = cookie_value
    return cookie_dict

cookie = os.getenv('PAYMENT_COOKIE')
s = requests.Session()

# 已经成功通知服务器的订单列表
orderList = {}

def check_order():
    localtime = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    print "staring get order", localtime
    # 由于支付宝限制只刷新订单页面会导致 Cookie 失效
    s.get("https://my.alipay.com/portal/i.htm", cookies=cookie_string_to_dict(cookie))
    # 仅查看收入
    r = s.get("https://consumeprod.alipay.com/record/advanced.htm?fundFlow=in&_input_charset=utf-8", cookies=cookie_string_to_dict(cookie))
    ps = BeautifulSoup(r.text, "html5lib")
    orderTable = ps.find("tbody")
    for order in orderTable.find_all("tr"):
        order_data = {}
        # 请装作没看见以下写的乱七八糟解析网页的代码
        # 订单产生时间
        order_data["time"] = str(order.td.p.text).strip() + " "+ order.td.p.find_next("p").text.strip()

        # 用户 id，没什么用，为了兼容 EasyPay 架构存在
        order_data["userid"] = ""

        # 订单名称
        try:
            order_data["desc"] = order.td.find_next("td").find_next("td").p.a.string.encode("utf-8")
        except:
            order_data["desc"] = "get has error"

        # 订单号
        order_data["tradeNo"] = order.td.find_next("td").find_next("td").find_next("td").p.text.encode("utf-8").split("|")[0].split(":")[1].strip()

        # 支付宝对方用户名
        order_data["username"] = order.td.find_next("td").find_next("td").find_next("td").find_next("td").p.text.strip()
        #order_data["username"] = u"error"

        # 转账金额，支出为负
        order_data["amount"] = float(order.td.find_next("td").find_next("td").find_next("td").find_next("td").find_next("td").span.text[2:])
        #print order_data["amount"]

        # 订单状态，通常为交易成功
        order_data["status"] = order.td.find_next("td").find_next("td").find_next("td").find_next("td").find_next("td").find_next("td").find_next("td").p.text

        # 解析网页完成
        if order_data["amount"] <= 0:
            # 支出则不再通知服务器
            print localtime, "tradeNo", order_data["tradeNo"], "amount <= 0"
        else:
            # 重复通知服务器完全没有问题，服务器不会更新订单状态，只是会让服务器执行较多的 SQL 查询
            if order_data["tradeNo"] in orderList:
                pass
            else:
                # 通知服务器
                # sig 签名算法 md5(tradeNo|payname|time|username|userid|amount|status|key)

                # 实现自己向服务器的推送算法

                push_data = order_data
                #print order_data["tradeNo"], order_data["desc"], order_data["time"], order_data["username"], order_data["userid"], str(order_data["amount"]), order_data["status"], PUSH_STATE_KEY
                sig_format = '|'.join([order_data["tradeNo"], order_data["desc"].decode("utf-8"), order_data["time"], order_data["username"], order_data["userid"], str(order_data["amount"]), order_data["status"], PUSH_STATE_KEY]).encode("utf-8")

                push_data["sig"] = hashlib.new("md5", sig_format).hexdigest().upper()

                response_text = requests.post(PUSH_STATE_URL, data=push_data).text

                print "sending to server tradeNo", order_data["tradeNo"], response_text

                if response_text == "success":
                    orderList[order_data["tradeNo"]] = order_data
                else:
                    return False

if __name__ == "__main__":
    while True:
        check_order()
        time.sleep(30)
