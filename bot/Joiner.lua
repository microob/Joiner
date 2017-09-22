joiner = dofile('./bot/funcation.lua')  Joiner_id = 224782491   ------   Joiner id
json = dofile('./libs/JSON.lua')
URL = require "socket.url"
serpent = dofile("./libs/serpent.lua")
http = require "socket.http"
https = require "ssl.https"
d = dofile('./libs/redis.lua')
config_sudo = {}   ------ Sudo Users
function dl_cb(arg, data)
end
function is_sudo(msg)   local var = false for v,user in pairs(config_sudo) do if user == msg.sender_user_id_ then  var = true  end end return var   end
	  function showedit(msg,data)   if msg then joiner.viewMessages(msg.chat_id_, {[0] = msg.id_}) if msg.send_state_.ID == "MessageIsSuccessfullySent" then  return false   end     
 if msg.chat_id_ then
      local id = tostring(msg.chat_id_)
      if id:match('-100(%d+)') then
        chat_type = 'super'
        elseif id:match('^(%d+)') then
        chat_type = 'user'
        else
        chat_type = 'group'
        end
      end

 local text = msg.content_.text_
	if text and text:match('[QWERTYUIOPASDFGHJKLZXCVBNM]') then
		text = text
		end
    if msg.content_.ID == "MessageText" then
      msg_type = 'text'
    end
    if msg.content_.ID == "MessageChatAddMembers" then
      msg_type = 'user'
    end
    if msg.content_.ID == "MessageChatJoinByLink" then
      msg_type = 'Joins'
    end
   if msg.content_.ID == "MessageDocument" then
        print("This is [ File Or Document ]")
        msg_type = 'Document'
      end
      if msg.content_.ID == "MessageSticker" then
        print("This is [ Sticker ]")
        msg_type = 'Sticker'
      end
      if msg.content_.ID == "MessageAudio" then
        print("This is [ Audio ]")
        msg_type = 'Audio'
      end
      if msg.content_.ID == "MessageVoice" then
        print("This is [ Voice ]")
        msg_type = 'Voice'
      end
     if msg.content_.ID == "MessageVideo" then
        print("This is [ Video ]")
        msg_type = 'Video'
      end
      -------------------------
      if msg.content_.ID == "MessageAnimation" then
        print("This is [ Gif ]")
        msg_type = 'Gif'
      end
      -------------------------
      if msg.content_.ID == "MessageLocation" then
        print("This is [ Location ]")
        msg_type = 'Location'
      end
          if msg.content_.ID == "MessageContact" then
        print("This is [ Contact ]")
        msg_type = 'Contact'
      end
      
 if not msg.reply_markup_ and msg.via_bot_user_id_ ~= 0 then
        print("This is [ MarkDown ]")
        msg_type = 'Markreed'
      end
    if msg.content_.ID == "MessagePhoto" then
      msg_type = 'Photo'
end
function check_markdown(text)   	str = text	if str:match('_') then	output = str:gsub('_',[[\_]])	elseif str:match('*') then	output = str:gsub('*','\\*')	elseif str:match('`') then	output = str:gsub('`','\\`')   else   output = str
		end
	return output
end
    if msg_type == 'text' and text then
      if text:match('^[/]') then
      text = text:gsub('^[/]','')
      end
    end



if text == 'Joiner On' and is_sudo(msg) then

          d:set('joinlink','yes')
         joiner.sendText(msg.chat_id_, msg.id_, 1,'Done  !', 1, 'md')
                              

end
 if text == 'Joiner off' and is_sudo(msg) then
 d:set('joinlink','no')
 d:del('joinlink','yes')  
 joiner.sendText(msg.chat_id_, msg.id_, 1,'Done  !', 1, 'md')
  end


 if text and text:match("https://telegram.me/joinchat/%S+") or text and text:match("https://t.me/joinchat/%S+") or text and text:match("https://t.me/joinchat/%S+")  or text and text:match("https://telegram.dog/joinchat/%S+") and is_sudo(msg) then
  local link = text and text:match("https://telegram.me/joinchat/%S+") or text and text:match("https://t.me/joinchat/%S+") or text and text:match("https://t.me/joinchat/%S+")  or text and text:match("https://telegram.dog/joinchat/%S+")
joiner.importChatInviteLink(link, dl_cb, nil)
                        
    joiner.sendText(msg.chat_id_, msg.id_, 1, '_> Join This Link_\n\n_> \nPlease Snd Me Any Shit  ........!_         ', 1, 'md')
end
  
  local joinlink = (d:get('joinlink') or 'no') 
    if joinlink == 'yes' then
	if text and text:match("https://telegram.me/joinchat/%S+") or text and text:match("https://t.me/joinchat/%S+") or text and text:match("https://t.me/joinchat/%S+")  or text and text:match("https://telegram.dog/joinchat/%S+") then
		local text = text:gsub("t.me", "telegram.me")
		for link in text:gmatch("(https://telegram.me/joinchat/%S+)") do
			if not d:sismember("links", link) then
				d:sadd("links", link)
				joiner.importChatInviteLink(link)
			end
		end
end
end
d:incr("tallmsg")
 if msg.chat_id_ then
      local id = tostring(msg.chat_id_)
      if id:match('-100(%d+)') then
        if not d:sismember("sgps",msg.chat_id_) then
          d:sadd("tsgps",msg.chat_id_)

        end
elseif id:match('^-(%d+)') then
if not d:sismember("tgp",msg.chat_id_) then
d:sadd("tgp",msg.chat_id_)

end
elseif id:match('') then
if not d:sismember("tusers",msg.chat_id_) then
d:sadd("tusers",msg.chat_id_)
end
   else
        if not d:sismember("tsgps",msg.chat_id_) then
            d:sadd("tsgps",msg.chat_id_)

end
end
end
end
end
      function tdcli_update_callback(data)
    if (data.ID == "UpdateNewMessage") then
     showedit(data.message_,data)
  elseif (data.ID == "UpdateMessageEdited") then
    data = data
    local function edit(extra,result,success)
      showedit(result,data)
    end
     tdcli_function ({ ID = "GetMessage", chat_id_ = data.chat_id_,message_id_ = data.message_id_}, edit, nil)
  elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
    tdcli_function ({ ID="GetChats",offset_order_="9223372036854775807", offset_chat_id_=0,limit_=20}, dl_cb, nil)
  end
end


