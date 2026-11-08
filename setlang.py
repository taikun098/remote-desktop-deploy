import FreeCAD
try:
    import FreeCADGui
    locs = FreeCADGui.supportedLocales()
    zh = {k:v for k,v in locs.items() if 'Chinese' in k or 'zh' in k.lower()}
    print('ZH_LOCALES=', zh)
except Exception as e:
    print('NO_GUI', repr(e))
p = FreeCAD.ParamGet('User parameter:BaseApp/Preferences/General')
p.SetString('Language', 'Chinese (Simplified)')
print('SET_LANG=', p.GetString('Language'))
