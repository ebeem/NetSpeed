PACKAGE=netspeed

GETTEXT_PACKAGE = $(PACKAGE)
UUID = netspeed@hedayaty.gmail.com

LANGUAGES=de fa en_CA it fr pt_BR ru zh_CN zh_TW
DOC_FILES=CHANGELOG README
SRC_FILES=extension.js prefs.js layout_menu_item.js net_speed.js net_speed_status_icon.js
MO_FILES=$(foreach LANGUAGE, $(LANGUAGES), locale/$(LANGUAGE)/LC_MESSAGES/$(GETTEXT_PACKAGE).mo)
SCHEMA_FILES=schemas/gschemas.compiled schemas/org.gnome.shell.extensions.netspeed.gschema.xml
EXTENSION_FILES=stylesheet.css metadata.json
OUTPUT=$(DOC_FILES) $(SRC_FILES) $(MO_FILES) $(SCHEMA_FILES) $(EXTENSION_FILES)
POT_FILE=po/$(GETTEXT_PACKAGE).pot
LOCAL_INSTALL=~/.local/share/gnome-shell/extensions/$(UUID)
pack: $(OUTPUT)
	zip $(UUID).zip $(OUTPUT)

$(POT_FILE): $(SRC_FILES)
	mkdir -p po
	xgettext -d $(GETTEXT_PACKAGE) -o $@ $(SRC_FILES)

update-po: $(POT_FILE)
	for lang in $(LANGUAGES); do \
		msgmerge -U po/$$lang.po $(POT_FILE); \
	done

locale/%/LC_MESSAGES/netspeed.mo: po/%.po
	mkdir -p `dirname $@`
	msgfmt $< -o $@

schemas/gschemas.compiled: schemas/org.gnome.shell.extensions.netspeed.gschema.xml
	glib-compile-schemas  schemas

install: pack
	mkdir -p $(LOCAL_INSTALL)
	rm -rf $(LOCAL_INSTALL)
	unzip $(UUID).zip -d $(LOCAL_INSTALL)
