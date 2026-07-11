{ ... }:
{
  environment.etc = {
    # Fix stupid high-resolution scrolling on G502
    "libinput/local-overrides.quirks".text = ''
    [Logitech G502]
    MatchName=Logitech G502
    AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;'';
  };
}
