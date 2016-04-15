<?php

/**
 * Public Base Pay Ment Restful API
 * Main File
 * @access private
 * @link https://github.com/ss098/payment
 * @author cenegd <cenegd@live.com>
**/

// 全局通信密码
$key = getenv('PAYMENT_SECERT');

ini_set('display_errors', true);
error_reporting(E_ALL);

header("Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0");
header("Pragma: no-cache");
header('Content-Type: application/json');

require_once '../library/medoo.php';

$database = new medoo(array(
	'database_type' => getenv('DB_TYPE'),
	'database_name' => getenv('DB_NAME'),
	'server' => getenv('DB_SERVER'),
	'username' => getenv('DB_USERNAME'),
	'password' => getenv('DB_PASSWORD'),
	'charset' =>  getenv('DB_CHARSET'),
	'port' => getenv('DB_PORT')
));

function message($message_id, $data='') {
	$message_list = array(
		0 => 'Order is exists', // 订单存在
		1 => 'Order is not exists', // 订单不存在
		2 => 'Order is exists, but is used for other appid', // 订单存在并且被用于其他 appid
		3 => 'Order is exists, but is used for this appid', // 订单存在并且被当前 appid 使用
		4 => 'Order did not use', // 订单没有被使用
		5 => 'Order used with this request', // 成功使用订单给这个应用
	);
	$json = array(
		'error' => false,
		'message_id' => $message_id,
		'message' => $message_list[$message_id]
	);

	if ($data) {
		$json['data'] = $data;
	}

	echo json_encode($json);
}

/* 统一输出函数 */
function message_error($message) {
	echo json_encode(array(
		'error' => true,
		'message' => $message
	));
}

if (isset($_GET['application'], $_GET['method'], $_GET['apikey'])) {
	$appid = (int)$_GET['application'];
	$method = $_GET['method'];
	$apikey = $_GET['apikey'];

	$application = $database->get('application', array('id' ,'apikey'), array('id' => $appid));

	if ($application) {
		if ($apikey === $application['apikey']) {
			$apikey = $application['apikey'];

			if ($method == 'new_order') {

				/* 方法 new_order 开始 */

				if (isset($_POST['sig'], $_POST['tradeNo'], $_POST['desc'], $_POST['time'], $_POST['username'], $_POST['userid'], $_POST['amount'], $_POST['status'])) {
					/**
					 * 给软件的接口，将订单添加到数据库
					 * 这段代码采用 echo 而不是标准输出函数输出，因为是给别的程序看的
					**/

					$sig = $_POST['sig']; //签名
					$tradeNo = $_POST['tradeNo']; //交易号
					$payname = $_POST['desc']; //交易名称（付款说明）
					$time = $_POST['time']; //付款时间
					$username = $_POST['username']; //客户名称
					$userid = $_POST['userid']; //客户id
					$amount = $_POST['amount']; //交易额
					$status = $_POST['status']; //交易状态

					if(strtoupper(md5("$tradeNo|$payname|$time|$username|$userid|$amount|$status|$key")) == $sig) {
						// 参数正确，将行添加到数据库
						$database->insert('order', array(
							'tradeNo' => $tradeNo,
							'payname' => $payname,
							'time' => $time,
							'username' => $username,
							'userid' => $userid,
							'amount' => $amount,
							'status' => $status,
						));

						// 成功
						echo 'success';
					} else {
						// 校对参数失败，参数可能是伪造的
						echo 'param sig has error';
					}
				} else {
					// 参数提交的不够
					echo 'Params is not exists';
				}

				/* 方法 new_order 结束 */
			} else if ($method == 'save_status') {
				if (isset($_POST['tradeNo'])) {

				}
			} else if ($method == 'check_order') {
				/* 方法 check_order 开始 */

				if (isset($_GET['tradeNo'])) {
					/**
					 * $tradeNo // 订单编号
					 * $use // 如果这个订单没有使用，是否使用这个订单给 appid
					**/

					$tradeNo = $_GET['tradeNo'];

					$order = $database->get('order', array('tradeNo', 'payname', 'time', 'username', 'userid', 'amount', 'status', 'use_timestamp', 'use_appid'), array('tradeNo' => $tradeNo));

					if ($order) {
						if ($order['use_appid']) {
							// 该订单被使用过
							if ($order['use_appid'] != $appid) {
								// 被其他 appid 使用了
								message(2);
							} else {
								// 被当前 appid 使用了
								message(3, $order);
							}
						} else {
							// 该订单没有被使用过
							if (isset($_GET['update'])) {
								// 如果没有使用过，那就标记为使用
								$updated = $database->update('order', array('use_timestamp'=>time(), 'use_appid'=>$appid), array('tradeNo'=>$tradeNo));
								if ($updated >= 1) {
									message(5, $order);
								} else {
									message_error('Failed to update order');
								}
							} else {
								// 该订单没有被使用过
								message(4, $order);
							}
						}
					} else {
						// 订单不存在
						message(1);
					}
				} else {
					// tradeNo 参数没有提交
					message_error('Param tradeNo is not exists');
				}

				/* 方法 check_order 结束 */
			} else {
				message_error('Method is not exists');
			}
		} else {
			// 参数 apikey 不正确
			message_error('Param apikey has error');
		}
	} else {
		// appid 不存在
		message_error('Application is not exists');
	}
} else {
	// 提交的参数不够
	message_error('Params is not exists');
}
