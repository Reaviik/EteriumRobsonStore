-- By Reavik, Player_rs and HarryKaray V3.0s

local cb = peripheral.find("chatBox")
if cb == nil then print("chatBox no found") end

local nameBot = "Robson Store"
local woner = "Reavik"
local remove = false

local function Split(s, delimiter)
    local result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

local function loadTabela()
    local f = fs.open("EteriumSky/priceTable.lua", "r")
    local data = textutils.unserialize(f.readAll())
    f.close()
    return data
end

local function sendMessage(msg, player)
    cb.sendMessageToPlayer(msg, player, nameBot)
end

local function findItem(str, table)
    local out = {}
    for index, v in pairs(table) do
        if string.find(v.name:lower(), str) then
            v["index"] = index
            out[#out+1] = v
        end
    end
    if #out == 0 then
        return false, {}
    else
        return true, out
    end
end

local function _downloadList()
    if not fs.exists("EteriumSky") then
        fs.makeDir("EteriumSky")
    end
    shell.run("wget https://raw.githubusercontent.com/Playerrs/CCrepo/master/EteriumLoja/EteriumTable.lua EteriumSky/priceTable.lua")
end

-- Main
if not fs.exists("EteriumSky/priceTable.lua") then _downloadList() end
local tabela = loadTabela()
print("Tudo certo e funcionando!\n["..nameBot.."]")

while true do
    --editei msg para message
    local e, player, message = os.pullEvent("chat")
    --modem.transmit(7777,98,{color, player, message})
    local split_string = Split(message, " ")
    msg = (split_string[1]):lower()

    if msg == "help" or msg == "calc" or msg == "c" or msg == "preço" or msg == "price" or msg == "prico" or msg == "sky" or msg == "remove"  or msg == "add" then
        print("["..player.."]: "..msg)
    end
    if msg == "preço" or msg == "preco" or msg == "price" then
        local item
        local stats, result
        if split_string[2] then
            item = split_string[2]:lower()
            stats, result = findItem(item, tabela)
        else
            sendMessage("Para mais informações digit \"sky\" ou \"help\" no chat", player)
        end

        if stats then
            for i, v in pairs(result) do
                sendMessage(("[Tier %s] [%s]:\n %s"):format(v.tier, v.name, v.info), player)
                sleep(1)
            end
        else
            sendMessage(("[%s] não foi encontrado na tabela\nTente pesquisar por outro nome\nOu calcule o proço baseado nos item usado para o craft\nUse \"help\" para mais informações"):format(item), player)
        end
    end
    if msg == "sky" then
        sendMessage("------------------ [Eterium Sky]\nExiste um delay de 1s entre um comando e outro\nAss: Reavik, Player_rs", player)
    end
    if msg == "help" then
        sendMessage("----------------- [Eterium Sky]\nDigite no chat local os comandos a seguir sem usar /\nprice\ncalc\nsky\nhelp", player)
    end
    -- split_string[1] = calc
    -- split_string[2] = int
    -- split_string[3] = parametro
    -- split_string[4] = int
    if msg == "calc" or msg == "c" then
        if split_string[2] then
            item = split_string[2]:lower()
            stats, result = findItem(item, tabela)
            local error = "[X] Você deve digitar apenas numeros e parametros matematicos"
        if split_string[3] == "+" then
            if tonumber(split_string[2]) and tonumber(split_string[4]) then
                sendMessage("A soma de "..split_string[2].." mais "..split_string[4].." é ["..tonumber(split_string[2]) + tonumber(split_string[4]).."]", player)
            else
                sendMessage(error,player)
            end
        end
        if split_string[3] == "-" then
            if tonumber(split_string[2]) and tonumber(split_string[4]) then
                sendMessage("A subitração de "..split_string[4].." de "..split_string[2].." é ["..tonumber(split_string[2]) - tonumber(split_string[4]).."]", player)
            else
                sendMessage(error,player)
            end
        end
        if split_string[3] == "/" or split_string[3] == "%" then
            if tonumber(split_string[2]) and tonumber(split_string[4]) then
                sendMessage("A divisão de "..split_string[2].." por "..split_string[4].." é ["..tonumber(split_string[2]) / tonumber(split_string[4]).."]", player)
            else
                sendMessage(error,player)
            end
        end
        if split_string[3] == "*" or split_string[3] == "x" then
            if tonumber(split_string[2]) and tonumber(split_string[4]) then
                sendMessage("A divisão de "..split_string[2].." por "..split_string[4].." é ["..tonumber(split_string[2]) * tonumber(split_string[4]).."]", player)
            else
                sendMessage(error,player)
            end
        end
        if split_string[3] == "^" then
            if tonumber(split_string[2]) and tonumber(split_string[4]) then
                sendMessage("A potência de "..split_string[2].." elevado "..split_string[4].." é ["..tonumber(split_string[2]) ^ tonumber(split_string[4]).."]", player)
            else
                sendMessage(error,player)
            end
        end
        if split_string[2] == "v" then
            if tonumber(split_string[3]) then
                sendMessage("A raiz quadrada de "..split_string[3].." é ["..math.sqrt(tonumber(split_string[3])).."]", player)
            else
                sendMessage(error,player)
            end
        end
        else
            sendMessage("Os parametros validos para a calculadora são:\n+ Soma\n- Subtração\n/ % Divisão\n* x Multilicação\n^ Potência\nv Raiz quadrada", player)
        end
        sleep(1)
    end
    if msg == "remove" and player == woner then
        local item
        --    bolean/table
        local stats, result
        --tabela resultante da pesquisa na lista
        if split_string[2] then
            item = split_string[2]:lower()
            stats, result = findItem(item, tabela)
        else
            sendMessage("Digite remove nomeDoItem para remover um item.", player)
        end

        if stats and remove == false then
            for i, v in pairs(result) do
                sendMessage(("%s: [Tier %s] [%s]:\n %s"):format(v.index, v.tier, v.name, v.info), player)
                sleep(1)
                --add o resultado da busca a uma tabela
            end
            sendMessage("Qual desses item voçe deseja remover", player)
            remove = true
        elseif stats and remove == true then
            print("Removendo")

            table.remove(tabela, tonumber(split_string[2]))

            --ler o arquivo com reescrever
            local f = fs.open("EteriumSky/priceTable.lua", "w")

            --reescreve a tabela
            f.write(textutils.serialise(tabela))
            f.close()
            remove = false
        else
            sendMessage("Não existe um item para ser removido.", player)
        end
    end
    if msg == "add" and player == woner then
        print("Add")
        if #split_string == 4 then
        --tabela
        --pegar a mensagem do player remover add
        --resulta em algo assim {name = "Minhoca", info = "2.000/inv", tier = 1},
        table.remove(split_string, 1)
        --split 3 valores "mane" "info" "tier" e separas as palavras
        local name = string.gsub(split_string[1], "(%u)", " %1"):gsub("^%*", "",1)
        --R preço unitario / pack
        local info = string.gsub(split_string[2], "(%u)", " %1")
        --R andar
        local tier = tonumber(split_string[3])
        --adicionar a tabela
            if type(tier) == "number" then
                table.insert(tabela,{name = name, info = info, tier = tier})
                --gravar a nova tabela
                local f = fs.open("EteriumSky/priceTable.lua", "w")
                f.write(textutils.serialise(tabela))
                --fexar a tabela
                f.close()
                sendMessage("O item "..(name:gsub("^%*", "",1)).." foi adicionado a tabela por "..info.." no tier "..info, player)
            else
                sendMessage("O tier precisa ser um numero")
        end
        else
            sendMessage("Você deve digitar \"add name, info, tier\"", player)
        end
    end
end


--fs "r" abre para leitura
--fs "w" abre para escrever e remover os dados existentes
--fs "a" abre para escrever e mantem os daddos existentes
