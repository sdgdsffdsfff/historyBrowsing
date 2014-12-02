<?php
// vim: set expandtab cindent tabstop=4 shiftwidth=4 fdm=marker:
 
/**
 * @file     redisEvalShaTest.php
 * @version  1.0
 * @author   wade
 * @date     2014-12-01 22:56:38
 * @desc     redis集成lua脚本功能实现浏览历史功能
 */


$redis = new Redis();
$redis->connect('127.0.0.1', '6379');
// $redis->set('test', 'Hello World');
// echo $redis->get('test');

$luaScript = file_get_contents('./addItemToBrowsingHistory.lua');
$ret = $redis->eval($luaScript, array(4011, 'brand_browsing_10011', 1417582943, 'brand_expired_10011', 1417582943, 1417582943, 3, 1417482943));
var_export($ret);

$err = $redis->getLastError(); 
var_export($err);

