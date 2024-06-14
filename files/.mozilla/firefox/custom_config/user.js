////////////
// Native //
////////////

// userchrome.css usercontent.css activate
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// no warning on about:config
user_pref("browser.aboutConfig.showWarning", false);

// no waring on fullscreen
user_pref("full-screen-api.warning.timeout", 0);
user_pref("full-screen-api.transition.timeout", 0);

////////////
// Onebar //
////////////
user_pref("onebar.disable-https-truncate", true);
user_pref("onebar.hide-all-URLbar-icons", true);
user_pref("onebar.disable-centering-of-URLbar", false);
user_pref("onebar.disable-single-tab", true);
user_pref("onebar.hide-all-tabs-button", true);
