local wezterm = require "wezterm"
local act = wezterm.action
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Light'
end

function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return 'Builtin Solarized Dark'
    else
        return 'Builtin Solarized Light'
    end
end

config.font = wezterm.font("Cascadia Code NF", {weight = "Medium"})
config.font_size = 15
config.color_scheme = scheme_for_appearance(get_appearance())
config.enable_tab_bar = false

config.hyperlink_rules = wezterm.default_hyperlink_rules()

config.keys = {
    {
        key = 'K',
        mods = 'CMD',
        action = act.Multiple {
            act.ClearScrollback 'ScrollbackAndViewport',
            act.SendKey { key = 'L', mods = 'CTRL' },
        }
    }
}

return config