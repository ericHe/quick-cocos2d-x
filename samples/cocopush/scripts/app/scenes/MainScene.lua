
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    if device.platform == "android" then
        self:showPushView()
    else
        self:noPushView()
    end
end

function MainScene:showPushView()    
    cc.ui.UILabel.new({text = "CocoPush demo", size = 48, align = cc.ui.TEXT_ALIGN_CENTER})
        :pos(display.cx, display.top - 50)
        :align(display.CENTER)
        :addTo(self)

    -- result show
    local resultLabel = cc.ui.UILabel.new({text = "result: -", size = 20, align = cc.ui.TEXT_ALIGN_CENTER})
        :pos(display.cx, display.top - 100)
        :align(display.CENTER)
        :addTo(self)
    self.resultLabel = resultLabel

    -- enable btn
    cc.ui.UIPushButton.new("Button01.png", {scale9 = true})
        :setButtonLabel(cc.ui.UILabel.new({text = "Enable Push", size = 22, color = display.COLOR_BLACK}))
        :setButtonSize(180, 50)
        :onButtonClicked(function()
            cc.push:startPush()
        end)
        :pos(100, display.top - 150)
        :addTo(self)

    -- disabel btn
    cc.ui.UIPushButton.new("Button01.png", {scale9 = true})
        :setButtonLabel(cc.ui.UILabel.new({text = "Disable Push", size = 22, color = display.COLOR_BLACK}))
        :setButtonSize(180, 50)
        :onButtonClicked(function()
            cc.push:stopPush()
        end)
        :pos(300, display.top - 150)
        :addTo(self)

    -- set tag
    cc.ui.UIPushButton.new("Button01.png", {scale9 = true})
        :setButtonLabel(cc.ui.UILabel.new({text = "set tag", size = 22, color = display.COLOR_BLACK}))
        :setButtonSize(180, 50)
        :onButtonClicked(function()
            local text = self.textSetTag:getText()
            if string.utf8len(text) < 1 then
                return
            end
            cc.push:setTags(string.split(text, ","))
        end)
        :pos(100, display.top - 200)
        :addTo(self)

    -- tag input
    local inputSetTagEdit = ui.newEditBox({
        image = "EditBoxBg.png",
        size = CCSize(180, 50),
        x = 300,
        y = display.top - 200,
        listener = function()end})
    :addTo(self)
    self.textSetTag = inputSetTagEdit

    -- del tag
    cc.ui.UIPushButton.new("Button01.png", {scale9 = true})
        :setButtonLabel(cc.ui.UILabel.new({text = "del tag", size = 22, color = display.COLOR_BLACK}))
        :setButtonSize(180, 50)
        :onButtonClicked(function()
            local text = self.textDelTag:getText()
            if string.utf8len(text) < 1 then
                return
            end
            cc.push:delTags(string.split(text, ","))
        end)
        :pos(100, display.top - 250)
        :addTo(self)

    -- tag input
    local inputDelTagEdit = ui.newEditBox({
        image = "EditBoxBg.png",
        size = CCSize(180, 56),
        x = 300,
        y = display.top - 250,
        listener = function()end})
    :addTo(self)
    self.textDelTag = inputDelTagEdit

    -- set alial
    cc.ui.UIPushButton.new("Button01.png", {scale9 = true})
        :setButtonLabel(cc.ui.UILabel.new({text = "set alias", size = 22, color = display.COLOR_BLACK}))
        :setButtonSize(180, 50)
        :onButtonClicked(function()
            local text = self.textAlias:getText()
            if string.utf8len(text) < 1 then
                return
            end
            cc.push:setAlias(text)
        end)
        :pos(100, display.top - 300)
        :addTo(self)

    -- tag input
    local inputSetAliasEdit = ui.newEditBox({
        image = "EditBoxBg.png",
        size = CCSize(180, 50),
        x = 300,
        y = display.top - 300,
        listener = function()end})
    :addTo(self)
    self.textAlias = inputSetAliasEdit

    -- del alias
    cc.ui.UIPushButton.new("Button01.png", {scale9 = true})
        :setButtonLabel(cc.ui.UILabel.new({text = "del alias", size = 22, color = display.COLOR_BLACK}))
        :setButtonSize(180, 50)
        :onButtonClicked(function()
            cc.push:delAlias()
        end)
        :pos(100, display.top - 350)
        :addTo(self)

    -- use EventProxy, ensure remove the listener when leave current the scene
    local proxy = cc.EventProxy.new(cc.push, self)
    proxy:addEventListener(cc.push.events.LISTENER, function(event)
        --event = 
        --{ provider,
        --  type,   返回类型 有setTags,delTags,setAlias,delAlias,startPush,stopPush
        --  ecode,  0为成功，其它为失败
        --  sucTags, 不为nil表示成功了的tag
        --  failTags, 不为nil表示失败了的tag
        --  }
        self.resultLabel:setString("result: " .. event.code)
    end)
end

function MainScene:noPushView()
    cc.ui.UILabel.new({text = "CocoPush demo\n\nPlease run this demo on Android device.",
            size = 24,
            align = cc.ui.TEXT_ALIGN_CENTER})
        :pos(display.cx, display.cy)
        :align(display.CENTER)
        :addTo(self)
end

function MainScene:onEnter()
    if device.platform == "android" then
        -- avoid unmeant back
        self:performWithDelay(function()
            -- keypad layer, for android
            local layer = display.newLayer()
            layer:addKeypadEventListener(function(event)
                if event == "back" then app.exit() end
            end)
            self:addChild(layer)

            layer:setKeypadEnabled(true)
        end, 0.5)
    end
end

function MainScene:onExit()
end

return MainScene
