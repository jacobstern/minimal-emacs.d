;;; post-early-init.el --- Post Early Init -*- no-byte-compile: t; lexical-binding: t; -*-

(setq tab-bar-close-button-show nil)
;; http://www.gonsie.com/blorg/tab-bar.html
(setq tab-bar-tab-hints t) ; Tab numbers
(setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator ; Hide new tab button
                                           ;; Show date and time
                                           tab-bar-format-align-right tab-bar-format-global))
(setq display-time-day-and-date t)
(setq display-time-default-load-average nil)

(display-time-mode 1)
(tab-bar-mode 1)
