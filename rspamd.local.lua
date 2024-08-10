spamd_config.NORTON_LIFELOCK = {
  callback = function(task)
     local lower_content = task:get_content():lower()
     if (lower_content:find("norton") and
        lower_content:find("lifelock") and
        lower_content:find("bank")) then
        return true
     else
        return false
     end
  end,
  score = 15.0,
  description = 'norton lifelock spam',
}

rspamd_config.DOCUSIGN_PHISH = {
  callback = function(task)
     local lower_content = task:get_content():lower()
     if (lower_content:find("review=20pending=20document") or
         lower_content:find("kindly=20complete=20electronic") )then
        return true
     else
        return false
     end
  end,
  score = 15.0,
  description = 'docusign phish',
}


rspamd_config.PHISH001 = {
  callback = function(task)
     local lower_content = task:get_content():lower()
     return (lower_content:find("By making this reference easily accessible to you, we will") or
        lower_content:find("80dc0-913b-4635-bf4e-0545a591849b") or
        lower_content:find("<html><body><div>Thank YOU.<br>") or
        lower_content:find("I also have full Ð°ccess to your account.") or
        lower_content:find("188.65.245.69") or
        lower_content:find("The fact is that you were infected with") or
        lower_content:find("formula2107@outlook.com") or
        lower_content:find("lvrzdign.php") or
        lower_content:find("activatefixmail.com"))
  end,
  score = 15.0,
  description = 'phish 001',
}
