-- custom_filter.lua
local rspamd_config = require "rspamd_config"

local function check_norton_lifelock(task)
    local has_norton = false
    local has_lifelock = false

    -- Check for "Norton" in the email content
    if task:get_content():lower():find("norton") then
        has_norton = true
    end

    -- Check for "LifeLock" in the email content
    if task:get_content():lower():find("lifelock") then
        has_lifelock = true
    end

    if has_norton and has_lifelock then
        task:insert_result('BLOCK_NORTON_LIFELOCK', 1.0)
    end
end

local function check_docusign_phish(task)
    local lower_content = task:get_content():lower()
     if (lower_content:find("review=20pending=20document") or
         lower_content:find("kindly=20complete=20electronic") )then
        task:insert_result('DOCUSIGN_PHISH', 1.0)
     end

end

local function other_phishing(task)
    local lower_content = task:get_content():lower()
    local is_phish = (lower_content:find("By making this reference easily accessible to you, we will") or
        lower_content:find("80dc0-913b-4635-bf4e-0545a591849b") or
        lower_content:find("<html><body><div>Thank YOU.<br>") or
        lower_content:find("I also have full Ð°ccess to your account.") or
        lower_content:find("188.65.245.69") or
        lower_content:find("The fact is that you were infected with") or
        lower_content:find("formula2107@outlook.com") or
        lower_content:find("lvrzdign.php") or
        lower_content:find("activatefixmail.com") or
        lower_content:find("is due for validation.<br>") or
        lower_content:find("my perverted friend.") or
        lower_content:find("linkmasters.ru") or  
        lower_content:find("<html><body><div>Order Confirmed."))
    if is_phish then
        task:insert_result('OTHER_PHISH', 1.0)
    end
end

local function check_other_spam(task)
    local is_spam = false

    if task:get_content():lower():find("casino leads") then
        is_spam = true
    end

    if task:get_content():lower():find("forex leads") then
        is_spam = true
    end

    if task:get_content():lower():find("pharma leads") then
        is_spam = true
    end

    if task:get_content():lower():find("you have won") then
        is_spam = true
    end

    if is_spam then
        task:insert_result('BLOCK_OTHER_SPAM', 1.0)
    end
end


rspamd_config:register_symbol({
    name = 'DOCUSIGN_PHISH',
    score = 10.0,
    callback = check_docusign_phish,
    description = 'Docusign Phishing',
    group = 'custom'
})

rspamd_config:register_symbol({
    name = 'OTHER_PHISH',
    score = 10.0,
    callback = other_phishing,
    description = 'Other Phishing',
    group = 'custom'
})

rspamd_config:register_symbol({
    name = 'BLOCK_NORTON_LIFELOCK',
    score = 10.0,
    callback = check_norton_lifelock,
    description = 'Block emails mentioning Norton LifeLock',
    group = 'custom'
})

rspamd_config:register_symbol({
    name = 'BLOCK_OTHER_SPAM',
    score = 10.0,
    callback = check_other_spam,
    description = 'Block spam emails',
    group = 'custom'
})
