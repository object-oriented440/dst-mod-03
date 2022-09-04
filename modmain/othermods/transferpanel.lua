---
--- @author zsh in 2022/8/28 16:59
---

-- ���벿��
---@type widget
local Widget = require "widgets/widget";
---@type screen
local Screen = require 'widgets/screen';
---@type imagebutton
local ImageButton = require "widgets/imagebutton"
---@type templates
local Templates = require 'widgets/redux/templates'; -- ���ֿؼ���ģ��
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

                        --self:Hide(); -- û�����壬��Ϊֻ�������˶���
                        --self = nil; -- ��ֻ������
                        --self:Kill(); -- ���У����ǿ��Ʋ��˽��棬Ϊʲô��
                        -- �϶��� HUD �� OpenScreenUnderPause ���µ�

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
        -- �������ؼ�������Դ
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
            -- NOTE: ���Լ���֪��
            -- opts.peek_height -- tips: �Ǳ��루��Ĭ��ֵ��
            -- opts.peek_percent -- tips: �Ǳ���
            -- opts.force_peek -- tips: �Ǳ���
            -- opts.num_visible_rows -- ���룬�������������ʾ������
            -- opts.num_columns -- ���룬�м���������
            -- opts.item_ctor_fn -- ���룬ÿһ��Ĺ��췽��
            -- opts.widget_width -- ���룬ÿһ��Ŀ�
            -- opts.widget_height -- ���룬ÿһ��ĸ�
            -- opts.end_offset -- tips: �Ǳ��루��Ĭ��ֵ��
            -- opts.allow_bottom_empty_row -- tips: �Ǳ���
            -- opts.scissor_pad -- tips: �Ǳ��루��Ĭ��ֵ��
            -- chang TrueScrollList ��Ĳ�����1��3��8��9��10
            -- opts.scroll_context -- tips: �Ǳ��루��Ĭ��ֵ��
            -- opts.apply_fn -- ���룬��ÿһ�ֵ������¼���
            -- opts.scrollbar_offset -- tips: �Ǳ��루��Ĭ��ֵ��
            -- opts.scrollbar_height_offset -- tips: �Ǳ��루��Ĭ��ֵ��
            -- opts.scroll_per_click -- tips: �Ǳ��루��Ĭ��ֵ��

            num_columns = 1, -- �м���������
            num_visible_rows = 8, -- �������������ʾ������
            -- ��ÿһ�ֵ������¼��ȣ��� item_ctor_fn ֮��ִ�У���
            -- TODO: ��������Ǹ���ģ��ÿ���ȥ��TrueScrollList �ĵ�����������
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
            widget_width = 380, -- ÿһ��Ŀ�
            widget_height = 50, -- ÿһ��ĸ�
        }
    }, {
        __call = function(t, self, savelocal)
            -- NOTE: �ú������ڱհ���������Ҫ���� self ������
            -- ÿһ��Ĺ��췽��
            t.opts.item_ctor_fn = function(content, index)
                local name = 'widget-' .. index; -- ��˵��� name ��ҪΨһ��
                ---@type widget @instance of widget
                local widget = Widget(name); -- ��� name ���������Ϸ�����ֵ���˼���� STRINGS.NAMES.xxx һ���ģ�

                widget:SetOnGainFocus(function()
                    self.scrollPanel:OnWidgetFocus(widget);
                end)

                -- �� widget ��һ������ destitem
                -- Temp: �����Ϊ���Ըĳɣ�����һ�� Item �࣬�̳��� Widget��Ȼ���� Item �ĳ�ʼ�������д��� Item �Ĳ��֣�
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

    -- �����ļ��ؼ���TextEdit �ǿɱ༭�ؼ�
    dest.name = dest:AddChild(TextEdit(BODYTEXTFONT, 35))
    dest.name:SetColour(255, 255, 255, 1)
    dest.name:SetEditTextColour(255, 255, 255, 1)
    dest.name:SetIdleTextColour(255, 255, 255, 1)
    dest.name:SetHAlign(ANCHOR_LEFT) -- x ��
    dest.name:SetVAlign(ANCHOR_MIDDLE) -- y ��
    -- NOTE: ע�⣬���ê����ָê���ڸ������λ�ã�����
    dest.name:SetPosition(-90, 0, 0)
    dest.name:SetRegionSize(150, 40)

    -- �༭��ɺ󣬵���س�ʱ�Ļص�
    dest.name.OnTextEntered = function(text)
        -- TODO:
    end

    -- ɾ����ť
    dest.deletebtn = dest:AddChild(Templates.StandardButton(function()
        -- TODO:
    end, "Delete", { 90, 40 }))
    dest.deletebtn:SetPosition(100, 0);

    -- ���ư�ť
    dest.up_button = dest:AddChild(ImageButton("images/global_redux.xml", "scrollbar_arrow_up.tex"))
    dest.up_button:SetPosition(160, 10)
    dest.up_button:SetScale(0.2)
    dest.up_button:SetOnClick(function()
        -- TODO:
    end)

    -- ���ư�ť
    dest.down_button = dest:AddChild(ImageButton("images/global_redux.xml", "scrollbar_arrow_down.tex"))
    dest.down_button:SetPosition(160, -10)
    dest.down_button:SetScale(0.2)
    dest.down_button:SetOnClick(function()
        -- TODO:
    end)

    -- ���������
    return dest
end

local savelocal = {
    initDestItem = initDestItem
}

local TransferPanel = Class(Screen, function(self, owner)
    Screen._ctor(self, 'dst_m3_TransferPanel');

    self.owner = owner; -- CurrentDate ����û���

    self.mainPanel = self:AddChild(Templates.RectangleWindow(Property.mainPanel(self)));

    do
        ---@type widget
        local mainPanel = self.mainPanel;
        mainPanel:SetHAnchor(0);
        mainPanel:SetVAnchor(0);
    end

    self.scrollPanel = self.mainPanel:AddChild(Templates.ScrollingGrid(Property.scrollPanel(self, savelocal)));

    -- Ҫ�ѹ������ҵ�������ϵ� self.default_focus ������ȥ ?
    self.default_focus = self.scrollPanel;

    --[[
        SetItemsData() ���ڸ��¹���������Դ�ģ��÷���self.scrollpanel:SetItemsData(newdestitems)
        GetScale() ���ڻ�ȡ�ؼ������ű����ģ�����ֵ�� (x,y,z) ���Բ���߾���������㣬�Ӷ�ʵ����Ļ���ܷŴ�����С�����ܱ��̶ֹ���λ��
    ]]
end);

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

--[[do
    -- Test code
    -- 2022-09-03-01:49 δ�ܽ���رս�������⣨�������ˣ���ô���أ��ٷ���ô����û�ṩ�أ���
    -- �������ˣ�������µģ�self.owner.HUD:OpenScreenUnderPause(self.dst_m3_transferpanel);
    -- ����ˣ�������������ģ������ҵ�Ŀ��ֻ��Ҫ��ʾ�����棬�������ˣ�
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
    -- FIXME: ����������������Ϸ�أ����������α��棿
    -- Temp: ���У�������û���壬������ʧ��ֻ�ǿ���������������Ļ���ƣ��� screens/controls �йأ�
    if (self.dst_m3_transferpanel) then
        self.dst_m3_transferpanel:Show();
        return self.dst_m3_transferpanel;
    end

    self.dst_m3_transferpanel = TransferPanel(self.owner);

    --[[    if (self.owner and self.owner.HUD) then
            -- �϶�����������⣡����ʲô���ˣ�
            self.owner.HUD:OpenScreenUnderPause(self.dst_m3_transferpanel);
        end]]

    -- Temp: ����ˣ��� T ��������ҵģ�
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
    --print('playerhud.dst_m3_transferpanel:', self.dst_m3_transferpanel); -- dst_m3_TransferPanel �����õ� TransferPanel �����֣�TransferPanel ��ʵ��
end]]

--[[local function closeTransferPanel(self)
    if self.dst_m3_transferpanel then
        self.dst_m3_transferpanel:Close(); -- ? ��ɾ���˿ɲ��У�
        self.dst_m3_transferpanel = nil;
    end
end]]

local env_savelocal = {
    showTransferPanel = showTransferPanel,
    --closeTransferPanel = closeTransferPanel
};


env.AddClassPostConstruct(false and "screens/playerhud" or "widgets/controls", function(self)
    -- ����Ļ�������һ����ť����������������ʾ��ر� tips: �˴���Ȼ��Ҫ self[KEY] �Ĵ����ˣ�
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