---
--- @author zsh in 2022/8/28 16:59
---

-- 导入部分
---@type widget
local Widget = require "widgets/widget";
---@type screen
local Screen = require 'widgets/screen';
---@type imagebutton
local ImageButton = require "widgets/imagebutton"
---@type templates
local Templates = require 'widgets/redux/templates'; -- 各种控件的模板
---@type textedit
local TextEdit = require 'widgets/textedit';

local Locale = require('chang_m3.dst.locale');
local Load = require('chang_m3.modules.utils.Load');
local Table = require('chang_m3.modules.utils.Table');
local Tool = require('chang_m3.dst.modtool');
local Text = Locale.getModText();
local S, F = Table.security.getSecurities();

local Property = {
    ['mainPanel'] = setmetatable({
        sizeX = 500,
        sizeY = 600,
        title_text = Text.UI.TransferPanel,
        button_spacing = nil,
        body_text = nil
    }, {
        __call = function(t, self)
            t.bottom_buttons = {
                {
                    text = "Add",
                    cb = function()
                        -- TODO:
                    end,
                    offset = nil
                },
                {
                    text = "Close",
                    cb = function()

                        --self:Hide(); -- 没有意义，因为只是隐藏了而已
                        --self = nil; -- 不只是这样
                        --self:Kill(); -- 不行，还是控制不了界面，为什么？
                        -- 肯定是 HUD 的 OpenScreenUnderPause 导致的

                        --self:Hide();

                        if (self.bind_TRANSFERPANEL) then
                            self.bind_TRANSFERPANEL:Hide();
                        end

                    end,
                    offset = nil
                },
            }
            return t.sizeX, t.sizeY, t.title_text, t.bottom_buttons, t.button_spacing, t.body_text;
        end
    }),
    ['scrollPanel'] = setmetatable({
        -- 滚动条控件的数据源
        items = {
            { index = 1, name = "abc1", x = 0, y = 0, z = 0 },
            { index = 2, name = "abc2", x = 0, y = 0, z = 0 },
            { index = 3, name = "abc3", x = 0, y = 0, z = 0 },
            { index = 4, name = "abc4", x = 0, y = 0, z = 0 },
            { index = 5, name = "abc5", x = 0, y = 0, z = 0 },
            { index = 6, name = "abc6", x = 0, y = 0, z = 0 },
            { index = 7, name = "abc7", x = 0, y = 0, z = 0 },
            { index = 8, name = "abc8", x = 0, y = 0, z = 0 },
            { index = 9, name = "abc9", x = 0, y = 0, z = 0 },
            { index = 10, name = "abc10", x = 0, y = 0, z = 0 },
        },
        opts = {
            -- NOTE: 可以见名知意
            -- opts.peek_height -- tips: 非必须（有默认值）
            -- opts.peek_percent -- tips: 非必须
            -- opts.force_peek -- tips: 非必须
            -- opts.num_visible_rows -- 必须，滚动条内最多显示多少行
            -- opts.num_columns -- 必须，有几个滚动条
            -- opts.item_ctor_fn -- 必须，每一项的构造方法
            -- opts.widget_width -- 必须，每一项的宽
            -- opts.widget_height -- 必须，每一项的高
            -- opts.end_offset -- tips: 非必须（有默认值）
            -- opts.allow_bottom_empty_row -- tips: 非必须
            -- opts.scissor_pad -- tips: 非必须（有默认值）
            -- chang TrueScrollList 类的参数：1、3、8、9、10
            -- opts.scroll_context -- tips: 非必须（有默认值）
            -- opts.apply_fn -- 必须，给每一项赋值，添加事件等
            -- opts.scrollbar_offset -- tips: 非必须（有默认值）
            -- opts.scrollbar_height_offset -- tips: 非必须（有默认值）
            -- opts.scroll_per_click -- tips: 非必须（有默认值）

            num_columns = 1, -- 有几个滚动条
            num_visible_rows = 8, -- 滚动条内最多显示多少行
            -- 给每一项赋值，添加事件等（在 item_ctor_fn 之后执行！）
            -- TODO: 所以这个是干嘛的，得看看去。TrueScrollList 的第三个参数！
            apply_fn = function(context, widget, data, index)
                widget.destitem:Hide();
                if data then
                    widget.destitem.name:SetString(data.name);
                    widget.destitem.backing:SetOnClick(function()
                    end);
                    widget.destitem:Show();
                    widget.destitem.name._index = data.index;
                end
            end,
            widget_width = 380, -- 每一项的宽
            widget_height = 50, -- 每一项的高
        }
    }, {
        __call = function(t, self, savelocal)
            -- NOTE: 该函数存在闭包！所以需要传个 self 进来！
            -- 每一项的构造方法
            t.opts.item_ctor_fn = function(content, index)
                local name = 'widget-' .. index; -- 话说这个 name 需要唯一吗？
                ---@type widget @instance of widget
                local widget = Widget(name); -- 这个 name 好像就是游戏内名字的意思，和 STRINGS.NAMES.xxx 一样的！

                widget:SetOnGainFocus(function()
                    self.scrollPanel:OnWidgetFocus(widget);
                end)

                -- 给 widget 绑定一个孩子 destitem
                -- Temp: 这个行为可以改成：创建一个 Item 类，继承自 Widget，然后在 Item 的初始化函数中处理 Item 的布局！
                widget.destitem = widget:AddChild(savelocal.initDestItem());

                return widget;
            end
            return t.items, t.opts;
        end
    })
}

local function initDestItem()
    local dest = Widget("destination");
    local width, height = 380, 50;
    dest.backing = dest:AddChild(Templates.ListItemBackground(width, height, function()
    end))
    dest.backing.move_on_click = true

    -- 名字文件控件，TextEdit 是可编辑控件
    dest.name = dest:AddChild(TextEdit(BODYTEXTFONT, 35))
    dest.name:SetColour(255, 255, 255, 1)
    dest.name:SetEditTextColour(255, 255, 255, 1)
    dest.name:SetIdleTextColour(255, 255, 255, 1)
    dest.name:SetHAlign(ANCHOR_LEFT) -- x 左
    dest.name:SetVAlign(ANCHOR_MIDDLE) -- y 中
    -- NOTE: 注意，这个锚点是指锚定在父亲里的位置！！！
    dest.name:SetPosition(-90, 0, 0)
    dest.name:SetRegionSize(150, 40)

    -- 编辑完成后，当点回车时的回调
    dest.name.OnTextEntered = function(text)
        -- TODO:
    end

    -- 删除按钮
    dest.deletebtn = dest:AddChild(Templates.StandardButton(function()
        -- TODO:
    end, "Delete", { 90, 40 }))
    dest.deletebtn:SetPosition(100, 0);

    -- 上移按钮
    dest.up_button = dest:AddChild(ImageButton("images/global_redux.xml", "scrollbar_arrow_up.tex"))
    dest.up_button:SetPosition(160, 10)
    dest.up_button:SetScale(0.2)
    dest.up_button:SetOnClick(function()
        -- TODO:
    end)

    -- 下移按钮
    dest.down_button = dest:AddChild(ImageButton("images/global_redux.xml", "scrollbar_arrow_down.tex"))
    dest.down_button:SetPosition(160, -10)
    dest.down_button:SetScale(0.2)
    dest.down_button:SetOnClick(function()
        -- TODO:
    end)

    -- 返回组件！
    return dest
end

local savelocal = {
    initDestItem = initDestItem
}

local TransferPanel = Class(Screen, function(self, owner)
    Screen._ctor(self, 'dst_m3_TransferPanel');

    self.owner = owner; -- CurrentDate 好像没添加

    self.mainPanel = self:AddChild(Templates.RectangleWindow(Property.mainPanel(self)));

    do
        ---@type widget
        local mainPanel = self.mainPanel;
        mainPanel:SetHAnchor(0);
        mainPanel:SetVAnchor(0);
    end

    self.scrollPanel = self.mainPanel:AddChild(Templates.ScrollingGrid(Property.scrollPanel(self, savelocal)));

    -- 要把滚动条挂到父组件上的 self.default_focus 对象上去 ?
    self.default_focus = self.scrollPanel;

    --[[
        SetItemsData() 用于更新滚动条数据源的，用法：self.scrollpanel:SetItemsData(newdestitems)
        GetScale() 用于获取控件的缩放比例的，返回值是 (x,y,z) 可以参与边距坐标的运算，从而实现屏幕不管放大还是缩小，都能保持固定的位置
    ]]
end);

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

--[[do
    -- Test code
    -- 2022-09-03-01:49 未能解决关闭界面的问题（我无语了？怎么会呢？官方怎么可能没提供呢？）
    -- 我无语了，这个导致的：self.owner.HUD:OpenScreenUnderPause(self.dst_m3_transferpanel);
    -- 解决了，但是是随便解决的（反正我的目的只是要显示个界面，溜了溜了）
    return;
end]]


local env_Property = {
    ['openbutton'] = setmetatable({
        txt = 'Open',
        size = { 100, 50 }
    }, {
        __call = function(t, self, savelocal)
            t.onclick = function()
                savelocal.showTransferPanel(self);
            end
            return t.onclick, t.txt, t.size;
        end
    })
}

local function showTransferPanel(self)
    -- FIXME: 即便这样，重启游戏呢？这个数据如何保存？
    -- Temp: 还有，隐藏了没意义，不是消失，只是看不见。（关于屏幕控制，和 screens/controls 有关）
    if (self.dst_m3_transferpanel) then
        self.dst_m3_transferpanel:Show();
        return self.dst_m3_transferpanel;
    end

    self.dst_m3_transferpanel = TransferPanel(self.owner);

    --[[    if (self.owner and self.owner.HUD) then
            -- 肯定是这个的问题！！！什么勾八！
            self.owner.HUD:OpenScreenUnderPause(self.dst_m3_transferpanel);
        end]]

    -- Temp: 解决了（从 T 键里随便找的）
    if self and self.containerroot then
        self.dst_m3_TRANSFERPANEL = self.containerroot:AddChild(self.dst_m3_transferpanel);
        self.dst_m3_TRANSFERPANEL:Show();

        self.dst_m3_transferpanel.bind_TRANSFERPANEL = self.dst_m3_TRANSFERPANEL;
    else
        print('ERROR!!!', "AddClassPostConstruct errors!")
        return self.dst_m3_transferpanel;
    end

    --self.dst_m3_transferpanel:Show();

    return self.dst_m3_transferpanel;

end

--[[do
    -- Test code: showTransferPanel
    --print('playerhud:', self); -- HUD
    --print('playerhud.dst_m3_transferpanel:', self.dst_m3_transferpanel); -- dst_m3_TransferPanel 即设置的 TransferPanel 的名字，TransferPanel 的实例
end]]

--[[local function closeTransferPanel(self)
    if self.dst_m3_transferpanel then
        self.dst_m3_transferpanel:Close(); -- ? 这删除了可不行！
        self.dst_m3_transferpanel = nil;
    end
end]]

local env_savelocal = {
    showTransferPanel = showTransferPanel,
    --closeTransferPanel = closeTransferPanel
};


env.AddClassPostConstruct(false and "screens/playerhud" or "widgets/controls", function(self)
    -- 在屏幕顶部添加一个按钮，用来触发面板的显示与关闭 tips: 此处显然需要 self[KEY] 的存在了！
    self.dst_m3_openbutton = self:AddChild(Templates.StandardButton(env_Property.openbutton(self, env_savelocal)));

    do
        ---@type widget
        local openbutton = self.dst_m3_openbutton;
        openbutton:SetHAnchor(1);
        openbutton:SetVAnchor(1);
        openbutton:SetPosition(280, -50);
        openbutton:SetScaleMode(SCALEMODE_PROPORTIONAL);
        openbutton:SetMaxPropUpscale(MAX_HUD_SCALE);
    end

end)