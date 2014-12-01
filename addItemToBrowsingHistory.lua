-- $productId, $browsingKey, $browsingTime, $expiredKey, $expiredTime, $delTime, $maxHistoryLength, $now
-- ARGV[1], ARGV[2], ARGV[3], ARGV[4], , ARGV[5], ARGV[6], ARGV[7], ARGV[8]
-- 4011, brand_browsing_10010, 1417498107, brand_expired_10010, 1417498107, 1417498107, 3, 1417440107

local productId = ARGV[1];
local browsingKey = ARGV[2];
local browsingTime = ARGV[3];
local expiredKey = ARGV[4];
local expiredTime = ARGV[5];
local delTime = ARGV[6];
local maxHistoryLength = ARGV[7];
local now = ARGV[8];
local num;
local tProductId;
local index;

redis.call('zAdd', browsingKey, browsingTime, productId);
redis.call('expire', browsingKey, delTime);

redis.call('zAdd', expiredKey, expiredTime, productId);
redis.call('expire', expiredKey, delTime);

local count = redis.call('ZCARD', expiredKey);
local balance = count - maxHistoryLength;
if balance > 0 then
    -- 获取过期列表
    -- NMB by score
    local expiredList = redis.call('zRangeByScore', expiredKey, 0, now);
    if expiredList ~= false and #expiredList ~= 0 then
        -- 有商品过期 删除
        num = redis.call('zDeleteRangeByScore', expiredKey, 0, now);
        balance = balance - num;
        for tProductId in ipairs(expiredList) do
            redis.call('ZREM', browsingKey, tProductId);
        end
    end

    if balance > 0 then
        -- 否则判断浏览历史列表
        -- 删了浏览历史最后一下
        local expiredList2 = redis.call('zRange', browsingKey, 0, balance - 1);
        num = redis.call('zRemRangeByRank', browsingKey, 0, balance - 1);

        -- NMB by index
        for index=1, #expiredList2 do
            redis.call('ZREM', expiredKey, expiredList2[index]);
        end
    end
end

return balance;