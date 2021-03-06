using Engine;
using Gee;

class ServerSettingsView : MenuSubView
{
    private OptionItemControl riichi_option;
    private OptionItemControl aka_option;
    private OptionItemControl multiple_ron_option;
    private OptionItemControl triple_ron_option;
    private OptionItemControl decision_time_option;

    private MenuTextButton? log_button;

    const string[] enabled_disabled_choices = { "Disabled", "Enabled" };
    const string[] decision_time_choices = { "2", "5", "10", "20", "30", "60", "120" };

    public ServerSettingsView(bool can_control, bool log_control, ServerSettings settings)
    {
        this.can_control = can_control;
        this.log_control = log_control;
        this.settings = new ServerSettings.from_settings(settings);
    }

    public override void load()
    {
        ArrayList<OptionItemControl> opts = new ArrayList<OptionItemControl>();

        riichi_option = new OptionItemControl(can_control, "Open riichi", enabled_disabled_choices, (int)settings.open_riichi);
        aka_option = new OptionItemControl(can_control, "Aka dora", enabled_disabled_choices, (int)settings.aka_dora);
        multiple_ron_option = new OptionItemControl(can_control, "Multiple ron", enabled_disabled_choices, (int)settings.multiple_ron);
        triple_ron_option = new OptionItemControl(can_control, "Triple ron draw", enabled_disabled_choices, (int)settings.triple_ron_draw);

        int decision_time_selected;
        switch (settings.decision_time)
        {
        case 2:
            decision_time_selected = 0;
            break;
        case 5:
            decision_time_selected = 1;
            break;
        case 10:
        default:
            decision_time_selected = 2;
            break;
        case 20:
            decision_time_selected = 3;
            break;
        case 30:
            decision_time_selected = 4;
            break;
        case 60:
            decision_time_selected = 5;
            break;
        case 120:
            decision_time_selected = 6;
            break;
        }
        
        decision_time_option = new OptionItemControl(can_control, "Decision time (seconds)", decision_time_choices, decision_time_selected);

        opts.add(riichi_option);
        opts.add(aka_option);
        opts.add(multiple_ron_option);
        opts.add(triple_ron_option);
        opts.add(decision_time_option);

        int padding = 30;

        Size2 size = Size2(600, 55);
        float start = top_offset + padding;

        for (int i = 0; i < opts.size; i++)
        {
            OptionItemControl option = opts.get(i);
            add_child(option);
            option.size = size;
            option.outer_anchor = Vec2(0.5f, 1);
            option.inner_anchor = Vec2(0.5f, 1);
            option.position = Vec2(0, -(start + size.height * i));
        }
    }

    protected override ArrayList<MenuTextButton>? get_menu_buttons()
    {
        ArrayList<MenuTextButton> buttons = new ArrayList<MenuTextButton>();

        if (can_control)
        {
            MenuTextButton apply_button = new MenuTextButton("MenuButton", "Apply");
            apply_button.clicked.connect(apply);
            buttons.add(apply_button);
        }

        MenuTextButton back_button = new MenuTextButton("MenuButton", "Back");
        back_button.clicked.connect(do_back);
        buttons.add(back_button);

        return buttons;
    }

    protected override void load_finished()
    {
        if (log_button != null)
            log_button.enabled = log_control;
    }

    public override void render(RenderState state, RenderScene2D scene)
    {
        state.back_color = Color.black();
    }

    private void apply()
    {
        settings.open_riichi = (OnOffEnum)riichi_option.index;
        settings.aka_dora = (OnOffEnum)aka_option.index;
        settings.multiple_ron = (OnOffEnum)multiple_ron_option.index;
        settings.triple_ron_draw = (OnOffEnum)triple_ron_option.index;
        settings.decision_time = int.parse(decision_time_choices[decision_time_option.index]);
        settings.save();

        do_finish();
    }

    protected override string get_name() { return "Server Settings"; }

    public ServerSettings settings { get; private set; }
    public bool can_control { get; private set; }
    public bool log_control { get; private set; }
}
