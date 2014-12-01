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
$ret = $redis->eval($luaScript, array(4028, 'brand_browsing_10010', 1417498107, 'brand_expired_10010', 1417498107, 1417498107, 3, 1417457308));
var_export($ret);

$err = $redis->getLastError(); 
var_export($err);

